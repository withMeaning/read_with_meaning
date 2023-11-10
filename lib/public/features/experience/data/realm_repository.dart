import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/features/experience/plan/stream_file%20(which)/data/stream_file_model.dart';
import 'package:read_with_meaning/public/features/experience/single%20(now)/view/domain/now.dart';
import 'package:read_with_meaning/shared/domain/realm_types/do.dart';
import 'package:read_with_meaning/shared/domain/realm_types/experience.dart';
import 'package:read_with_meaning/shared/domain/realm_types/read.dart';
import 'package:realm/realm.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../plan/sort (when)/domain/realm_ordered.dart';

final realmProvider = StateProvider<Realm>((ref) {
  Realm realm =
      Realm(Configuration.flexibleSync(ref.read(appProvider).currentUser!, [
    Experience.schema,
    StreamFile.schema,
    Orders.schema,
    Now.schema,
    Read.schema,
    DoIt.schema
  ]));
  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(realm.all<StreamFile>());
    mutableSubscriptions.add(realm.all<Experience>());
    mutableSubscriptions.add(realm.all<Orders>());
    mutableSubscriptions.add(realm.all<Now>());
    mutableSubscriptions.add(realm.all<Read>());
    mutableSubscriptions.add(realm.all<DoIt>());
    //ref.refresh(currentUserProvider);Test
  });
  return realm;
});

class UserStateRiverpod extends StateNotifier<User?> {
  UserStateRiverpod(super.user);

  // define a method to initialize your user
  void init(User user, WidgetRef ref) {
    state = user;
  }
}

// TODO maybe change to a riverpod annotation without the Statenotifier
final userProvider = StateNotifierProvider<UserStateRiverpod, User?>((ref) {
  var initialUser = ref.read(appProvider).currentUser;
  return UserStateRiverpod(initialUser);
});

final appProvider = StateProvider<App>((ref) {
  return App(AppConfiguration(dotenv.env['REALM_APP_ID']!));
});

/* final todaysExperiencesStreamProvider =
    StreamProvider<RealmResults<Orders>>((ref) {
  RealmResults<Orders> orders = ref.read(todaysExperiencesProvider);
  return orders.changes.map((event) => orders);
}); */

final allExperiencesProvider = StateProvider<RealmResults<Experience>>((ref) {
  Realm realm = ref.read(realmProvider);
  RealmResults<Experience> items =
      realm.all<Experience>().query("content != ''");
  return items;
});

final allExpsStreamProvider = StreamProvider<RealmResults<Experience>>((ref) {
  RealmResults<Experience> exps = ref.watch(allExperiencesProvider);

  return exps.changes.map((event) => exps);
});

final todaysExperiencesProvider = StateProvider<RealmResults<Orders>>((ref) {
  String currentUserId = ref.read(userProvider)!.id;
  Realm realm = ref.read(realmProvider);
  RealmResults<Orders> items;
  for (var i = 0; i < 2; i++) {
    items = realm
        .all<Orders>()
        .query("experience.owner_id = \$0 OR experience.owner_id == 'public'",
            [currentUserId])
        .query("experience.content != ''")
        .query("TRUEPREDICATE SORT(orderIndex ASC)");
    if (items.isEmpty && i == 0) {
      try {
        realm.write(() {
          var exp = Experience(
              ObjectId(), currentUserId, DateTime.now(), "Welcome!", "read");
          realm.add(exp);
          realm.add(Orders(ObjectId(), experience: exp, 0));
          realm.add(Read(
            ObjectId(),
            currentUserId,
            "Hello",
            "withmeaning.io",
            experience: exp,
          ));
        });
      } catch (e, stacktrace) {
        Sentry.captureException(e, stackTrace: stacktrace);
      }
    } else {
      if (items.isEmpty) {
        throw Exception("No experiences found");
      }
      return items;
    }
  }
  throw Exception("No experiences found");

  //.query(
  //    "experience.type == 'read' OR experience.type == 'do' OR experience.type == 'see'"); // TODO replace with an actual query
  //
  //.query("TRUEPREDICATE SORT(orderIndex ASC)");
});

/* final currentIndexProvider2 =
    StateNotifierProvider<CurrentIndexController, int>(
        (ref) => CurrentIndexController(ref));

class CurrentIndexController extends StateNotifier<int> {
  WidgetRef ref;
  late final StreamSubscription<RealmObjectChanges<Now>> _subscription;
  late int currentIndex;
  CurrentIndexController(this.ref) : super(0) {
    // Listen to the change stream from Realm.
    _subscription = ref.watch(nowProvider).changes.listen((data) {
      // When a change comes in dispatch the updated state.
      state = ref.read(realmProvider)!
          .query<Orders>("experience = \$0", [data.object.experience])
          .first
          .orderIndex;
    });
  } 

  @override
  void dispose() {
    // Always remember to cancel your subscriptions.
    _subscription.cancel();
    super.dispose();
  }
} */

final currentIndexProvider = StateProvider<int>((ref) {
  Now now = ref.watch(nowProvider);
  // initializes the currentIndex for the current user
  int currentIndex = ref
      .read(realmProvider)
      .query<Orders>("experience = \$0", [now.experience])
      .first
      .orderIndex;
  // updates the currentIndex when Now changes
  var nowStream = ref.watch(nowStreamProvider);
  nowStream.whenData((value) {
    currentIndex = ref
        .read(realmProvider)
        .query<Orders>("experience = \$0", [now.experience])
        .first
        .orderIndex;
  });
  return currentIndex;
});

final nowProvider = StateProvider<Now>((ref) {
  Realm realm = ref.read(realmProvider)!;
  String currentUserId = ref.read(userProvider)!.id;
  // get the Now object of the current user
  RealmResults<Now> results =
      realm.query<Now>("owner_id = \$0", [currentUserId]);
  // making sure there is ever only one Now object per user
  // ? does this impact performance?
  if (results.length > 1) {
    Experience firstExperience =
        ref.read(todaysExperiencesProvider).first.experience!;
    realm.write(() {
      realm.deleteMany(results);
      realm.add(Now(ObjectId(), currentUserId, experience: firstExperience));
    });
  }
  if (results.isEmpty) {
    Experience firstExperience =
        ref.read(todaysExperiencesProvider).first.experience!;
    realm.write(() {
      realm.add(Now(ObjectId(), currentUserId, experience: firstExperience));
    });
  }
  return results.first;
});

final nowStreamProvider = StreamProvider<Now>((ref) {
  Now now = ref.watch(nowProvider);
  return now.changes.map((event) => now);
});

final extraStreamProvider = StreamProvider.autoDispose<ExperienceExtra?>((ref) {
  Now now = ref.watch(nowProvider);

  return now.changes.map((event) {
    switch (now.experience!.type) {
      case "read":
        Read? read = ref
            .read(realmProvider)
            .query<Read>("experience = \$0", [now.experience]).firstOrNull;
        return read ?? PureExperience();
      case "do":
        return ref.read(realmProvider).query<DoIt>(
                "experience = \$0", [now.experience]).firstOrNull ??
            PureExperience();
      default:
        return PureExperience();
    }
  });
});

final extraProvider = StateProvider<ExperienceExtra?>((ref) {
  Now now = ref.watch(nowProvider);
/*   Read? read = ref.read(realmProvider)!.query<Read>(
      "ANY experience == obj('Experience',oid(\$0))",
      [now.id.hexString]).firstOrNull; */
  ExperienceExtra extra;
  switch (now.experience!.type) {
    case ("read"):
      extra = ref
              .read(realmProvider)
              .query<Read>("experience = \$0", [now.experience]).firstOrNull ??
          PureExperience();
      break;
    case ("do"):
      extra = ref
              .read(realmProvider)
              .query<DoIt>("experience = \$0", [now.experience]).firstOrNull ??
          PureExperience();
      break;
    default:
      extra = PureExperience();
  }
  return extra;
});

final changeNowProvider = FutureProvider.family<void, Experience>((ref, exp) {
  Realm realm = ref.read(realmProvider)!;
  Now now = ref.read(nowProvider);
  try {
    realm.write(() {
      realm.add(Now(now.id, ref.read(userProvider)!.id, experience: exp),
          update: true);
    });
  } on Exception catch (e) {
    Logger().e(e);
  }
});

/* final loginRealmRepositoryProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  final app = ref.read(appProvider);
  String? authToken = await secureStorage.read(key: 'authToken');
  String? email = await secureStorage.read(key: 'email');
  if (authToken != null && email != null) {
    try {
      User? user = app.currentUser ??
          await app.logIn(Credentials.emailPassword(email, authToken));
      ref.read(userProvider.notifier).state = user;
    } catch (e) {
      //if (e == "invalid username/password") {
      await app.emailPasswordAuthProvider.registerUser(email, authToken);
      try {
        User? user =
            await app.logIn(Credentials.emailPassword(email, authToken));
        ref.read(userProvider.notifier).state = user;
      } catch (e) {
        Logger().e("Second Login failed $e");
        rethrow;
      }
      //}
    }
    final realm = ref.read(realmProvider.notifier);

    realm.state = Realm(Configuration.flexibleSync(app.currentUser!, [
      Experience.schema,
      StreamFile.schema,
      Orders.schema,
      Now.schema,
      Read.schema,
      DoIt.schema
    ]));
    realm.state!.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.add(realm.state!.all<StreamFile>());
      mutableSubscriptions.add(realm.state!.all<Experience>());
      mutableSubscriptions.add(realm.state!.all<Orders>());
      mutableSubscriptions.add(realm.state!.all<Now>());
      mutableSubscriptions.add(realm.state!.all<Read>());
      mutableSubscriptions.add(realm.state!.all<DoIt>());
      //ref.refresh(currentUserProvider);Test
    });
    return true;
  } else {
    return false;
  }
});
 */
// TODO This is a stupid way of building the stream,
// ! but I want the stream to update without saving
final streamFileProvider =
    StreamProvider.autoDispose<StreamFile?>((ref) async* {
  var realm = ref.watch(realmProvider);
  var allStreamFiles = realm.all<StreamFile>();
  var myStreamFile = allStreamFiles.first;
  yield* myStreamFile.changes.map((event) => event.object);
});

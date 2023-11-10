import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:read_with_meaning/public/constants/theme.dart';
import 'package:read_with_meaning/public/constants/text_strings.dart';
import 'package:read_with_meaning/public/routing/routes.dart';

import 'package:flutter/services.dart';

// TODO replace Logger() with logger everywhere
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
  level: Level.debug, //main function to tell what to show
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // because of a Riverpod Error
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is Trace) return stack.vmTrace;
    if (stack is Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  await dotenv.load();

  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DNS'];
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      const ProviderScope(
        child: Meaning(),
      ),
    ),
  );

  // TODO use env variables
  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}

class Meaning extends ConsumerWidget {
  const Meaning({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    // hides standart Android navigation bar and top bar
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark));
    }
    return MaterialApp.router(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: MeaningAppTheme.lightTheme,
      darkTheme: MeaningAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

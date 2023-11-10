import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/features/experience/plan/sort%20(when)/domain/sort.dart';

// TODO implement with riverpod and build List<Order>

void reorder(WidgetRef ref, int oldIndex, int newIndex) {
/*   if (oldIndex < newIndex) {
    newIndex -= 1;
  } */
  Sort sort = Sort(newIndex: newIndex, oldIndex: oldIndex);
  // ! Drift
  //ref.read(sortOrderProvider(sort));
}

          // the actual reordering logic:
          // do the above
          // which will result in something like [widget 1, widget 3, widget 2, widget 4]
          // then create a new list, that looks like this: [<order>{widget_1.id, 0}, <order>{widget_3.id , 1}, order{widget 2, 2}, order{widget 4, 3}}]
          // I guess that's not necessary, as the index is already part of list? So I don't
          // need to an Order object, but can just use a List<String>?
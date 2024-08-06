import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/add_task/presentation/screen/add_task_screen.dart';
import 'package:todo_list_app/modules/home/presentation/screen/home_screen.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  testWidgets(
    "Adding tasks and marking it as completed.",
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          themeMode: ThemeMode.light,
          home: const HomeScreen(),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key("homeScreenKey")), findsOneWidget);
      expect(find.text(AppConstants.noTaskListFound), findsOneWidget);

      await tester.tap(find.byKey(const Key("addTaskButtonKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("homeScreenKey")), findsNothing);
      expect(find.byKey(const Key("addTaskScreenKey")), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), "Visit Supermarket");
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(2), "Visit Supermarket and buy some vegetables");
      await tester.pumpAndSettle();

      final AddTaskScreenState addTaskScreenState = tester.state<AddTaskScreenState>(find.byType(AddTaskScreen));
      final String formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
      addTaskScreenState.dateController.text = formattedDate;

      expect((tester.widget(find.byType(TextFormField).at(1)) as TextFormField).controller?.text, formattedDate);

      await tester.tap(find.byKey(const Key("addTaskSubmitKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("homeScreenKey")), findsOneWidget);
      expect(find.text(AppConstants.noTaskListFound), findsNothing);

      expect(find.text("You have [ 1 ] pending task out of [ 1 ]"), findsOneWidget);
      expect(find.byKey(const Key("taskTileKey")), findsOneWidget);

      await tester.tap(find.byKey(const Key("markAsCompletedButtonKey")));
      await tester.pumpAndSettle();

      expect(find.text("You have [ 1 ] pending task out of [ 1 ]"), findsNothing);
      expect(find.text("Congratulations! You have completed all the tasks."), findsOneWidget);
    },
  );
}

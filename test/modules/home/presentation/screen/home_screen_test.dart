import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/add_task/presentation/screen/add_task_screen.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_bloc.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_event.dart';
import 'package:todo_list_app/modules/home/presentation/screen/home_screen.dart';

import '../bloc/home_bloc_test.mocks.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await configureDependencies();
  await getIt.allReady();
  MockHomeRepository mockHomeRepository = MockHomeRepository();
  await getIt.unregister<HomeRepository>();
  getIt.registerSingleton<HomeRepository>(mockHomeRepository);

  when(
    mockHomeRepository.getTaskList(),
  ).thenAnswer((realInvocation) async {
    return [];
  });

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
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => getIt<HomeBloc>()..add(GetTaskList())),
              BlocProvider(
                create: (context) => CompleteTaskBloc(),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key("homeScreenKey")), findsOneWidget);
      expect(find.text(AppConstants.noTaskListFound), findsOneWidget);

      await tester.tap(find.byKey(const Key("addTaskButtonKey")));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("homeScreenKey")), findsNothing);
      expect(find.byKey(const Key("addTaskScreenKey")), findsOneWidget);

      await tester.enterText(
          find.byType(TextFormField).at(0), "Visit Supermarket");
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(2),
          "Visit Supermarket and buy some vegetables");
      await tester.pumpAndSettle();

      final AddTaskScreenState addTaskScreenState =
          tester.state<AddTaskScreenState>(find.byType(AddTaskScreen));
      final String formattedDate =
          DateFormat('MMM dd, yyyy').format(DateTime.now());
      addTaskScreenState.dateController.text = formattedDate;

      expect(
          (tester.widget(find.byType(TextFormField).at(1)) as TextFormField)
              .controller
              ?.text,
          formattedDate);

      await tester.tap(find.byKey(const Key("addTaskSubmitKey")));
      when(
        mockHomeRepository.getTaskList(),
      ).thenAnswer((realInvocation) async {
        return [
          TaskModel(
              id: 1,
              title: "Test",
              status: 0,
              description: 'Sample',
              date: DateTime.now()),
        ];
      });
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();
      expect(find.byKey(const Key("homeScreenKey")), findsOneWidget);
      expect(find.text(AppConstants.noTaskListFound), findsNothing);

      expect(find.text("You have [ 1 ] pending task out of [ 1 ]"),
          findsOneWidget);
      expect(find.byKey(const Key("taskTileKey")), findsOneWidget);

      await tester.tap(find.byKey(const Key("markAsCompletedButtonKey")));
      await tester.pumpAndSettle();

      expect(
          find.text("You have [ 1 ] pending task out of [ 1 ]"), findsNothing);
      expect(find.text("Congratulations! You have completed all the tasks."),
          findsOneWidget);
    },
  );
}

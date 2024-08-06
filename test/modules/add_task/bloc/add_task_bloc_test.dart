import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_event.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_state.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:bloc_test/bloc_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await configureDependencies();
  await getIt.allReady();


  blocTest(
    "Add task Success",
    build: () => getIt<AddTaskBloc>(),
    act: (AddTaskBloc bloc) async {
      bloc.add(AddTaskTapped(
        taskModel: TaskModel(
          id: 1,
          title: 'Test',
          description: 'Test',
          status: 0,
          date: DateTime.now(),
        ),
      ));
    },
    expect: () => [isA<TaskAddedSuccess>()],
  );

  blocTest(
    "Add task Failure State",
    build: () => getIt<AddTaskBloc>(),
    act: (AddTaskBloc bloc) async {
      bloc.add(AddTaskTapped(taskModel: TaskModel()));
    },
    expect: () => [isA<FailureState>()],
  );

}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/modules/task_filter/bloc/task_filter_bloc.dart';
import 'package:todo_list_app/modules/task_filter/bloc/task_filter_event.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:todo_list_app/modules/task_filter/bloc/task_filter_state.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await configureDependencies();
  await getIt.allReady();

  blocTest(
    "Get Status of selected task",
    build: () => getIt<TaskFilterBloc>(),
    act: (TaskFilterBloc bloc) async {
      bloc.add(SelectTaskStatus(status: ''));
    },
    expect: () => [isA<UpdateTaskStatus>()],
  );
}
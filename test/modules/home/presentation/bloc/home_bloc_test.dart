import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_event.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_state.dart';
import 'home_bloc_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() async {
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
    return [
      TaskModel(id: 1, title: "Test", status: 1, description: ''),
    ];
  });

  blocTest(
    "Get Status of selected task",
    build: () => getIt<HomeBloc>(),
    act: (HomeBloc bloc) async {
      bloc.add(GetTaskList());
    },
    expect: () => [
      isA<ShowProgressBar>(),
      isA<ShowTaskList>(),
    ],
  );
}

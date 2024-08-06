import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.config.dart';


bool testing = false;
final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
)
Future<void> configureDependencies() async => getIt.init();

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_bloc.dart'
    as _i900;
import 'package:todo_list_app/modules/home/data/repository/home_repository.dart'
    as _i825;
import 'package:todo_list_app/modules/home/presentation/bloc/home_bloc.dart'
    as _i298;
import 'package:todo_list_app/modules/task_filter/bloc/task_filter_bloc.dart'
    as _i313;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i825.HomeRepository>(() => _i825.HomeRepository());
    gh.factory<_i298.HomeBloc>(() => _i298.HomeBloc());
    gh.factory<_i313.TaskFilterBloc>(() => _i313.TaskFilterBloc());
    gh.factory<_i900.AddTaskBloc>(() => _i900.AddTaskBloc());
    return this;
  }
}

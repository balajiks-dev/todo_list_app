part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class NavigateToHome extends SplashState {}

class FailureState extends SplashState with EquatableMixin {
  final String errorMessage;

  FailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage, identityHashCode(this)];
}

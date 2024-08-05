import 'dart:convert';

import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/core/network/meta.dart';
import 'package:todo_list_app/modules/splash/data/model/failure_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SignInEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<GetAppInitialData>(_onGetAppInitialData);
  }

  Future<void> _onGetAppInitialData(
      GetAppInitialData event,
    Emitter<SplashState> emit,
  ) async {
    // MetaResponse meta = await SignInRepository().userLogin(SignInRequestModel(
    //   email: event.email,
    //   password: event.password,
    // ));
    await Future.delayed(const Duration(seconds: 2));
    MetaResponse metaResponse = MetaResponse(statusCode: 200, statusMsg: "");

    if (metaResponse.statusCode == 200) {
      // SignInResponseModel signInResponseModel =
      //     SignInResponseModel.fromJson(jsonDecode(meta.statusMsg));
      emit(NavigateToHome());
    } else {
      try {
        FailureResponseModel failureResponseModel =
            FailureResponseModel.fromJson(jsonDecode(metaResponse.statusMsg));
        emit(FailureState(
            errorMessage:
                failureResponseModel.message ?? AppConstants.loginFailed));
      } catch (e) {
        emit(FailureState(errorMessage: AppConstants.somethingWentWrong));
      }
    }
  }
}

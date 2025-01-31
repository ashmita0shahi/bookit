import 'package:bloc/bloc.dart';
import 'package:bookit/features/auth/presentation/view/login_page.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/snackbar/my_snackbar.dart';
import '../../../domain/use_case/register_usecase.dart';
import '../../../domain/use_case/verify_usecase.dart';
import '../../view/verify_view.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;
  final VerifyEmailUsecase _verifyEmailUsecase;

  RegisterBloc({
    required RegisterUseCase registerUseCase,
    required VerifyEmailUsecase verifyEmailUsecase,
  })  : _registerUseCase = registerUseCase,
        _verifyEmailUsecase = verifyEmailUsecase,
        super(RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    print("RegisterUserEvent triggered"); // Debugging

    if (event.password != event.confirmPassword) {
      emit(state.copyWith(errorMessage: "Passwords do not match"));
      showMySnackBar(
        context: event.context,
        message: "Passwords do not match",
        color: Colors.red,
      );
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _registerUseCase.call(
      RegisterUserParams(
        fullname: event.fullname,
        phoneNo: event.phoneNo,
        address: event.address,
        email: event.email,
        password: event.password,
        image: event.file.path,
      ),
    );

    print("API Call Result: $result"); // Debugging

    result.fold(
      (failure) {
        print("Registration failed: ${failure.message}"); // Debugging
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: failure.message,
        ));
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
      (success) {
        print("Registration successful!"); // Debugging
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration successful!",
          color: Colors.green,
        );

        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationView(email: event.email),
          ),
        );
      },
    );
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _verifyEmailUsecase.call(
      VerifyEmailParams(email: event.email, otp: event.otp),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          isOtpVerified: false,
          errorMessage: failure.message,
        ));
        ScaffoldMessenger.of(event.context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (success) {
        emit(state.copyWith(
          isLoading: false,
          isOtpVerified: true,
        ));
        ScaffoldMessenger.of(event.context).showSnackBar(
          const SnackBar(content: Text("OTP Verified! Registration Complete!")),
        );
        Navigator.pushReplacement(
          event.context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },
    );
  }
}

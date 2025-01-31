import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullname;
  final String phoneNo;
  final String address;
  final String email;
  final String password;
  final String confirmPassword;
  final File file;

  const RegisterUserEvent({
    required this.context,
    required this.fullname,
    required this.phoneNo,
    required this.address,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.file,
  });

  @override
  List<Object> get props => [
        fullname,
        phoneNo,
        address,
        email,
        password,
        confirmPassword,
        file,
      ];
}

class VerifyOtpEvent extends RegisterEvent {
  final BuildContext context;
  final String email;
  final String otp;

  const VerifyOtpEvent(
      {required this.context, required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserProfile extends UserEvent {} // ✅ Remove userId parameter

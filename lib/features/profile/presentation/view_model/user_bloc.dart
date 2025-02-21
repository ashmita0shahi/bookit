import 'package:bloc/bloc.dart';

import '../../domain/use_case/get_user_profile_usecase.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserProfileUseCase;

  UserBloc(this.getUserProfileUseCase) : super(UserInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(UserLoading());

      final result = await getUserProfileUseCase();
      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user)),
      );
    });
  }
}

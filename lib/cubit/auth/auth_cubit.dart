import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthService _authService = AuthService();

  void registerUser(RegisterRequest data) async {
    emit(RegisterInitialState());

    ApiReturn apiResult = await _authService.userRegistration(data);
    if (apiResult.success) {
      emit(RegisterSuccessfulState());
    } else {
      emit(RegisterFailedState(apiResult.message));
    }
  }
}

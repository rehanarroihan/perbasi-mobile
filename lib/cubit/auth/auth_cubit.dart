import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/coach_type_model.dart';
import 'package:perbasitlg/models/login_model.dart';
import 'package:perbasitlg/models/player_position_model.dart';
import 'package:perbasitlg/models/request/change_password_request.dart';
import 'package:perbasitlg/models/request/login_request.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/models/user_model.dart';
import 'package:perbasitlg/services/auth_service.dart';
import 'package:perbasitlg/utils/constant_helper.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  AuthService _authService = AuthService();
  UserModel loggedInUserData = UserModel();

  List<PlayerPositionModel> playerPositionList = List<PlayerPositionModel>();
  List<CoachTypeModel> coachTypeList = List<CoachTypeModel>();

  void registerUser(RegisterRequest data) async {
    emit(RegisterInitialState());

    ApiReturn apiResult = await _authService.userRegistration(data);
    if (apiResult.success) {
      emit(RegisterSuccessfulState());
    } else {
      emit(RegisterFailedState(apiResult.message));
    }
  }

  void loginUser(LoginRequest data) async {
    emit(LoginInitialState());

    LoginModel apiResult = await _authService.userLogin(data);
    if (apiResult.success) {
      // NOTE : fill up prefs as session
      App().prefs.setBool(ConstantHelper.PREFS_IS_USER_LOGGED_IN, true);
      App().prefs.setString(ConstantHelper.PREFS_TOKEN_KEY, apiResult.accessToken);
      App().dio.options.headers = {
        'Authorization': 'Bearer ${apiResult.accessToken}'
      };

      emit(LoginSuccessfulState());
    } else {
      emit(LoginFailedState());
    }
  }

  void getUserDetail() async {
    emit(GetUserDataInitialState());

    ApiReturn<UserModel> apiResult = await _authService.getUserDetail();
    ApiReturn<List<PlayerPositionModel>> apiPosResult = await _authService.getPlayerPosition();
    ApiReturn<List<CoachTypeModel>> apiCoachTypeResult = await _authService.getCoachType();
    if (apiResult.success) {
      this.loggedInUserData = apiResult.data;
      this.playerPositionList = apiPosResult.data;
      this.coachTypeList = apiCoachTypeResult.data;
      emit(GetUserDataSuccessfulState());
    } else {
      emit(GetUserDataFailedState());
    }
  }

  void postChangePassword(ChangePasswordRequest data) async {
    emit(ChangePasswordInitialState());

    ApiReturn apiResult = await _authService.userChangePassword(data);
    if (apiResult.success) {
      emit(ChangePasswordSuccessfulState(apiResult.message));
    } else {
      emit(ChangePasswordFailedState(apiResult.message));
    }
  }

  void postToken(String token) async {
    emit(PostTokenInitialState());

    ApiReturn apiResult = await _authService.postTokenFirebase(token);
    if (apiResult.success) {
      emit(PostTokenSuccessfulState());
    } else {
      emit(PostTokenFailedState());
    }
  }

  void deleteToken(String token) async {
    emit(DeleteTokenInitialState());

    ApiReturn apiResult = await _authService.deleteTokenFirebase(token);
    if (apiResult.success) {
      emit(DeleteTokenSuccessfulState());
    } else {
      emit(DeleteTokenFailedState());
    }
  }

}

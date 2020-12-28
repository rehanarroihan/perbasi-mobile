import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/services/profile_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileService _profileService = ProfileService();
  double updateProfileUploadProgress = 0;

  void updateProfilePlayer(ProfilePlayerRequest data) async {
    this.updateProfileUploadProgress = 0;
    emit(UpdateProfileInit());

    ApiReturn apiResult = await _profileService.updatePlayerProfile(
      data: data,
      onSendProgress: (double progress) {
        emit(UpdateProfileProgressChangeInit());
        this.updateProfileUploadProgress = progress;
        emit(UpdateProfileProgressChanged());
      }
    );

    if (apiResult.success) {
      emit(UpdateProfileSuccessful());
    } else {
      emit(UpdateProfileFailed());
    }
  }

  void updateProfileCoach(ProfileCoachRequest data) async {
    this.updateProfileUploadProgress = 0;
    emit(UpdateProfileInit());

    ApiReturn apiResult = await _profileService.updateCoachProfile(
      data: data,
      onSendProgress: (double progress) {
        emit(UpdateProfileProgressChangeInit());
        this.updateProfileUploadProgress = progress;
        emit(UpdateProfileProgressChanged());
      }
    );

    if (apiResult.success) {
      emit(UpdateProfileSuccessful());
    } else {
      emit(UpdateProfileFailed());
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perbasitlg/models/api_return.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/services/profile_service.dart';
import 'package:perbasitlg/utils/constant_helper.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileService _profileService = ProfileService();
  double updateProfileUploadProgress = 0;

  void updatePictureProfile({
    String role,
    ProfilePlayerRequest playerRequest,
    ProfileCoachRequest coachRequest
  }) async {
    emit(UpdateProfilePictureInit());

    ApiReturn apiResult;
    if (role == ConstantHelper.ROLE_PEMAIN) {
      apiResult = await _profileService.updatePlayerProfile(
        data: playerRequest,
        onSendProgress: (double progress) {

        }
      );
    }

    if (role == ConstantHelper.ROLE_PELATIH || role == ConstantHelper.ROLE_WASIT) {
      apiResult = await _profileService.updateCoachProfile(
        data: coachRequest,
        onSendProgress: (double progress) {
          emit(UpdateProfileProgressChangeInit());
          this.updateProfileUploadProgress = progress;
          emit(UpdateProfileProgressChanged());
        },
        role: role
      );
    }

    if (apiResult.success) {
      emit(UpdateProfilePictureSuccessful());
    } else {
      emit(UpdateProfilePictureFailed());
    }
  }

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

  void updateProfileCoach(ProfileCoachRequest data, String role) async {
    this.updateProfileUploadProgress = 0;
    emit(UpdateProfileInit());

    ApiReturn apiResult = await _profileService.updateCoachProfile(
      data: data,
      onSendProgress: (double progress) {
        emit(UpdateProfileProgressChangeInit());
        this.updateProfileUploadProgress = progress;
        emit(UpdateProfileProgressChanged());
      },
      role: role
    );

    if (apiResult.success) {
      emit(UpdateProfileSuccessful());
    } else {
      emit(UpdateProfileFailed());
    }
  }

  void scanQRCode(String code) async {
    emit(ScanQrCodeInit());

    ApiReturn apiReturn = await _profileService.scanQRCode(code);

    emit(ScanQrCodeSuccessful(apiReturn.message));
  }
}

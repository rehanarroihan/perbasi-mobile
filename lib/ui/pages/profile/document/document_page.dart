import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/upload_form.dart';
import 'package:perbasitlg/ui/widgets/modules/upload_progress_dialog.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';

class DocumentPage extends StatefulWidget {
  DocumentPage({Key key}) : super(key: key);

  @override
  _DocumentPageState createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  AuthCubit _authCubit = AuthCubit();
  ProfileCubit _profileCubit = ProfileCubit();

  String _loggedInRole;

  bool _isKKPictPreview = false;
  bool _isBirthCertPictPreview = false;
  bool _isLicensePictPreview = false;
  bool _isKTPPictPreview = false;
  bool _isSelfiePictPreview = false;

  // player
  File _kk;
  File _birthCert;
  File _selfie;
  File _ktp;
  TextEditingController _kkInput = TextEditingController();
  TextEditingController _birthCertInput = TextEditingController();
  TextEditingController _selfieInput = TextEditingController();
  TextEditingController _ktpInput = TextEditingController();

  // kuch
  File _licensePhoto;
  TextEditingController _licensePhotoInput = TextEditingController();

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _profileCubit = BlocProvider.of<ProfileCubit>(context);

    _loggedInRole = _authCubit.loggedInUserData.role.name;
    _updateFields();

    super.initState();
  }

  Future<String> getImagePathFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          cubit: _profileCubit,
          listener: (context, state) {
            if (state is UpdateProfileInit) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => UploadProgressDialog(_profileCubit)
              );
            } else if (state is UpdateProfileSuccessful) {
              Navigator.pop(context);
              showFlutterToast('Berhasil menyimpan perubahan');
              _authCubit.getUserDetail();
            } else if (state is UpdateProfileFailed) {
              Navigator.pop(context);
              showFlutterToast('Gagal menyimpan perubahan');
            }
          },
        ),
        BlocListener(
          cubit: _authCubit,
          listener: (context, state) {
            if (state is GetUserDataSuccessfulState) {
              _updateFields();
            }
          },
        )
      ],
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(30),
            ScreenUtil().setHeight(28),
            ScreenUtil().setWidth(30),
            ScreenUtil().setHeight(28),
          ),
          child: _loggedInRole == ConstantHelper.ROLE_PEMAIN ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UploadForm(
                input: _ktpInput,
                label: 'Upload KTP',
                imageUrl: _authCubit.loggedInUserData.ktp,
                isPreviewThumbnail: _isKTPPictPreview,
                image: _ktp,
                validator: (String args) {
                  if (_ktpInput == null) {
                    return 'file ktp harus di pilih';
                  }
                },
                onPickImage: () async {
                  String filePath = await getImagePathFromGallery();
                  if (!GlobalMethodHelper.isEmpty(filePath)) {
                    _ktp = File(filePath);

                    if (_ktp.lengthSync() > 5120000) {
                      showFlutterToast('Maximum photo size is 5 MB');
                      return;
                    }

                    _isKTPPictPreview = true;
                    _ktpInput.text = 'File sudah dipilih';

                    _updateProfile();
                    _ktpInput.text = 'Uploading...';

                    setState(() {});
                  }
                }
              ),
              Space(height: 40),
              UploadForm(
                input: _kkInput,
                label: 'Upload KK',
                imageUrl: _authCubit.loggedInUserData.kk,
                isPreviewThumbnail: _isKKPictPreview,
                image: _kk,
                validator: (String args) {
                  if (_kkInput == null) {
                    return 'file kk harus di pilih';
                  }
                },
                onPickImage: () async {
                  String filePath = await getImagePathFromGallery();
                  if (!GlobalMethodHelper.isEmpty(filePath)) {
                    _kk = File(filePath);

                    if (_kk.lengthSync() > 5120000) {
                      showFlutterToast('Maximum photo size is 5 MB');
                      return;
                    }

                    _kkInput.text = 'File sudah dipilih';
                    _isKKPictPreview = true;

                    _updateProfile();
                    _kkInput.text = 'Uploading...';

                    setState(() {});
                  }
                }
              ),
              Space(height: 40),
              UploadForm(
                input: _birthCertInput,
                label: 'Akta Kelahiran',
                imageUrl: _authCubit.loggedInUserData.akta,
                isPreviewThumbnail: _isBirthCertPictPreview,
                image: _birthCert,
                onPickImage: () async {
                  String filePath = await getImagePathFromGallery();
                  if (!GlobalMethodHelper.isEmpty(filePath)) {
                    _birthCert = File(filePath);

                    if (_birthCert.lengthSync() > 5120000) {
                      showFlutterToast('Maximum photo size is 5 MB');
                      return;
                    }

                    _birthCertInput.text = 'File sudah dipilih';
                    _isBirthCertPictPreview = true;

                    _updateProfile();
                    _birthCertInput.text = 'Uploading...';

                    setState(() {});
                  }
                },
                validator: (String args) {
                  if (_birthCertInput == null) {
                    return 'file akta kelahiran harus di pilih';
                  }
                },
              ),
              Space(height: 40),
              UploadForm(
                input: _selfieInput,
                label: 'Foto selfie dengan KTP / Kartu Pelajar',
                imageUrl: _authCubit.loggedInUserData.selfie,
                isPreviewThumbnail: _isSelfiePictPreview,
                image: _selfie,
                onPickImage: () async {
                  String filePath = await getImagePathFromGallery();
                  if (!GlobalMethodHelper.isEmpty(filePath)) {
                    _selfie = File(filePath);

                    if (_selfie.lengthSync() > 5120000) {
                      showFlutterToast('Maximum photo size is 5 MB');
                      return;
                    }

                    _selfieInput.text = 'File sudah dipilih';
                    _isSelfiePictPreview = true;

                    _updateProfile();
                    _selfieInput.text = 'Uploading...';

                    setState(() {});
                  }
                },
                validator: (String args) {
                  if (_selfieInput == null) {
                    return 'file selfie harus di pilih';
                  }
                },
              ),
            ],
          ) :
          _loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UploadForm(
                input: _licensePhotoInput,
                label: 'Foto Lisensi',
                imageUrl: _authCubit.loggedInUserData.licenseFile,
                isPreviewThumbnail: _isLicensePictPreview,
                image: _licensePhoto,
                onPickImage: () async {
                  String filePath = await getImagePathFromGallery();
                  if (!GlobalMethodHelper.isEmpty(filePath)) {
                    _licensePhoto = File(filePath);

                    if (_licensePhoto.lengthSync() > 5120000) {
                      showFlutterToast('Maximum photo size is 5 MB');
                      return;
                    }

                    _licensePhotoInput.text = 'File sudah dipilih';
                    _isLicensePictPreview = true;

                    _updateProfile();
                    _licensePhotoInput.text = 'Uploading...';

                    setState(() {});
                  }
                },
                validator: (String args) {
                  if (_licensePhotoInput == null) {
                    return 'foto lisensi harus di pilih';
                  }
                },
              ),
            ],
          ) :
          Container(),
        ),
      ),
    );
  }

  void _updateFields() async {
    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.kk)) {
      _kkInput.text = 'KK sudah di upload';
    }

    if (_loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT) {
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.licenseFile)) {
        _licensePhotoInput.text = 'Foto lisensi sudah di upload';
      }
    }

    if (_loggedInRole == ConstantHelper.ROLE_PEMAIN) {
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.ktp)) {
        _ktpInput.text = 'Foto ktp sudah di upload';
      }
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.akta)) {
        _birthCertInput.text = 'Foto akta sudah di upload';
      }
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.selfie)) {
        _selfieInput.text = 'Foto selfie sudah di upload';
      }
    }

    _kk = null;
    _birthCert = null;
    _selfie = null;
    _ktp = null;
    _licensePhoto = null;

    _isKKPictPreview = false;
    _isBirthCertPictPreview = false;
    _isLicensePictPreview = false;
    _isKTPPictPreview = false;
    _isSelfiePictPreview = false;

    setState(() {});
  }

  void _updateProfile() async {
    if (_loggedInRole == ConstantHelper.ROLE_PEMAIN) {
      LoadingDialog(
        title: 'Loading',
        description: 'Silahkan tunggu...'
      ).show(context);

      File resizedKKImage;
      if (_kk != null) {
        resizedKKImage = await GlobalMethodHelper.resizeImage(
          _kk, preferredWidth: 320,
          fileName: _kk.path.split("/").last
        );
      }

      File resizedKTPImage;
      if (_ktp != null) {
        resizedKTPImage = await GlobalMethodHelper.resizeImage(
          _ktp, preferredWidth: 320,
          fileName: _ktp.path.split("/").last
        );
      }

      File resizedSelfieImage;
      if (_selfie != null) {
        resizedSelfieImage = await GlobalMethodHelper.resizeImage(
          _selfie, preferredWidth: 320,
          fileName: _selfie?.path?.split("/")?.last
        );
      }

      File resizedBirthCertImage;
      if (_birthCert != null) {
        resizedBirthCertImage = await GlobalMethodHelper.resizeImage(
          _birthCert, preferredWidth: 320,
          fileName: _birthCert?.path?.split("/")?.last
        );
      }

      Navigator.pop(context);

      ProfilePlayerRequest requestData = ProfilePlayerRequest(
        nik: _authCubit.loggedInUserData.nik,
        name: _authCubit.loggedInUserData.name,
        birthPlace: _authCubit.loggedInUserData.birthPlace,
        birthDate: _authCubit.loggedInUserData.birthDate,
        email: _authCubit.loggedInUserData.email,
        address: _authCubit.loggedInUserData.address,
        phone: _authCubit.loggedInUserData.phone,
        positionId: _authCubit.loggedInUserData.positionId?.id.toString(),
        gender: _authCubit.loggedInUserData.gender,
        almaMater: _authCubit.loggedInUserData.almamater,
        identityAddress: _authCubit.loggedInUserData.identityAddress,
        noKK: _authCubit.loggedInUserData.noKK,
        kk: resizedKKImage != null ? resizedKKImage : null,
        akta: resizedBirthCertImage != null ? resizedBirthCertImage : null,
        ktp: resizedKTPImage != null ? resizedKTPImage : null,
        selfie: resizedSelfieImage != null ? resizedSelfieImage : null
      );

      _profileCubit.updateProfilePlayer(requestData);
    }

    if (_loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT) {
      LoadingDialog(
        title: 'Loading',
        description: 'Silahkan tunggu...'
      ).show(context);

      File resizedLicenseImage;
      if (_licensePhoto != null) {
        resizedLicenseImage = await GlobalMethodHelper.resizeImage(
          _licensePhoto, preferredWidth: 320,
          fileName: _licensePhoto.path.split("/").last
        );
      }

      Navigator.pop(context);

      ProfileCoachRequest requestData = ProfileCoachRequest(
        nik: _authCubit.loggedInUserData.nik,
        name: _authCubit.loggedInUserData.name,
        birthPlace: _authCubit.loggedInUserData.birthPlace,
        birthDate: _authCubit.loggedInUserData.birthDate,
        email: _authCubit.loggedInUserData.email,
        address: _authCubit.loggedInUserData.address,
        phone: _authCubit.loggedInUserData.phone,
        licence: _authCubit.loggedInUserData.licence,
        licenceNumber: _authCubit.loggedInUserData.licenceNumber,
        licenceFrom: _authCubit.loggedInUserData.licenceFrom,
        licenceActiveDate: _authCubit.loggedInUserData.licenceActiveDate,
        typeId: _authCubit.loggedInUserData?.typeId?.id?.toString(),
        gender: _authCubit.loggedInUserData.gender,
        licenceFile: resizedLicenseImage != null ? resizedLicenseImage : null,
      );

      _profileCubit.updateProfileCoach(requestData, _loggedInRole);
    }
  }
}
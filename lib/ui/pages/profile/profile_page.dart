import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/ui/pages/profile/biodata/biodata_page.dart';
import 'package:perbasitlg/ui/pages/profile/document/document_page.dart';
import 'package:perbasitlg/ui/pages/profile/qr_code_page.dart';
import 'package:perbasitlg/ui/pages/splash_page.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/upload_progress_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/ui/pages/profile/qr_scanner_page.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  AuthCubit _authCubit = AuthCubit();
  ProfileCubit _profileCubit = ProfileCubit();

  File _profilePict;
  bool _isProfilePictPreview = false;

  String _loggedInRole;

  TabController _tabController;
  int selectedTab = 0;

  String tokenDeviceId = '';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _profileCubit = BlocProvider.of<ProfileCubit>(context);

    _loggedInRole = _authCubit.loggedInUserData.role.name;

    _tabController = TabController(vsync: this, length: 2);


    _firebaseMessaging.getToken().then((token) => setState(() {
      this.tokenDeviceId = token;
    }));
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _profileCubit,
      listener: (context, state) {
        if (state is UpdateProfilePictureInit) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => UploadProgressDialog(_profileCubit)
          );
        } else if (state is UpdateProfilePictureSuccessful) {
          Navigator.pop(context);
          showFlutterToast('Berhasil menyimpan foto profile baru');
          _authCubit.getUserDetail();
        } else if (state is UpdateProfilePictureFailed) {
          Navigator.pop(context);
          showFlutterToast('Gagal menyimpan perubahan');
        }
      },
      child: BlocBuilder(
        cubit: _authCubit,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.pageBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              elevation: 2,
              title: Text(
                'Profil',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
              actions: [
                _authCubit.loggedInUserData.role.name == ConstantHelper.ROLE_PEMAIN ? Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12, right: 8),
                  child: FlatButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => QRScannerPage()
                    )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                    ),
                    color: AppColor.lightBlue,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_sharp,
                          size: 20,
                          color: AppColor.secondaryColor,
                        ),
                        Space(width: 6),
                        Text(
                          'Scan QR',
                          style: TextStyle(
                            color: AppColor.secondaryColor,
                            fontSize: ScreenUtil().setSp(12),
                          ),
                        ),
                      ],
                    ),
                  )
                ) : Container(),
                Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12, right: 8),
                  child: FlatButton(
                    onPressed: () {
                      AppAlertDialog(
                        title: 'Logout',
                        description: 'Apakah anda yakin ingin keluar dari aplikasi ?',
                        negativeButtonText: 'Tidak',
                        negativeButtonOnTap: () => Navigator.pop(context),
                        positiveButtonText: 'Ya',
                        positiveButtonOnTap: () {
                          _authCubit.deleteToken(tokenDeviceId);
                          App().prefs.setBool(ConstantHelper.PREFS_IS_USER_LOGGED_IN, false);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => SplashPage()
                          ));
                        },
                      ).show(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)
                    ),
                    color: AppColor.lightOrange,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout,
                          size: 20,
                          color: AppColor.primaryColor,
                        ),
                        Space(width: 6),
                        Text(
                          'Keluar',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: ScreenUtil().setSp(12),
                          ),
                        ),
                      ],
                    ),
                  )
                )
              ]
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        offset: const Offset(0, 0),
                        blurRadius: 6,
                      ),
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileHeader(),
                      Container(
                        height: ScreenUtil().setHeight(48),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: AppColor.primaryColor,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Tab(child: Text('Biodata')),
                            Tab(child: Text('Dokumen')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BiodataPage(),
                      DocumentPage()
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<String> getImagePathFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return '';
    }
  }

  Widget _profileHeader() {

    String coachType(String status) {
      if (status == ConstantHelper.LICENSE_PELATIH_KEPALA) {
        return ConstantHelper.LICENSE_PELATIH_KEPALA_TEXT;
      } else if (status == ConstantHelper.LICENSE_ASISTEN_PELATIH) {
        return  ConstantHelper.LICENSE_ASISTEN_PELATIH_TEXT;
      } else if (status == ConstantHelper.LICENSE_MANAGER) {
        return ConstantHelper.LICENSE_MANAGER_TEXT;
      } else if (status == ConstantHelper.LICENSE_MEDIS) {
        return ConstantHelper.LICENSE_MEDIS_TEXT;
      } else if (status == ConstantHelper.LICENSE_STATISTIK) {
        return ConstantHelper.LICENSE_STATISTIK_TEXT;
      } else {
        return "-";
      }
    }

    return Container(
      padding: EdgeInsets.only(
        top: 24, left: 16, bottom: 24, right: 12
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                String filePath = await getImagePathFromGallery();
                if (!GlobalMethodHelper.isEmpty(filePath)) {
                  _profilePict = File(filePath);

                  if (_profilePict.lengthSync() > 1024000) {
                    showFlutterToast('Maximum photo size is 1 MB');
                    return;
                  }

                  _isProfilePictPreview = true;

                  _updateProfilePict();

                  setState(() {});
                }
              },
              child: Column(
                children: [
                  _buildRoundedProfilePict(),
                  Space(height: 4),
                  Text(
                    'Ubah',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          ),
          Space(width: ScreenUtil().setWidth(14)),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _authCubit.loggedInUserData.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(14)
                  ),
                ),
                Text(
                  _authCubit.loggedInUserData.role.name == ConstantHelper.ROLE_PEMAIN
                      ? _authCubit.loggedInUserData.verified ? 'Terverifikasi' : 'Belum Terverifikasi'
                      : _authCubit.loggedInUserData.role.name == ConstantHelper.ROLE_PELATIH ? coachType(_authCubit.loggedInUserData.typeId.id.toString()) :
                  _authCubit.loggedInUserData.role.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: ScreenUtil().setSp(13),
                    color: _authCubit.loggedInUserData.role.name == ConstantHelper.ROLE_PEMAIN
                        ? _authCubit.loggedInUserData.verified ? Colors.green : Colors.red
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: FlatButton(
          //     padding: EdgeInsets.fromLTRB(8, 20, 8, 12),
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(
          //         builder: (context) => ImageDetailPage(
          //           title: 'QR Code',
          //           imageDetail: _authCubit.loggedInUserData.qrcode,
          //         )
          //       ));
          //     },
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(6)
          //     ),
          //     color: AppColor.lightGrey.withOpacity(0.0),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         CachedNetworkImage(
          //           imageUrl: _authCubit.loggedInUserData.qrcode,
          //           fit: BoxFit.cover,
          //           height: 74,
          //           width: 74,
          //         ),
          //         Space(height: 4),
          //         // Text('QR Code')
          //       ],
          //     )
          //   ),
          // ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedProfilePict() {
    if (_isProfilePictPreview) {
      return Container(
        width: ScreenUtil().setWidth(68),
        height: ScreenUtil().setHeight(68),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              offset: const Offset(0, 0),
              blurRadius: 4,
            )
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(_profilePict),
          ),
        ),
      );
    }

    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.foto)) {
      return Container(
        width: ScreenUtil().setWidth(68),
        height: ScreenUtil().setHeight(68),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(_authCubit.loggedInUserData.foto)
          ),
          shape: BoxShape.circle
        ),
      );
    }

    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.primaryColor
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  void _updateProfilePict() async {
    LoadingDialog(
      title: 'Loading',
      description: 'Silahkan tunggu...'
    ).show(context);

    File resizedProfileImage = await GlobalMethodHelper.resizeImage(
      _profilePict, preferredWidth: 320,
      fileName: _profilePict?.path?.split("/")?.last
    );

    Navigator.pop(context);

    ProfilePlayerRequest playerRequest;
    if (_loggedInRole == ConstantHelper.ROLE_PEMAIN) {
      playerRequest = ProfilePlayerRequest(
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
        foto: resizedProfileImage != null ? resizedProfileImage : null,
      );
    }

    ProfileCoachRequest coachRequest;
    if (_loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT) {
      coachRequest = ProfileCoachRequest(
        nik: _authCubit.loggedInUserData.nik,
        name: _authCubit.loggedInUserData.name,
        birthPlace: _authCubit.loggedInUserData.birthPlace,
        birthDate: _authCubit.loggedInUserData.birthDate,
        email: _authCubit.loggedInUserData.email,
        address: _authCubit.loggedInUserData.address,
        phone: _authCubit.loggedInUserData.phone,
        foto: resizedProfileImage != null ? resizedProfileImage : null,
        licence: _authCubit.loggedInUserData.licence,
        licenceNumber: _authCubit.loggedInUserData.licenceNumber,
        licenceFrom: _authCubit.loggedInUserData.licenceFrom,
        licenceActiveDate: _authCubit.loggedInUserData.licenceActiveDate,
        licence_active_at: _authCubit.loggedInUserData.licence_active_at,
        typeId: _authCubit.loggedInUserData?.typeId?.id.toString(),
        gender: _authCubit.loggedInUserData.gender,
      );
    }

    _profileCubit.updatePictureProfile(
      role: _loggedInRole,
      playerRequest: playerRequest,
      coachRequest: coachRequest
    );
  }
}
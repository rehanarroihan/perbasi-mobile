import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/ui/pages/profile/biodata/biodata_page.dart';
import 'package:perbasitlg/ui/pages/profile/document/document_page.dart';
import 'package:perbasitlg/ui/pages/profile/qr_code_page.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
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

  TabController _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _profileCubit = BlocProvider.of<ProfileCubit>(context);

    _tabController = TabController(vsync: this, length: 2);

    super.initState();
  }

  File _generateProfilePictFileFromUrl(String filename) {
    String pathName = p.join(App().appDocsDir.path, filename);
    _profilePict = File(pathName);
    return File(pathName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
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
          showFlutterToast('Berhasil menyimpan perubahan');
          _authCubit.getUserDetail();
        } else if (state is GetUserDataSuccessfulState) {

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
                IconButton(
                  icon: Icon(Icons.camera_sharp),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => QRScannerPage()
                  )),
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
    return Container(
      padding: EdgeInsets.all(24),
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

                  if (_profilePict.lengthSync() > 5120000) {
                    showFlutterToast('Maximum photo size is 5 MB');
                    return;
                  }

                  _isProfilePictPreview = true;
                  setState(() {});
                  showFlutterToast('Tekan tombol simpan untuk menyimpan foto profile yang telah dipilih');
                }
              },
              child: Column(
                children: [
                  _buildRoundedProfilePict(),
                  Text(
                    'Ubah',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: ScreenUtil().setSp(10)
                    ),
                  )
                ],
              ),
            ),
          ),
          Space(width: ScreenUtil().setWidth(14)),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start  ,
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
                      : _authCubit.loggedInUserData.role.name,
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ImageDetailPage(
                    title: 'QR Code',
                    imageDetail: _authCubit.loggedInUserData.qrcode,
                  )
                ));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/qrcode.svg'),
                  Space(height: 4),
                  Text('QR Code')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundedProfilePict() {
    if (_isProfilePictPreview) {
      return Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(_profilePict),
          ),
        ),
      );
    }

    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.foto)) {
      return Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkToFileImage(
              url: _authCubit.loggedInUserData.foto,
              file: _generateProfilePictFileFromUrl(_authCubit.loggedInUserData.foto.split('/').last)
            ),
          ),
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
}
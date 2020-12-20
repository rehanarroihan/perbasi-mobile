import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/ui/pages/splash_page.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthCubit _authCubit = AuthCubit();
  
  String _loggedInRole;

  TextEditingController _nikInput = TextEditingController();
  TextEditingController _nameInput = TextEditingController();
  TextEditingController _birthPlaceInput = TextEditingController();
  TextEditingController _birthDateInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  String _birthDateForServer = '';

  // Player additional form
  TextEditingController _positionInput = TextEditingController();
  TextEditingController _teamInput = TextEditingController();
  TextEditingController _kkInput = TextEditingController();
  File _kk;

  // Kuch additional form
  TextEditingController _licenseNameInput = TextEditingController();
  TextEditingController _licenseNumberInput = TextEditingController();
  TextEditingController _licensePublisherInput = TextEditingController();

  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);

    _loggedInRole = _authCubit.loggedInUserData.role.name;
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authCubit,
      listener: (context, state) {

      },
      child: BlocBuilder(
        cubit: _authCubit,
        builder: (context, state) {
          _nikInput.text = _authCubit.loggedInUserData.nik;
          _nameInput.text = _authCubit.loggedInUserData.name;
          _birthPlaceInput.text = _authCubit.loggedInUserData.birthPlace;
          _birthDateInput.text = DateFormat('dd MMMM yyyy').format(
            DateTime.parse(_authCubit.loggedInUserData.birthDate)
          );
          _emailInput.text = _authCubit.loggedInUserData.email;

          return Scaffold(
            backgroundColor: AppColor.pageBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: Text(
                'Biodata',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileHeader(),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        _profileForm(),
                        _additionalFormBasedOnRole(),
                      ],
                    ),
                  ),
                  _callToActionButtons()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _callToActionButtons() {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(34),
        bottom: ScreenUtil().setHeight(30),
        left: ScreenUtil().setWidth(30),
        right: ScreenUtil().setWidth(30),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Button(
              onPressed: () {},
              text: 'Simpan',
              style: AppButtonStyle.secondary,
              padding: 13,
              fontSize: 16,
            ),
          ),
          Space(height: 8),
          Container(
            width: double.infinity,
            child: FlatButton(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(13)
              ),
              onPressed: () {
                AppAlertDialog(
                  title: 'Logout',
                  description: 'Apakah anda yakin ingin keluar dari aplikasi ?',
                  negativeButtonText: 'Tidak',
                  negativeButtonOnTap: () => Navigator.pop(context),
                  positiveButtonText: 'Ya',
                  positiveButtonOnTap: () {
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
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          )
        ],
      ),
    );
  }
  
  Widget _profileForm() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(30),
        ScreenUtil().setHeight(28),
        ScreenUtil().setWidth(30),
        0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxInput(
            controller: _nikInput,
            label: 'NIK',
            keyboardType: TextInputType.number,
            validator: (String val) {
              if (val.length < 16) {
                return 'nik harus valid';
              }
            },
          ),
          Space(height: 40),
          BoxInput(
            controller: _nameInput,
            label: 'Nama',
            validator: (String val) {
              if (val.length < 3) {
                return 'nama harus valid';
              }
            },
          ),
          Space(height: 40),
          BoxInput(
            controller: _birthPlaceInput,
            label: 'Tempat Lahir',
            textCapitalization: TextCapitalization.sentences,
            validator: (String val) {
              if (val.length < 3) {
                return 'tempat lahir harus valid';
              }
            },
          ),
          Space(height: 40),
          GestureDetector(
            onTap: () async {
              final DateTime pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(DateTime.now().year, 12, 31),
              );
              if (pickedDate != null) {
                final DateTime fullResult = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedDate.hour,
                  pickedDate.minute,
                );

                // formatting datetime for request data needs
                _birthDateForServer = DateFormat('yyyy-MM-dd').format(fullResult);

                // formatting datetime to show to the screen
                _birthDateInput.text = DateFormat('dd MMMM yyyy').format(fullResult);

                setState(() {});
              } else {
                return;
              }
            },
            child: BoxInput(
              controller: _birthDateInput,
              readOnly: true,
              label: 'Tanggal Lahir',
              validator: (String val) {
                if (GlobalMethodHelper.isEmpty(val.length)) {
                  return 'tanggal lahir harus valid';
                }
              },
            ),
          ),
          Space(height: 40),
          BoxInput(
            controller: _emailInput,
            label: 'Alamat Email',
            keyboardType: TextInputType.emailAddress,
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val.length)) {
                return 'email harus diisi';
              }

              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(_emailInput.text);
              if (!emailValid) {
                return 'email harus valid';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _additionalFormBasedOnRole() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(30),
        ScreenUtil().setHeight(40),
        ScreenUtil().setWidth(30),
        0
      ),
      child: _loggedInRole == ConstantHelper.ROLE_PEMAIN ?
      Column(
        children: [
          BoxInput(
            controller: _positionInput,
            label: 'Posisi',
          ),
          Space(height: 40),
          BoxInput(
            controller: _teamInput,
            label: 'Team',
            readOnly: true,
            suffixWidget: Container(
              width: ScreenUtil().setWidth(72),
              child: Button(
                onPressed: () {},
                fontSize: 10,
                text: 'Lihat Team',
                style: AppButtonStyle.primary,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Space(height: 40),
          _kkUploadForm()
        ],
      ) :
      _loggedInRole == ConstantHelper.ROLE_PELATIH
      || _loggedInRole == ConstantHelper.ROLE_WASIT ?
      Column(
        children: [
          BoxInput(
            controller: _licenseNameInput,
            label: 'Nama Lisensi',
          ),
          Space(height: 40),
          BoxInput(
            controller: _licenseNumberInput,
            label: 'Nomer Lisensi',
          ),
          Space(height: 40),
          BoxInput(
            controller: _licensePublisherInput,
            label: 'Penerbit Lisensi',
          ),
          Space(height: 40),
          _kkUploadForm()
        ],
      ) :
      Container(),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: const Offset(0, 3),
            blurRadius: 20,
          ),
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider('https://scontent-cgk1-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/c0.51.853.853a/s640x640/116793383_155683982795561_3501380845844702714_n.jpg?_nc_ht=scontent-cgk1-1.cdninstagram.com&_nc_cat=105&_nc_ohc=7SgjB_YhcrEAX9PWljX&tp=1&oh=77a60b198456376c48802cbef0023005&oe=6007A236'),
                ),
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
              onTap: () {},
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

  Widget _kkUploadForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxInput(
          controller: _kkInput,
          label: 'Upload KK',
          readOnly: true,
          suffixWidget: Container(
            width: ScreenUtil().setWidth(72),
            child: Button(
              onPressed: () {},
              fontSize: 10,
              text: 'Pilih File',
              style: AppButtonStyle.primary,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Space(height: 4),
        Text(
          '*Upload file (PNG, JPG, JPEG) max. 5 MB',
          style: TextStyle(
            fontSize: 12
          ),
        )
      ],
    );
  }
}
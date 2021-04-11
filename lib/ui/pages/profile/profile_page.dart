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
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/ui/pages/profile/qr_code_page.dart';
import 'package:perbasitlg/ui/pages/splash_page.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/dropdown_input.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/upload_progress_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:intl/intl.dart';
import 'package:perbasitlg/ui/pages/profile/qr_scanner_page.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthCubit _authCubit = AuthCubit();
  ProfileCubit _profileCubit = ProfileCubit();
  TeamCubit _teamCubit = TeamCubit();
  HomeCubit _homeCubit = HomeCubit();

  String _loggedInRole;

  TextEditingController _nikInput = TextEditingController();
  TextEditingController _nameInput = TextEditingController();
  TextEditingController _birthPlaceInput = TextEditingController();
  TextEditingController _birthDateInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _addressInput = TextEditingController();
  TextEditingController _phoneInput = TextEditingController();
  String _birthDateForServer = '';
  File _profilePict;

  bool _isProfilePictPreview = false;
  bool _isKKPictPreview = false;
  bool _isLicensePictPreview = false;

  // Player additional form
  TextEditingController _positionInput = TextEditingController();
  TextEditingController _teamInput = TextEditingController();
  TextEditingController _kkInput = TextEditingController();
  File _kk;

  // Kuch additional form
  TextEditingController _licenseNameInput = TextEditingController();
  TextEditingController _licenseNumberInput = TextEditingController();
  TextEditingController _licensePublisherInput = TextEditingController();
  TextEditingController _licenseDateInput = TextEditingController();
  TextEditingController _licensePhotoInput = TextEditingController();
  File _licensePhoto;
  String _licenseDateForServer = '';
  int _selectedPositionId;
  String _selectedLicenseName;

  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _profileCubit = BlocProvider.of<ProfileCubit>(context);
    _teamCubit = BlocProvider.of<TeamCubit>(context);
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    _loggedInRole = _authCubit.loggedInUserData.role.name;

    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData?.positionId?.id)) {
      _selectedPositionId = _authCubit.loggedInUserData.positionId.id;
    }

    _formKey = GlobalKey<FormState>();

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

  void _updateProfile() async {
    // Checking _birhDateForServer value
    if (GlobalMethodHelper.isEmpty(_birthDateForServer)) {
      _birthDateForServer = _authCubit.loggedInUserData.birthDate;
    }

    if (GlobalMethodHelper.isEmpty(_licenseDateForServer)) {
      _licenseDateForServer = _authCubit.loggedInUserData.licenceActiveDate;
    }

    if (_loggedInRole == ConstantHelper.ROLE_PEMAIN) {
      LoadingDialog(
        title: 'Loading',
        description: 'Silahkan tunggu...'
      ).show(context);

      File resizedProfileImage = await GlobalMethodHelper.resizeImage(
        _profilePict, preferredWidth: 320,
        fileName: _profilePict.path.split("/").last
      );

      File resizedKKImage = await GlobalMethodHelper.resizeImage(
        _kk, preferredWidth: 320,
        fileName: _kk.path.split("/").last
      );

      Navigator.pop(context);

      ProfilePlayerRequest requestData = ProfilePlayerRequest(
        nik: _nikInput.text.trim(),
        name: _nameInput.text.trim(),
        birthPlace: _birthPlaceInput.text.trim(),
        birthDate: _birthDateForServer,
        email: _emailInput.text.trim(),
        address: _addressInput.text.trim(),
        phone: _phoneInput.text.trim(),
        foto: resizedProfileImage,
        positionId: _selectedPositionId.toString(),
        kk: resizedKKImage,
      );

      _profileCubit.updateProfilePlayer(requestData);
    }

    if (_loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT) {
      LoadingDialog(
        title: 'Loading',
        description: 'Silahkan tunggu...'
      ).show(context);

      File resizedProfileImage = await GlobalMethodHelper.resizeImage(
        _profilePict, preferredWidth: 320,
        fileName: _profilePict.path.split("/").last
      );

      File resizedLicenseImage = await GlobalMethodHelper.resizeImage(
        _licensePhoto, preferredWidth: 320,
        fileName: _licensePhoto.path.split("/").last
      );

      Navigator.pop(context);

      ProfileCoachRequest requestData = ProfileCoachRequest(
        nik: _nikInput.text.trim(),
        name: _nameInput.text.trim(),
        birthPlace: _birthPlaceInput.text.trim(),
        birthDate: _birthDateForServer,
        email: _emailInput.text.trim(),
        address: _addressInput.text.trim(),
        phone: _phoneInput.text.trim(),
        foto: resizedProfileImage,
        licence: _licenseNameInput.text.trim(),
        licenceNumber: _licenseNumberInput.text.trim(),
        licenceFrom: _licensePublisherInput.text.trim(),
        licenceFile: resizedLicenseImage,
        licenceActiveDate: _licenseDateForServer
      );

      _profileCubit.updateProfileCoach(requestData, _loggedInRole);
    }
  }

  File _generateProfilePictFileFromUrl(String filename) {
    String pathName = p.join(App().appDocsDir.path, filename);
    _profilePict = File(pathName);
    return File(pathName);
  }

  File _generateKKFileFromUrl(String filename) {
    String pathName = p.join(App().appDocsDir.path, filename);
    _kk = File(pathName);
    return File(pathName);
  }

  File _generateLicenseFileFromUrl(String filename) {
    String pathName = p.join(App().appDocsDir.path, filename);
    _licensePhoto = File(pathName);
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
          _updateFields();
          setState(() {});
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
              elevation: 0,
              title: Text(
                'Biodata',
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

  void _updateFields() {
    _nikInput.text = _authCubit.loggedInUserData.nik;
    _nameInput.text = _authCubit.loggedInUserData.name;
    _birthPlaceInput.text = _authCubit.loggedInUserData.birthPlace;
    _birthDateInput.text = DateFormat('dd MMMM yyyy').format(
      DateTime.parse(_authCubit.loggedInUserData.birthDate)
    );
    _emailInput.text = _authCubit.loggedInUserData.email;
    _addressInput.text = _authCubit.loggedInUserData.address;
    _phoneInput.text = _authCubit.loggedInUserData.phone;
    _positionInput.text = _authCubit.loggedInUserData.positionId?.name ?? '';
    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.kk)) {
      _kkInput.text = 'KK sudah di upload';
    }

    if (_teamCubit.userHaveTeam) {
      _teamInput.text = _teamCubit.myClubDetail.detailTeam.name;
    } else {
      _teamInput.text = 'Belum memiliki team';
    }

    // Coach input
    _licenseNameInput.text = _authCubit.loggedInUserData.licence;
    _licenseNumberInput.text = _authCubit.loggedInUserData.licenceNumber;
    _licensePublisherInput.text = _authCubit.loggedInUserData.licenceFrom;
    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.licenceActiveDate)) {
      _licenseDateInput.text = DateFormat('dd MMMM yyyy').format(
        DateTime.parse(_authCubit.loggedInUserData.licenceActiveDate)
      );
    }
    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.licenseFile)) {
      _licensePhotoInput.text = 'Foto lisensi sudah di upload';
    }
    _selectedLicenseName = _authCubit.loggedInUserData.licence;
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
              onPressed: () {
                if (_profilePict == null) {
                  showFlutterToast('Anda belum memilih foto profile');
                  return;
                }

                if (!_formKey.currentState.validate()) {
                  return;
                }

                _updateProfile();
              },
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
          BoxInput(
            controller: _birthDateInput,
            label: 'Tanggal Lahir',
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val)) {
                return 'tanggal lahir harus valid';
              }
            },
            onClick: () async {
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
          Space(height: 40),
          BoxInput(
            controller: _addressInput,
            label: 'Alamat',
            maxLines: 2,
            keyboardType: TextInputType.emailAddress,
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val)) {
                return 'alamat harus di isi';
              }
            },
          ),
          Space(height: 40),
          BoxInput(
            controller: _phoneInput,
            label: 'No. Telefon',
            keyboardType: TextInputType.phone,
            validator: (String val) {
              if (val.length < 10) {
                return 'nomor telefon harus valid';
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black38,
                  width: 1,
                ),
              )
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                hint: Text('Pilih Posisi'),
                value: _selectedPositionId,
                items: _authCubit.playerPositionList.map((value) {
                  return DropdownMenuItem(
                    child: Text(value.name),
                    value: value.id,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPositionId = value;
                  });
                },
              ),
            ),
          ),
          Space(height: 40),
          BoxInput(
            controller: _teamInput,
            label: 'Team',
            onClick: () => _homeCubit.changeSelectedPage(2),
            suffixWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: ScreenUtil().setWidth(72),
                  height: ScreenUtil().setHeight(32),
                  child: Button(
                    onPressed: () => _homeCubit.changeSelectedPage(2),
                    fontSize: 10,
                    text: 'Lihat Team',
                    padding: 0,
                    style: AppButtonStyle.primary,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Space(height: 40),
          _kkUploadForm()
        ],
      ) :
      _loggedInRole == ConstantHelper.ROLE_PELATIH
      || _loggedInRole == ConstantHelper.ROLE_WASIT ?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama Lisensi',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey
            ),
          ),
          _loggedInRole == ConstantHelper.ROLE_WASIT ? DropdownInput(
            onChanged: (value) {
              setState(() {
                _licenseNameInput.text = value;
              });
            },
            listItem: ['C', 'B2', 'B1', 'A', 'FIBA', 'Pengawas'].map((bank) {
              return DropdownData(
                value: bank,
                text: bank
              );
            }).toList(),
            defaultValues: _selectedLicenseName,
          ) : _loggedInRole == ConstantHelper.ROLE_PELATIH ? DropdownInput(
            onChanged: (value) {
              setState(() {
                _licenseNameInput.text = value;
              });
            },
            listItem: ['C', 'B', 'A'].map((bank) {
              return DropdownData(
                value: bank,
                text: bank
              );
            }).toList(),
            defaultValues: _selectedLicenseName,
          ) : Container(),
          Space(height: 40),
          BoxInput(
            controller: _licenseNumberInput,
            label: 'Nomer Lisensi',
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val)) {
                return 'nomor lisensi harus di isi';
              }
            },
          ),
          Space(height: 40),
          BoxInput(
            controller: _licensePublisherInput,
            label: 'Penerbit Lisensi',
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val)) {
                return 'penerbit lisensi harus di isi';
              }
            },
          ),
          Space(height: 40),
          BoxInput(
            controller: _licenseDateInput,
            label: 'Tanggal Lisensi',
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val)) {
                return 'tanggal lisensi harus valid';
              }
            },
            onClick: () async {
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
                _licenseDateForServer = DateFormat('yyyy-MM-dd').format(fullResult);

                // formatting datetime to show to the screen
                _licenseDateInput.text = DateFormat('dd MMMM yyyy').format(fullResult);

                setState(() {});
              } else {
                return;
              }
            },
          ),
          Space(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoxInput(
                controller: _licensePhotoInput,
                label: 'Foto Lisensi',
                onClick: () async {
                  String filePath = await getImagePathFromGallery();
                  if (!GlobalMethodHelper.isEmpty(filePath)) {
                    _licensePhoto = File(filePath);

                    if (_licensePhoto.lengthSync() > 5120000) {
                      showFlutterToast('Maximum photo size is 5 MB');
                      return;
                    }

                    _licensePhotoInput.text = 'File sudah dipilih';

                    showFlutterToast('Tekan tombol simpan untuk menyimpan foto lisensi yang telah dipilih');
                  }
                },
                validator: (String args) {
                  if (_licensePhoto == null) {
                    return 'foto lisensi harus di pilih';
                  }
                },
                suffixWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLicensePhoto(),
                    Space(width: 8),
                    Container(
                      width: ScreenUtil().setWidth(72),
                      height: ScreenUtil().setHeight(32),
                      child: Button(
                        onPressed: () {},
                        fontSize: 10,
                        text: 'Pilih File',
                        style: AppButtonStyle.primary,
                        padding: 0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
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
          )
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

  Widget _kkUploadForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxInput(
          controller: _kkInput,
          label: 'Upload KK',
          onClick: () async {
            String filePath = await getImagePathFromGallery();
            if (!GlobalMethodHelper.isEmpty(filePath)) {
              _kk = File(filePath);

              if (_kk.lengthSync() > 5120000) {
                showFlutterToast('Maximum photo size is 5 MB');
                return;
              }

              _kkInput.text = 'File sudah dipilih';

              _isKKPictPreview = true;
              setState(() {});
              showFlutterToast('Tekan tombol simpan untuk menyimpan foto KK yang telah dipilih');
            }
          },
          validator: (String args) {
            if (_kk == null) {
              return 'file kk harus di pilih';
            }
          },
          suffixWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildKkThumbnail(),
              Space(width: 8),
              Container(
                width: ScreenUtil().setWidth(72),
                height: ScreenUtil().setHeight(32),
                child: Button(
                  onPressed: () {},
                  fontSize: 10,
                  text: 'Pilih File',
                  style: AppButtonStyle.primary,
                  padding: 0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
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

  Widget _buildKkThumbnail() {
    if (_isKKPictPreview) {
      return Container(
        width: ScreenUtil().setWidth(32),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(_kk),
          ),
        ),
      );
    }

    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.kk)) {
      return Container(
        width: ScreenUtil().setWidth(32),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkToFileImage(
              url: _authCubit.loggedInUserData.kk,
              file: _generateKKFileFromUrl(_authCubit.loggedInUserData.kk.split('/').last)
            ),
          ),
        ),
      );
    }

    return Container(
      width: ScreenUtil().setWidth(32),
      height: ScreenUtil().setHeight(32),
    );
  }

  Widget _buildLicensePhoto() {
    if (_isLicensePictPreview) {
      return Container(
        width: ScreenUtil().setWidth(32),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(_licensePhoto.path),
          ),
        ),
      );
    }

    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.licenseFile)) {
      return Container(
        width: ScreenUtil().setWidth(32),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkToFileImage(
              url: _authCubit.loggedInUserData.licenseFile,
              file: _generateLicenseFileFromUrl(_authCubit.loggedInUserData.licenseFile.split('/').last)
            ),
          ),
        ),
      );
    }

    return Container(
      width: ScreenUtil().setWidth(32),
      height: ScreenUtil().setHeight(32),
    );
  }
}
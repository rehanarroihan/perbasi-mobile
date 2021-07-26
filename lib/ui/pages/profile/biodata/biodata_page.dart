import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/cubit/home/home_cubit.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/request/profile_coach_request.dart';
import 'package:perbasitlg/models/request/profile_player_request.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/dropdown_input.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/gender_options.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/upload_progress_dialog.dart';
import 'package:perbasitlg/utils/constant_helper.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:intl/intl.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';

class BiodataPage extends StatefulWidget {
  BiodataPage({Key key}) : super(key: key);

  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  AuthCubit _authCubit = AuthCubit();
  ProfileCubit _profileCubit = ProfileCubit();
  TeamCubit _teamCubit = TeamCubit();
  HomeCubit _homeCubit = HomeCubit();

  GlobalKey<FormState> _formKey;

  String _loggedInRole;

  TextEditingController _nikInput = TextEditingController();
  TextEditingController _nameInput = TextEditingController();
  TextEditingController _birthPlaceInput = TextEditingController();
  TextEditingController _birthDateInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _addressInput = TextEditingController();
  TextEditingController _phoneInput = TextEditingController();
  String _birthDateForServer = '';

  Gender _selectedGender = Gender.L;

  // Player additional form
  TextEditingController _positionInput = TextEditingController();
  TextEditingController _teamInput = TextEditingController();
  TextEditingController _noKKInput = TextEditingController();
  TextEditingController _almaMaterInput = TextEditingController();
  String _selectedDomicile;

  // Kuch additional form
  TextEditingController _licenseNameInput = TextEditingController();
  TextEditingController _licenseNumberInput = TextEditingController();
  TextEditingController _licensePublisherInput = TextEditingController();
  TextEditingController _licenseDateInput = TextEditingController();
  String _licenseDateForServer = '';
  int _selectedPositionId;
  String _selectedLicenseName;
  String _selectedCoachTypeId;

  void _updateProfile() async {
    // Checking _birthDateForServer value
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

      Navigator.pop(context);

      ProfilePlayerRequest requestData = ProfilePlayerRequest(
        nik: _nikInput.text.trim(),
        name: _nameInput.text.trim(),
        birthPlace: _birthPlaceInput.text.trim(),
        birthDate: _birthDateForServer,
        email: _emailInput.text.trim(),
        address: _addressInput.text.trim(),
        phone: _phoneInput.text.trim(),
        positionId: _selectedPositionId.toString(),
        gender: _selectedGender == Gender.L ? 'L' : 'P',
        almaMater: _almaMaterInput.text,
        identityAddress: _selectedDomicile,
        noKK: _noKKInput.text,
      );

      _profileCubit.updateProfilePlayer(requestData);
    }

    if (_loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT) {
      LoadingDialog(
        title: 'Loading',
        description: 'Silahkan tunggu...'
      ).show(context);

      Navigator.pop(context);

      ProfileCoachRequest requestData = ProfileCoachRequest(
        nik: _nikInput.text.trim(),
        name: _nameInput.text.trim(),
        birthPlace: _birthPlaceInput.text.trim(),
        birthDate: _birthDateForServer,
        email: _emailInput.text.trim(),
        address: _addressInput.text.trim(),
        phone: _phoneInput.text.trim(),
        licence: _licenseNameInput.text.trim(),
        licenceNumber: _licenseNumberInput.text.trim(),
        licenceFrom: _licensePublisherInput.text.trim(),
        licenceActiveDate: _licenseDateForServer,
        typeId: _selectedCoachTypeId,
        gender: _selectedGender == Gender.L ? 'L' : 'P'
      );

      _profileCubit.updateProfileCoach(requestData, _loggedInRole);
    }
  }

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _profileCubit = BlocProvider.of<ProfileCubit>(context);
    _teamCubit = BlocProvider.of<TeamCubit>(context);
    _homeCubit = BlocProvider.of<HomeCubit>(context);

    _loggedInRole = _authCubit.loggedInUserData.role.name;

    _formKey = GlobalKey<FormState>();

    _updateFields();

    super.initState();
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
      child: SingleChildScrollView(
        child: Column(
          children: [
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
          Text(
            'Jenis Kelamin',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(11),
                color: Colors.grey.withOpacity(0.9)
            ),
          ),
          Space(height: 8),
          GenderOptions(
            value: _selectedGender,
            onChange: (Gender gend) {
              setState(() {
                _selectedGender = gend;
              });
            },
          ),
          Space(height: 32),
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
      child: _loggedInRole == ConstantHelper.ROLE_PEMAIN ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Domisili',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(11),
              color: Colors.grey.withOpacity(0.9)
            ),
          ),
          DropdownInput(
            placeholder: 'Pilih domisili',
            onChanged: (value) {
              setState(() {
                _selectedDomicile = value;
              });
            },
            listItem: ['Tulungagung', 'Luar Kota'].map((dom) {
              return DropdownData(
                value: dom,
                text: dom
              );
            }).toList(),
            defaultValues: _selectedDomicile,
          ),
          Space(height: 40),
          BoxInput(
            controller: _noKKInput,
            label: 'Nomor KK',
            keyboardType: TextInputType.number,
            validator: (String val) {
              if (val.length < 16) {
                return 'nomor kk harus valid';
              }
            },
          ),
          Space(height: 40),
          BoxInput(
            controller: _almaMaterInput,
            label: 'Sekolah / Almamater',
            validator: (String val) {
              if (GlobalMethodHelper.isEmpty(val)) {
                return 'almamater harus di isi';
              }
            },
          ),
          Space(height: 40),
          Text(
            'Posisi',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(11),
              color: Colors.grey.withOpacity(0.9)
            ),
          ),
          DropdownInput(
            placeholder: 'Pilih posisi',
            onChanged: (value) {
              setState(() {
                _selectedPositionId = value;
              });
            },
            listItem: _authCubit.playerPositionList.map((value) {
              return DropdownData(
                value: value.id.toString(),
                text: value.name,
              );
            }).toList(),
            defaultValues: _selectedPositionId.toString(),
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
                    text: 'Lihat Club',
                    padding: 0,
                    style: AppButtonStyle.primary,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ) :
      _loggedInRole == ConstantHelper.ROLE_PELATIH || _loggedInRole == ConstantHelper.ROLE_WASIT ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loggedInRole == ConstantHelper.ROLE_PELATIH ? _coachTypeField() : Container(),
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
          ) :
          _loggedInRole == ConstantHelper.ROLE_PELATIH ? DropdownInput(
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
        ],
      ) :
      Container(),
    );
  }

  Widget _coachTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis Pelatih',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey
          ),
        ),
        DropdownInput(
          onChanged: (value) {
            setState(() {
              _selectedCoachTypeId = value;
            });
          },
          listItem: _authCubit.coachTypeList.map((coachType) {
            return DropdownData(
              value: coachType.id.toString(),
              text: coachType.name
            );
          }).toList(),
          defaultValues: _selectedCoachTypeId,
        ),
        Space(height: 40),
      ],
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
    if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.gender)) {
      _selectedGender = _authCubit.loggedInUserData.gender == 'L'
          ? Gender.L
          : Gender.P;
    }

    // Coach input
    if (_loggedInRole == ConstantHelper.ROLE_PELATIH) {
      _licenseNameInput.text = _authCubit.loggedInUserData.licence;
      _licenseNumberInput.text = _authCubit.loggedInUserData.licenceNumber;
      _licensePublisherInput.text = _authCubit.loggedInUserData.licenceFrom;
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.licenceActiveDate)) {
        _licenseDateInput.text = DateFormat('dd MMMM yyyy').format(
            DateTime.parse(_authCubit.loggedInUserData.licenceActiveDate)
        );
      }
      _selectedLicenseName = _authCubit.loggedInUserData.licence;
      _selectedCoachTypeId = _authCubit.loggedInUserData.typeId.id.toString();
    }

    if (_loggedInRole == ConstantHelper.ROLE_PEMAIN) {
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.identityAddress)) {
        _selectedDomicile = _authCubit.loggedInUserData.identityAddress;
      }
      _noKKInput.text = _authCubit.loggedInUserData.noKK;
      _almaMaterInput.text = _authCubit.loggedInUserData.almamater;
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData?.positionId?.id)) {
        _selectedPositionId = _authCubit.loggedInUserData.positionId.id;
      }
      if (_teamCubit.userHaveTeam) {
        String clubNames = '';
        for (int i = 0; i<_teamCubit.myClubList.length; i++) {
          if (i == 0) {
            clubNames += _teamCubit.myClubList[0].detailTeam.name;
          } else {
            clubNames += ', ' + _teamCubit.myClubList[0].detailTeam.name;
          }
        }
        _teamInput.text = clubNames;
      } else {
        _teamInput.text = 'Belum memiliki team';
      }
    }

    if (_loggedInRole == ConstantHelper.ROLE_WASIT) {
      _licenseNameInput.text = _authCubit.loggedInUserData.licence;
      _licenseNumberInput.text = _authCubit.loggedInUserData.licenceNumber;
      _licensePublisherInput.text = _authCubit.loggedInUserData.licenceFrom;
      if (!GlobalMethodHelper.isEmpty(_authCubit.loggedInUserData.licenceActiveDate)) {
        _licenseDateInput.text = DateFormat('dd MMMM yyyy').format(
            DateTime.parse(_authCubit.loggedInUserData.licenceActiveDate)
        );
      }
      _selectedLicenseName = _authCubit.loggedInUserData.licence;
    }
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
        ],
      ),
    );
  }
}
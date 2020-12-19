import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/models/request/register_request.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthCubit _authCubit;

  int _selectedRoleIndex = 0;
  List<Map<String, dynamic>> _roleList = [
    {
      'id': 3,
      'role': 'Pemain'
    },
    {
      'id': 4,
      'role': 'Pelatih'
    },
    {
      'id': 2,
      'role': 'Wasit'
    },
  ];
  String _birthDateForServer = '';

  GlobalKey<FormState> _formKey;

  TextEditingController _nikInput = TextEditingController();
  TextEditingController _nameInput = TextEditingController();
  TextEditingController _birthPlaceInput = TextEditingController();
  TextEditingController _birthDateInput = TextEditingController();
  TextEditingController _passwordInput = TextEditingController();
  TextEditingController _confirmPasswordInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);

    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  void _doRegister() {
    RegisterRequest registerData = RegisterRequest(
      roleId: _roleList[_selectedRoleIndex]['id'].toString(),
      nik: _nikInput.text.trim(),
      email: _emailInput.text.trim(),
      birthPlace: _birthPlaceInput.text.trim(),
      name: _nameInput.text.trim(),
      password: _confirmPasswordInput.text.trim(),
      birthDate: _birthDateForServer
    );
    _authCubit.registerUser(registerData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authCubit,
      listener: (context, state) {
        if (state is RegisterInitialState) {
          LoadingDialog(
            title: 'Silahkan Tunggu',
            description: 'Mendaftarkan pengguna'
          ).show(context);
        } else if (state is RegisterSuccessfulState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.pageBackgroundColor,
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                offset: const Offset(0, -3),
                blurRadius: 24,
              ),
            ]
          ),
          child: Container(
            width: double.infinity,
            child: Button(
              style: AppButtonStyle.secondary,
              text: 'daftar',
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _doRegister();
                }
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(24)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Space(height: 24),
                  Icon(Icons.arrow_back_outlined),
                  Space(height: 24),
                  Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Space(height: 10),
                  _roleForm(),
                  Space(height: 40),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              _birthDateInput.text = DateFormat('dd M yyyy').format(fullResult);

                              setState(() {});
                            } else {
                              return;
                            }
                          },
                          child: BoxInput(
                            controller: _birthDateInput,
                            enabled: false,
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
                        Space(height: 40),
                        BoxInput(
                          controller: _passwordInput,
                          label: 'Kata sandi',
                          passwordField: true,
                          validator: (String val) {
                            if (val.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                          },
                        ),
                        Space(height: 40),
                        BoxInput(
                          controller: _confirmPasswordInput,
                          label: 'Ulangi kata sandi',
                          passwordField: true,
                          validator: (String val) {
                            if (_passwordInput.text != val) {
                              return 'konfirmasi password tidak valid';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Space(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleForm() {
    return GestureDetector(
      onTap: () => _showRegisterRoleDialog(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              'Daftar sebagai',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(10),
                color: Colors.black54
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black26,
                  width: 1,
                ),
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _roleList[_selectedRoleIndex]['role'],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.chevron_right)
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterRoleDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter stateSetter) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(20)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih Daftar Sebagai',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context)
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _roleList.map<Widget>((item) => _roleOptionTile(
                    text: item['role'],
                    onClick: () {
                      Navigator.pop(context);
                      _roleOptionChange(_roleList.indexWhere((element) => element == item));
                    }
                  )).toList(),
                ),
                Space(height: 12),
              ],
            );
          }
        );
      }
    );
  }

  void _roleOptionChange(int roleIndex) {
    setState(() {
      _selectedRoleIndex = roleIndex;
    });
  }

  Widget _roleOptionTile({String text, Function onClick}) {
    return Container(
      width: double.infinity,
      child: FlatButton(
        color: text == _roleList[_selectedRoleIndex]['role']
            ? AppColor.primaryColor
            : Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(12),
          horizontal: ScreenUtil().setWidth(20),
        ),
        onPressed: () => onClick(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w400
              ),
            ),
          ],
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perbasitlg/cubit/auth/auth_cubit.dart';
import 'package:perbasitlg/models/request/change_password_request.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  AuthCubit _authCubit;

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirmation = TextEditingController();

  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _authCubit = BlocProvider.of<AuthCubit>(context);
    // TODO: implement initState
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  void _doChangePassword() async {
    ChangePasswordRequest changePasswordRequest = ChangePasswordRequest(
        old_password: _oldPassword.text,
        password: _password.text,
        password_confirmation: _passwordConfirmation.text);
    _authCubit.postChangePassword(changePasswordRequest);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _authCubit,
      listener: (context, state) {
        if (state is ChangePasswordInitialState) {
          LoadingDialog(
              title: 'Silahkan Tunggu',
              description: 'Merubah Password')
              .show(context);
        } else if (state is ChangePasswordFailedState) {
          Navigator.pop(context);
          AppAlertDialog(
              title: 'Merubah password gagal',
              description: state.message,
              positiveButtonText: 'Ok',
              positiveButtonOnTap: () => Navigator.pop(context))
              .show(context);
        } else if (state is ChangePasswordSuccessfulState) {
          Navigator.pop(context);
          AppAlertDialog(
              title: 'Merubah password berhasil',
              description: state.message,
              positiveButtonText: 'Ok',
              positiveButtonOnTap: () {
                Navigator.pop(context);
              }).show(context);
        }
      },
      child: BlocBuilder(
          cubit: _authCubit,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                title: Text("Ubah Password", style: TextStyle(color: Colors.black),),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Space(height: 5),
                        Text("Ubah/Ganti Password",
                            style:
                            TextStyle(fontWeight: FontWeight.w600)),
                        Space(height: 5),
                        BoxInput(
                          controller: _oldPassword,
                          label: 'Password Lama',
                          keyboardType: TextInputType.text,
                          passwordField: true,
                          validator: (String val) {
                            if (val.length == 0) {
                              return 'Password lama harus diisi';
                            }
                          },
                        ),
                        Space(height: 5),
                        BoxInput(
                          controller: _password,
                          label: 'Password Baru',
                          keyboardType: TextInputType.text,
                          passwordField: true,
                          validator: (String val) {
                            if (val.length == 0) {
                              return 'Password baru harus diisi';
                            }
                          },
                        ),
                        Space(height: 5),
                        BoxInput(
                          controller: _passwordConfirmation,
                          label: 'Konfirmasi Password',
                          keyboardType: TextInputType.text,
                          passwordField: true,
                          validator: (String val) {
                            if (val.length == 0) {
                              return 'Konfirmasi password harus diisi';
                            }
                          },
                        ),
                        Space(height: 20),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              _doChangePassword();
                              FocusScope.of(context).unfocus();
                              _oldPassword.clear();
                              _password.clear();
                              _passwordConfirmation.clear();
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(16),
                            decoration: new BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(4))),
                            child: Text(
                              "Ubah Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

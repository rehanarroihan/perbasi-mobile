import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/app_color.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _selectedRoleIndex = 0;
  List<Map<String, dynamic>> _roleList = [
    {
      'id': 1,
      'role': 'Pemain'
    },
    {
      'id': 2,
      'role': 'Pelatih'
    },
    {
      'id': 3,
      'role': 'Wasit'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                BoxInput(
                  controller: TextEditingController(),
                  label: 'NIK',
                ),
                Space(height: 40),
                BoxInput(
                  controller: TextEditingController(),
                  label: 'Nama',
                ),
                Space(height: 40),
                BoxInput(
                  controller: TextEditingController(),
                  label: 'tempat lahir',
                ),
                Space(height: 40),
                BoxInput(
                  controller: TextEditingController(),
                  label: 'Kata sandi',
                  passwordField: true,
                ),
                Space(height: 40),
                BoxInput(
                  controller: TextEditingController(),
                  label: 'Ulangi kata sandi',
                  passwordField: true,
                ),
                Space(height: 32),
              ],
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
              ),
            ),
          ),
          Space(height: ScreenUtil().setHeight(8)),
          Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(12),
                    right: ScreenUtil().setWidth(12),
                    top: ScreenUtil().setHeight(12)
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
                )
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
          horizontal: ScreenUtil().setWidth(12),
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
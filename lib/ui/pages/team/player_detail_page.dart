import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/cubit/team/team_cubit.dart';
import 'package:perbasitlg/models/club_detail.dart';
import 'package:perbasitlg/models/document_model.dart';
import 'package:perbasitlg/models/request/verify_player_request.dart';
import 'package:perbasitlg/ui/pages/profile/qr_code_page.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/ui/widgets/modules/app_alert_dialog.dart';
import 'package:perbasitlg/ui/widgets/modules/loading_dialog.dart';
import 'package:perbasitlg/utils/app_color.dart';
import 'package:intl/intl.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';
import 'package:perbasitlg/utils/show_flutter_toast.dart';
import 'package:perbasitlg/utils/url_constant_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerDetailPage extends StatefulWidget {
  final TeamPlayer item;

  PlayerDetailPage({Key key, this.item}) : super(key: key);

  @override
  _PlayerDetailPageState createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  TeamCubit _teamCubit = TeamCubit();

  TextEditingController _nikInput = TextEditingController();
  TextEditingController _birthDetailInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _documentInput = TextEditingController();

  String _kkFileLink = '';

  String _actionType = '';

  @override
  void initState() {
    _teamCubit = BlocProvider.of<TeamCubit>(context);

    super.initState();
  }

  void verifyPlayer(String status) {
    _actionType = status;
    _teamCubit.verifyPlayer(VerifyPlayerRequest(
      registerId: widget.item.id.toString(),
      status: status
    ));
  }

  @override
  Widget build(BuildContext context) {
    _nikInput.text = widget.item.detail.nik ?? '';
    _emailInput.text = widget.item.detail.email ?? '';
    _birthDetailInput.text = widget.item.detail.birthPlace + ', '
        + DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.item.detail.birthDate));
    if (widget.item.document.length > 0) {
      List<DocumentModel> isKKDocExist = widget.item.document
          .where((dc) => dc.documentType == 'kk').toList();
      if (isKKDocExist.length > 0) {
        _documentInput.text = 'Documen KK';
        _kkFileLink = UrlConstantHelper.IMAGE_BASE_URL + isKKDocExist[0].file;
      }
    }

    return BlocListener(
      cubit: _teamCubit,
      listener: (context, state) {
        if (state is PlayerVerificationInitState) {
          Navigator.pop(context);
          LoadingDialog(
            title: 'Loading',
            description: 'Silahkan tunggu...'
          ).show(context);
        } else if (state is PlayerVerificationSuccessfulState) {
          showFlutterToast('Berhasil ${_actionType == 'accepted' ? 'menerima' : 'menolak'} pendaftar');
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          _teamCubit.getMyTeamPage();
        } else if (state is PlayerVerificationFailedState) {
          Navigator.pop(context);
          showFlutterToast('Gagal ${_actionType == 'accepted' ? 'menerima' : 'menolak'} pendaftar, mohon coba lagi');
        }
      },
      child: BlocBuilder(
        cubit: _teamCubit,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black
              ),
              title: Text(
                'Detail Pemain Pendaftar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14)
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(24),
                  vertical: ScreenUtil().setHeight(24)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfilePicture(),
                        Space(width: ScreenUtil().setWidth(12)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.detail.name,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Text(
                              'Player',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(12),
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Space(height: 24),
                    BoxInput(
                      controller: _nikInput,
                      label: 'NIK',
                      onClick: () {},
                    ),
                    Space(height: 40),
                    BoxInput(
                      controller: _birthDetailInput,
                      label: 'Tempat, Tanggal Lahir',
                      onClick: () {},
                    ),
                    Space(height: 40),
                    BoxInput(
                      controller: _emailInput,
                      label: 'Alamat Email',
                      onClick: () {},
                    ),
                    Space(height: 40),
                    BoxInput(
                      controller: _documentInput,
                      label: 'Dokumen',
                      onClick: GlobalMethodHelper.isEmpty(_kkFileLink) ? null : () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ImageDetailPage(
                            title: 'Dokumen',
                            imageDetail: _kkFileLink,
                          )
                        ));
                      },
                      suffixWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(72),
                            height: ScreenUtil().setHeight(32),
                            child: Button(
                              onPressed: () {},
                              fontSize: 10,
                              text: 'Lihat File',
                              style: AppButtonStyle.primary,
                              padding: 0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Space(height: 16),
                    _callToActionButtons()
                  ],
                ),
              ),
            ),
          );
        }
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
      child: Container(
        width: double.infinity,
        child: FlatButton(
          padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(13)
          ),
          onPressed: () {
            AppAlertDialog(
              title: 'Keluar',
              description: 'Apakah anda yakin mengeluarkan ${widget.item.detail.name} dari club ?',
              negativeButtonText: 'Kembali',
              negativeButtonOnTap: () => Navigator.pop(context),
              positiveButtonText: 'Keluarkan',
              positiveButtonOnTap: () => verifyPlayer('rejected'),
            ).show(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          color: AppColor.lightOrange,
          child: Text(
            'Keluarkan dari club',
            style: TextStyle(
              color: AppColor.primaryColor,
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500
            ),
          ),
        )
      ),
    );
  }

  Widget _buildProfilePicture() {
    List<DocumentModel> dm = widget.item.document.where((element) => element.documentType == 'foto').toList();
    
    if (dm.length != 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: AppColor.lightOrange,
          height: ScreenUtil().setHeight(99),
          width: ScreenUtil().setWidth(99),
          child: CachedNetworkImage(
            imageUrl: UrlConstantHelper.IMAGE_BASE_URL + dm[0].file,
          ),
        ),
      );;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.red,
        height: ScreenUtil().setHeight(99),
        width: ScreenUtil().setWidth(99),
        child: Center(
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
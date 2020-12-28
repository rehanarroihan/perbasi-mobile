import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perbasitlg/cubit/profile/profile_cubit.dart';
import 'package:perbasitlg/ui/widgets/base/circle_progress_bar.dart';
import 'package:perbasitlg/utils/app_color.dart';

class UploadProgressDialog extends StatefulWidget {
  final ProfileCubit profileCubit;

  UploadProgressDialog(this.profileCubit);

  @override
  _UploadProgressDialogState createState() => _UploadProgressDialogState();
}

class _UploadProgressDialogState extends State<UploadProgressDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: widget.profileCubit,
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please Wait',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CircleProgressBar(
                          foregroundColor: AppColor.primaryColor,
                          backgroundColor: AppColor.primaryColor.withOpacity(0.2),
                          value: widget.profileCubit.updateProfileUploadProgress / 100
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Updating profile ${widget.profileCubit.updateProfileUploadProgress.round()}%...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
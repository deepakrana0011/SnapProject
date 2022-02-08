import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/provider/history_provider.dart';
import 'package:snap_app/view/base_view.dart';
import 'package:snap_app/widgets/image_view.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        context: context,
        minTextAdapt: true,
        orientation: Orientation.portrait);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "history".tr()),
        body: BaseView<HistoryProvider>(
          onModelReady: (provider)  {
          },
          builder: (context, provider, _) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              margin: EdgeInsets.only(top: DimensionConstants.d36.h),
              padding: EdgeInsets.only(top: DimensionConstants.d38.h),
              decoration: BoxDecoration(
                color: ColorConstants.colorWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(DimensionConstants.d44.r),
                  topLeft: Radius.circular(DimensionConstants.d44.r),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  //  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: DimensionConstants.d73.h),
                    historyScreenCard(ImageConstants.emailIcon, "email".tr()),
                    historyScreenCard(ImageConstants.microphoneIcon, "voice".tr()),
                    historyScreenCard(ImageConstants.imageIcon, "photo".tr())
                  ]
              ),
              ),);
          },
        ));
  }

  Widget historyScreenCard(String imageIcon, String title){
    return Padding(
      padding: EdgeInsets.fromLTRB(DimensionConstants.d20.w, 0.0, DimensionConstants.d20.w, DimensionConstants.d19.h),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(DimensionConstants.d15.r),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(DimensionConstants.d19.w, DimensionConstants.d20.h, DimensionConstants.d18.w, DimensionConstants.d20.h),
          child: Row(
            children: [
              Container(
                height: DimensionConstants.d80.h,
                width: DimensionConstants.d80.w,
               decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DimensionConstants.d20.r),
              color: ColorConstants.textFieldGrayColor),
                child: ImageView(
                  path: imageIcon, height: DimensionConstants.d42.h,
                  width: DimensionConstants.d42.w
                ),
              ),
              SizedBox(width: DimensionConstants.d13.w),
              Text(title).mediumText(ColorConstants.colorBlackDown, DimensionConstants.d16.sp, TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}

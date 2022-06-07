import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snap_app/constants/color_constants.dart';
import 'package:snap_app/constants/dimension_constants.dart';
import 'package:snap_app/constants/image_constants.dart';
import 'package:snap_app/enum/view_state.dart';
import 'package:snap_app/extensions/all_extensions.dart';
import 'package:snap_app/helper/common_widgets.dart';
import 'package:snap_app/provider/history_provider.dart';
import 'package:snap_app/view/base_view.dart';
import 'package:snap_app/widgets/image_view.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.backgroundColor,
        appBar: CommonWidgets.appBar(context, "history".tr()),
        body: BaseView<HistoryProvider>(
          onModelReady: (provider)  {
            provider.history(context);
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
              child: provider.state == ViewState.busy ? Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: DimensionConstants.d4.h),
                  Text("loading_history".tr()).regularText(ColorConstants.primaryColor, DimensionConstants.d15.sp, TextAlign.center),
                ],
              )) :
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: provider.historyData.length,
                        itemBuilder: (context, index){
                          var dateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(provider.historyData[index].createdAt.toString(), true);
                          var dateLocal = dateTime.toLocal();
                          var timeLocal =  DateFormat('hh:mm a').format(dateTime.toLocal());
                      return historyScreenCard(provider.historyCardIcon(int.parse(provider.historyData[index].type.toString())), provider.historyCardName(int.parse(provider.historyData[index].type.toString())), "${dateLocal.day <= 9 ? "0" + dateLocal.day.toString() : dateLocal.day }-${dateLocal.month <= 9 ? "0" + dateLocal.month.toString() : dateLocal.month }-${dateLocal.year}", timeLocal);
                    })
                  ]
              ),
              ),);
          },
        ));
  }

  Widget historyScreenCard(String imageIcon, String title, String date, String time){
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
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(title).mediumText(ColorConstants.colorBlackDown, DimensionConstants.d16.sp, TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                )
              ),
              SizedBox(width: DimensionConstants.d4.w),
              Column(
                children: [
                  Row(
                    children: [
                      ImageView(path: ImageConstants.dateIcon),
                      SizedBox(width: DimensionConstants.d8.w),
                      Text(date).mediumText(ColorConstants.colorGrayDown, DimensionConstants.d12.sp, TextAlign.center)
                    ],
                  ),
                  SizedBox(height: DimensionConstants.d6.h),
                  Row(
                    children: [
                      SizedBox(width: DimensionConstants.d12.w),
                      ImageView(path: ImageConstants.timeIcon),
                      SizedBox(width: DimensionConstants.d4.w),
                      Text(time).mediumText(ColorConstants.colorGrayDown, DimensionConstants.d12.sp, TextAlign.center)
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

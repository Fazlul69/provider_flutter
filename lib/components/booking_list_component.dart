import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/price_widget.dart';
import 'package:handyman_provider_flutter/handyman/screen/handyman_booking_detail_screen.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/provider/booking/booking_summary_dialog.dart';
import 'package:handyman_provider_flutter/provider/booking/p_booking_detail_screen.dart';
import 'package:handyman_provider_flutter/provider/handyman/assign_handyman_Dialog.dart';
import 'package:handyman_provider_flutter/utils/app_common.dart';
import 'package:handyman_provider_flutter/utils/color_extension.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../widgets/app_widgets.dart';

class BookingListComponent extends StatefulWidget {
  final String? status;
  final BookingData? bookingData;
  final int? index;

  BookingListComponent({this.status, this.bookingData, this.index});

  @override
  BookingListComponentState createState() => BookingListComponentState();
}

class BookingListComponentState extends State<BookingListComponent> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    //
  }

  Future<void> updateBooking(int bookingId, String updatedStatus, int index) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: bookingId,
      BookingUpdateKeys.status: updatedStatus,
    };
    await bookingUpdate(request).then((res) async {
      LiveStream().emit(LiveStreamUpdateBookings);
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> confirmationRequestDialog(BuildContext context, int index, String status) async {
    showConfirmDialogCustom(
      context,
      positiveText: context.translate.lblYes,
      negativeText: context.translate.lblNo,
      primaryColor: status == BookingStatusKeys.rejected ? Colors.redAccent : primaryColor,
      onAccept: (context) async {
        LiveStream().emit(LiveStreamUpdateBookings);
        updateBooking(widget.bookingData!.id.validate(), status, index);
      },
      title: context.translate.confirmationRequestTxt,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              cachedImage(
                widget.bookingData!.image_attchments!.isNotEmpty ? widget.bookingData!.image_attchments!.first.validate() : '',
                fit: BoxFit.cover,
                width: context.width(),
                height: 150,
              ).cornerRadiusWithClipRRect(defaultRadius),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  constraints: BoxConstraints(maxWidth: context.width() * 0.3),
                  decoration: boxDecorationWithShadow(
                    backgroundColor: widget.bookingData!.status.validate().getPaymentStatusBackgroundColor,
                    borderRadius: radius(24),
                  ),
                  child: Marquee(
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: Text(
                      "${widget.bookingData!.status_label.validate()}",
                      style: boldTextStyle(color: white, size: 12),
                    ).paddingSymmetric(horizontal: 8, vertical: 4),
                  ),
                ),
              ),
            ],
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.bookingData!.service_name.validate(),
                style: boldTextStyle(size: 18),
                overflow: TextOverflow.ellipsis,
              ).expand(),
              8.height,
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(16), backgroundColor: primaryColor),
                child: Text('#' + widget.bookingData!.id.toString().validate(), style: boldTextStyle(color: white)),
              )
            ],
          ),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PriceWidget(
                price: widget.bookingData!.type == ServiceTypeHourly
                    ? widget.bookingData!.totalAmount.validate()
                    : calculateTotalAmount(
                        servicePrice: widget.bookingData!.price.validate(),
                        qty: widget.bookingData!.quantity.validate(),
                        couponData: widget.bookingData!.couponData != null ? widget.bookingData!.couponData : null,
                        taxes: widget.bookingData!.taxes.validate(),
                        serviceDiscountPercent: widget.bookingData!.discount.validate(),
                      ),
                color: primaryColor,
                isHourlyService: widget.bookingData!.isHourlyService,
                size: 20,
              ),
              if (widget.bookingData!.type.toString().validate() == ServiceTypeHourly) 4.width else 8.width,
              if (widget.bookingData!.discount != null && widget.bookingData!.discount != 0)
                Row(
                  children: [
                    Text('(${widget.bookingData!.discount}%', style: boldTextStyle(size: 14, color: Colors.green)),
                    Text(' ${context.translate.lblOff})', style: boldTextStyle(size: 14, color: Colors.green)),
                  ],
                ),
            ],
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(servicesAddress, height: 18, width: 18, color: context.iconColor),
              8.width,
              Text(
                widget.bookingData!.address != null ? widget.bookingData!.address.validate() : context.translate.notAvailable,
                style: secondaryTextStyle(),
              ).flexible(),
            ],
          ),
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(calendar, height: 18, width: 18, color: context.iconColor),
              8.width,
              Row(
                children: [
                  Text("${formatDate(widget.bookingData!.date.validate(), format: DATE_FORMAT_6)} At ", style: secondaryTextStyle()),
                  Text(formatDate(widget.bookingData!.date.validate(), format: DATE_FORMAT_3), style: boldTextStyle(size: 14)),
                ],
              ),
            ],
          ),
          if (widget.bookingData!.customer_name.validate().isNotEmpty)
            Column(
              children: [
                16.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(profile, height: 18, width: 18, color: context.iconColor),
                    8.width,
                    Text(widget.bookingData!.customer_name.validate(), style: secondaryTextStyle()),
                  ],
                ),
              ],
            ),
          if (widget.bookingData!.handyman!.validate().isNotEmpty && isUserTypeProvider)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(profile, height: 18, width: 18, color: context.iconColor),
                        8.width,
                        Text(context.translate.handyman, style: primaryTextStyle(size: 14)).expand(),
                      ],
                    ).expand(),
                    Text(
                      widget.bookingData!.handyman!.first.handyman!.displayName.validate(),
                      style: secondaryTextStyle(),
                    ).flexible(),
                  ],
                ),
              ],
            ),
          16.height,
          if (widget.bookingData!.payment_status != null)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(total_booking, height: 18, width: 18, color: context.iconColor),
                        8.width,
                        Text(context.translate.paymentStatus, style: primaryTextStyle(size: 14)).expand(),
                      ],
                    ).expand(),
                    Text(
                      getPaymentStatusText(widget.bookingData!.payment_status),
                      style: boldTextStyle(size: 14, color: widget.bookingData!.payment_status.validate() == PAID ? Colors.green : Colors.red),
                    ).flexible(),
                  ],
                ),
                8.height,
              ],
            ),
          if (isUserTypeProvider && widget.bookingData!.status == BookingStatusKeys.pending || (isUserTypeHandyman && widget.bookingData!.status == BookingStatusKeys.accept))
            Row(
              children: [
                if (isUserTypeProvider)
                  Row(
                    children: [
                      AppButton(
                        child: Text(context.translate.accept, style: boldTextStyle(color: white)),
                        width: context.width(),
                        color: primaryColor,
                        elevation: 0,
                        onTap: () async {
                          await showInDialog(
                            context,
                            backgroundColor: Colors.transparent,
                            builder: (_) {
                              return BookingSummaryDialog(
                                bookingDataList: widget.bookingData!,
                                bookingId: widget.bookingData!.id,
                              );
                            },
                            shape: RoundedRectangleBorder(borderRadius: radius()),
                            contentPadding: EdgeInsets.zero,
                          );
                        },
                      ).expand(),
                      16.width,
                    ],
                  ).expand(),
                AppButton(
                  child: Text(context.translate.decline, style: boldTextStyle()),
                  width: context.width(),
                  elevation: 0,
                  color: appStore.isDarkMode ? cardDarkColor : cardColor,
                  onTap: () {
                    confirmationRequestDialog(context, widget.index!, BookingStatusKeys.rejected);
                  },
                ).expand(),
              ],
            ),
          if (isUserTypeProvider && widget.bookingData!.handyman!.isEmpty && widget.bookingData!.status == BookingStatusKeys.accept)
            Column(
              children: [
                8.height,
                AppButton(
                  width: context.width(),
                  child: Text(context.translate.lblAssignHandyman, style: boldTextStyle(color: white)),
                  color: primaryColor,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AssignHandymanDialog(
                          bookingId: widget.bookingData!.id,
                          serviceAddressId: widget.bookingData!.booking_address_id,
                          onUpdate: () {
                            setState(() {});
                            LiveStream().emit(LiveStreamUpdateBookings);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    ).onTap(() async {
      if (isUserTypeProvider) {
        BookingDetailScreen(bookingId: widget.bookingData!.id).launch(context);
      } else {
        HBookingDetailScreen(bookingId: widget.bookingData!.id).launch(context);
      }
    }, hoverColor: Colors.transparent, highlightColor: Colors.transparent, splashColor: Colors.transparent);
  }
}

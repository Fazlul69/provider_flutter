import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/models/user_data.dart';
import 'package:handyman_provider_flutter/screens/chat/user_chat_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:handyman_provider_flutter/widgets/disabled_rating_bar_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class BasicInfoComponent extends StatefulWidget {
  final UserData? handymanData;
  final UserData? customerData;
  final ProviderData? providerData;
  final Service? service;
  final int flag;
  final BookingDetail? bookingDetail;

  BasicInfoComponent(this.flag, {this.customerData, this.handymanData, this.providerData, this.service, this.bookingDetail});

  @override
  BasicInfoComponentState createState() => BasicInfoComponentState();
}

class BasicInfoComponentState extends State<BasicInfoComponent> {
  Customer customer = Customer();
  ProviderData provider = ProviderData();
  UserData userData = UserData();
  Service service = Service();

  String? googleUrl;
  String? address;
  String? name;
  String? contactNumber;
  String? profileUrl;
  int? profileId;
  int? handymanRating;

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.flag == 0) {
      profileId = widget.customerData!.id.validate();
      name = widget.customerData!.displayName.validate();
      profileUrl = widget.customerData!.profileImage.validate();
      contactNumber = widget.customerData!.contactNumber.validate();
      address = widget.customerData!.address.validate();
      userData = widget.customerData!;
      await userService.getUser(email: widget.customerData!.email.validate()).then((value) {
        widget.customerData!.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });
    } else if (widget.flag == 1) {
      profileId = widget.handymanData!.id.validate();
      name = widget.handymanData!.displayName.validate();
      profileUrl = widget.handymanData!.profileImage.validate();
      contactNumber = widget.handymanData!.contactNumber.validate();
      address = widget.handymanData!.address.validate();
      userData = widget.handymanData!;
      await userService.getUser(email: widget.handymanData!.email.validate()).then((value) {
        widget.handymanData!.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });
    } else {
      profileId = widget.providerData!.id.validate();
      name = widget.providerData!.displayName.validate();
      profileUrl = widget.providerData!.profileImage.validate();
      contactNumber = widget.providerData!.contactNumber.validate();
      address = widget.providerData!.address.validate();
      provider = widget.providerData!;
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profileUrl.validate().isNotEmpty) circleImage(image: profileUrl.validate(), size: 65),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.validate(), style: boldTextStyle(size: 18)),
                      10.height,
                      if (widget.service!.categoryName.validate().isNotEmpty && widget.flag == 1)
                        Text(
                          widget.service!.categoryName.validate(),
                          style: secondaryTextStyle(),
                        ),
                      if (widget.service!.categoryName.validate().isNotEmpty && widget.flag == 1) 10.height,
                      if (userData.email.validate().isNotEmpty && widget.flag == 0)
                        Row(
                          children: [
                            ic_message.iconImage(size: 16),
                            6.width,
                            Text(userData.email.validate(), style: secondaryTextStyle()).flexible(),
                          ],
                        ).onTap(() {
                          launchMail(userData.email.validate());
                        }),
                      if (widget.bookingDetail != null && widget.flag == 0)
                        Column(
                          children: [
                            8.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                servicesAddress.iconImage(size: 20),
                                3.width,
                                Text(widget.bookingDetail!.address.validate(), style: secondaryTextStyle()).flexible(),
                              ],
                            ),
                          ],
                        ).onTap(() {
                          commonLaunchUrl('$GOOGLE_MAP_PREFIX${Uri.encodeFull(widget.bookingDetail!.address.validate())}', launchMode: LaunchMode.externalApplication);
                        }),
                      if (widget.flag == 1) DisabledRatingBarWidget(rating: userData.handymanRating.validate().toDouble(), size: 14),
                    ],
                  ).expand()
                ],
              ),
              8.height,
              Divider(),
              8.height,
              Row(
                children: [
                  if (contactNumber.validate().isNotEmpty)
                    AppButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(calling, color: white, height: 18, width: 18),
                          16.width,
                          Text(context.translate.lblCall, style: boldTextStyle(color: white)),
                        ],
                      ),
                      width: context.width(),
                      color: primaryColor,
                      elevation: 0,
                      onTap: () {
                        launchCall(contactNumber.validate());
                      },
                    ).expand(),
                  if (contactNumber.validate().isNotEmpty) 24.width,
                  AppButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(chat, color: context.iconColor, height: 18, width: 18),
                        16.width,
                        Text(context.translate.lblChat, style: boldTextStyle()),
                      ],
                    ),
                    width: context.width(),
                    elevation: 0,
                    color: context.scaffoldBackgroundColor,
                    onTap: () async {
                      UserChatScreen(receiverUser: userData).launch(context);
                    },
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
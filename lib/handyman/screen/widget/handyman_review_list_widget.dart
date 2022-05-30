import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/handyman_review_response.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:handyman_provider_flutter/widgets/disabled_rating_bar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewListWidget extends StatelessWidget {
  final HandymanReview? handymanReview;
  final bool? userProfile;

  ReviewListWidget({this.handymanReview, this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cachedImage(
            isUserTypeProvider ? handymanReview!.profile_image : handymanReview!.customer_profile_image,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ).cornerRadiusWithClipRRect(35),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(handymanReview!.customer_name.validate(), style: boldTextStyle()),
                  8.width,
                  Text('${DateTime.parse(handymanReview!.created_at.validate()).timeAgo}', style: secondaryTextStyle()),
                ],
              ),
              4.height,
              Text(handymanReview!.service_name.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
              4.height,
              DisabledRatingBarWidget(rating: handymanReview!.rating.validate().toDouble().toDouble(), size: 16),
              4.height,
              Text(handymanReview!.review.validate(), style: secondaryTextStyle(), maxLines: 4, overflow: TextOverflow.ellipsis)
            ],
          ).expand(),
        ],
      ),
    );
  }
}

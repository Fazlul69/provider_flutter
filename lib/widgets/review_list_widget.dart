import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:handyman_provider_flutter/widgets/disabled_rating_bar_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewListWidget extends StatelessWidget {
  final RatingData ratingData;

  ReviewListWidget({required this.ratingData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(ratingData.profileImage, height: 70, width: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(ratingData.customerName.validate(), style: boldTextStyle()),
                      8.width,
                      ratingData.createdAt.validate().isNotEmpty
                          ? Text(
                              '${DateTime.parse(ratingData.createdAt.validate()).timeAgo}',
                              style: secondaryTextStyle(),
                            )
                          : SizedBox(),
                    ],
                  ),
                  8.height,
                  DisabledRatingBarWidget(rating: ratingData.rating.validate().toDouble(), size: 16),
                  if (ratingData.review != null) Text(ratingData.review.validate(), style: secondaryTextStyle(), maxLines: 4, overflow: TextOverflow.ellipsis).paddingTop(8)
                ],
              ).expand(),
            ],
          ),
        ],
      ),
    );
  }
}

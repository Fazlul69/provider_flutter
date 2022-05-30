import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/screens/zoom_image_screen.dart';
import 'package:handyman_provider_flutter/widgets/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceProofListWidget extends StatefulWidget {
  final List<ServiceProof>? serviceProofList;

  ServiceProofListWidget({required this.serviceProofList});

  @override
  State<ServiceProofListWidget> createState() => _ServiceProofListWidgetState();
}

class _ServiceProofListWidgetState extends State<ServiceProofListWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text('Service Proof', style: boldTextStyle(size: 18)),
        16.height,
        Container(
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ListView.separated(
              separatorBuilder: (_, i) {
                return Divider(height: 0);
              },
              itemCount: widget.serviceProofList!.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                ServiceProof data = widget.serviceProofList![i];

                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.title!.isNotEmpty) Text(data.title.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (data.description!.isNotEmpty) 8.height,
                      if (data.description!.isNotEmpty) Text(data.description.validate(), style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (data.attachments!.isNotEmpty) 16.height,
                      if (data.attachments!.isNotEmpty)
                        HorizontalList(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          itemCount: data.attachments!.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            return Container(
                              decoration: boxDecorationRoundedWithShadow(10),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: cachedImage(
                                data.attachments![i].validate(),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ).onTap(() {
                              ZoomImageScreen(galleryImages: data.attachments!, index: i).launch(context);
                            });
                          },
                        ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
    ;
  }
}

import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';

import '../network/apiService.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';

class FeedListFragment extends StatefulWidget {
  @override
  _FeedListFragmentState createState() => _FeedListFragmentState();
}

class _FeedListFragmentState extends State<FeedListFragment> {
  bool descTextShowFlag = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: getNews() ,
      builder: (_, snap) {
        if (snap.hasData) {
          return ListView.builder(
            itemCount: snap.data!.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 24, right: 16),
            itemBuilder: (BuildContext context, int index) {
              News data = snap.data![index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cachedImage(
                    "${data.image.validate()}",
                    fit: BoxFit.fitWidth,
                    width: context.width(),
                    height: 200,
                  ).cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
                  Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                      backgroundColor: context.cardColor,
                    ),
                    width: context.width(),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text(
                          '${data.postDate.validate()}',
                          style: secondaryTextStyle(color: secondaryTxtColor),
                        ).paddingOnly(right: 8),
                        8.height,
                        Text('${data.postTitle.validate()}', style: boldTextStyle(size: 18)),
                        22.height,
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(80)),
                                child: cachedImage(data.image.validate(), fit: BoxFit.cover),
                              ).onTap(
                                    () {},
                              ),
                            ),
                            16.width,
                            Text('${data.postTitle.validate()}', style: boldTextStyle()).expand(),
                            AppButton(
                              onTap: () {
                               // Share.share(data.share_url.validate());
                              },
                              color: context.cardColor,
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/icons/share.png",
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.cover,
                                    color: secondaryTxtColor,
                                  ),
                                  8.width,
                                  Text('Share', style: secondaryTextStyle(color: secondaryTxtColor)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  24.height,
                ],
              ).onTap(() {
               // FeedDetailsScreen(newsData: data).launch(context);
              });
            },
          );
        }
        return snapWidgetHelper(snap);
      },
    );
  }
}

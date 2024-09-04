import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:socialverse/export.dart';

import '../../providers/reply_provider.dart';

class InfoSideBar extends StatelessWidget {
  const InfoSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final video = Provider.of<VideoProvider>(context);
    return Consumer<HomeProvider>(
      builder: (_, __, ___) {
        return Consumer<ReplyProvider>(builder: (context, value, child) {
          final postTitle = value.posts.isEmpty? __.posts[__.index].title:value.posts[value.index].title;
          return Positioned(
            left: 15,
            bottom: video.downloading == true || video.downloadingCompleted
                ? 30
                : 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (__.posts[__.index].title.isNotEmpty) ...[
                  SizedBox(
                    width: cs().width(context) - 100,
                    child: GestureDetector(
                      onTap: () => __.toggleTextExpanded(),
                      child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunchUrl(Uri.parse(link.url))) {
                            await launchUrl(Uri.parse(link.url));
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        text: postTitle,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.normalRegular,
                        textAlign: TextAlign.start,
                        maxLines: __.isTextExpanded
                            ? (5 + (6 * __.expansionProgress)).round()
                            : 1,
                        linkStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        });
      },
    );
  }
}

import 'package:socialverse/export.dart';

class ReplySideBar extends StatelessWidget {
  const ReplySideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final video = Provider.of<VideoProvider>(context);
    bool isAdmin = (prefs_username == 'afrobeezy' || prefs_username == 'jack');

    return Consumer<ReplyProvider>(
      builder: (_, __, ___) {
        //dynamic count = __.posts[__.index].commentCount;
        return __.posts.isEmpty
            ? shrink
            : Container(
                height: cs().height(context),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Column(
                              children: [
                                SideBarItem(
                                  onTap: () {
                                    if (__.posts[__.index].upvoted) {
                                      __.posts[__.index].upvoted = false;
                                      __.posts[__.index].upvoteCount--;
                                      __.postLikeRemove(
                                        id: __.posts[__.index].id,
                                      );
                                    } else {
                                      __.posts[__.index].upvoted = true;
                                      __.posts[__.index].upvoteCount++;
                                      __.postLikeAdd(
                                        id: __.posts[__.index].id,
                                      );
                                    }
                                  },
                                  // onTapDown: (position) {
                                  //   __.getTapPosition(context, position);
                                  // },
                                  // onLongPress: () async {
                                  //   // HapticFeedback.mediumImpact();
                                  //   // __.isSlider = true;
                                  //   __.showContextMenu(
                                  //     context,
                                  //     id: __.posts[__.index].id,
                                  //     rate_value:
                                  //         __.posts[__.index].ratingCount,
                                  //   );
                                  // },
                                  value: 14,
                                  icon: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return __.posts[__.index].upvoted
                                          ? LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: <Color>[
                                                Theme.of(context).hintColor,
                                                Colors.red,
                                                Theme.of(context).hintColor,
                                              ],
                                              tileMode: TileMode.repeated,
                                            ).createShader(bounds)
                                          : const LinearGradient(
                                              colors: <Color>[
                                                Colors.white,
                                                Colors.white
                                              ],
                                            ).createShader(bounds);
                                    },
                                    child: SvgPicture.asset(
                                      AppAsset.iclike,
                                      color: Colors.white,
                                    ),
                                  ),
                                  text: shrink,
                                  //   Text(
                                  //     __.posts[__.index].upvoteCount.toString(),
                                  //     style: TextStyle(
                                  //       fontSize: 13,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: Colors.white,
                                  //       fontFamily: 'sofia',
                                  //     ),
                                  //   ),
                                ),
                                height7,
                                // SideBarItem(
                                //   onTap: () {
                                //     if (logged_in == true) {
                                //       showModalBottomSheet(
                                //         constraints: BoxConstraints(
                                //           maxHeight:
                                //               cs().height(context) / 1.35,
                                //         ),
                                //         isScrollControlled: true,
                                //         shape: const RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.only(
                                //             topRight: Radius.circular(30),
                                //             topLeft: Radius.circular(30),
                                //           ),
                                //         ),
                                //         context: context,
                                //         builder: (context) {
                                //           return FractionallySizedBox(
                                //             heightFactor: 1,
                                //             child: HomeCommentWidget(
                                //               id: __.posts[__.index].id,
                                //             ),
                                //           );
                                //         },
                                //       );
                                //     } else {
                                //       auth.showAuthBottomSheet(context);
                                //     }
                                //   },
                                //   value: 14,
                                //   icon: SvgPicture.asset(
                                //     AppAsset.iccomment,
                                //     color: Colors.white,
                                //   ),
                                //   text: shrink,
                                //   // Consumer<CommentProvider>(
                                //   //   builder: (context, value, child) {
                                //   //     if (value.update_count == true) {
                                //   //       count++;
                                //   //       __.posts[__.index].commentCount = count;
                                //   //     }
                                //   //     return Text(
                                //   //       __.posts[__.index].commentCount
                                //   //           .toString(),
                                //   //       style: TextStyle(
                                //   //         fontSize: 13,
                                //   //         fontWeight: FontWeight.w400,
                                //   //         color: Colors.white,
                                //   //         fontFamily: 'sofia',
                                //   //       ),
                                //   //     );
                                //   //   },
                                //   // ),
                                // ),
                                // height7,
                                SideBarItem(
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    bool isUser = __.posts[__.index].username !=
                                        prefs_username;
                                    final link =
                                        await __.dynamicLink.createPostLink(
                                      imageUrl: __.posts[__.index].thumbnailUrl,
                                      postID: '${__.posts[__.index].id}',
                                      username: __.posts[__.index].username,
                                      description: __.posts[__.index].title,
                                      isPost: true,
                                    );
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.black,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                      ),
                                      builder: (context) {
                                        return ShareSheet(
                                          isUser: isUser,
                                          dynamicLink: link,
                                        );
                                      },
                                    );
                                  },
                                  value: 0,
                                  icon: Padding(
                                    padding: EdgeInsets.only(bottom: 3),
                                    child: Icon(
                                      UniconsLine.share,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  text: shrink,
                                  // Text(
                                  //   'Share',
                                  //   style: TextStyle(
                                  //     fontSize: 13,
                                  //     fontWeight: FontWeight.w400,
                                  //     color: Colors.white,
                                  //     fontFamily: 'sofia',
                                  //   ),
                                  // ),
                                ),
                                height7,
                                SideBarItem(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    if (video.isViewMode) {
                                      video.isViewMode = false;
                                    } else {
                                      video.isViewMode = true;
                                    }
                                  },
                                  value: 5,
                                  icon: Icon(
                                    Icons.fullscreen_rounded,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  text: shrink,
                                  // Text(
                                  //   'View',
                                  //   style: TextStyle(
                                  //     fontSize: 13,
                                  //     fontWeight: FontWeight.w400,
                                  //     color: Colors.white,
                                  //     fontFamily: 'sofia',
                                  //   ),
                                  // ),
                                ),
                                height7,
                                SideBarItem(
                                  onTap: () async {
                                    HapticFeedback.heavyImpact();
                                    if (__
                                        .videoController(__.index)!
                                        .value
                                        .isPlaying) {
                                      await __
                                          .videoController(__.index)!
                                          .pause();
                                    }
                                    __.showInspiredDialog(
                                      context,
                                      id: __.posts[__.index].id,
                                    );
                                  },
                                  value: 10,
                                  icon: Image.asset(
                                    AppAsset.icon,
                                  ),
                                  text: shrink,
                                ),
                                height7,
                                if (isAdmin) ...[
                                  SideBarItem(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      __.posts[__.index].exitCount += 1;
                                      __.updateExitCount(
                                        id: __.posts[__.index].id,
                                      );
                                    },
                                    value: 5,
                                    icon: Center(
                                      child: Text(
                                        '${__.posts[__.index].exitCount}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontFamily: 'sofia',
                                        ),
                                      ),
                                    ),
                                    text: shrink,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(
                            height: video.downloading == true ||
                                    video.downloadingCompleted
                                ? 40
                                : 40,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}

import 'package:socialverse/export.dart';
import 'package:socialverse/features/profile/widgets/profile/shared/bio.dart';
import 'package:socialverse/features/profile/widgets/profile/shared/posts_grid.dart';
import 'package:socialverse/features/profile/widgets/profile/shared/profile_info.dart';
import 'package:socialverse/features/profile/widgets/profile/shared/profile_stats_item.dart';
import 'package:socialverse/features/profile/widgets/profile/user/user_profile_button.dart';
import 'package:socialverse/features/profile/widgets/profile/user/user_profile_header.dart';

class UserProfileScreenArgs {
  final String username;
  final Function(bool isFollowing)? isFollowing;

  const UserProfileScreenArgs({
    required this.username,
    this.isFollowing,
  });
}

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user';
  const UserProfileScreen({
    Key? key,
    required this.username,
    this.isFollowing,
  }) : super(key: key);

  final String username;
  final Function(bool isFollow)? isFollowing;

  static Route route({required UserProfileScreenArgs args}) {
    return CupertinoPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => UserProfileScreen(
        username: args.username,
        isFollowing: args.isFollowing,
      ),
    );
  }

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late TabController _controller;
  late ScrollController _posts;

  fetchData() async {
    final user = Provider.of<UserProfileProvider>(context, listen: false);

    await user.getUserProfile(
      username: widget.username,
    );

    if (widget.username != prefs_username) {
      user.isFollowing = user.user.isFollowing;
      user.isBlocked = user.user.isBlocked;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _controller = TabController(length: 1, vsync: this);

    _posts = ScrollController();

    _posts.addListener(() {
      _profileScrollListener(_posts);
    });

    _controller.addListener(_tabChangeListener);
  }

  void _tabChangeListener() {
    if (_controller.index == 1) {
      _posts.jumpTo(0);
    }
  }

  void _profileScrollListener(ScrollController controller) {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      final user = Provider.of<UserProfileProvider>(context, listen: false);
      user.page++;
      if (_controller.index == 0) {
        user.getUserPosts(username: widget.username);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              __.user.username,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            surfaceTintColor: Colors.transparent,
            actions: [UserProfileHeader(username: __.user.username)],
          ),
          body: RefreshIndicator(
            color: Theme.of(context).indicatorColor,
            backgroundColor: Theme.of(context).primaryColor,
            notificationPredicate: (notification) {
              return notification.depth == 2;
            },
            onRefresh: () async {
              __.page = 1;
              __.posts.clear();
              __.loading = true;
              __.getUserProfile(username: __.user.username, forceRefresh: true);
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!__.loading &&
                    scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  __.page++;
                  if (_controller.index == 0) {
                    __.getUserPosts(username: widget.username);
                  }
                  return true;
                }
                return false;
              },
              child: NestedScrollView(
                controller: _posts,
                headerSliverBuilder: (context, ___) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height10,
                          CustomCircularAvatar(
                            borderColor: Theme.of(context).hintColor,
                            height: 100,
                            width: 100,
                            imageUrl: __.user.profilePictureUrl,
                          ),
                          height10,
                          Text(
                            __.user.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 20),
                          ),
                          height10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ProfileStatsItem(
                                    value: __.user.followerCount,
                                    label: 'Followers',
                                    onTap: () {
                                      if (__.user.followerCount != 0) {
                                        Navigator.of(context).pushNamed(
                                          FollowersScreen.routeName,
                                          arguments: FollowersScreenArgs(
                                            username: __.user.username,
                                          ),
                                        );
                                      }
                                    }),
                              ),
                              Expanded(
                                child: ProfileStatsItem(
                                  value: __.user.followingCount,
                                  label: 'Following',
                                  onTap: () {
                                    if (__.user.followingCount != 0) {
                                      Navigator.of(context).pushNamed(
                                        FollowingScreen.routeName,
                                        arguments: FollowingScreenArgs(
                                          username: __.user.username,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                child: ProfileStatsItem(
                                  value: __.user.postCount,
                                  label: 'Videos',
                                ),
                              ),
                            ],
                          ),
                          height20,
                          UserProfileButton(
                            isFollowing: widget.isFollowing,
                            username: __.user.username,
                            chat_id: __.user.chatId,
                          ),
                          Bio(bio: __.user.bio),
                          ProfileInfo(
                            instagram: __.user.instagramUrl,
                            tiktok: __.user.tiktokUrl,
                            youtube: __.user.youtubeUrl,
                            site: __.user.website,
                          ),
                          height20,
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: _controller,
                          labelStyle: AppTextStyle.bodyLarge
                              .copyWith(color: Color(0xFF9032E6)),
                          labelColor: Color(0xFF9032E6),
                          unselectedLabelStyle: AppTextStyle.bodyLarge
                              .copyWith(color: Theme.of(context).focusColor),
                          unselectedLabelColor: Theme.of(context).focusColor,
                          indicatorColor: Color(0xFF9032E6),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2.5,
                          indicatorPadding: EdgeInsets.symmetric(vertical: 6),
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(text: 'Videos'),
                            // Tab(text: 'Liked'),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _controller,
                  children: [
                    PostsGrid(
                      posts: __.posts,
                      isFromProfile: false,
                      likedTab: false,
                      isSelfProfile: false,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(20),
                    //   child: Text(
                    //     'This user\'s liked videos are private',
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .displaySmall!
                    //         .copyWith(fontSize: 15),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

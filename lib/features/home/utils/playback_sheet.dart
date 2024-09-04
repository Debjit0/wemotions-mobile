import 'package:socialverse/export.dart';
import 'package:socialverse/features/home/providers/reply_provider.dart';

class PlaybackSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<double> _items = [0.5, 1.0, 1.5, 2.0];
    return Consumer<HomeProvider>(
      builder: (_, __, ___) {
        return Consumer<ReplyProvider>(builder: (context,replies,child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < _items.length; i++)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      title: Text(
                        _items[i] == 1.0 ? 'Normal' : '${_items[i]}x',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontSize: 15),
                      ),
                      trailing: Radio(
                        value: _items[i],
                        activeColor: Theme.of(context).indicatorColor,
                        groupValue: replies.posts.isEmpty? __.playback_speed : replies.playback_speed,
                        onChanged: (value) {
                          HapticFeedback.mediumImpact();
                          if(replies.posts.isEmpty)
                          {
                            __.playback_speed = value!;
                          __.setPlaybackSpeed(__.playback_speed);
                          } else
                          {
                             replies.playback_speed = value!;
                          replies.setPlaybackSpeed(replies.playback_speed);
                          }
                          
                          navKey.currentState!
                            ..pop()
                            ..pop();
                        },
                      ),
                    ),
                  height20,
                ],
              ),
            );
          }
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../../instagram/classes/metadata_item.dart';
import 'widgets/story_item.dart';
import 'widgets/story_progress.dart';

class InstagramStoryView extends StatefulWidget {
  final int position;
  final String layout;
  final int time;
  final List<MetadataItem> items;

  const InstagramStoryView({
    required this.position,
    required this.items,
    required this.layout,
    required this.time,
  });

  @override
  State<InstagramStoryView> createState() => _StateInstagramStoryView();
}

class _StateInstagramStoryView extends State<InstagramStoryView>
    with SingleTickerProviderStateMixin {
  List<MetadataItem> get items => widget.items;
  int page = 0;

  /// Use for get devices position (FLUXBUILDER)
  GlobalKey keyScaffold = GlobalKey();

  Map<int, int?> storyDurations = {};

  @override
  void initState() {
    super.initState();

    page = widget.position;
  }

  void _onTap(TapUpDetails details) {
    var x = details.globalPosition.dx;

    /// remove spacing in FluxBuilder
    var box = keyScaffold.currentContext?.findRenderObject() as RenderBox?;
    var position = box?.localToGlobal(Offset.zero);
    if (position != null) {
      var dx = position.dx;
      x = x - dx;
    }
    var mediaWidth = MediaQuery.of(context).size.width;
    if ((x - (mediaWidth / 2)) > 0) {
      if (page >= items.length - 1) {
        Navigator.pop(context);
        return;
      }
      setState(() {
        page++;
      });
    } else {
      if (page == 0) return;
      setState(() {
        page--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: keyScaffold,
      body: Stack(
        children: [
          GestureDetector(
            onTapUp: _onTap,
            onLongPressUp: () {},
            child: StoryItem(
              items[page],
              layout: StoryItemLayout.values.firstWhere(
                (element) => element.name == widget.layout,
                orElse: () => StoryItemLayout.iframe,
              ),
              durationCallback: (value) {
                storyDurations[page] = value;
                if (mounted) {
                  setState(() {});
                }
              },
              key: Key('story-${items[page].id}'),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    items.length,
                    (index) {
                      final time = items[page].time ??
                          storyDurations[page] ??
                          widget.time;
                      return Expanded(
                        child: StoryProgressIndicator(
                          key: Key('time-${items[page].id}-$time'),
                          enable: page == index,
                          finished: page > index,
                          time: time,
                          onFinish: () {
                            if (page >= items.length - 1) {
                              Navigator.pop(context);
                              return;
                            }
                            setState(() {
                              page++;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .primaryColorLight
                        .withValueOpacity(0.5),
                    borderRadius: BorderRadius.circular(40)),
                margin: const EdgeInsets.only(
                  right: 20,
                  bottom: 20,
                  left: 10,
                  top: 10,
                ),
                width: 40,
                height: 40,
                child: const Center(child: Icon(CupertinoIcons.back)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

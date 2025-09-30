import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:fstore/common/tools/gravatar.dart';
import 'package:fstore/models/index.dart';
import 'package:inspireui/extensions/color_extension.dart';
import 'package:inspireui/widgets/timeago/timeago.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/chat_view_model.dart';
import '../../../models/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage chatMessage;

  final bool shouldShowInfo;
  final bool isFirstMessage;
  final bool isLastMessage;

  final bool isPrevMessageFromSameSender;
  final bool isNextMessageFromSameSender;

  final int diffWithNextInMin;
  final int diffWithPrevInMin;

  final bool shouldShowTimeSeparator;

  const ChatMessageBubble({
    super.key,
    required this.chatMessage,
    this.shouldShowInfo = true,
    this.isFirstMessage = false,
    this.isLastMessage = false,
    this.isPrevMessageFromSameSender = false,
    this.isNextMessageFromSameSender = false,
    this.diffWithNextInMin = 0,
    this.diffWithPrevInMin = 0,
  }) : shouldShowTimeSeparator =
            isFirstMessage || diffWithNextInMin > Duration.minutesPerDay;

  @override
  Widget build(BuildContext context) {
    final model = context.read<ChatViewModel>();
    final isMe =
        chatMessage.sender.isNotEmpty && chatMessage.sender == model.sender;
    return Padding(
      padding: EdgeInsets.only(
        top: 24.0 *
                (min(diffWithNextInMin, Duration.minutesPerHour) /
                    Duration.minutesPerHour) +
            (shouldShowInfo ? 24.0 : 0.0),
      ),
      child: Column(
        children: [
          if (shouldShowTimeSeparator)
            Padding(
              padding: const EdgeInsets.only(
                top: 24.0,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('dd MMMM yyyy')
                        .format(chatMessage.createdAt.toLocal()),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!shouldShowInfo)
                const SizedBox(
                  width: 36.0,
                )
              else if (!isMe)
                SizedBox.square(
                  key: ValueKey('avatar-${chatMessage.sender}'),
                  dimension: 36.0,
                  child: CircleAvatar(
                    foregroundImage: NetworkImage(
                      getGravatarUrl(chatMessage.sender),
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (shouldShowInfo && !isMe)
                      Text(
                        model.receiver == chatMessage.sender
                            ? model.receiverName
                            : chatMessage.sender,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4.0),
                    Tooltip(
                      message: DateFormat().format(
                        chatMessage.createdAt.toLocal(),
                      ),
                      waitDuration: const Duration(milliseconds: 500),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? context.read<AppModel>().darkTheme
                                  ? Colors.white12
                                  : Colors.black12
                              : Theme.of(context)
                                  .primaryColor
                                  .withValueOpacity(0.12),
                          borderRadius: _getBorderRadius(isMe),
                        ),
                        child: SelectableLinkify(
                          onOpen: (link) => Tools.launchURL(link.url),
                          text: chatMessage.text,
                          options: const LinkifyOptions(humanize: false),
                        ),
                      ),
                    ),
                    if (isLastMessage)
                      Align(
                        alignment: isMe
                            ? AlignmentDirectional.centerEnd
                            : AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 16.0,
                          ),
                          child: Text(
                            TimeAgo.format(
                              chatMessage.createdAt.toLocal(),
                              locale: context.read<AppModel>().langCode,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BorderRadiusDirectional _getBorderRadius(bool isMe) {
    const outerRadius = Radius.circular(20.0);
    const radius = Radius.circular(10.0);
    const zero = Radius.zero;

    final isNextAndPrevFromSameSender =
        isNextMessageFromSameSender && isPrevMessageFromSameSender;
    final defaultRadius =
        !isPrevMessageFromSameSender && !isNextMessageFromSameSender
            ? outerRadius
            : radius;

    var topStart = isMe ? defaultRadius : zero;
    var topEnd = isMe ? zero : defaultRadius;
    var bottomStart = defaultRadius;
    var bottomEnd = defaultRadius;

    final isFar = diffWithNextInMin > 15 || diffWithPrevInMin > 15;
    if (diffWithNextInMin > 15 ||
        diffWithNextInMin < 15 && !isNextMessageFromSameSender) {
      topStart = isMe ? outerRadius : zero;
      topEnd = isMe ? zero : outerRadius;
    }

    if (diffWithPrevInMin > 15 ||
        diffWithPrevInMin < 15 && !isPrevMessageFromSameSender) {
      bottomStart = outerRadius;
      bottomEnd = outerRadius;
    }

    if (isLastMessage) {
      bottomStart = outerRadius;
      bottomEnd = outerRadius;
    }

    if (!isFar && isNextAndPrevFromSameSender) {
      bottomStart = isMe ? bottomStart : radius;
      bottomEnd = isMe ? radius : bottomEnd;
      topStart = isMe ? topStart : radius;
      topEnd = isMe ? radius : topEnd;
    }

    return BorderRadiusDirectional.only(
      topStart: topStart,
      topEnd: topEnd,
      bottomStart: bottomStart,
      bottomEnd: bottomEnd,
    );
  }
}

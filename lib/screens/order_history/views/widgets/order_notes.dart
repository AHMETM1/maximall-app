import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:intl/intl.dart';

import '../../../../common/config.dart';
import '../../../../models/entities/order_note.dart';
import '../../../../widgets/common/box_comment.dart';

class OrderNotes extends StatelessWidget {
  const OrderNotes({
    super.key,
    required this.listOrderNote,
    required this.isLoading,
  });

  final List<OrderNote>? listOrderNote;
  final bool isLoading;

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy, HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (isLoading) {
          return kLoadingWidget(context);
        }
        if (listOrderNote?.isEmpty ?? true) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).orderNotes,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              listOrderNote!.length,
              (index) {
                final orderNote = listOrderNote![index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomPaint(
                        painter:
                            BoxComment(color: Theme.of(context).primaryColor),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 25),
                            child: kAdvanceConfig.orderNotesLinkSupport
                                ? Linkify(
                                    text: orderNote.note!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        height: 1.2),
                                    onOpen: (link) async {
                                      await Tools.launchURL(link.url);
                                    },
                                  )
                                : HtmlWidget(
                                    orderNote.note!,
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        height: 1.2),
                                  ),
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(DateTime.parse(orderNote.dateCreated!)),
                        style: const TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

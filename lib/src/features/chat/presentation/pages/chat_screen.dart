import 'package:flutter/material.dart';

import '../widgets/appBar_builder.dart';
import '../widgets/chat_body/chat_body.dart';
import '../widgets/message_sender/message_sender.dart';

class ChatScreen extends StatelessWidget {
  static const routName = '/chat-screen';

  const ChatScreen({
    required this.orderId,
    required this.otherPersonName,
    required this.otherPersonImage,
    required this.otherPersonPhoneNumber,
    required this.readOnly,
    Key? key,
  }) : super(key: key);

  final String orderId;
  final String otherPersonName;
  final String otherPersonImage;
  final String otherPersonPhoneNumber;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(
        context,
        otherPersonName,
        otherPersonImage,
        otherPersonPhoneNumber,
        readOnly,
      ),
      body: Column(
        children: [
          Expanded(
            child: readOnly
                ? ChatBodyWithOneTimeRead(
                    orderId,
                    otherPersonImage,
                    otherPersonName,
                  )
                : ChatBodyWithRealTimeChanges(
                    orderId,
                    otherPersonImage,
                    otherPersonName,
                  ),
          ),
          readOnly
              ? const _ReadOnlyContainer('This Chat is read only')
              : MessageSender(orderId),
        ],
      ), //
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

class _ReadOnlyContainer extends StatelessWidget {
  const _ReadOnlyContainer(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade300,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

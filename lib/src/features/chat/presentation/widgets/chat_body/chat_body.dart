import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/message.dart';

import '../../../../account/presentation/providers/account.dart';
import '../../providers/chat.dart';

import 'message_bubble.dart';

class ChatBodyWithRealTimeChanges extends StatelessWidget {
  const ChatBodyWithRealTimeChanges(
    this.orderId,
    this.otherPersonImage,
    this.otherPersonName, {
    Key? key,
  }) : super(key: key);

  final String orderId;
  final String otherPersonImage;
  final String otherPersonName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<Chat>(context, listen: false)
          .getChatWithRealTimeChanges(orderId),
      builder: (context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /*&&  !services.dataFetchedFromBackend*/
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('There Is No Messages!!!'),
          );
        }

        final currentUser = Provider.of<Account>(context, listen: false);
        final messages = snapshot.data!;

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemCount: messages.length,
          itemBuilder: (ctx, index) => MessageBubble(
            messages[index].message,
            messages[index].date,
            currentUser.image,
            otherPersonImage,
            otherPersonName,
            messages[index].messageType,
            messages[index].captionOfImage,
            currentUser.idIsMe(messages[index].senderId),
          ),
        );
      },
    );
  }
}

class ChatBodyWithOneTimeRead extends StatelessWidget {
  const ChatBodyWithOneTimeRead(
    this.orderId,
    this.otherPersonImage,
    this.otherPersonName, {
    Key? key,
  }) : super(key: key);

  final String orderId;
  final String otherPersonImage;
  final String otherPersonName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Chat>(context, listen: false)
          .getChatWithOneTimeRead(orderId),
      builder: (context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /*&&  !services.dataFetchedFromBackend*/
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('There Is No Messages!!!'),
          );
        }

        final currentUser = Provider.of<Account>(context, listen: false);
        final messages = snapshot.data!;
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          itemCount: messages.length,
          itemBuilder: (ctx, index) => MessageBubble(
            messages[index].message,
            messages[index].date,
            currentUser.image,
            otherPersonImage,
            otherPersonName,
            messages[index].messageType,
            messages[index].captionOfImage,
            currentUser.idIsMe(messages[index].senderId),
          ),
        );
      },
    );
  }
}

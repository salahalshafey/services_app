import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../account/presentation/providers/account.dart';
import '../../providers/chat.dart';

import '../../../../../core/util/builders/custom_alret_dialog.dart';

class TextSender extends StatelessWidget {
  const TextSender(
    this.orderId,
    this.sendButtonLoadingState,
    this.controller,
    this.slideController, {
    Key? key,
  }) : super(key: key);

  final String orderId;
  final void Function(bool state) sendButtonLoadingState;
  final TextEditingController controller;
  final AnimationController slideController;

  Future<void> _sendTextMessage(BuildContext context) async {
    final currentUser = Provider.of<Account>(context, listen: false);
    try {
      sendButtonLoadingState(true);
      await Provider.of<Chat>(context, listen: false).sendTextMessage(
        orderId,
        controller.text,
        currentUser.id,
      );
    } catch (error) {
      sendButtonLoadingState(false);
      showCustomAlretDialog(
        context: context,
        title: 'Error',
        titleColor: Colors.red,
        content: error.toString(),
      );
      return;
    }

    sendButtonLoadingState(false);
    controller.clear();
    slideController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _sendTextMessage(context),
      child: const Icon(Icons.send),
      style: const ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)))),
        minimumSize: WidgetStatePropertyAll(Size(55, 55)),
      ),
    );
  }
}

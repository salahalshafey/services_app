import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/chat.dart';
import '../../../../controllers/my_account.dart';
import '../../../general_custom_widgets/custom_alret_dialoge.dart';
import '../../../general_custom_widgets/location_picker.dart';

class LocationSender extends StatelessWidget {
  const LocationSender(
    this.orderId,
    this.sendButtonLoadingState,
    this.slideController, {
    Key? key,
  }) : super(key: key);

  final String orderId;
  final void Function(bool state) sendButtonLoadingState;
  final AnimationController slideController;

  Animation<Offset> get _offsetAnimation => Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(CurvedAnimation(
        parent: slideController,
        curve: Curves.linear,
      ));

  Future<void> _sendLocationMessage(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final location = await myLocationPicker(
      context: context,
      currentLocationChoiceTitle: 'Send Current Location',
      mapChoiceTitle: 'Sellect Location From The Map',
      loadingState: sendButtonLoadingState,
    );

    if (location == null) {
      return;
    }

    final currentUser = Provider.of<MyAccount>(context, listen: false);
    try {
      sendButtonLoadingState(true);
      await Chat.sendLocationMessage(
        orderId,
        location,
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
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: IconButton(
        onPressed: () => _sendLocationMessage(context),
        tooltip: 'Send Location',
        icon: Icon(
          Icons.location_on_sharp,
          color: Colors.grey.shade700,
          size: 30,
        ),
      ),
    );
  }
}

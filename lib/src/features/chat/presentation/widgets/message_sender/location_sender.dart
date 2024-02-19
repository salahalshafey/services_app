import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../account/presentation/providers/account.dart';
import '../../providers/chat.dart';

import '../../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../../core/util/builders/location_picker.dart';

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
      mapChoiceTitle: 'Select Location From The Map',
      loadingState: sendButtonLoadingState,
    );

    if (location == null) {
      return;
    }

    final currentUser = Provider.of<Account>(context, listen: false);
    try {
      sendButtonLoadingState(true);
      await Provider.of<Chat>(context, listen: false).sendLocationMessage(
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
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade700
              : Colors.grey.shade300,
          size: 30,
        ),
      ),
    );
  }
}

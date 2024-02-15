import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/builders/custom_alret_dialog.dart';
import '../../../../core/util/builders/custom_bottom_sheet.dart';

import '../providers/orders.dart';

import 'radio_list.dart';

class CancelTheOrderButton extends StatefulWidget {
  const CancelTheOrderButton(this.orderId, {Key? key}) : super(key: key);

  final String orderId;

  @override
  State<CancelTheOrderButton> createState() => _CancelTheOrderButtonState();
}

class _CancelTheOrderButtonState extends State<CancelTheOrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: _isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: _cancelTheOrder,
              child: const Text('Cancel The Order'),
            ),
    );
  }

  Future<void> _cancelTheOrder() async {
    /******* make sure that the user is sure about canceling the order ********/
    final cancel = await showCustomAlretDialog<bool>(
      context: context,
      title: 'Attention',
      titleColor: Colors.red,
      content: 'Are you Sure That You Want To Cancel This Order',
      actionsBuilder: (dialogContext) => [
        TextButton(
          child: const Text('Yes', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(dialogContext).pop(true);
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(dialogContext).pop(false);
          },
        ),
      ],
    );
    if (cancel == null || cancel == false) {
      return;
    }

    /***************** take the reason from the user **************************/
    final _choices = [
      'Want to change service giver',
      'Delivery time is too long',
      'Change of mind',
      'fees-order cost',
      'Service giver is not serious about his job',
      'Other',
    ];
    int? _sellectedIndex;
    String? _otherDetails;

    final reason = await showCustomBottomSheet<String>(
      context: context,
      title: 'Please select a reason',
      child: RadioList(
        choices: _choices,
        onSellected: (index, otherDetails) {
          _sellectedIndex = index;
          _otherDetails = otherDetails;
        },
      ),
      buttonTitle: 'Confirm',
      onButtonPressed: () {
        if (_sellectedIndex == null) {
          showCustomAlretDialog(
            context: context,
            title: 'Select a reason',
            titleColor: Colors.red,
            content: 'You must sellect a reason',
          );
          return;
        } else if (_sellectedIndex == _choices.length - 1 &&
            _otherDetails!.split(RegExp(' +')).length < 5) {
          showCustomAlretDialog(
            context: context,
            title: 'More details',
            titleColor: Colors.red,
            content: 'Please provide us more details not less than 5 words',
          );
          return;
        } else if (_sellectedIndex == _choices.length - 1) {
          Navigator.of(context).pop(_otherDetails);
        } else {
          Navigator.of(context).pop(_choices[_sellectedIndex!]);
        }
      },
    );
    if (reason == null) {
      return;
    }

    /********** Cancel the order And handle the errors and loading ************/
    final orders = Provider.of<Orders>(context, listen: false);
    try {
      _isLoadingState(true);
      await orders.cancelOrder(widget.orderId, reason);
    } catch (error) {
      _isLoadingState(false);
      showCustomAlretDialog(
        context: context,
        title: 'ERROR',
        titleColor: Colors.red,
        content: '$error',
      );
      return;
    }

    /************ if There is no errors go to current orders screen ***********/
    Navigator.of(context).pop();
  }

  void _isLoadingState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }
}

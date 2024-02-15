import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/util/functions/string_manipulations_and_search.dart';

class RadioList extends StatefulWidget {
  const RadioList({
    Key? key,
    required this.choices,
    required this.onSellected,
  }) : super(key: key);

  final List<String> choices;
  final void Function(int? index, String? otherDetails) onSellected;

  @override
  State<RadioList> createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  int? _sellectedIndex;
  var _textDirection = getDirectionalityOf("");
  final _otherDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final choicesNumber = widget.choices.length;
    return ListView.builder(
      itemCount: choicesNumber + 1,
      itemBuilder: (context, index) {
        if (index == choicesNumber) {
          return _sellectedIndex == choicesNumber - 1 // if sellect Other
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    autofocus: true,
                    autocorrect: false,
                    controller: _otherDetailsController,
                    maxLines: 5,
                    textDirection: _textDirection,
                    onChanged: (value) {
                      setState(() {
                        _textDirection = getDirectionalityOf(value);
                      });

                      widget.onSellected(
                        widget.choices.length - 1,
                        _otherDetailsController.text,
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Please provide us more details',
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                )
              : const SizedBox();
        }
        return RadioListTile<int>(
          title: Text(widget.choices[index]),
          value: index,
          groupValue: _sellectedIndex,
          onChanged: (index) {
            setState(() {
              _sellectedIndex = index;
            });

            if (index == choicesNumber - 1) {
              widget.onSellected(index, _otherDetailsController.text);
            } else {
              widget.onSellected(index, null);
            }
          },
        );
      },
    );
  }
}

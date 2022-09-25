import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/util/functions/general_functions.dart';

class RadioList extends StatefulWidget {
  const RadioList(this.choices, this.onSellected, {Key? key}) : super(key: key);
  final List<String> choices;
  final void Function(int? index, String? otherDetails) onSellected;

  @override
  State<RadioList> createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  int? _sellectedIndex;
  var _textDirection = TextDirection.ltr;
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
                      if (firstCharIsArabic(value)) {
                        setState(() {
                          _textDirection = TextDirection.rtl;
                        });
                      } else {
                        setState(() {
                          _textDirection = TextDirection.ltr;
                        });
                      }

                      widget.onSellected(
                        widget.choices.length - 1,
                        _otherDetailsController.text,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Please provide us more details',
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(15),
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

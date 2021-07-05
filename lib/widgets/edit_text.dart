import 'dart:core';

import 'package:flutter/material.dart';

typedef MyIntCallback(int);
class EditText extends StatelessWidget {

  final String text;
  final TextEditingController textController;
  final bool numbers;

  final MyIntCallback onChanged;

  const EditText({
    Key key, @required this.text, this.onChanged, this.textController, this.numbers,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      keyboardType: numbers?TextInputType.number:TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        hintText: text,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (text) {
        this.onChanged(text);
      },
    );
  }
}

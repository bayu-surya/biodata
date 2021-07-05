import 'package:flutter/material.dart';

typedef MyIntCallback(int);
class DatePicker extends StatelessWidget {

  final String text;
  final TextEditingController textController;
  final Function onClick;

  final MyIntCallback onChanged;

  const DatePicker({
    Key key, @required this.text, this.onChanged, this.textController, this.onClick,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextFormField(
          controller: textController,
          enabled: false,
          autofocus: false,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: text,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          onChanged: (text) {
            this.onChanged(text);
          },
        ),
        Row(
          children: <Widget>[
            Expanded(
              child:
              MaterialButton(
                onPressed: onClick,
                color: Colors.transparent,
                elevation: 0.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ResponseButton extends StatefulWidget {
  final int announcementId;
  final Function(int, BuildContext) addResponse;

  ResponseButton({required this.announcementId, required this.addResponse});

  @override
  _ResponseButtonState createState() => _ResponseButtonState();
}

class _ResponseButtonState extends State<ResponseButton> {
  bool isResponded = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isResponded ? Icons.star : Icons.star_border,
        color: isResponded ? Colors.yellow : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          isResponded = true;
        });
        widget.addResponse(widget.announcementId, context);
      },
    );
  }
}

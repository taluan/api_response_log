import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class LogResponsePage extends StatelessWidget {
  final String response;
  LogResponsePage({super.key, required this.response});

  final jsonViewThem = JsonViewTheme(
      viewType: JsonViewType.base,
      openIcon: const Icon(
        Icons.arrow_drop_down,
        size: 18,
        color: Colors.grey,
      ),
      closeIcon: const Icon(
        Icons.arrow_drop_up,
        size: 18,
        color: Colors.grey,
      ),
      backgroundColor: Colors.white, defaultTextStyle: TextStyle(color: Colors.black87));

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? json;
    try {
      json = jsonDecode(response);
    } catch (_) {}
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Log Response"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black26,
        actions: [
          TextButton.icon(onPressed: () async {
            await Clipboard.setData(ClipboardData(text: response));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã copy vào clipboard')));
          }, label: const Text('Copy'), icon: const Icon(Icons.copy),)
        ],
      ),
      body: json != null
          ? JsonView.map(
        json,
        theme: jsonViewThem,
      )
          : Container(
          decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: const BorderRadius.all(Radius.circular(8)),
              // border: Border.all(color: Colors.grey, width: 0.75)
          ),
          padding: const EdgeInsets.all(10),
          child: Text(response)),
    );
  }
}

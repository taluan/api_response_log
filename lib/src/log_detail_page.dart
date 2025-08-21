import 'dart:convert';


import 'package:api_response_log/src/log_response_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'model/log_api_model.dart';



class LogDetailPage extends StatefulWidget {
  final LogApiModel item;
  LogDetailPage({super.key, required this.item});

  @override
  State<LogDetailPage> createState() => _LogDetailPageState();
}

class _LogDetailPageState extends State<LogDetailPage> {
  bool isExpanded = true;

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

  void showMessageCopySuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã copy vào clipboard')));
  }

  Widget jsonHeaderView() {
    try {
      return JsonView.string(
        widget.item.header,
        theme: jsonViewThem,
      );
    } catch(e, s) {
      // debugPrint(s.toString());
      // debugPrint("jsonHeaderView error: ${e.toString()}");
    }
    return Text(widget.item.header);
  }

  String createCurl() {
    try {
      Map<String, dynamic> header = jsonDecode(widget.item.header);
      Map<String, dynamic> param = {};
      if (widget.item.params.isNotEmpty) {
        param = jsonDecode(widget.item.params);
        // param.forEach((key, value) {
        //   if (value != null) {
        //     header[key] = value;
        //   }
        // });
      }
      String curlCommand = '''
      curl -X '${widget.item.method}' \\
        '${widget.item.url}' \\
        -H 'accept: text/plain' \\
        -H '${jsonEncode(header).replaceAll(",\"", ",\n\"")}' \\
        -d '${jsonEncode(param).replaceAll(",\"", ",\n\"")}'
      ''';
      return curlCommand;
    } catch(_){}
    return "";
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? json;
    try {
      json = jsonDecode(widget.item.response);
    } catch (_) {}
    return Scaffold(
        appBar: AppBar(
          title: const Text("Log Detail"),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black26,
          actions: [
            IconButton(onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }, icon: Icon(Icons.screenshot_monitor_rounded)),
            TextButton.icon(onPressed: () async {
              await Clipboard.setData(ClipboardData(
                  text: "[${widget.item.method}] ${widget.item.url}\nHeaders: ${widget.item.header}\nParams: ${widget.item.params}\nResponse ${widget.item.statusCode}: ${widget.item.response}\nStartTime: ${widget.item.createdDate}\nEndRequestTime: ${widget.item.endRequestDate}"));
              showMessageCopySuccess(context);
            }, label: const Text('Copy all'), icon: const Icon(Icons.copy),)
          ],
          // elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 4,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text("[${widget.item.method}] ${widget.item.url}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  )),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: "[${widget.item.method}] ${widget.item.url}"));
                    showMessageCopySuccess(context);
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Header:",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  )),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: widget.item.header));
                    showMessageCopySuccess(context);
                  }, icon: const Icon(Icons.copy),),
                  const SizedBox(width: 5,),
                  TextButton.icon(
                    style: TextButton.styleFrom(shape: StadiumBorder(side: BorderSide(color: Colors.grey))),
                    onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text: createCurl()));
                    showMessageCopySuccess(context);
                  }, label: const Text('Copy curl'), icon: const Icon(Icons.copy),)
                ],
              ),
              // Text(item.header),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.grey, width: 0.75)),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(2),
                child: jsonHeaderView(),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                        "Params:",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      )),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: widget.item.params));
                    showMessageCopySuccess(context);
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.grey, width: 0.75)),
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.item.params)),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Response code: ${widget.item.statusCode}",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: (!widget.item.isSuccess ||
                              widget.item.response.contains('Status":{"Code":500') ||
                              widget.item.response.contains('Status":{"Code":401'))
                              ? Colors.red
                              : Colors.black87),
                    ),
                  ),

                  IconButton(onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  }, icon: isExpanded ? Icon(Icons.keyboard_arrow_up_rounded) : Icon(Icons.keyboard_arrow_down_rounded)),
                  IconButton(onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  LogResponsePage(response: widget.item.response,),));
                  }, icon: Icon(Icons.fullscreen_rounded)),
                  IconButton(onPressed: ()  async {
                    await Clipboard.setData(ClipboardData(text: widget.item.response));
                    showMessageCopySuccess(context);
                  }, icon: const Icon(Icons.copy),)
                ],
              ),
              isExpanded ? (json != null
                  ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.grey, width: 0.75)),
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(2),
                    child: JsonView.map(
                        json,
                        theme: jsonViewThem,
                      ),
                  )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.grey, width: 0.75)),
                      padding: const EdgeInsets.all(10),
                      child: Text(widget.item.response))) : const SizedBox(),
              Text("StartTime: ${widget.item.createdDate}"),
              Text("EndTime: ${widget.item.endRequestDate}"),
              if (widget.item.endRequestDate != null)
                Text("Duration: ${formatNumber(widget.item.endRequestDate!.difference(widget.item.createdDate).inMilliseconds)} ms"),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text('ĐÓNG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),)),
              const SizedBox(height: 30,),

            ],
          ),
        ),
      // persistentFooterAlignment: AlignmentDirectional.center,
      // persistentFooterButtons: [

      // ],
    );
  }
}

String formatNumber(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
  );
}
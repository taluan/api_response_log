
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import '../api_response_log.dart';
import 'log_detail_page.dart';
import 'model/log_api_model.dart';

class LogApiPage extends StatefulWidget {
  const LogApiPage({super.key});

  @override
  State<LogApiPage> createState() => _LogApiPageState();
}

class _LogApiPageState extends State<LogApiPage> {
  final searchController = TextEditingController();
  List<LogApiModel> datas = ApiLog.datas;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchOnChanged(String value) {
    setState(() {
      datas = ApiLog.datas.where((element) => removeDiacritics(element.url.toLowerCase()).contains(removeDiacritics(value.toLowerCase()))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log API'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        shadowColor: Colors.black26,
        actions: [
          ElevatedButton(onPressed: () {
            setState(() {
              ApiLog.clear();
              datas.clear();
            });
          }, child: const Text('Clear'),),
          const SizedBox(width: 10,),
          // TextButton.icon(
          //   label: const Text('Clear'),
          //   icon: const Icon(Icons.clear),
          //   onPressed: () {
          //     setState(() {
          //       ApiLog.clear();
          //       datas.clear();
          //     });
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 10, right: 12),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              autocorrect: false,
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Icon(Icons.search_rounded, size: 26, color: Colors.grey,),
                ),
                isDense: true,
                prefixIconConstraints:const BoxConstraints(maxWidth: 38, maxHeight: 38),
                suffixIconConstraints:const BoxConstraints(maxWidth: 38, maxHeight: 38),
                suffixIcon: IconButton(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    searchController.clear();
                    searchOnChanged("");
                  },
                ),
              ),
              onChanged: searchOnChanged,
            ),
          ),
          Expanded(child: ListView.builder(
              itemCount: datas.length,
              itemBuilder: (context, index) {
                final item = datas[index];
                return  ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>  LogDetailPage(item: item),));
                  },
                  title: Text("[${item.method}] ${item.statusCode} ${item.url}", style: TextStyle(fontSize: 13, color: (!item.isSuccess || item.response.contains('Status":{"Code":500') || item.response.contains('Status":{"Code":401')) ? Colors.red : Colors.black87),),
                  trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                  contentPadding: const EdgeInsets.only(left: 12, right: 5),
                );
              }))
        ],
      ),
    );
  }
}

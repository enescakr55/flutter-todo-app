import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vs_code/todoDetails.dart';
import 'todo.dart';
import 'package:http/http.dart' as http;

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainApplication(),
    );
  }
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text("Todo Items"),
        ),
        body: const HttpPage());
  }
}

class HttpPage extends StatefulWidget {
  const HttpPage({super.key});

  @override
  State<HttpPage> createState() => _HttpPageState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class _HttpPageState extends State<HttpPage> {
  bool sendRequest = false;
  bool isLoading = true;
  List<dynamic> list = List.empty(growable: true);
  List<TodoItem> todoItems = List.empty(growable: true);
  Future<List<dynamic>> getTodoList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> queryParams = {"limit": "150", "skip": "0"};
    sendRequest = true;
    var uri = Uri.https('dummyjson.com', '/todos', queryParams);
    final request = await http.get(uri);
    todoItems = (json.decode(request.body)['todos'] as List)
        .map((data) => TodoItem.fromJson(data))
        .toList();
    if (request.statusCode == 200) {
      setState(() {
        isLoading = false;
        sendRequest = true;
      });
      return list;
    } else {
      sendRequest = false;
      throw Exception("Veri çekilirken bir hata oluştu");
    }
  }
  void navigate(TodoItem todoItem) async{
    var waitData = await Navigator.push(context, MaterialPageRoute(builder: (_)=>TodoDetails(data: todoItem,)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (sendRequest == false) ...[
                ElevatedButton(
                    child: Text("Verileri Al"), onPressed: () => getTodoList())
              ],
              isLoading == true && sendRequest == true
                  ? CircularProgressIndicator()
                  : Container(
                      child: Expanded(
                          child: SizedBox(
                              height: 300,
                              width: 300,
                              child: ListView.builder(
                                  itemCount: todoItems.length,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      leading: Text(todoItems[i].id.toString()),
                                      title: Text(todoItems[i].todo),
                                      trailing: todoItems[i].completed == true
                                          ? const Icon(Icons.check)
                                          : const Icon(
                                              Icons.watch_later_outlined),
                                      onTap: ()=> navigate(todoItems[i]),
                                    );
                                  }))),
                    ),
              //IconButton(onPressed: ()=>getTodoList(), icon: const Icon(Icons.list))
            ],
          )
        ]);
  }
}

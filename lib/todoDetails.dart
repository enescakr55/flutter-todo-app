import 'package:flutter/material.dart';
import 'package:flutter_vs_code/todo.dart';

class TodoDetails extends StatefulWidget {
  const TodoDetails({super.key,required this.data }) ;
  final TodoItem data;
  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  late TodoItem todo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todo = widget.data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Text(todo.todo),),
    );
  }
}
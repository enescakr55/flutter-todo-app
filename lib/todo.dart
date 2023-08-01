class TodoItems {
  final Object todos;
  final int total;
  final int skip;
  final int limit;
  const TodoItems({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit
  });

  static TodoItems fromJson(json) => TodoItems(
    todos: json['todos'],
    total: json['total'],
    skip: json['skip'],
    limit: json['limit']

  );
}
class TodoItem {
  final int id;
  final String todo;
  final bool completed;
  final int userId;
  
  const TodoItem({
    required this.id,
    required this.completed,
    required this.todo,
    required this.userId
  });
  static TodoItem create(int id,String todo,bool completed, int userId) => TodoItem(id: id, completed: completed, todo: todo, userId: userId);
  static TodoItem fromJson(Map<String,dynamic> json) => TodoItem(
    id: json['id'] as int,
    todo: json['todo'] as String,
    completed: json['completed'] as bool,
    userId: json['userId'] as int
  );


}
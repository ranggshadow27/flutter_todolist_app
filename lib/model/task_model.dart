class Task {
  final int id;
  final String task;
  final DateTime dateTime;

  Task({
    this.dateTime,
    this.id,
    this.task,
  });

  Map<String, dynamic> toMap() {
    return ({
      'id': id,
      'task': task,
      'creationDate': dateTime.toString(),
    });
  }
}

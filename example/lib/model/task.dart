/*每个Task的模型文件*/
class Task{
  int id;//task_id
  String content;//task的具体内容
  String username;//task所属的用户名
  DateTime endTime;//截止时间
  bool isFinish;//是否完成

  Task({this.id, this.username, this.content, this.endTime, this.isFinish});

  Task.fromMap(Map<String,dynamic> map){
    this.id = map["id"];
    this.username = map["username"];
    this.content = map["content"];
    this.endTime = DateTime.parse(map["endTime"]);
    this.isFinish = map["isFinish"]==1;
  }//枚举map

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'content': content,
      'endTime': endTimeStr,
      'isFinish': isFinishInt
    };
  }//map格式

  String get endTimeStr {
    return "${this.endTime.year.toString()}-${this.endTime.month.toString().padLeft(2, '0')}-${this.endTime.day.toString().padLeft(2, '0')} ${this.endTime.hour.toString().padLeft(2, '0')}:${this.endTime.minute.toString().padLeft(2, '0')}";
  }//结束时间的格式化输出

  int get isFinishInt {
    return this.isFinish? 1:0 ;
  }//返回是否完成

  @override
  String toString() {
    return 'Task{id: $id, username: $username, content: $content, endTime: $endTime, isFinish: $isFinish}';
  }//返回String类型
}
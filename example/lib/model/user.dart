/*每个用户的模型文件*/
class user {
  int id;//用户id
  String username;//用户名
  String phone;//用户手机号
  String password;//密码
  String email;//邮箱
  String nickname;//昵称

  user({this.username,this.nickname,this.email, this.phone,this.password});

  user.fromMap(Map<String, dynamic> map) {
    this.username = map['username'];
    this.nickname = map['nickname'];
    this.email = map['email'];
    this.phone = map['phone'];
    this.password = map['password'];
  }//枚举map

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['username'] = this.username;
    map['nickname'] = this.nickname;
    map['email'] = this.email;
    map['phone'] = this.phone;
    map['password'] = this.password;
    return map;
  }//定义map格式
}
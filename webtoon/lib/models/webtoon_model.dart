class WebtoonModel {
  final String title, thumb, id;

  // named constructor를 사용했다.
  // flutter에서 자주 쓰이는 패턴
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}

class WebtoonModel {
  final String title, thumb, id;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
//java나 .net으로 치면 model과 같은 기능을 한다.
//api로 넘어오는 데이터는 json이라고 명명한 뒤, 해당의 내용을
//위와 같이 일종의 파싱을 하는 기능

//해당 기능은 api를 호출하여 받는 쪽에서 사용한다.
}

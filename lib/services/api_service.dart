import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";

  void getTodayToons() async {
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    //비동기 통신을 사용하는 이유는 api에서 요청을 보낸 뒤
    //응답값이 오지도 않았는데, 처리를 하는 것을 방지하기 위함
    //그렇기에 await키워드를 사용하며, 해당 키워드를 사용하기 위해선
    //함수에 async 키워드를 반드시 붙여줘야 한다.
    //또한 return type 이 future인 경우도 비동기 통신으로 응답을 받는다.

    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Error();
  }
}

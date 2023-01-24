import 'dart:convert';

import 'package:flutter_webtoon/models/webtoon_detail_modal.dart';
import 'package:http/http.dart' as http;
import '../models/webtoon_episode_modal.dart';
import '../models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodayToons() async {
    //위와 같이 void가 아닌, 타입을 명명 해줄경우, async를 사용하면 에러가 발생한다.
    //에러 발생을 막기 위해선 Future 키워드를 사용한다.
    List<WebtoonModel> webtoonInstance = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    //비동기 통신을 사용하는 이유는 api에서 요청을 보낸 뒤
    //응답값이 오지도 않았는데, 처리를 하는 것을 방지하기 위함
    //그렇기에 await키워드를 사용하며, 해당 키워드를 사용하기 위해선
    //함수에 async 키워드를 반드시 붙여줘야 한다.
    //또한 return type 이 future인 경우도 비동기 통신으로 응답을 받는다.

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      //현재 api를 호출 했을때 넘어오는 데이터의 타입은 리스트 안에 든 객체 형태이다.
      //그렇기 때문에 webtoons 안에는 응답값을 디코딩 해서 담아주고, 타입은 리스트로 명명한다.
      //참고로 dynamic은 어떤 타입이라도 받을 수 있다.
      for (var webtoon in webtoons) {
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstance.add(instance);
        //java나 .net으로 치면 model과 같다.
        //models 폴더내에서 api 응답값을 받아서, model에 담는 기능을 만든 뒤(WebtoonModel.fromJson)
        //api 응답값을 받는 쪽에서 해당 함수를 호출하여 사용
      }
      return webtoonInstance;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatesEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}

import 'dart:convert';

// pub.dev에서 http 공식 패키지를 다운받았다.
// pubspec.yaml에 복붙하거나, 아니면 flutter 명령어로 shell에서 다운 가능
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  // 지금은 이 메소드가 어떤 타입을 반환할지 알 수 없다. 이를 위해 Future가 있다.
  // async: await을 쓰려면 필수
  // get함수가 Future를 반환하므로 이 함수도 Future를 이용해야 한다.
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url); // Future 타입 리턴. 미래에 받을 값의 타입을 알려준다.
    // API 요청은 인터넷 연결, 서버 메모리 문제 등 여러 이유로 시간이 걸릴 수 있다.
    // API 요청이 완료된 후 응답을 반환할 때까지 대기하게 할 것이다.
    // await는 주로 Future 타입을 반환할 때 사용한다.
    // get은 Future<Response> 타입을 반환하며, 미래에 Response 타입을 반환함을 의미한다.
    // Response는 서버 응답 정보를 담고 있다.

    if (response.statusCode == 200) {
      // statusCode == 200: 요청이 성공했다는 의미
      // response의 body를 json으로 디코딩
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
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

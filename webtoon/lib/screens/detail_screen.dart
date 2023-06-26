import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // 여기서 바로 widget을 참조할 수 없다.
  // late modifier로 생성자에서 초기화 불가능한 프로퍼티의 초기화 미루기
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    // 스마트폰 저장소에 액세스를 얻는다.
    prefs = await SharedPreferences.getInstance();
    // likedToons를 저장소에서 불러온다.
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id)) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      // 앱을 처음 실행하면 likedToons는 없으므로 새로 만들어준다.
      // 딱히 setStringList의 결과를 기다릴 필요는 없으므로 await를 쓸 필요는 없다.
      prefs.setStringList('likedToons', []);
    }
  }

  onHeartTap() async {
    // likedToons를 저장소에서 불러온다.
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      // likedToons를 다시 저장소에 저장한다.
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 생성자에서 초기화 불가능한 프로퍼티는 여기서 초기화한다.
    // initState는 build보다 먼저 호출되기 때문
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          )
        ],
        title: Text(
          // 그냥 title이 아니라 widget.title로 표현되는 이유는 stateful로 바뀌면서
          // 위젯과 state가 별개가 되었기 때문. 즉, 클래스가 분리되었다.
          // widget: 부모 클래스(DetailScreen)한테 가라
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero: 화면 전환 시 애니메이션 제공
                  Hero(
                    // Navigator.push로 받은 webtoon.id를 이용한다.
                    // webtoon_widget.dart에도 Hero 위젯의 태그와 같은 값이다.
                    // 그냥 id가 아니라 widget.id로 표현되는 이유는 stateful로 바뀌면서
                    // 위젯과 state가 별개가 되었기 때문. 즉, 클래스가 분리되었다.
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      // clipBehavior: 자식의 부모 영역 침범 제어 방법
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.5),
                          )
                        ],
                      ),
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // ListView나 ListViewBuilder를 쓰지 않는 이유는 episodes는 10개만 가져오기 때문
                    // ListView나 ListViewBuilder는 리스트가 엄청 길고 최적화가 엄청 중요할 때만 사용한다.
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          ),
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  // const는 컴파일 전에 값을 알고 있다는 뜻
  // 즉, Future를 쓰면 const는 못 씀
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      // FutureBuilder가 대신 await을 해준다.
      // 이것 덕분에 stateful widget을 쓸 필요가 없다.
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          // context: BuildContext
          // snapshot으로 Future의 상태를 알 수 있다.
          // 예: 데이터를 받았는지 오류가 났는지
          if (snapshot.hasData) {
            // future의 동작이 끝나고 서버가 응답했을 때만 동작
            // ListView는 버전이 많다.
            // return ListView(
            //   children: [
            //     for (var webtoon in snapshot.data!) Text(webtoon.title),
            //   ],
            // );

            // ListView에 비해 최적화되어 있다.
            // return ListView.builder(
            //   // 수평 방향 스크롤
            //   scrollDirection: Axis.horizontal,
            //   itemCount: snapshot.data!.length,
            //   // itemBuilder: 위젯을 반환하는 함수를 정의한다.
            //   itemBuilder: (context, index) {
            //     // 사용자가 보고 있는 아이템만 빌드 할 것이다.
            //     // 보고 있지 않은 아이템은 ListView.builder가 해당 아이템을 메모리에서 삭제할 것이다.
            //     // 어떤 아이템이 빌드되는지는 index를 통해 알 수 있다.
            //     var webtoon = snapshot.data![index];
            //     print(index);
            //     return Text(webtoon.title);
            //   },
            // );

            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                // Expanded: 화면의 남는 공간을 차지하는 위젯
                Expanded(child: makeList(snapshot)),
              ],
            );
          }
          return const Center(
            // 로딩 동그라미 그려주는 위젯
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      itemBuilder: (context, index) {
        // 사용자가 보고 있는 아이템만 빌드 할 것이다.
        // 보고 있지 않은 아이템은 ListView.builder가 해당 아이템을 메모리에서 삭제할 것이다.
        // 어떤 아이템이 빌드되는지는 index를 통해 알 수 있다.
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      // separatorBuilder: 아이템을 구분하기 위해 아이템 사이에 렌더링 될 위젯을 반환하는 함수
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}

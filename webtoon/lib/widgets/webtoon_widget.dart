import 'package:flutter/material.dart';
import 'package:webtoon/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTapUp(손가락을 올라감)과 onTapDown(손가락이 내려옴)의 조합
      onTap: () {
        // Navigator.push를 쓰면 애니메이션 효과로 유저가 다른 페이지로 왔다고 느끼게 할 수 있다.
        // route: DetailScreen 같은 Stateless Widget을 애니메이션 효과로 감싸서 스크린처럼 보이게 한다.
        // route에 바로 DetailScreen()을 넣을 수는 없다.
        // MaterialPageRoute: StatelessWidget을 route로 감싸서 다른 스크린처럼 보이게 한다.
        // builder: route를 만드는 함수
        Navigator.push(
          context,
          MaterialPageRoute(
            // DetailScreen에 웹툰의 title, thumb, id를 넘긴다.
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            // fullscreenDialog: true일 경우 위젯이 bottom에서 올라온다는데...나는 안됨
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          // Hero: 화면 전환 시 애니메이션 제공
          Hero(
            // detail_screen.dart에도 Hero 위젯과 같은 태그를 준다.
            tag: id,
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
                  ),
                ],
              ),
              // Image.network는 URL이 필요하다.
              child: Image.network(
                thumb,
                headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

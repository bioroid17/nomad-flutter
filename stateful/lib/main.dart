import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// 앱의 위젯
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

// 앱의 위젯의 state
// state의 데이터를 바꾸면 UI가 새로고침 되어 최신 데이터를 보여줌
// Stateful Widget의 데이터는 클래스 프로퍼티
class _AppState extends State<App> {
  bool showTitle = true;

  void toggleTitle() {
    setState(() {
      showTitle = !showTitle;
    });
  }

  // 이 data는 그냥 Dart의 클래스 프로퍼티일 뿐 Flutter의 기능이 아니다.
  /*
  List<int> numbers = [];

  void onClicked() {
    // setState: State 클래스에게 데이터가 변경되었음을 알리는 함수
    // setState 구현 안 하면 build 메소드는 처음에 실행되고 다시는 실행 안됨
    // setState는 새로운 데이터를 가지고 build를 다시 호출
    // 데이터의 변화가 반드시 setState 안에 있을 필요는 없지만, 권장된다.
    setState(() {
      numbers.add(numbers.length);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Flutter는 앱의 모든 스타일을 한 곳에서 지정할 수 있는 기능을 제공한다.
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF4EDDB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              showTitle ? const MyLargeTitle() : const Text('Nothing'),
              IconButton(
                onPressed: toggleTitle,
                icon: const Icon(Icons.remove_red_eye),
              )
              // Text(
              //   '$counter',
              //   style: const TextStyle(
              //     fontSize: 30,
              //   ),
              // ),
              /*for (var n in numbers) Text('$n'),
              IconButton(
                iconSize: 40,
                onPressed: onClicked,
                icon: const Icon(Icons.add_box_rounded),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

// StatelessWidget인 MyLargeTitle에서 부모(_AppState)의 theme의 값에 접근하기 원한다.
class MyLargeTitle extends StatefulWidget {
  const MyLargeTitle({
    super.key,
  });

  @override
  State<MyLargeTitle> createState() => _MyLargeTitleState();
}

class _MyLargeTitleState extends State<MyLargeTitle> {
  // initState: state 초기화 반드시 쓸 필요는 없음
  // 단, 부모 요소에 의존하는 데이터를 초기화 해야 하는 경우는 써야 함
  // 항상 build 전에 호출되며, 단 한 번만 호출된다.
  @override
  void initState() {
    super.initState(); // 반드시 선언해야 함
    print('initState!');
  }

  // dispose: 위젯이 화면에서 제거될 때 호출됨
  // API 업데이트나 이벤트 리스너로부터 구독을 취소하거나
  // form의 리스너로부터 벗어나고 싶을 때 사용 가능
  // dispose는 무언가를 취소하는 것
  @override
  void dispose() {
    super.dispose();
    print('dispose!');
  }

// context는 Text 이전에 있는 모든 상위 요소에 대한 정보. 위젯 트리의 요소를 담고 있다.
  @override
  Widget build(BuildContext context) {
    print('build!');
    return Text(
      'My Large Title',
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).textTheme.titleLarge!.color,
      ),
    );
  }
}

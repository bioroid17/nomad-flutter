import 'package:flutter/material.dart';
import 'package:webtoon/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  // 이 위젯의 키를 슈퍼클래스(StatelessWidget)에 보냄
  // 플러터는 식별자 역할을 하는 키를 가지고 있음
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

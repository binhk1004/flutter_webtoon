import 'package:flutter/material.dart';
import 'package:flutter_webtoon/screens/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  //위젯은 Id 같은 식별자 역할을 하는 key가 존재한다.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

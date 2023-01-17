import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  //StatefulWidget로 변경한 이유는 state를 주어 데이터를 받은 뒤
  //동적으로 화면이 바뀌어야 하기 때문

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WebtoonModel> webtoons = [];
  bool isLoading = true;

  void waitForWebToons() async {
    webtoons = await ApiService.getTodayToons();
    isLoading = false;
    setState(() {});
    //waitForWebToons 함수에서 async를 사용하는 이유는
    //getTodayToons는 비동기 함수이다. 즉 getTodayToons 함수가
    //api에 요청을 보낸 뒤 응답값을 받고 모든 싸이클이 종료 된 뒤에
    //작동해야 하기 때문에 async 키워드를 사용한다.
  }

  @override
  void initState() {
    super.initState();
    waitForWebToons();
  }

  @override
  Widget build(BuildContext context) {
    print(webtoons);
    print(isLoading);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}

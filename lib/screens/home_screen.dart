import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_model.dart';
import 'package:flutter_webtoon/services/api_service.dart';
import 'package:flutter_webtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodayToons();

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: webtoons,
        //기다릴 데이터를 명명한다.
        builder: (context, snapshot) {
          //데이터가 도착 후 작업할 내용들인데, 여기서 snapshot은 future 상태를 말한다.
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      //StatelessWidget 을 쓸수 있는 이유는 FutureBuilder 때문
      //FutureBuilder는 api로 부터 응답값이 넘어오기까지 기다려주는 역할을 해준다.
      //그말인즉 응답값이 넘어 온 후 화면을 그려주는 역할
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
        //Webtoon이란 위젯을 별도 생성하여, 데이터만 넘겨주고
        //화면상에 보이는 웹툰 카드는 위젯에서 만들어서 보여준다.
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
      //itemBuilder의 역할은 전달받은 데이터를 다 만들어서 보여주는 것이 아닌
      //스크롤 하는 만큼 즉 index의 수 만큼만 데이터를 보여주는 역할
      //필요할때만
    );
  }
}

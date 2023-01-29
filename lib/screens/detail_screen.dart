import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_detail_modal.dart';
import 'package:flutter_webtoon/models/webtoon_episode_modal.dart';
import 'package:flutter_webtoon/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/episode_widget.dart';

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
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    //모바일 내부에 저장소와 연결한다.
    final likedToons = prefs.getStringList('likedToons');

    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        //사용자가 좋아요를 클릭한 웹툰의 아이디가 있는지, 저장되어 있는
        //likedToons 에서 찾는다.
        setState(() {
          isLiked = true;
        });
        //값이 변경이 되었다면, setState를 통해 해당 값을 저장해야 한다.
        //setState를 사용하는 이유는 해당 위젯이 StatefulWidget 이기 떄문
      }
    } else {
      await prefs.setStringList('likedToons', []);
      //사용자가 어플리케이션을 최초 실행 시 likedToons은 없기 때문에,
      //빈 리스트를 생성해준다.
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatesEpisodesById(widget.id);
    initPrefs();
  }
  //widget.id 혹은 widget.title로 명명해야 하는 이유는
  //기존에는 StatelessWidget 으로 진행 했을 당시, title, id등
  //model에 담긴 데이터 바로 접근이 가능했지만, StatefulWidget으로 변경된 순간
  //이제 각각 별도의 class로 구분 되기 때문에 widget.블라블라 로 접근해야 한다.

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          ),
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              offset: const Offset(10, 10),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ]),
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: ((context, snapshot) {
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
                }),
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          )
                      ],
                    );
                    //api에서 10개의 리스트만 뱉기 때문에, column을 쓰지만,
                    //만약 얼마나 많은 양의 리스트를 뱉는지 모르거나 혹은 많은 양의
                    //리스트를 뱉는다면 ListView를 쓰는게 더 좋다.
                  }
                  return Container();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_webtoon/models/webtoon_detail_modal.dart';
import 'package:flutter_webtoon/models/webtoon_episode_modal.dart';
import 'package:flutter_webtoon/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatesEpisodesById(widget.id);
  }
  //widget.id 혹은 widget.title로 명명해야 하는 이유는
  //기존에는 StatelessWidget 으로 진행 했을 당시, title, id등
  //model에 담긴 데이터 바로 접근이 가능했지만, StatefulWidget으로 변경된 순간
  //이제 각각 별도의 class로 구분 되기 때문에 widget.블라블라 로 접근해야 한다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
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
        ],
      ),
    );
  }
}

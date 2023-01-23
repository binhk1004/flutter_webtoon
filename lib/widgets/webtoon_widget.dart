import 'package:flutter/material.dart';
import 'package:flutter_webtoon/screens/detail_screen.dart';

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
      //GestureDetector 위젯은 대부분의 동작을 감지해준다.
      onTap: () {
        Navigator.push(
          // Navigator.push를 사용하면, 단순 화면 전환이지만
          //애니메이션 효과를 줄 수 있다.
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      //MaterialPageRoute는 화면간 이동을 위한 위젯
      child: Column(
        children: [
          Hero(
            //hero위젯은 페이지를 새로 덮는 애니메이션이 아닌,
            //아주 일부만이라도 클릭 된 이미지를 가져와서 보여주는 방법
            tag: id,
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
              child: Image.network(thumb),
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

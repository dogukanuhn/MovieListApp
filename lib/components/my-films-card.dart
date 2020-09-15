import 'package:flutter/material.dart';

import '../constants.dart';

// ignore: must_be_immutable
class MyFilmsCard extends StatelessWidget {
  String url, time, imdb, popularity;

  MyFilmsCard(this.url, this.time, this.imdb, this.popularity);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).backgroundColor,
      margin: EdgeInsets.only(right: 18),
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: AssetImage(url), fit: BoxFit.cover)),
                )),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                title: textWithIcon(Icons.timer, time),
                trailing: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: orange),
                    child: buildText(imdb, Colors.white)),
                subtitle: textWithIcon(Icons.insert_chart, popularity),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row textWithIcon(icon, text) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Icon(
            icon,
            size: 15,
            color: gray,
          ),
        ),
        buildText(text, gray),
      ],
    );
  }

  Text buildText(text, colorText) {
    return Text(
      text,
      style: TextStyle(color: colorText, fontSize: 14),
    );
  }
}

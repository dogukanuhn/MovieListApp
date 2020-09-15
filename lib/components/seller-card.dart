import 'package:bookapp/components/category-pin.dart';
import 'package:bookapp/constants.dart';
import 'package:bookapp/pages/movie-detail.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SellerCard extends StatefulWidget {
  String name, image, date, lang, like, director, id;
  bool adult;
  List<dynamic> genres;

  SellerCard(this.name, this.image, this.date, this.like, this.director,
      this.id, this.adult, this.lang);

  @override
  _SellerCardState createState() => _SellerCardState();
}

class _SellerCardState extends State<SellerCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetailPage(widget.id)),
        );
      },
      child: Card(
        elevation: 0,
        color: bgColor,
        margin: EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          children: [
            buildImage(context),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    widget.director,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 25),
                      child: Row(
                        children: [
                          textWithIcon(Icons.date_range, widget.date),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: textWithIcon(Icons.thumb_up, widget.like))
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        (widget.adult
                            ? CategoryPin("+18", Color(0xFFee6271))
                            : SizedBox.shrink()),
                        CategoryPin(
                            widget.lang.toUpperCase(), Color(0xFFee6271))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .25,
      height: MediaQuery.of(context).size.width * .4,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://image.tmdb.org/t/p/w154/" + widget.image))),
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

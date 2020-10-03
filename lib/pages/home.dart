import 'dart:convert';

import 'package:bookapp/components/my-films-card.dart';
import 'package:bookapp/components/seller-card.dart';
import 'package:bookapp/models/Movie.dart';
import 'package:bookapp/services/movies.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class SellerTab extends StatefulWidget {
  @override
  _SellerTabState createState() => _SellerTabState();
}

class _SellerTabState extends State<SellerTab> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return buildBestSeller(context);
  }

  Container buildBestSeller(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 35),
        child: Column(
          children: [
            Row(
              children: [
                buildOutlineButtonSellerTab(context, "Populer", 0),
                buildOutlineButtonSellerTab(context, "Latest", 1),
                buildOutlineButtonSellerTab(context, "Coming Soon", 2),
              ],
            ),
            (selectedTab == 0
                ? buildLoop(MovieService.getPopulerMovies())
                : selectedTab == 1
                    ? buildLoop(MovieService.getTopRatedMovie())
                    : buildLoop(MovieService.getUpComingMovie())),
          ],
        ));
  }

  Container buildLoop(future) {
    return Container(
      child: FutureBuilder<List<Movie>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: [
              for (var x in snapshot.data)
                SellerCard(
                    x.originalTitle,
                    x.posterPath,
                    x.date,
                    x.popularity.toString(),
                    "dogukan urhan",
                    x.id.toString(),
                    x.adult,
                    x.lang)
            ]);
          }
          return SizedBox();
        },
      ),
    );
  }

  FlatButton buildOutlineButtonSellerTab(BuildContext context, text, id) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      onPressed: () {
        setState(() {
          selectedTab = id;
        });
      },
      child: Text(
        text,
        style: (selectedTab == id
            ? TextStyle(
                color: Colors.white,
                fontSize: 18,
              )
            : TextStyle(
                color: gray,
                fontSize: 18,
              )),
      ),
    );
  }
}

class Home extends StatelessWidget {
  dynamic getMyFilms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get("myFilms");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: buildBody(context),
    );
  }

  ListView buildBody(BuildContext context) => ListView(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        children: [
          buildTopBar(context),
          buildTab(),
          getMyFilms() != null ? buildMyFilms(context) : SizedBox.shrink(),
          SellerTab()
        ],
      );

  Container buildMyFilms(BuildContext context) {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    List films;
    prefs.then((value) => {films = json.decode(value.getString("films"))});
    return Container(
        margin: EdgeInsets.only(top: 35),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Films",
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: ListView.builder(
                  itemCount: films.length,
                  itemBuilder: (context, index) => MyFilmsCard(
                      "assets/images/a.jpg",
                      "3s 10dk",
                      films[index]['voteAverage'],
                      "50%"),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            )
          ],
        ));
  }

  Container buildTab() {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          shape: BoxShape.rectangle,
          color: homeTab),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildOutlineButton(
              Icon(Icons.view_quilt, color: orange), "Claim", () {}),
          buildVerticalDivider(),
          buildOutlineButton(
              Icon(Icons.bookmark_border, color: orange), "Bookmark", () {}),
        ],
      ),
    );
  }

  OutlineButton buildOutlineButton(icon, text, event) {
    return OutlineButton(
      borderSide: BorderSide.none,
      padding: EdgeInsets.symmetric(vertical: 10),
      onPressed: event,
      child: Row(
        children: [
          icon,
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(text, style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }

  VerticalDivider buildVerticalDivider() {
    return VerticalDivider(
      thickness: 1,
      color: Colors.grey[500],
      width: 2,
      endIndent: 15,
      indent: 15,
    );
  }

  Row buildTopBar(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Good Morning",
                      style: Theme.of(context).textTheme.headline6)),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Batricia Salfiora",
                      style: Theme.of(context).textTheme.headline5))
            ],
          ),
          Container(
            child: RaisedButton(
              onPressed: () {},
              shape: StadiumBorder(),
              color: orange,
              child: Text(
                "240 point",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ]);
  }
}

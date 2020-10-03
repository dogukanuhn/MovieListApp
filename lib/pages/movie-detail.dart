import 'dart:convert';
import 'dart:math';

import 'package:bookapp/components/category-pin.dart';
import 'package:bookapp/constants.dart';
import 'package:bookapp/models/Bookmark.dart';
import 'package:bookapp/models/MovieDetail.dart';
import 'package:bookapp/services/movies.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailPage extends StatefulWidget {
  String id;

  MovieDetailPage(this.id);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieDetail>(
        future: MovieService.getMovieDetail(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data;
            return Scaffold(
                backgroundColor: bgColor,
                bottomNavigationBar: buildNavigationBar(
                    data.videos.results
                        .firstWhere((element) => element.type == "Trailer")
                        .key,
                    new Bookmark(
                        id: data.id,
                        posterPath: data.posterPath,
                        voteAverage: data.voteAverage)),
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    buildSliverAppBar(context, data),
                  ],
                  body: buildBody(context, data),
                ));
          } else {
            return SizedBox.expand();
          }
        });
  }

  ListView buildBody(BuildContext context, MovieDetail data) {
    List colors = [Color(0xFFee6271), Color(0xFF4dd6d3), Color(0xFFcdd64d)];
    Random random = new Random();
    return ListView(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(children: [
                for (var x in data.genres)
                  CategoryPin(x.name, colors[random.nextInt(3)]),
              ]),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Açıklama",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                data.overview,
                style: TextStyle(color: Colors.white, letterSpacing: 1),
              ),
            )
          ],
        ),
      ),
    ]);
  }

  SliverAppBar buildSliverAppBar(BuildContext context, MovieDetail data) {
    return SliverAppBar(
      stretch: true,
      expandedHeight: MediaQuery.of(context).size.height * .65,
      title: Text(
        "Movie Detail",
        style: TextStyle(fontSize: 15),
      ),
      centerTitle: true,
      backgroundColor: bgColor,
      flexibleSpace: buildFlexibleSpaceBar(context, data),
    );
  }

  Container buildNavigationBar(String data, Bookmark bookmark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildBookmarkButton(bookmark),
          buildWatchTrailerButton(data),
        ],
      ),
    );
  }

  saveBookmark(Bookmark bookmark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List films;

    if (prefs.containsKey("films")) {
      films = json.decode(prefs.getString("films"));

      if (films.firstWhere((element) => element['id'] == bookmark.id,
              orElse: () => null) !=
          null) {
        films.removeWhere((a) => a['id'] == bookmark.id);
      } else {
        films.add(bookmark);
      }
    } else {
      films = [];
      films.add(bookmark);
    }

    prefs.setString("films", json.encode(films));
    print(films);
  }

  Expanded buildWatchTrailerButton(String a) {
    return Expanded(
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: EdgeInsets.only(left: 10),
        child: FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            splashColor: Colors.transparent,
            color: orange,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Tanıtımı İzle",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
            ),
            onPressed: () {
              var link = 'https://www.youtube.com/watch?v=' + a;
              canLaunch(link).then((value) => {
                    if (value) {launch(link)}
                  });
            }),
      ),
    );
  }

  Container buildBookmarkButton(Object bookmark) {
    return Container(
      decoration: BoxDecoration(
          color: bookmarkButton,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: IconButton(
        onPressed: () {
          saveBookmark(bookmark);
        },
        icon: Icon(Icons.bookmark_border),
        color: gray,
        splashRadius: 1,
      ),
    );
  }

  FlexibleSpaceBar buildFlexibleSpaceBar(
      BuildContext context, MovieDetail data) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("https://image.tmdb.org/t/p/w154/" +
                          data.posterPath))),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 2),
              child: buildText(data.title, 12, 1),
            ),
            Container(
                child: buildText(data.productionCompanies[0].name, 10, .5)),
            buildRatingArea(context, data)
          ],
        ),
      ),
      background: buildBgImage(data.posterPath),
    );
  }

  Container buildRatingArea(BuildContext context, MovieDetail movie) {
    return Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            color: bgColor.withOpacity(.8),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: MediaQuery.of(context).size.width * .5,
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildArea(movie.voteAverage.toString(), "Rating"),
            buildVerticalDivider(),
            buildArea(movie.popularity.toString(), "Popularity"),
            buildVerticalDivider(),
            buildArea(movie.voteCount.toString(), "Likes"),
          ],
        ));
  }

  VerticalDivider buildVerticalDivider() {
    return VerticalDivider(
      color: Colors.grey,
      width: 1,
      endIndent: 5,
      indent: 5,
    );
  }

  Column buildArea(text, detail) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 10),
        ),
        Text(
          detail,
          style: TextStyle(fontSize: 9, color: gray),
        )
      ],
    );
  }

  Text buildText(text, double size, double space) {
    return Text(
      text,
      style:
          TextStyle(color: Colors.white, fontSize: size, letterSpacing: space),
    );
  }

  Opacity buildBgImage(String image) {
    return Opacity(
      opacity: .3,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter:
                    ColorFilter.mode(homeTab.withOpacity(.5), BlendMode.color),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                image:
                    NetworkImage("https://image.tmdb.org/t/p/w154/" + image))),
      ),
    );
  }
}

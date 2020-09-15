import 'dart:convert';

Movie postFromJson(String str) {
  final jsonData = json.decode(str);
  return Movie.fromJson(jsonData);
}

class Movie {
  double popularity;
  String posterPath;
  bool adult;
  String originalTitle;
  double voteAverage;
  String lang;
  String date;

  int id;

  Movie(
      {this.popularity,
      this.posterPath,
      this.adult,
      this.voteAverage,
      this.originalTitle,
      this.id,
      this.lang,
      this.date});

  factory Movie.fromJson(Map<String, dynamic> json) => new Movie(
        popularity: (json["popularity"] as num).toDouble(),
        posterPath: json["poster_path"],
        adult: json["adult"],
        voteAverage: (json["vote_average"] as num).toDouble(),
        originalTitle: json["original_title"],
        id: json["id"],
        lang: json["original_language"],
        date: json["release_date"],
      );

  Map<String, dynamic> toJson() => {
        "popularity": popularity,
        "poster_path": posterPath,
        "adult": adult,
        "vote_average": voteAverage,
        "original_title": originalTitle,
        "id": id,
        "original_language": lang,
        "release_date": date,
      };
}

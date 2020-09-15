class Bookmark {
  int id;
  String posterPath;
  double voteAverage;

  Bookmark({this.id, this.posterPath, this.voteAverage});

  Bookmark.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        posterPath = json['posterPath'],
        voteAverage = json['voteAverage'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
    };
  }
}

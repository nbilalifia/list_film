
class FilmItem {
  int? id;
  String title;
  String description;
  String recommendation; // "Recommended" atau "Not Recommended"
  String date;
  String imagePath; // path ke file gambar

  FilmItem(this.title, this.description, this.recommendation, this.date, this.imagePath);
  FilmItem.withId(this.id, this.title, this.description, this.recommendation, this.date, this.imagePath);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'recommendation': recommendation,
      'date': date,
      'imagePath': imagePath,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  FilmItem.fromMapObject(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        recommendation = map['recommendation'],
        date = map['date'],
        imagePath = map['imagePath'];
}

class SessionModel {
  final String id;
  final String creator;
  final String title;

  SessionModel({required this.id, required this.creator, required this.title});

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      SessionModel(
        id: json['id'],
        creator: json['creator'],
        title: json['title'],
      );
}

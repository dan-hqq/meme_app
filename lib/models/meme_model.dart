class MemeModel{
  String memeCaption;
  String imageMeme;
  DateTime memeDate;

  MemeModel({
    required this.memeCaption,
    required this.imageMeme,
    required this.memeDate
  });

  static MemeModel empty() => MemeModel(
    memeCaption: '',
    imageMeme: '',
    memeDate: DateTime.now()
  );

  Map<String, dynamic> toJson() {
    return {
      'memeCaption': memeCaption,
      'imageMeme': imageMeme,
      'memeDate': memeDate
    };
  }
}
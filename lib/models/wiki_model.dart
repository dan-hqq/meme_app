class WikiModel{
  String? memeId;
  String memeName;
  String description;
  String imageMeme;
  String exampleMeme;

  WikiModel({
    required this.memeName,
    required this.description,
    required this.imageMeme,
    required this.exampleMeme, 
    required this.memeId
  });

  static WikiModel empty() => WikiModel(
    memeId: '',
    memeName: '',
    description: '',
    imageMeme: '',
    exampleMeme: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'memeName': memeName,
      'description': description,
      'imageMeme': imageMeme,
      'exampleMeme': exampleMeme,
    };
  }
}
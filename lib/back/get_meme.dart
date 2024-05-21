import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme_app/models/meme_model.dart';

class GetMeme {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<MemeModel>> getAllMeme() async {
    try {
      final snapshot = await firestore.collection('memes').orderBy('memeDate', descending: true).get();

      return snapshot.docs.map((doc) {
        // print(doc.id);
        Map<String, dynamic> data = doc.data();
        return MemeModel(
          memeCaption: data['memeCaption'] ?? '',
          imageMeme: data['imageMeme'] ?? '',
          memeDate: DateTime.now()
        );
      }).toList();
    } catch (e) {
      print('Error retrieving wiki data: $e');
      return [];
    }
  }

  // Future<List<Map<String, dynamic>>> getAllWiki() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore.collection('wikis').get();
  //     List<Map<String, dynamic>> wikiList = [];
  //     querySnapshot.docs.forEach((doc) {
  //       wikiList.add(doc.data() as Map<String, dynamic>);
  //     });
  //     return wikiList;
  //   } catch (error) {
  //     print('Error retrieving wiki data: $error');
  //     return [];
  //   }
  // }
}

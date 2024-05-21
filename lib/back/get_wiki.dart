import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme_app/models/wiki_model.dart';

class GetWiki {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<WikiModel>> getAllWiki() async {
    try {
      final snapshot = await firestore.collection('wikis').orderBy('memeName', descending: false).get();

      return snapshot.docs.map((doc) {
        // print(doc.id);
        Map<String, dynamic> data = doc.data();
        return WikiModel(
          memeId: doc.id,
          memeName: data['memeName'] ?? '',
          description: data['description'] ?? '',
          imageMeme: data['imageMeme'] ?? '',
          exampleMeme: data['exampleMeme'] ?? '',
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

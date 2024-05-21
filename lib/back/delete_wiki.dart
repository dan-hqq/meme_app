import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteWiki {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> deleteMeme(String memeId) async {
    try {
      await firestore.collection('wikis').doc(memeId).delete();
      print('Meme with ID $memeId deleted successfully.');
      return;
    } catch (e) {
      print('Error deleting meme: $e');
      return;
    }
  }
}

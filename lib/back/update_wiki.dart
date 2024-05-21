import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/main.dart';
import 'package:meme_app/models/wiki_model.dart';
import 'package:http/http.dart' as http;

class UpdateWiki{
  final WikiModel meme;
  final String newMemeName;
  final String newMemeDescription;
  final File? newImageMeme;
  final File? newExampleMeme;

  const UpdateWiki({
    required this.meme,
    required this.newMemeName,
    required this.newMemeDescription,
    required this.newImageMeme,
    required this.newExampleMeme
  });

  Future<String?> uploadImageToCloudinary(File? imageFile) async {
    if (imageFile == null) return null;

    final url = Uri.parse("https://api.cloudinary.com/v1_1/dp3h9gw5l/upload");

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'qaonaibj'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      final urlImage = jsonMap['url'];
      return urlImage;
    }

    return null;
  }

  Future<void> updateWikiMeme(BuildContext context) async {
    
    String? newUrlImageMeme = (newImageMeme != null) ? await uploadImageToCloudinary(newImageMeme) : meme.imageMeme;
    String? newUrlExampleMeme = (newExampleMeme != null) ? await uploadImageToCloudinary(newExampleMeme) : meme.exampleMeme;

    // Model yang akan di-insert ke firebase
    final updatedWiki = WikiModel(
      memeId: '',
      memeName: newMemeName,
      description: newMemeDescription,
      imageMeme: newUrlImageMeme!,
      exampleMeme: newUrlExampleMeme!
    );

    try {
      // Insert Wiki Meme ke Firebase
      await FirebaseFirestore.instance.collection("wikis").doc(meme.memeId).update(updatedWiki.toJson());

      // Redirect ke Wiki Meme Page
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainApp()));

    } 
    catch (error) {
      throw 'Error $error';
    } 
  }
}
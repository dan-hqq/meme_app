import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/main.dart';
import 'package:meme_app/models/meme_model.dart';
import 'package:http/http.dart' as http;

class AddMeme{
  final String memeCaption;
  final File imageMeme;

  const AddMeme({
    required this.memeCaption,
    required this.imageMeme,
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

  Future<void> createMeme(BuildContext context) async {
    
    String? urlImageMeme = await uploadImageToCloudinary(imageMeme);

    // Model yang akan di-insert ke firebase
    final newMeme = MemeModel(
      memeCaption: memeCaption,
      imageMeme: urlImageMeme!,
      memeDate: DateTime.now() 
    );

    try {
      // Insert Wiki Meme ke Firebase
      await FirebaseFirestore.instance.collection("memes").add(newMeme.toJson());

      // Redirect ke Wiki Meme Page
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainApp()));

    } 
    catch (error) {
      throw 'Error $error';
    } 
  }
}
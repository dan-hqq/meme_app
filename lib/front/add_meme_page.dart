import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_app/back/add_meme.dart';

class AddMemePage extends StatefulWidget {
  const AddMemePage ({super.key});
  
  @override
  State<AddMemePage> createState() => _AddMemePageState();
}

class _AddMemePageState extends State<AddMemePage> {
  final _formKey = GlobalKey<FormState>();
  String _memeCaption = '';
  File? _imageMeme;

  final picker = ImagePicker();

  Future getImageMeme() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageMeme = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String? validateMeme(File? value) {
    if (value == null) {
      return 'Please select an example image for the meme.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(child: Text('Add Meme', style: TextStyle(color: Colors.white),)),
        iconTheme: const IconThemeData(
          color: Colors.white, // Mengatur warna ikon kembali
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Aksi kembali ke halaman sebelumnya
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Meme Caption',
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter meme name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _memeCaption = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Image Meme', style: TextStyle(color: Colors.white),),
                GestureDetector(
                  onTap: getImageMeme,
                  child: AspectRatio(
                    // color: Colors.grey[300],
                    // height: 300,
                    // width: double.infinity,
                    aspectRatio: 9 / 16,
                    child: Container(
                      color: Colors.grey[300],
                      child: _imageMeme == null
                          ? const Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                          : Image.file(_imageMeme!, fit: BoxFit.contain),
                    ),
                  ),
                ),
                if (_imageMeme == null) const Text(
                  'Please select an image for the meme.',
                  style: TextStyle(color: Colors.red),
                ),              
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: 
                  // (_memeName.isEmpty || _memeDescription.isEmpty || _imageMeme == null || _exampleMeme == null) ? null
                  // :
                   () async {
                    if (_formKey.currentState!.validate() && validateMeme(_imageMeme) == null) {
                      _formKey.currentState!.save();

                      // print('Meme Name: $_memeName');
                      // print('Meme Description: $_memeDescription');
                      // print('Image Meme: $_imageMeme');
                      // print('Example Meme: $_imageMeme');

                      final memeUpload = AddMeme(
                        memeCaption: _memeCaption,
                        imageMeme: _imageMeme!,
                      );

                      await memeUpload.createMeme(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



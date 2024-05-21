import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_app/back/add_wiki.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';

class AddWikiPage extends StatefulWidget {
  const AddWikiPage({super.key});
  
  @override
  State<AddWikiPage> createState() => _AddWikiPageState();
}

class _AddWikiPageState extends State<AddWikiPage> {
  final _formKey = GlobalKey<FormState>();
  String _memeName = '';
  String _memeDescription = '';
  File? _imageMeme;
  File? _exampleMeme;

  final picker = ImagePicker();

  Future getImageMeme() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: image,
          ),
        ),
      );

        final tempDir = await getTemporaryDirectory();
        _imageMeme = await File('${tempDir.path}/image.png').create();
      setState(() {
        // Uint8List imageInUnit8List = // store unit8List image here ;
        _imageMeme?.writeAsBytesSync(editedImage);
        // _imageMeme = editedImage;
      });
    } else {
      print('No image selected.');
    }
    // setState(() async {
      // if (pickedFile != null) {
      //   final image = File(pickedFile.path);
      //   final editedImage = await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ImageEditor(
      //         image: image,
      //       ),
      //     ),
      //   );

      //   setState(() {
      //     _imageMeme = editedImage;
      //   });
      // } else {
      //   print('No image selected.');
      // }
    // });
  }

  Future getExampleMeme() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: image,
          ),
        ),
      );

        final tempDir = await getTemporaryDirectory();
        _exampleMeme = await File('${tempDir.path}/image2.png').create();
      setState(() {
        // Uint8List imageInUnit8List = // store unit8List image here ;
        _exampleMeme?.writeAsBytesSync(editedImage);
        // _imageMeme = editedImage;
      });
    } else {
      print('No image selected.');
    }
    // setState(() async {
    //   if (pickedFile != null) {
    //     // _exampleMeme = File(pickedFile.path);
    //     final image = File(pickedFile.path);
    //     final editedImage = await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ImageEditor(
    //           image: image,
    //         ),
    //       ),
    //     );

    //     setState(() {
    //       _exampleMeme = editedImage;
    //     });
    //   } else {
    //     print('No image selected.');
    //   }
    // });
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
        title: const Center(child: Text('Add Meme Wiki', style: TextStyle(color: Colors.white),)),
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
                    labelText: 'Meme Name',
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
                      _memeName = value!;
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
                    aspectRatio: 1 / 1,
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
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Meme Description',
                    labelStyle: TextStyle(color: Colors.white)
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter meme description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _memeDescription = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('Example Meme', style: TextStyle(color: Colors.white),),
                GestureDetector(
                  onTap: getExampleMeme,
                  child: AspectRatio(
                    // color: Colors.grey[300],
                    // height: 300,
                    // width: double.infinity,
                    aspectRatio: 9 / 16,
                    child: Container(
                      color: Colors.grey[300],
                      child: _exampleMeme == null
                          ? const Icon(Icons.add_a_photo, size: 50, color: Colors.white)
                          : Image.file(_exampleMeme!, fit: BoxFit.contain),
                    ),
                  ),
                ),
                if (_exampleMeme == null) const Text(
                  'Please select an image for the meme.',
                  style: TextStyle(color: Colors.red),
                ),  
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: 
                  // (_memeName.isEmpty || _memeDescription.isEmpty || _imageMeme == null || _exampleMeme == null) ? null
                  // :
                   () async {
                    if (_formKey.currentState!.validate() && validateMeme(_imageMeme) == null && validateMeme(_exampleMeme) == null) {
                      _formKey.currentState!.save();

                      // print('Meme Name: $_memeName');
                      // print('Meme Description: $_memeDescription');
                      // print('Image Meme: $_imageMeme');
                      // print('Example Meme: $_imageMeme');

                      final wikiUpload = AddWiki(
                        memeName: _memeName,
                        memeDescription: _memeDescription,
                        imageMeme: _imageMeme!,
                        exampleMeme: _exampleMeme!
                      );

                      await wikiUpload.createWikiMeme(context);
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


// import 'package:flutter/material.dart';

// class AddWikiPage extends StatelessWidget {
//   const AddWikiPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("Add Wiki Page"),
//       ),
//     );
//   }
// }
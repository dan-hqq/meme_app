import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_app/back/update_wiki.dart';
import 'package:meme_app/models/wiki_model.dart';
import 'package:path_provider/path_provider.dart';


class EditWikiPage extends StatefulWidget {
  final WikiModel meme;

  const EditWikiPage({super.key, required this.meme});

  @override
  State<EditWikiPage> createState() => _EditWikiPageState();
}

class _EditWikiPageState extends State<EditWikiPage> {
  final _formKey = GlobalKey<FormState>();
  late String _memeName;
  late String _memeDescription;
  late File? _imageMeme;
  late File? _exampleMeme;
  bool _isDataChanged = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _memeName = widget.meme.memeName;
    _memeDescription = widget.meme.description;
    _imageMeme = null;
    _exampleMeme = null;
    _isDataChanged = false;
  }

  Future getImageMeme() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageMeme = File(pickedFile.path);
        _isDataChanged = (_memeName.compareTo(widget.meme.memeName) != 0 || _memeDescription.compareTo(widget.meme.description) != 0 || _imageMeme != null || _exampleMeme != null); // Periksa apakah ada perubahan
      } else {
        print('No image selected.');
      }
    });
  }

  Future editImageMeme() async {
      
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: Image.network(widget.meme.imageMeme),
          ),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      _imageMeme = await File('${tempDir.path}/image3.png').create();
      setState(() {
        // Uint8List imageInUnit8List = // store unit8List image here ;
        _imageMeme?.writeAsBytesSync(editedImage);
        // _imageMeme = editedImage;
      });
  }

  Future getExampleMeme() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _exampleMeme = File(pickedFile.path);
        _isDataChanged = (_memeName.compareTo(widget.meme.memeName) != 0 || _memeDescription.compareTo(widget.meme.description) != 0 || _imageMeme != null || _exampleMeme != null);
      } else {
        print('No image selected.');
      }
    });
  }

  Future editExampleMeme() async {
    
    final editedImage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: Image.network(widget.meme.exampleMeme),
        ),
      ),
    );

    final tempDir = await getTemporaryDirectory();
    _exampleMeme = await File('${tempDir.path}/image4.png').create();
    setState(() {
      // Uint8List imageInUnit8List = // store unit8List image here ;
      _exampleMeme?.writeAsBytesSync(editedImage);
      // _imageMeme = editedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text(
            'Edit Meme',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                  initialValue: _memeName,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: 'Meme Name',
                      labelStyle: TextStyle(color: Colors.white)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter meme name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _memeName = value;
                      _isDataChanged = (_memeName.compareTo(widget.meme.memeName) != 0 || _memeDescription.compareTo(widget.meme.description) != 0 || _imageMeme != null || _exampleMeme != null);
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Image Meme',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                        title: const Text('Edit Gambar'),
                        content: const Text('Edit Gambar atau Pilih Baru?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Navigator.of(context).pop();
                              editImageMeme();
                            },
                            child: const Text('Edit Gambar'),
                          ),
                          TextButton(
                            onPressed: () {
                            // Panggil fungsi deleteMeme dari DeleteWiki untuk menghapus meme
                            // DeleteWiki().deleteMeme(meme.memeId ?? '').then((_) {
                            //   // Setelah penghapusan selesai, arahkan kembali ke halaman utama
                            //   Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => const MainApp()),
                            //     (Route<dynamic> route) => false,
                            //   );
                            // });
                          },
                          child: const Text('Pilih Baru'),
                        ),
                      ],
                    );
                      }
                    );
                    getImageMeme();
                  },
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      color: Colors.grey[300],
                      child: _imageMeme == null
                          ? Image.network(widget.meme.imageMeme, fit: BoxFit.contain)
                          : Image.file(_imageMeme!, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: _memeDescription,
                  style: const TextStyle(color: Colors.white),
                  maxLines: null,
                  decoration: const InputDecoration(
                      labelText: 'Meme Description',
                      labelStyle: TextStyle(color: Colors.white)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter meme description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _memeDescription = value;
                      _isDataChanged = (_memeName.compareTo(widget.meme.memeName) != 0 || _memeDescription.compareTo(widget.meme.description) != 0 || _imageMeme != null || _exampleMeme != null);
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Example Meme',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: getExampleMeme,
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Container(
                      color: Colors.grey[300],
                      child: _exampleMeme == null
                          ? Image.network(widget.meme.exampleMeme, fit: BoxFit.contain)
                          : Image.file(_exampleMeme!, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isDataChanged ? () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final wikiEdit = UpdateWiki(
                        meme: widget.meme,
                        newMemeName: _memeName,
                        newMemeDescription: _memeDescription,
                        newImageMeme: _imageMeme,
                        newExampleMeme: _exampleMeme
                      );

                      await wikiEdit.updateWikiMeme(context);
                    }
                  }
                  :
                  null,
                  style: ButtonStyle(
                    backgroundColor: _isDataChanged ? MaterialStateProperty.all( Colors.blue) : MaterialStateProperty.all(Colors.grey)
                  ),
                  child: const Text('Update', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

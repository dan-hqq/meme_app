import 'package:flutter/material.dart';
import 'package:meme_app/back/delete_wiki.dart';
import 'package:meme_app/front/edit_wiki_page.dart';
import 'package:meme_app/main.dart';
import 'package:meme_app/models/wiki_model.dart';
import 'package:meme_app/others/custom_divider.dart';

class MemeDetailPage extends StatelessWidget {
  
  final WikiModel meme;

  const MemeDetailPage({super.key, required this.meme});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme Wikipedia',
      theme: ThemeData(
        fontFamily: 'TrajanPro'
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white, // Mengatur warna ikon kembali
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(), // Aksi kembali ke halaman sebelumnya
          ), // Menghilangkan bayangan AppBar
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Aksi ketika tombol edit ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditWikiPage(meme: meme),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Aksi ketika tombol hapus ditekan
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Hapus Meme'),
                      content: const Text('Apakah yakin ingin menghapus meme ini?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Panggil fungsi deleteMeme dari DeleteWiki untuk menghapus meme
                            DeleteWiki().deleteMeme(meme.memeId ?? '').then((_) {
                              // Setelah penghapusan selesai, arahkan kembali ke halaman utama
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const MainApp()),
                                (Route<dynamic> route) => false,
                              );
                            });
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30), // Jarak antara AppBar dan tulisan "Wikipedia"
              const Center(
                child: Text(
                  'MemE WikipediA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TrajanPro', // Ganti dengan font yang diinginkan
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                color: Colors.grey[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      meme.memeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.network(
                      meme.imageMeme,
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[900],
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Deskripsi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8),
                      child:  CustomDivider(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      meme.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Contoh Meme',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8),
                      child:  CustomDivider(),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Image.network(
                        meme.exampleMeme,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MemeDetailPage extends StatelessWidget {
//   final WikiModel meme;
  
//   const MemeDetailPage({super.key, required this.meme});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
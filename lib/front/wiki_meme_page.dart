import 'package:flutter/material.dart';
import 'package:meme_app/back/get_wiki.dart';
import 'package:meme_app/front/meme_detail_page.dart';
import 'package:meme_app/models/wiki_model.dart';

class WikiMemePage extends StatefulWidget {
  const WikiMemePage({super.key});

  @override
  State<WikiMemePage> createState() => _WikiMemePageState();
}

class _WikiMemePageState extends State<WikiMemePage> {
  final GetWiki _getWiki = GetWiki();
  List<WikiModel> _wikis = [];
  List<WikiModel> _filteredWikis = [];
  int _currentPage = 1;
  final _pageSize = 10;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final List<WikiModel> allWikis = await _getWiki.getAllWiki();
    setState(() {
      _wikis = allWikis;
      _filteredWikis = _filterWikis(_searchQuery);
    });
  }

  List<WikiModel> _getCurrentPageWikis() {
    final int startIndex = (_currentPage - 1) * _pageSize;
    final int endIndex = startIndex + _pageSize;
    final int totalWikis = _filteredWikis.length;
    // Pastikan bahwa endIndex tidak melebihi total wikis yang tersedia
    final int safeEndIndex = endIndex.clamp(0, totalWikis);
    return _filteredWikis.sublist(startIndex, safeEndIndex);
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
  }

  void _previousPage() {
    setState(() {
      _currentPage--;
    });
  }
  
  List<WikiModel> _filterWikis(String query) {
    return _wikis.where((wiki) => wiki.memeName.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Metode untuk memfilter wikis berdasarkan query pencarian
  // void _filterWikis(String query) {
  //   setState(() {
  //     _searchQuery = query;
  //     _filteredWikis = _wikis.where((wiki) => wiki.memeName.toLowerCase().contains(query.toLowerCase())).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(child: Text('Dann\'s Wiki Meme', style: TextStyle(color: Colors.white))),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Cari Meme',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                  _filteredWikis = _filterWikis(query);
                  _currentPage = 1; // Kembalikan ke halaman pertama setiap kali query berubah
                });
              }, // Panggil _filterWikis setiap kali nilai teks berubah
            ),
          ),
          Expanded(
            child: _buildWikiList(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: _currentPage > 1 ? _previousPage : null, // Menambahkan null jika berada di halaman pertama
              child: Text(
                'Previous Page',
                style: TextStyle(
                  color: _currentPage > 1 ? Colors.white : Colors.white.withOpacity(0.5)
                )
              )
            ),
            TextButton(
              onPressed: _currentPage * _pageSize < _filteredWikis.length ? _nextPage : null, // Menambahkan null jika berada di halaman terakhir
              child: Text(
                'Next Page', 
                style: TextStyle(
                  color: _currentPage * _pageSize < _filteredWikis.length ? Colors.white : Colors.white.withOpacity(0.5)
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWikiList() {
    final List<WikiModel> currentPageWikis = _getCurrentPageWikis();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: currentPageWikis.length,
      itemBuilder: (context, index) {
        WikiModel wikiData = currentPageWikis[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemeDetailPage(meme: wikiData),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Menambahkan padding pada Card
            child: Card(
              color: Colors.grey[800],
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                            child: Image.network(
                              wikiData.imageMeme,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8.0,
                          left: 8.0,
                          right: 8.0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                wikiData.memeName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
      },
    );
  }

  // Widget _buildWikiList() {
  //   final List<WikiModel> currentPageWikis = _getCurrentPageWikis();
  //   return GridView.builder(
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2, // 2 kolom
  //       crossAxisSpacing: 8.0, // Spasi antar kolom
  //       mainAxisSpacing: 8.0, // Spasi antar baris
  //     ),
  //     itemCount: currentPageWikis.length,
  //     itemBuilder: (context, index) {
  //       WikiModel wikiData = currentPageWikis[index];
  //       return GestureDetector(
  //         onTap: () {
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => MemeDetailPage(meme: wikiData)));
  //         },
  //         child: Card(
  //           elevation: 2.0,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               Expanded(
  //                 flex: 3, // Lebih banyak ruang untuk gambar
  //                 child: Image.network(
  //                   wikiData.imageMeme,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //               Expanded(
  //                 flex: 1, // Kurang ruang untuk teks
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(
  //                     wikiData.memeName,
  //                     style: const TextStyle(fontSize: 16.0),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }


  // Widget _buildWikiList() {
  //   final List<WikiModel> currentPageWikis = _getCurrentPageWikis();
  //   return ListView.builder(
  //     itemCount: currentPageWikis.length,
  //     itemBuilder: (context, index) {
  //       WikiModel wikiData = currentPageWikis[index];
  //       return ListTile(
  //         subtitle: Center(child: Text(wikiData.memeName)),
  //         title: Image.network(wikiData.imageMeme, fit: BoxFit.cover,), // Menampilkan gambar di sebelah nama
  //         // Tambahkan fungsi lainnya sesuai kebutuhan
  //       );
  //     },
  //   );
  // }
}


// class WikiMemePage extends StatefulWidget {
//   const WikiMemePage({super.key});

//   @override
//   State<WikiMemePage> createState() => _WikiMemePageState();
// }

// class _WikiMemePageState extends State<WikiMemePage> {
//   final GetWiki _getWiki = GetWiki();
//   late Future<List<WikiModel>> _wikiListFuture;

//   @override
//   void initState() {
//     super.initState();
//     _wikiListFuture = _getWiki.getAllWiki();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Wiki Meme Page'),
//       ),
//       body: FutureBuilder(
//         future: _wikiListFuture,
//         builder: (context, AsyncSnapshot<List<WikiModel>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No wikis found'));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               WikiModel wikiData = snapshot.data![index];
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: Image.network(
//                       wikiData.imageMeme,
//                       fit: BoxFit.contain, // Sesuaikan dengan kebutuhan
//                     ),
//                   ),
//                   ListTile(
//                     title: Text(wikiData.memeName),
//                     // Tambahkan fungsi lainnya sesuai kebutuhan
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
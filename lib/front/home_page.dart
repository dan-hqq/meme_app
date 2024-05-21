import 'package:flutter/material.dart';
import 'package:meme_app/back/get_meme.dart';
import 'package:meme_app/front/add_meme_page.dart';
import 'package:meme_app/models/meme_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetMeme _getMeme = GetMeme();
  List<MemeModel> _memes = [];
  int _currentPage = 1;
  final _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final List<MemeModel> allMemes = await _getMeme.getAllMeme();
    setState(() {
      _memes = allMemes;
    });
  }

  List<MemeModel> _getCurrentPageMeme() {
    final int startIndex = (_currentPage - 1) * _pageSize;
    final int endIndex = startIndex + _pageSize;
    final int totalWikis = _memes.length;
    // Pastikan bahwa endIndex tidak melebihi total wikis yang tersedia
    final int safeEndIndex = endIndex.clamp(0, totalWikis);
    return _memes.sublist(startIndex, safeEndIndex);
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(child: Text('List Meme', style: TextStyle(color: Colors.white),)),
      ),
      backgroundColor: Colors.grey[900],
      body: _buildMemeList(),
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
              onPressed: _currentPage * _pageSize < _memes.length ? _nextPage : null, // Menambahkan null jika berada di halaman terakhir
              child: Text(
                'Next Page', 
                style: TextStyle(
                  color: _currentPage * _pageSize < _memes.length ? Colors.white : Colors.white.withOpacity(0.5)
                )
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const AddMemePage()
            )
          );
        }, 
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMemeList() {
  final List<MemeModel> currentPageMemes = _getCurrentPageMeme();
  return SingleChildScrollView(
    child: Column(
      children: currentPageMemes.map((memeData) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Colors.grey[900],
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), 
                  child: Center(
                    child: Text(
                      memeData.memeCaption,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                SizedBox(
                  height: null, 
                  child: Image.network(
                    memeData.imageMeme,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}



}
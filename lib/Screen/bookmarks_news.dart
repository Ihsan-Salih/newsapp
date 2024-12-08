import 'package:flutter/material.dart';
import 'package:news_app/model/new_model.dart';
import 'package:news_app/Screen/news_deatil.dart';

class BookmarksScreen extends StatefulWidget {
  final List<NewsModel> bookmarks;
  final Function(NewsModel) onToggleBookmark;

  const BookmarksScreen({
    super.key,
    required this.bookmarks,
    required this.onToggleBookmark,
  });

  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late List<NewsModel> _bookmarks;

  @override
  void initState() {
    super.initState();
    _bookmarks = widget.bookmarks;  // Initialize local list with passed bookmarks
  }

  // Function to handle bookmark toggle action and update list
  void _toggleBookmark(NewsModel article) {
    setState(() {
      if (_bookmarks.contains(article)) {
        _bookmarks.remove(article);
      } else {
        _bookmarks.add(article);
      }
    });

    // Call onToggleBookmark to notify parent about the change
    widget.onToggleBookmark(article);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarked Articles")),
      body: _bookmarks.isEmpty
          ? const Center(child: Text("No bookmarks yet!"))
          : ListView.builder(
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final article = _bookmarks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDeatil(
                          newsModel: article,
                          toggleBookmark: (newsModel) {
                            widget.onToggleBookmark(newsModel);
                            setState(() {}); // Refresh bookmarks screen
                          },
                          isBookmarked: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            article.urlToImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.title!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

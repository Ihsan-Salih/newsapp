import 'package:flutter/material.dart';
import 'package:news_app/Screen/news_deatil.dart';
import 'package:news_app/model/new_model.dart';

class SearchScreen extends StatelessWidget {
  final List<NewsModel> searchResults;
  final List<NewsModel> bookmarkedArticles;
  final Function(NewsModel) toggleBookmark;
  final bool Function(NewsModel) isBookmarked;

  const SearchScreen({
    super.key,
    required this.searchResults,
    required this.bookmarkedArticles,
    required this.toggleBookmark,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Results"),
      ),
      body: searchResults.isEmpty
          ? const Center(
              child: Text("No articles found."),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final article = searchResults[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDeatil(
                          newsModel: article,
                          toggleBookmark: toggleBookmark,  
                          isBookmarked: isBookmarked(article), // Pass the bookmark status
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
                            height: 250,
                            width: 350,
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

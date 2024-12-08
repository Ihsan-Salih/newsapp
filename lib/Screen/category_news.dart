import 'package:flutter/material.dart';
import 'package:news_app/Screen/news_deatil.dart';
import 'package:news_app/Services/services.dart';
import 'package:news_app/model/new_model.dart';

class SelectCategoryNews extends StatefulWidget {
  final String category;
  SelectCategoryNews({super.key, required this.category});

  @override
  State<SelectCategoryNews> createState() => _SelecCategoryNewsState();
}

class _SelecCategoryNewsState extends State<SelectCategoryNews> {
  List<NewsModel> articles = [];
  bool isLoding = true;
  List<NewsModel> bookmarkedArticles = [];
  bool isSortedDescending = true;

  getNews() async {
    CategoryNews news = CategoryNews();
    await news.getNews(widget.category);
    articles = news.dataStore;


      articles.sort((a, b) {
      final dateA = DateTime.parse(a.publishedAt!);
      final dateB = DateTime.parse(b.publishedAt!);
      return isSortedDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });
    setState(() {
      isLoding = false;
    });
  }

  bool isBookmarked(NewsModel article) {
    return bookmarkedArticles.contains(article);
  }

  void toggleBookmark(NewsModel article) {
    setState(() {
      if (isBookmarked(article)) {
        bookmarkedArticles.remove(article);
      } else {
        bookmarkedArticles.add(article);
      }
    });
  }

 void sortArticles() {
    setState(() {
      isSortedDescending = !isSortedDescending;
      articles.sort((a, b) {
        final dateA = DateTime.parse(a.publishedAt!);
        final dateB = DateTime.parse(b.publishedAt!);
        return isSortedDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      });
    });
  }
    String _formatDate(String dateStr) {
  final date = DateTime.parse(dateStr);
  return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
}

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        title: Text(
          widget.category,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [IconButton(
            icon: const Icon(Icons.sort), // Sorting icon
            onPressed: sortArticles, // Call the sortArticles method
          ),],
      ),
      body: isLoding
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListView.builder(
                itemCount: articles.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  final article = articles[index];
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
                          const SizedBox(height: 5),
            Text(
               "Published at: ${_formatDate(article.publishedAt ?? '')}",
  style: const TextStyle(
    fontSize: 14,
    color: Colors.grey,
              ),
            ),
                          const Divider(thickness: 2),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

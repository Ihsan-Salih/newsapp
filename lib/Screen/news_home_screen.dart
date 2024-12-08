import 'package:flutter/material.dart';
import 'package:news_app/Screen/bookmarks_news.dart';
import 'package:news_app/Screen/category_news.dart';
import 'package:news_app/Screen/news_deatil.dart';
import 'package:news_app/Screen/search_news.dart';
import 'package:news_app/Services/services.dart';
import 'package:news_app/model/category_data.dart';
import 'package:news_app/model/new_model.dart';

class NewsHomeScreen extends StatefulWidget {
  final VoidCallback toggleDarkMode; // Callback to toggle dark mode

  const NewsHomeScreen({super.key, required this.toggleDarkMode});

  @override
  _NewsHomeScreenState createState() => _NewsHomeScreenState();
}

class _NewsHomeScreenState extends State<NewsHomeScreen> {
  List<NewsModel> articles = []; // List to store fetched articles
  List<CategoryModel> categories = []; // List to store categories
  TextEditingController searchController = TextEditingController(); // Controller for the search field
  FocusNode searchFocusNode = FocusNode(); // Focus node to manage search field focus
  List<NewsModel> bookmarkedArticles = []; // List of bookmarked articles
  bool isLoding = true; // Flag to indicate loading state
  bool isSortedDescending = true; // Flag to toggle sorting order

  // Fetch news articles and initialize data
  getnews() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews();
    articles = newsApi.dataStore;

    // Sort articles by date after fetching
    articles.sort((a, b) {
      final dateA = DateTime.parse(a.publishedAt!);
      final dateB = DateTime.parse(b.publishedAt!);
      return isSortedDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });

    // Update state to remove loading indicator
    setState(() {
      isLoding = false;
    });
  }

  // Search for articles matching the query
  void searchArticles(String query) {
    final results = articles
        .where((article) =>
            article.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Navigate to the search results screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          searchResults: results,
          bookmarkedArticles: bookmarkedArticles, // Pass the bookmarked articles
          toggleBookmark: toggleBookmark, // Pass the toggleBookmark function
          isBookmarked: (article) => bookmarkedArticles.contains(article), // Check if the article is bookmarked
        ),
      ),
    );
  }

  // Toggle bookmark status for an article
  void toggleBookmark(NewsModel article) {
    setState(() {
      if (bookmarkedArticles.contains(article)) {
        bookmarkedArticles.remove(article); // Remove from bookmarks
      } else {
        bookmarkedArticles.add(article); // Add to bookmarks
      }
    });
  }

  // Sort articles by date
  void sortArticles() {
    setState(() {
      isSortedDescending = !isSortedDescending; // Toggle sorting order
      articles.sort((a, b) {
        final dateA = DateTime.parse(a.publishedAt!);
        final dateB = DateTime.parse(b.publishedAt!);
        return isSortedDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      });
    });
  }

  // Format the date string to a readable format
  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return "${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}";
  }

  @override
  void initState() {
    categories = getCategories(); // Load categories
    getnews(); // Fetch news
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        searchFocusNode.unfocus(); // Dismiss keyboard on tap outside text field
      },
      onPanDown: (_) {
        searchFocusNode.unfocus(); // Dismiss keyboard on scroll
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "News App",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            // Button to navigate to bookmarks screen
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookmarksScreen(
                      bookmarks: bookmarkedArticles,
                      onToggleBookmark: toggleBookmark,
                    ),
                  ),
                );
              },
            ),
            // Button to sort articles
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: sortArticles,
            ),
            // Button to toggle dark mode
            IconButton(
              icon: const Icon(Icons.nightlight_round),
              onPressed: widget.toggleDarkMode,
            ),
          ],
          // Search bar in the app bar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode, // Attach focus node
                onSubmitted: searchArticles,
                decoration: InputDecoration(
                  hintText: "Search articles...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Main content
        body: isLoding
            ? const Center(child: CircularProgressIndicator()) // Loading indicator
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Horizontal category list
                    Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to category-specific news screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelectCategoryNews(
                                    category: category.categoryName!,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.blue,
                                ),
                                child: Center(
                                  child: Text(
                                    category.categoryName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Vertical list of articles
                    ListView.builder(
                      itemCount: articles.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        final isBookmarked = bookmarkedArticles.contains(article);

                        return GestureDetector(
                          onTap: () {
                            // Navigate to article details screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDeatil(
                                  newsModel: article,
                                  toggleBookmark: toggleBookmark,
                                  isBookmarked: isBookmarked,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Article image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    article.urlToImage!,
                                    height: 250,
                                    width: 500,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Article title
                                Text(
                                  article.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Published date
                                Text(
                                  "Published at: ${_formatDate(article.publishedAt!)}",
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
                  ],
                ),
              ),
      ),
    );
  }
}

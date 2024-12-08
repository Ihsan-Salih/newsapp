import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/model/new_model.dart';

class NewsApi {

 // news home screen 
    List<NewsModel> dataStore = [];
   Future<void> getNews() async {
    Uri url = Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=ab0ea3fe60cf4c15a6e9da1458160fc0");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData['status']== 'ok') {
     jsonData['articles'].forEach((element){
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['content'] != null &&
            element['publishedAt'] != null &&
            element['url'] != null) {
        NewsModel newsModel = NewsModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
            publishedAt: element['publishedAt'],
            url: element['url'],
        );
        dataStore.add(newsModel);
        }
     });

    }

   } 
}

class CategoryNews {

 // news category screen 
    List<NewsModel> dataStore = [];
   Future<void> getNews(String category) async {
    Uri url = Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=ab0ea3fe60cf4c15a6e9da1458160fc0");
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);
    if (jsonData['status']== 'ok') {
     jsonData['articles'].forEach((element){
        if (element['urlToImage'] != null &&
            element['description'] != null &&
            element['author'] != null &&
            element['publishedAt'] != null &&
            element['content'] != null) {
        NewsModel newsModel = NewsModel(
            title: element['title'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            author: element['author'],
            content: element['content'],
            publishedAt: element['publishedAt'],
        );
        dataStore.add(newsModel);
        }
     }
     );

    }

   } 
}
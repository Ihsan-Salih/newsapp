import 'package:flutter/material.dart';
import 'package:news_app/model/new_model.dart';


class NewsDeatil extends StatefulWidget {
  final NewsModel newsModel;
  final Function(NewsModel) toggleBookmark;
  final bool isBookmarked;

  const NewsDeatil({
    super.key,
    required this.newsModel,
    required this.toggleBookmark,
    required this.isBookmarked,
  });

  @override
  _NewsDeatilState createState() => _NewsDeatilState();
}

class _NewsDeatilState extends State<NewsDeatil> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.newsModel.title!),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
              widget.toggleBookmark(widget.newsModel);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              widget.newsModel.title!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(child: Text("- ${widget.newsModel.author!}", maxLines: 1)),
              ],
            ),
            const SizedBox(height: 10),
            Image.network(widget.newsModel.urlToImage!),
            const SizedBox(height: 10),
            Text(
              widget.newsModel.content!,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.newsModel.description!,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

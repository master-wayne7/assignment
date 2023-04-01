import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../model/article.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List articles = [];
  @override
  void initState() {
    super.initState();
    _fetchArticles().then((articles) {
      setState(() {
        this.articles = articles;
      });
    });
  }

  formattedDateTime(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final DateFormat formatter = DateFormat.yMMMMd().add_jms();
    final String formatted = formatter.format(dateTime);

    return formatted;
  }

  Future<List<Article>> _fetchArticles() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=173fa7cf72b940b1ad95959b7d7e4cb8'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> articlesJson = json['articles'];
      print(articlesJson);
      return articlesJson
          .map((articleJson) => Article(
                title: articleJson['title'] ?? '',
                description: articleJson['description'] ?? '',
                imageUrl: articleJson['urlToImage'] ?? '',
                publishedAt: articleJson['publishedAt'] ?? '',
                sourceName: articleJson['source']['name'] ?? '',
                url: articleJson['url'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreenPage(article: article),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        child: Image.network(
                          article.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Text(
                        article.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Source: ${article.sourceName}',
                              ),
                              Text(
                                formattedDateTime(article.publishedAt),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: article.isFavorite
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                article.isFavorite = !article.isFavorite;
                                print(article.isFavorite);
                              });
                            },
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
      ),
    );
  }
}
// ListTile(
//               leading: Image.network(article.imageUrl),
//               title: Text(article.title),
//               trailing: IconButton(
//                 icon: article.isFavorite
//                     ? Icon(Icons.favorite)
//                     : Icon(Icons.favorite_border),
//                 color: Colors.red,
//                 onPressed: () {
//                   setState(() {
//                     article.isFavorite = !article.isFavorite;
//                     print(article.isFavorite);
//                   });
//                 },
//               ),
//             ),
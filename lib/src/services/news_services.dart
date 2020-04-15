import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '7a71e0cf296545999534036661acaee9';

class NewsService with ChangeNotifier {
  List<Article> headLines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadLines();

    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();
    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);

    notifyListeners();
  }

  List<Article> get getArticlesSelected =>
      this.categoryArticles[this.selectedCategory];

  getTopHeadLines() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=co';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.headLines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }

    final url =
        '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=co&category=$category';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);

    this.categoryArticles[category].addAll(newsResponse.articles);

    notifyListeners();
  }
}

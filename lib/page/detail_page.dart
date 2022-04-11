import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:recipes_apps/database/dbhelper.dart';
import 'package:recipes_apps/model/meal_item.dart';
import 'package:recipes_apps/model/response_detail.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String idMeal;

  DetailPage({required this.idMeal});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ResponseDetail? responseDetail;
  bool isLoading = true;
  bool isFavorite = false;
  var db = DBHelper();

  Future<ResponseDetail?> fetchDetail() async {
    try {
      var res = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.idMeal}'));

      isFavorite = await db.isFavorite(widget.idMeal);

      print("Favorite : $isFavorite");
      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);
        ResponseDetail data = ResponseDetail.fromJson(json);
        if (mounted) {
          setState(() {
            responseDetail = data;
            isLoading = false;
          });
        }
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Failed $e');
      return null;
    }
  }

  setFavorite() async {
    var db = DBHelper();
    Meal favorite = Meal(
        idMeal: responseDetail!.meals[0]['idMeal'],
        strMeal: responseDetail!.meals[0]['strMeal'],
        strMealThumb: responseDetail!.meals[0]['strMealThumb'],
        strCategory: responseDetail!.meals[0]['strCategory'],
        strInstructions: responseDetail!.meals[0]['strInstructions']);

    if (!isFavorite) {
      await db.insert(favorite);
      print('add data');
    } else {
      await db.delete(favorite);
      print('delete data');
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
        actions: [
          IconButton(
            icon:
                isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: () {
              setFavorite();
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<ResponseDetail?>(
            future: fetchDetail(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                  strokeWidth: 5,
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Center(
                        child: Hero(
                          child: Material(
                            child: Image.network(
                                '${responseDetail!.meals[0]['strMealthumb']}'),
                          ),
                          tag: '${responseDetail!.meals[0]['idMeal']}',
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('${responseDetail!.meals[0]['strMeal']}'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('Instructions'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                            '${responseDetail!.meals[0]['strInstructions']}'),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

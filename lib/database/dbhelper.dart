import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:recipes_apps/model/meal_item.dart';
import 'package:recipes_apps/ui/item_meals.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  //1
  DBHelper._createInstance();

  //2
  static final DBHelper _instance = DBHelper._createInstance();

  //3
  factory DBHelper() => _instance;

  //4
  static Database? _db;

  //5 membuat database
  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'mealsDB');
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  //6
  void _onCreate(Database db, int version) async {
    var dbsql = "CREATE TABLE favorite(id INTEGER PRIMARY KEY, idMeal TEXT, strMeal TEXT, strInstructions TEXT, strMealThumb TEXT, strCategory TEXT)";
    await db.execute(dbsql);
    print('DB Created');
  }

  //7
  Future<Database?> get db async {
    _db = await setDB();
    return _db ?? _db;
  }

  //8
  Future<int> insert(Meal meals) async {
    var dbClient = await db;
    int res = await dbClient!.insert("favorite", meals.toJson()).then((value) {
      return 1;
    });
    if (res == 1) {
      print("data favorite bertambah");
    }
    return res;
  }

  Future<Meal?> get(String idMeal) async {
    var dbClient = await db;
    var sql = "SELECT * FROM FAVORITE WHERE idMeal=? ORDER BY idMeal DESC";
    List<Map> list = await dbClient!.rawQuery(sql, [idMeal]);
    late Meal meals;
    if (list.isNotEmpty) {
      meals = Meal(
          idMeal: list[0]["idMeal"],
          strMeal: list[0]["strMeal"],
          strMealThumb: list[0]["strMealThumb"],
          strCategory: list[0]["strCategory"],
          strInstructions: list[0]["strInstructions"]
      );
      return meals;
    }

  }

  Future<List<Meal>?> gets(String category) async {
    var dbClient = await db;
    var sql = "SELECT * FROM favorite WHERE strCategory=? ORDER BY idMeal DESC";
    List<Map> list = await dbClient!.rawQuery(sql, [category]);
    List<Meal> favorites = [];
    for (int i = 0; i < list.length; i++) {
      Meal favorite = Meal(
        idMeal: list[i]["idMeal"],
        strMeal: list[i]["strMeal"],
        strMealThumb: list[i]["strMealThumb"],
        strInstructions: list[i]["strInstructions'"],
        strCategory: list[i]["strCategory"],
      );
      favorite.setFavoriteId(list[i]["idMeal"]);
      favorites.add(favorite);
    }
    return favorites;
  }

  Future<int?> delete(Meal meals) async {
    var dbClient = await db;
    var sql = "DELETE FROM favorite WHERE idMeal = ?";
    var res = await dbClient!.rawDelete(sql, [meals.idMeal]);
    print("Favorite data deleted");
    return res;
  }

  Future<bool> isFavorite (String idMeals) async {
    var dbClient = await db;
    var sql = "SELECT * FROM favorite WHERE idMeal = ?";
    var res = await dbClient!.rawQuery(sql, [idMeals]);

    return res.isNotEmpty;
  }
}


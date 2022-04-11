import 'package:flutter/material.dart';
import 'package:recipes_apps/database/dbhelper.dart';
import 'package:recipes_apps/model/response_filter.dart';
import 'package:recipes_apps/ui/list_meals.dart';

class FavoritePage extends StatefulWidget {
  final int indexNav;

  const FavoritePage({Key? key, required this.indexNav}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int currentIndex = 0;
  String category = "Seafood";
  ResponseFilter? responseFilter;
  bool isLoading = true;
  var db = DBHelper();

  void fetcDataMeals() async {
    var data = await db.gets(category);
    setState(() {
      responseFilter = ResponseFilter(meals: data);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcDataMeals();
    currentIndex = widget.indexNav;
  }

  @override
  Widget build(BuildContext context) {
    var listNav = [
      listMeals(responseFilter),
      listMeals(responseFilter)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Recipes"),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: isLoading == false
            ? listNav[currentIndex]
            : CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: "Seafood"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cake),
              label: "Dessert"
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            index == 0 ? category = "Seafood" : category = "Dessert";
          });
          fetcDataMeals();
        },
      ),
    );
  }
}

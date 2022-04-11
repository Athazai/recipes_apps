import 'package:flutter/material.dart';
import 'package:recipes_apps/model/response_filter.dart';
import 'package:recipes_apps/network/netclient.dart';
import 'package:recipes_apps/page/favorite_page.dart';
import 'package:recipes_apps/ui/list_meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  ResponseFilter? responseFilter;
  bool isLoading = true;

  void fetcDataMeals() async {
    try {
      Netclient client = Netclient();
      var data = await client.fetchDataMeals(currentIndex);
      setState(() {
        responseFilter = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetcDataMeals();
  }

  @override
  Widget build(BuildContext context) {
    var listNav = [
      listMeals(responseFilter),
      listMeals(responseFilter)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return FavoritePage(indexNav: currentIndex);
                }));
              },
              icon: Icon(Icons.favorite_border),
          ),
        ],
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
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Seafood"),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Dessert"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          fetcDataMeals();
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:recipeman/model.dart';
import 'package:recipeman/recipeview.dart';
import 'package:recipeman/search.dart';
import 'model.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool isLoading = true;
  List<RecipeModel> recipelist = <RecipeModel>[];
  TextEditingController searchcontrol = new TextEditingController();
  List recipeCatList = [
    {"imgUrl": "assets/img/check1.jpg", "heading": "pizza"},
    {"imgUrl": "assets/img/pr.jpg", "heading": "Paratha"},
    {"imgUrl": "assets/img/idli.jpg", "heading": "Idli"},
    {"imgUrl": "assets/img/dhokla.jpg", "heading": "Dhokla"},
    {"imgUrl": "assets/img/fries.jpg", "heading": "French Fries"}
  ];

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=88ede23a&app_key=b6445bdf03e7fae1ce2c08289a9d0de3";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipelist.add(recipeModel);

      setState(() {
        isLoading = false;
      });
    });

    recipelist.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("pasta");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 255, 205, 191),
          Color.fromARGB(255, 255, 31, 6),
        ])),
      ),
      SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Search(searchcontrol.text)));
                        }
                        ;
                      }),
                      child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueGrey,
                          ),
                          margin: EdgeInsets.fromLTRB(4, 1, 7, 5)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchcontrol,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ' Search Food',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(2),
                child: Text(
                  "Let's Cook something Special!",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      fontFamily: 'Frau',
                      fontSize: 49,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 0, 0, 0)),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recipelist.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => recipeview(
                                            recipelist[index].appurl),
                                      ));
                                },
                                splashColor: Colors.blue,
                                highlightColor: Colors.black,
                                child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 5.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            recipelist[index].appimgUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          )),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.black38),
                                          child: Text(
                                            recipelist[index].applabel,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: 0,
                                          top: 5.0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white38),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department,
                                                    color: Color.fromARGB(
                                                        255, 241, 158, 23),
                                                  ),
                                                  Text(
                                                    recipelist[index]
                                                        .appcalories
                                                        .toString()
                                                        .substring(0, 7),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              )))
                                    ],
                                  ),
                                ));
                          })),
              Container(
                height: 100,
                child: ListView.builder(
                    itemCount: recipeCatList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return Container(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Search(
                                          recipeCatList[index]["heading"]),
                                    ));
                              },
                              child: Card(
                                  margin: EdgeInsets.all(10),
                                  shadowColor: Colors.black26,
                                  elevation: 5.0,
                                  child: Stack(children: [
                                    ClipRRect(
                                        child: Image.asset(
                                      recipeCatList[index]["imgUrl"],
                                      fit: BoxFit.cover,
                                      width: 300,
                                      height: 500,
                                    )),
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      top: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black26),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                recipeCatList[index]["heading"],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 234, 231, 210),
                                                    fontSize: 28),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ]))));
                    })),
              )
            ],
          ),
        ),
      ),
    ]));
  }
}

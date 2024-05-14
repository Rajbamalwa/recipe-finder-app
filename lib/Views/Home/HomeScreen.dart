import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:recipe_finder/Constants/Color_constants.dart';
import 'package:recipe_finder/Constants/Constants_api.dart';
import 'package:recipe_finder/Services/Api_Services.dart';
import 'package:recipe_finder/Views/Home/Components/RecipeDetailScreen.dart';

import '../../Widget/clipWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List recipeData = [];
  FocusNode focusNode = FocusNode();
  late TextEditingController controller;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  int length = 10;
  var currrentLength;

  var toalLength;

  getRecipeData(String value) async {
    setState(() {
      isLoading = true;
    });
    var response = await ApiService().fetchData(
        "$API$value&number=$length&diet=$_diet&fillIngredients=true&addRecipeInformation=true&addRecipeInstructions=true&addRecipeNutrition=true&addRecipeInformation=true&apiKey=$API_KEY");
    log(response.toString());
    if (response != null) {
      setState(() {
        currrentLength = response['number'];
        toalLength = response['totalResults'];

        recipeData.addAll(response['results']);
        isLoading = false;
      });
    } else {
      setState(() {
        recipeData = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.requestFocus();

    controller = TextEditingController();

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      log(scrollController.position.toString());
      if (currrentLength <= toalLength) {
        setState(() {
          print('Api reHitted');
          length += 10;
          getRecipeData(controller.text.toString());
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  List<String> _diets = [
    'None',
    'Gluten Free',
    'Ketogenic',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Vegan',
    'Pescetarian',
    'Paleo',
    'Primal',
    'Whole30',
  ];
  double _targetCalories = 2250;
  String _diet = 'None';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue.withOpacity(0.7),
        centerTitle: true,
        title: Text(
          "Recipe Finder",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              onChanged: (value) {},
              cursorWidth: 1.0,
              focusNode: focusNode,
              readOnly: false,
              onFieldSubmitted: (value) {
                if (value.isEmpty) {
                } else {
                  setState(() {
                    length = 10;
                    recipeData.clear();

                    getRecipeData(value.toString());
                  });
                }
              },
              minLines: 1,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: white,
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    if (controller.text.isEmpty) {
                    } else {
                      setState(() {
                        length = 10;
                        recipeData.clear();
                        getRecipeData(controller.text.toString());
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                ),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: grey,
                ),
                hintText: "Search here",

                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: grey,
                ),
                contentPadding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: blue.withOpacity(0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: blue.withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: blue.withOpacity(0.6),
                  ),
                ),

                floatingLabelBehavior: FloatingLabelBehavior.auto,
                isDense: false,

                // border: OutlineInputBorder(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: _diets.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (controller.text.isEmpty) {
                          } else {
                            setState(() {
                              _diet = _diets[index];
                              length = 10;
                              recipeData.clear();

                              getRecipeData(controller.text.toString());
                            });
                          }
                        },
                        child: clipWidget(
                          _diets[index],
                          _diets[index] == _diet.toString()
                              ? white
                              : Colors.transparent,
                          _diets[index] == _diet.toString() ? black : white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          isLoading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : controller.text.isEmpty
                  ? Center(
                      child: Text(
                        "Please Search for Recipe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: grey,
                        ),
                      ),
                    )
                  : recipeData.isEmpty
                      ? Center(
                          child: Text(
                            "No Data Found",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: grey,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: recipeData.length,
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                            itemBuilder: (context, index) {
                              log(recipeData.toString());

                              if (index == recipeData.length) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              // if (errorMessage.isNotEmpty)
                              //   Positioned.fill(
                              //     child: Container(
                              //       color: tSecondaryColor,
                              //       child: Center(
                              //         child: Padding(
                              //           padding: EdgeInsets.all(20.0),
                              //           child: Text(
                              //             errorMessage,
                              //             style: TextStyle(
                              //               color: Colors.white,
                              //               fontSize: 18.0,
                              //             ),
                              //             textAlign: TextAlign.center,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   );

                              var data = recipeData[index];
                              return index == recipeData.length
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: blue))
                                  : Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      RecipeDetailScreen(
                                                          recipe: data)));
                                        },
                                        child: Container(
                                          height: 100,
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data['image'],
                                                    ),
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Stack(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: width * 0.65,
                                                        child: Text(
                                                          data['title']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.65,
                                                        child: Text(
                                                          "Time to make - ${data['readyInMinutes'].toString()}",
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.65,
                                                        child: Text(
                                                          "Dish type - ${data['dishTypes'].toString().replaceAll("[", "").replaceAll("]", "" + "  -")}",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 12,
                                                          ),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      // SizedBox(
                                                      //     width: width * 0.6,
                                                      //     child: HtmlWidget(
                                                      //         data['summary']))
                                                    ],
                                                  ),
                                                  Positioned(
                                                    right: 0,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              color:
                                                                  data['vegetarian'] ==
                                                                          true
                                                                      ? green
                                                                      : red),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
        ],
      ),
    );
  }
}

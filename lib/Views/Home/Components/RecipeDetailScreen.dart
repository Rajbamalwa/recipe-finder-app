import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Constants/Color_constants.dart';

class RecipeDetailScreen extends StatefulWidget {
  final recipe;
  RecipeDetailScreen({required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Method to load the shared preference data
  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      items = prefs.getStringList("item")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue.withOpacity(0.7),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();

              if (items.contains(widget.recipe['id'].toString())) {
                setState(() {
                  items.remove(widget.recipe['id'].toString());

                  prefs.setStringList("item", items);
                });
              } else {
                setState(() {
                  items.add(widget.recipe['id'].toString());

                  prefs.setStringList("item", items);
                });
              }
            },
            icon: Icon(
              items.contains(widget.recipe['id'].toString())
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  items.contains(widget.recipe['id'].toString()) ? red : white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 0),
              child: Container(
                width: width,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.recipe['image'].toString(),
                    ),
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
                child: Text(
                  widget.recipe['title'].toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: blue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Tooltip(
                    message: widget.recipe['vegetarian'] == true
                        ? "Vegetarian"
                        : "Non-Vegetarian",
                    child: Text(
                      "Type : ",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: white,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: widget.recipe['vegetarian'] == true
                        ? "Vegetarian"
                        : "Non-Vegetarian",
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color:
                            widget.recipe['vegetarian'] == true ? green : red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                "Summary",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: HtmlWidget(widget.recipe['summary']),
            ),
            ListTile(
              title: Text(
                "Dish Type",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Text(
                widget.recipe['dishTypes']
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", "" + "  -"),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: white,
                ),
              ),
            ),
            ExpansionTile(
              title: Text(
                "Making Instructions",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: blue,
                ),
              ),
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    ...List.generate(
                      widget.recipe['analyzedInstructions'].length,
                      (index) => ExpansionTile(
                        title: Text(widget.recipe['analyzedInstructions'][index]
                                    ['name'] ==
                                ""
                            ? "Steps"
                            : widget.recipe['analyzedInstructions'][index]
                                ['name']),
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.horizontal,
                            spacing: 5,
                            runSpacing: 5,
                            children: [
                              ...List.generate(
                                  widget
                                      .recipe['analyzedInstructions'][index]
                                          ['steps']
                                      .length,
                                  (inde) => ExpansionTile(
                                        title: Text(widget
                                            .recipe['analyzedInstructions']
                                                [index]['steps'][inde]['step']
                                            .toString()),
                                        leading: CircleAvatar(
                                          child: Text(widget
                                              .recipe['analyzedInstructions']
                                                  [index]['steps'][inde]
                                                  ['number']
                                              .toString()),
                                        ),
                                        children: [
                                          ...List.generate(
                                              widget
                                                  .recipe[
                                                      'analyzedInstructions']
                                                      [index]['steps'][inde]
                                                      ['ingredients']
                                                  .length,
                                              (ind) => ListTile(
                                                    leading: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(widget
                                                                  .recipe[
                                                                      'analyzedInstructions']
                                                                      [index]
                                                                      ['steps']
                                                                      [inde][
                                                                      'ingredients']
                                                                      [ind]
                                                                      ['image']
                                                                  .toString()))),
                                                    ),
                                                    title: Text(widget.recipe[
                                                            'analyzedInstructions']
                                                            [index]['steps']
                                                            [inde]
                                                            ['ingredients'][ind]
                                                            ['name']
                                                        .toString()),
                                                  )),
                                        ],
                                      )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // widget.recipe['nutrition']['ingredients'].isEmpty
            //     ? SizedBox()
            //     : ExpansionTile(
            //         title: Text(
            //           "Nutrition",
            //           style: TextStyle(
            //             fontWeight: FontWeight.w800,
            //             fontSize: 18,
            //             color: white,
            //           ),
            //         ),
            //         children: [
            //           Wrap(
            //             alignment: WrapAlignment.start,
            //             crossAxisAlignment: WrapCrossAlignment.center,
            //             direction: Axis.horizontal,
            //             spacing: 5,
            //             runSpacing: 5,
            //             children: [
            //               ...List.generate(
            //                 widget.recipe['nutrition']['ingredients'].length,
            //                 (index) => ExpansionTile(
            //                   title: Text(widget.recipe['nutrition']
            //                       ['ingredients'][index]['name']),
            //                   children: [
            //                     Wrap(
            //                       alignment: WrapAlignment.start,
            //                       crossAxisAlignment: WrapCrossAlignment.center,
            //                       direction: Axis.horizontal,
            //                       spacing: 5,
            //                       runSpacing: 5,
            //                       children: [
            //                         ...List.generate(
            //                           widget.recipe['nutrition']['ingredients']
            //                               .length,
            //                           (i) => Chip(
            //                             backgroundColor: Colors.transparent,
            //                             label: Text(widget.recipe['nutrition']
            //                                         ['ingredients'][i]
            //                                     ['nutrients'][i]['name'] +
            //                                 " - " +
            //                                 widget.recipe['nutrition']
            //                                         ['ingredients'][i]
            //                                         ['nutrients'][i]['amount']
            //                                     .toString() +
            //                                 " " +
            //                                 widget.recipe['nutrition']
            //                                         ['ingredients'][i]
            //                                     ['nutrients'][i]['unit']),
            //                             deleteIcon: SizedBox(),
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
          ],
        ),
      ),
    );
  }
}

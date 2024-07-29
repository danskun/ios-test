import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:skripsi/admin_app/RatingPageAdmin.dart';
import 'package:skripsi/color/color_select.dart';
import 'package:skripsi/data/service/api_service.dart';

class ContentMakanan2 extends StatefulWidget {
  final String cd_user;
  final String cd_shop;
  final Uint8List? image;
  final String name;
  final String time_open;
  final String time_closed;
  final String location;
  final String level;

  ContentMakanan2({
    super.key,
    required this.cd_user,
    required this.cd_shop,
    required this.image,
    required this.name,
    required this.time_open,
    required this.time_closed,
    required this.location,
    required this.level,
  });

  @override
  _ContentMakanan2State createState() => _ContentMakanan2State();
}

class _ContentMakanan2State extends State<ContentMakanan2> {
  late Future<Map<String, dynamic>> favDataFuture;
  bool isFavorite = false;
  String totalRating = '0';

  @override
  void initState() {
    super.initState();
    print('qweqew ${widget.level}');
    checkFav();
    fetchTotalRating();
  }

  void fetchTotalRating() async {
    try {
      String rating = await APIService().getTotalRating(widget.cd_shop);
      String result = rating.substring(0, 3);
      setState(() {
        totalRating = rating.isEmpty ? "0" : result;
      });
    } catch (error) {
      print("Error fetching rating: $error");
      setState(() {
        totalRating = "0";
      });
    }
    print(totalRating);
  }

  void checkFav() {
    favDataFuture =
        APIService().getFavoriteBool(widget.cd_user, widget.cd_shop);
    favDataFuture.then((data) {
      if (data["OK"] != null &&
          data["OK"].isNotEmpty &&
          data["OK"]["favorite"] == "1") {
        setState(() {
          isFavorite = true;
        });
      } else {
        setState(() {
          isFavorite = false;
        });
      }
    }).catchError((error) {
      print("Error: $error");
      setState(() {
        isFavorite = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RatingPageAdmin(
            image: widget.image,
            cd_user: widget.cd_user,
            cd_shop: widget.cd_shop,
            name: widget.name,
            time_open: widget.time_open,
            time_closed: widget.time_closed,
            location: widget.location,
            level: widget.level,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: ColorSelect.secondaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  height: 200,
                  width: double.maxFinite,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: widget.image != null
                        ? Image.memory(
                            widget.image!,
                            fit: BoxFit.cover,
                          )
                        : null
                  ),
                ),
                Positioned(
                  top: 145.0,
                  right: 5.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        if (isFavorite) {
                          APIService().addFavorite(
                              context, widget.cd_user, widget.cd_shop);
                        } else {
                          APIService().removeFavorite(
                              context, widget.cd_user, widget.cd_shop);
                        }
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade300,
                      ),
                      child: Center(
                        child: isFavorite
                            ? Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: Colors.blue,
                              ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${totalRating}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color :Color(0xff4682a9)),
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xff789ba4)),
                    ),
                  ),
                  Container(
                    child: Text(
                      "${widget.time_open} - ${widget.time_closed}",
                      style: TextStyle(color: Color(0xff4682a9)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

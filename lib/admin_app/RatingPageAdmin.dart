import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/modalRating.dart';
import 'package:skripsi/modalResult.dart';

class RatingPageAdmin extends StatefulWidget {
  final String cd_user;
  final String cd_shop;
  final Uint8List? image;
  final String name;
  final String time_open;
  final String time_closed;
  final String location;
  final String level;

  RatingPageAdmin({
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
  final String gambar1 = 'assets/JAKEATS.png';

  @override
  _RatingPageAdminState createState() => _RatingPageAdminState();
}

class _RatingPageAdminState extends State<RatingPageAdmin> {
  final key = GlobalKey<FormState>();
  double userRating = 0;
  double rasaRating = 0;
  double kebersihanRating = 0;
  double pelayananRating = 0;
  double hargaRating = 0;
  double vibesRating = 0;
  TextEditingController commentController = TextEditingController();
  late Future<List> ratingDataFuture;
  late Future<List> reviewDataFuture;
  String totRating = '0';

  bool display = false;

  @override
  void initState() {
    super.initState();
    ratingDataFuture = APIService().getReview(widget.cd_user, widget.cd_shop);
    reviewDataFuture = APIService().getReviewAll(widget.cd_shop, widget.cd_user);
    fetchTotRating();
    if(widget.level == 'User'){
      setState(() {
        display = true;
      });
    } else {
      setState(() {
        display = false;
      });
    }
  }

  void fetchTotRating() async {
    try {
      String rating = await APIService().getTotRating(widget.cd_shop);
      setState(() {
        totRating = rating.isEmpty ? "0" : rating;
      });
    } catch (error) {
      print("Error fetching rating: $error");
      setState(() {
        totRating = "0";
      });
    }
    print(totRating);
  }

  void updateReviews() {
    setState(() {
      ratingDataFuture = APIService().getReview(widget.cd_user, widget.cd_shop);
      reviewDataFuture = APIService().getReviewAll(widget.cd_shop, widget.cd_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        title: SizedBox(
          child: Image.asset(
            widget.gambar1,
            height: 100,
            width: 100,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.image != null)
                Image.memory(
                  widget.image!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey,
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff4682a9),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Color(0xff4682a9),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  widget.location,
                                  maxLines: null,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.timelapse_outlined,
                              color: Color(0xff4682a9),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${widget.time_open} - ${widget.time_closed}',
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (display)
                Form(
                  key: key,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showModal(context, widget.cd_user, widget.cd_shop);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff4682a9),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Tambah Ulasan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              if (display)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Rating dan Ulasan Sendiri',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff4682a9),
                  ),
                ),
              ),
              if (display)
              FutureBuilder<List>(
                future: ratingDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No reviews available'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        color: Colors.white,
                        height: 100,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final review = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 8.0),
                                        child: CircleAvatar(
                                          radius: 19.0,
                                          backgroundColor: Color(0xff4682a9),
                                          child: review['image'] != null
                                              ? ClipOval(
                                                  child: Image.memory(
                                                    base64Decode(review['image']),
                                                    fit: BoxFit.cover,
                                                    width: 38.0,
                                                    height: 38.0,
                                                  ),
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(review['comment']),
                                            SizedBox(height: 4),
                                            RatingBar.builder(
                                              initialRating: review['rating'].toDouble(),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 16,
                                              ignoreGestures: true,
                                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                        IconButton(
                                          onPressed: () {
                                            showModalResult(
                                              context,
                                              review['rasa'].toString(),
                                              review['kebersihan'].toString(),
                                              review['pelayanan'].toString(),
                                              review['harga'].toString(),
                                              review['vibes'].toString(),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.remove_red_eye_sharp,
                                            color: Color(0xff4682a9),
                                          ),
                                        ),
                                      IconButton(
                                        onPressed: () {
                                          if (key.currentState!.validate()) {
                                            APIService().deleteReview(context, review['cd_review']);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RatingPageAdmin(
                                                  cd_user: widget.cd_user,
                                                  cd_shop: widget.cd_shop,
                                                  image: widget.image,
                                                  name: widget.name,
                                                  time_open: widget.time_open,
                                                  time_closed: widget.time_closed,
                                                  location: widget.location,
                                                  level: widget.level,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Color(0xff4682a9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),if (display)
              Divider(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Rating dan Ulasan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff4682a9),
                  ),
                ),
              ),
              FutureBuilder<List>(
                future: reviewDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No reviews available'));
                  } else {
                    return Container(
                      color: Colors.white,
                      height: 295,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final review = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 8.0),
                                      child: CircleAvatar(
                                        radius: 19.0,
                                        backgroundColor: Color(0xff4682a9),
                                        child: review['image'] != null
                                            ? ClipOval(
                                                child: Image.memory(
                                                  base64Decode(review['image']),
                                                  fit: BoxFit.cover,
                                                  width: 38.0,
                                                  height: 38.0,
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xff4682a9),
                                            ),
                                          ),
                                          Text(review['comment']),
                                          SizedBox(height: 4),
                                          RatingBar.builder(
                                            initialRating: review['rating'].toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 16,
                                            ignoreGestures: true,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showModalResult(
                                          context,
                                          review['rasa'].toString(),
                                          review['kebersihan'].toString(),
                                          review['pelayanan'].toString(),
                                          review['harga'].toString(),
                                          review['vibes'].toString(),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye_sharp,
                                        color: Color(0xff4682a9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skripsi/admin_app/RatingPageAdmin.dart';
import 'package:skripsi/admin_app/ratingSection.dart';
import 'package:skripsi/data/service/api_service.dart';

void showModal(BuildContext context, String cd_user, String cd_shop) {
  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true, // This allows the modal to take up the full height
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return ModalWidget(
            scrollController: scrollController,
            cd_user: cd_user,
            cd_shop: cd_shop,
          );
        },
      );
    },
  );
}

class ModalWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String cd_user;
  final String cd_shop;

  ModalWidget({
    required this.scrollController,
    required this.cd_user,
    required this.cd_shop,
  });

  @override
  _ModalWidgetState createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<ModalWidget> {
  final key = GlobalKey<FormState>();
  double ratingController = 0;
  TextEditingController commentController = TextEditingController();
  double rasaController = 0;
  double kebersihanController = 0;
  double pelayananController = 0;
  double hargaController = 0;
  double vibesController = 0;
  late Future<List> ratingDataFuture;
  late Future<List> reviewDataFuture;

  void updateReviews() {
    setState(() {
      // Memperbarui future untuk mendapatkan ulasan terbaru
      ratingDataFuture = APIService().getReview(widget.cd_user, widget.cd_shop);
      reviewDataFuture =
          APIService().getReviewAll(widget.cd_shop, widget.cd_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Ulasan dan Rating',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Tulis komentar Anda...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              RatingSection(
                title: 'Rasa',
                initialRating: rasaController,
                onRatingUpdate: (rating) {
                  setState(() {
                    rasaController = rating;
                  });
                },
              ),
              SizedBox(height: 8.0),
              RatingSection(
                title: 'Kebersihan',
                initialRating: kebersihanController,
                onRatingUpdate: (rating) {
                  setState(() {
                    kebersihanController = rating;
                  });
                },
              ),
              SizedBox(height: 8.0),
              RatingSection(
                title: 'Pelayanan',
                initialRating: pelayananController,
                onRatingUpdate: (rating) {
                  setState(() {
                    pelayananController = rating;
                  });
                },
              ),
              SizedBox(height: 8.0),
              RatingSection(
                title: 'Harga',
                initialRating: hargaController,
                onRatingUpdate: (rating) {
                  setState(() {
                    hargaController = rating;
                  });
                },
              ),
              SizedBox(height: 8.0),
              RatingSection(
                title: 'Vibes',
                initialRating: vibesController,
                onRatingUpdate: (rating) {
                  setState(() {
                    vibesController = rating;
                  });
                },
              ),
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    double averageRating = (ratingController +
                            kebersihanController +
                            pelayananController +
                            hargaController +
                            vibesController) /
                        5;
                    if (key.currentState!.validate()) {
                      APIService().createReview(
                          context,
                          widget.cd_user,
                          widget.cd_shop,
                          averageRating.toString(),
                          commentController.text,
                          rasaController.toString(),
                          kebersihanController.toString(),
                          pelayananController.toString(),
                          hargaController.toString(),
                          vibesController.toString());
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff4682a9),
                            foregroundColor: Colors.white,
                          ),
                  child: Text(
                    'Tambahkan Ulasan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                
              ),
            ],
          ),
          
        ),
        
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:skripsi/PromoPage.dart';

class PromoPage extends StatefulWidget {
  String cd_promo;
  String description;
  String date_open;
  String date_closed;
  int min_trans;
  String terms;
  Uint8List? image;

  PromoPage({
    Key? key,
    required this.cd_promo,
    required this.description,
    required this.date_open,
    required this.date_closed,
    required this.min_trans,
    required this.terms,
    required this.image,
  }) : super(key: key);

  @override
  _PromoPageState createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SecondScreen(
              cd_promo: widget.cd_promo,
              description: widget.description,
              date_open: widget.date_open,
              date_closed: widget.date_closed,
              min_trans: widget.min_trans,
              terms: widget.terms,
              image: widget.image);
        }));
      },
      child: Container(
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   color: ColorSelect.secondaryColor,
        // ),
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
                  height: 300,
                  width: double.maxFinite,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(15),
                    //   topRight: Radius.circular(15),
                    // ),
                    child: widget.image != null
                        ? Image.memory(
                            widget.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/kocak.jpg',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

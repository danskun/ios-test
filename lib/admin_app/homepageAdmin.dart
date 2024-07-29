// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skripsi/admin_app/navigationAdmin.dart';

import 'package:skripsi/color/color_select.dart';
import 'package:skripsi/admin_app/carousel_sliderAdmin.dart';
import 'package:skripsi/carousel/carousel_slider_promo.dart';
import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/users_app/carousel_slider.dart';
import 'package:skripsi/users_app/navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyHomePageAdmin extends StatefulWidget {
  const MyHomePageAdmin({
    Key? key,
    required this.cd_user,
    required this.level,
    required this.title,
  });

  final String cd_user;
  final String level;
  final String title;
  final String gambar1 = 'assets/JAKEATS.png';

  @override
  State<MyHomePageAdmin> createState() => _MyHomePageAdminState();
}

class _MyHomePageAdminState extends State<MyHomePageAdmin> {
  late Future<List> promoDataFuture;
  late Future<List> shopDataFuture;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    promoDataFuture = APIService().getPromo();
    shopDataFuture = APIService().getShop();
    // print('qweqew ${widget.level}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: NavAdmin(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Color(0xff4682a9),
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
              FutureBuilder<List>(
                future: promoDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Data Kosong'),
                    );
                  } else {
                    return CarouselSlider(
                      items: snapshot.data!.map<Widget>((promo) {
                        return PromoPage(
                          cd_promo: promo['cd_promo'],
                          description: promo['description'],
                          date_open: promo['date_open'],
                          date_closed: promo['date_closed'],
                          min_trans: promo['min_trans'],
                          terms: promo['terms'],
                          image: promo['image'] != null
                              ? base64Decode(promo['image'])
                              : null,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 340.0,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: true,
                        viewportFraction: 0.9,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Rekomendasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List>(
                future: shopDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Data Kosong'),
                    );
                  } else {
                    return CarouselSlider(
                      items: snapshot.data!.map<Widget>((shop) {
                        return ContentMakanan2(
                          cd_user: widget.cd_user,
                          cd_shop: shop['cd_shop'],
                          image: shop['image'] != null
                              ? base64Decode(shop['image'])
                              : null,
                          name: shop['name'],
                          time_open: shop['time_open'],
                          time_closed: shop['time_closed'],
                          location: shop['location'], 
                          level: widget.level,
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 340.0,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.9,
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

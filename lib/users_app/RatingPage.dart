// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:skripsi/data/service/api_service.dart';

class RatingPage extends StatefulWidget {
  final String cd_shop;
  RatingPage({
    super.key,
    required this.cd_shop,
  });
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  String userComment = '';
  double userRating = 0;
  String totRating = '0';

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Image.asset(
              'assets/sate.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            // Informasi tempat
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nama Tempat',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Lokasi Tempat'),
                  SizedBox(height: 8),
                  Text('12:00 - 02:00'),
                ],
              ),
            ),
            // Rating
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RatingBar.builder(
                initialRating: userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20, // Ukuran bintang
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    userRating = rating; // Memperbarui rating pengguna
                  });
                  print(rating);
                },
              ),
            ),
            // Komentar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: commentController, // Menggunakan controller
                decoration: InputDecoration(
                  hintText: 'Tulis komentar Anda...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            // Tombol Kirim Komentar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    userComment =
                        commentController.text; // Memperbarui komentar pengguna
                  });
                },
                child: Text('Kirim Komentar'),
              ),
            ),
            // Komentar dan Rating User
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Rating dan Ulasan ("${totRating}")',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            // FutureBuilder<List>(
            //   future: reviewDataFuture,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //       return Center(child: Text('No reviews available'));
            //     } else {
            //       return Container(
            //         height: 300, // Fixed height to allow ListView scrolling
            //         child: ListView.builder(
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index) {
            //             final review = snapshot.data![index];
            //             return Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Container(
            //                         margin: EdgeInsets.only(right: 8.0),
            //                         child: CircleAvatar(
            //                           child: review['image'] != null
            //                               ? Image.memory(
            //                                   base64Decode(review['image']),
            //                                 )
            //                               : Icon(Icons.person),
            //                         ),
            //                       ),
            //                       Expanded(
            //                         child: Column(
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           children: [
            //                             Text(review['comment']),
            //                             SizedBox(height: 4),
            //                             RatingBar.builder(
            //                               initialRating:
            //                                   review['rating'].toDouble(),
            //                               minRating: 1,
            //                               direction: Axis.horizontal,
            //                               allowHalfRating: true,
            //                               itemCount: 5,
            //                               itemSize: 16,
            //                               ignoreGestures: true,
            //                               itemPadding: EdgeInsets.symmetric(
            //                                   horizontal: 2.0),
            //                               itemBuilder: (context, _) => Icon(
            //                                 Icons.star,
            //                                 color: Colors.amber,
            //                               ),
            //                               onRatingUpdate: (rating) {},
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                       IconButton(
            //                         onPressed: () {},
            //                         icon: Icon(Icons.delete),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

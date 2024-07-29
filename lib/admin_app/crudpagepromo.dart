import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skripsi/admin_app/editpagepromo.dart';
import 'package:skripsi/admin_app/navigationAdmin.dart';
import 'package:skripsi/data/service/api_service.dart';

class CrudPagePromo extends StatefulWidget {
  final String gambar1 = 'assets/JAKEATS.png';

  @override
  _CrudPagePromoState createState() => _CrudPagePromoState();
}

class _CrudPagePromoState extends State<CrudPagePromo> {
  late Future<List> promoDataFuture;

  @override
  void initState() {
    super.initState();
    promoDataFuture = APIService().getPromo();
    print(promoDataFuture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavAdmin(),
      appBar: AppBar(
        title: Text('Data Master'),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Color(0xff4682a9),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List>(
          future: promoDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Data Kosong'),
              );
            } else {
              var promoData = snapshot.data;
              return ListView.builder(
                itemCount: promoData?.length,
                itemBuilder: (context, index) {
                  final promo = promoData?[index];
                  return ListTile(
                    title: Text(promo['description']),
                    subtitle:
                        Text("${promo['date_open']} - ${promo['date_closed']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPagePromo(
                                  cd_promo: promo['cd_promo'],
                                  description: promo['description'],
                                  date_open: promo['date_open'],
                                  date_closed: promo['date_closed'],
                                  min_trans: promo['min_trans'],
                                  terms: promo['terms'],
                                  image: promo['image'] != null
                                      ? base64Decode(promo['image'])
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            APIService().deletePromo(
                              context,
                              promo['cd_promo'],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

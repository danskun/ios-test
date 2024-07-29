import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skripsi/admin_app/editpage.dart';
import 'package:skripsi/admin_app/navigationAdmin.dart';
import 'package:skripsi/data/service/api_service.dart';

class CrudPage extends StatefulWidget {
  final String gambar1 = 'assets/JAKEATS.png';

  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  late Future<List> shopDataFuture;

  @override
  void initState() {
    super.initState();
    shopDataFuture = APIService().getShop();
    print(shopDataFuture);
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
          future: shopDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Data Kosong'),
              );
            } else {
              var shopData = snapshot.data;
              return ListView.builder(
                itemCount: shopData?.length,
                itemBuilder: (context, index) {
                  final shop = shopData?[index];
                  return ListTile(
                    title: Text(shop['name']),
                    subtitle:
                        Text("${shop['time_open']} - ${shop['time_closed']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(
                                  cd_shop: shop['cd_shop'],
                                  name: shop['name'],
                                  time_open: shop['time_open'],
                                  time_closed: shop['time_closed'],
                                  location: shop['location'],
                                  image: shop['image'] != null
                                      ? base64Decode(shop['image'])
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            APIService().deleteShop(
                              context,
                              shop['cd_shop'],
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

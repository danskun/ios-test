import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skripsi/admin_app/carousel_sliderAdmin.dart';
import 'package:skripsi/color/color_select.dart';
import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/users_app/navigation.dart';

class FavoritePage extends StatefulWidget {
  final String gambar1 = 'assets/JAKEATS.png';
  final String cd_user;

  FavoritePage({
    super.key,
    required this.cd_user,
  });

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List> favoriteDataFuture;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  List shopData = [];
  List filteredShopData = [];

  @override
  void initState() {
    super.initState();
    favoriteDataFuture = APIService().getFavorite(widget.cd_user);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    filterSearchResults(_searchController.text);
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredShopData = shopData;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredShopData = shopData
            .where((shop) =>
                shop['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawerUser(),
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
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xff4682a9),
                  ),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Color(0xff4682a9),
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              isSearching = false;
                              filteredShopData = shopData;
                            });
                          },
                        )
                      : null,
                  hintText: "Search...",
                  filled: true,
                  fillColor: ColorSelect.secondaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List>(
                future: favoriteDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Data Kosong'));
                  } else {
                    shopData = snapshot.data!;
                    filteredShopData =
                        isSearching ? filteredShopData : shopData;
                    return ListView.builder(
                      itemCount: filteredShopData.length,
                      itemBuilder: (context, index) {
                        var shop = filteredShopData[index];
                        return Column(
                          children: [
                            ContentMakanan2(
                              cd_user: widget.cd_user,
                              cd_shop: shop['cd_shop'],
                              image: shop['image'] != null
                                  ? base64Decode(shop['image'])
                                  : null,
                              name: shop['name'],
                              time_open: shop['time_open'],
                              time_closed: shop['time_closed'],
                              location: shop['location'], level: '',
                            ),
                            SizedBox(height: 30),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

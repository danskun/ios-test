import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:skripsi/admin_app/RatingPageAdmin.dart';
import 'package:skripsi/admin_app/navigationAdmin.dart';
import 'package:skripsi/color/color_select.dart';
import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/users_app/navigation.dart';

class RestaurantListPage extends StatefulWidget {
  final String gambar1 = 'assets/JAKEATS.png';
  final String cd_user;
  final String level;

  RestaurantListPage({
    required this.cd_user,
    required this.level,
  });

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  late Future<List> shopDataFuture;
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  List filteredShopDataList = [];
  List shopDataList = [];

  @override
  void initState() {
    super.initState();
    shopDataFuture = APIService().getShop();
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
        filteredShopDataList = shopDataList;
      });
    } else {
      setState(() {
        isSearching = true;
        filteredShopDataList = shopDataList
            .where((shop) => shop['name'].toLowerCase().contains(query.toLowerCase()))
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
        iconTheme: IconThemeData(color: Color(0xff4682a9)),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xff4682a9)),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Color(0xff4682a9)),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              isSearching = false;
                              filteredShopDataList = shopDataList;
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
            Expanded(
              child: FutureBuilder<List>(
                future: shopDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text('Data Kosong'));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    shopDataList = snapshot.data!;
                    filteredShopDataList = isSearching ? filteredShopDataList : shopDataList;
                    return ListView.builder(
                      itemCount: filteredShopDataList.length,
                      itemBuilder: (context, index) {
                        final shop = filteredShopDataList[index];
                        return CustomListTile(
                          cd_user: widget.cd_user,
                          cd_shop: shop['cd_shop'] ?? '',
                          image: shop['image'] ?? '',
                          name: shop['name'] ?? 'No Name',
                          location: shop['location'] ?? 'No Location',
                          open: shop['time_open'] ?? '',
                          closed: shop['time_closed'] ?? '',
                          level: widget.level,
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

class CustomListTile extends StatefulWidget {
  CustomListTile({
    required this.cd_user,
    required this.cd_shop,
    required this.image,
    required this.name,
    required this.location,
    required this.open,
    required this.closed,
    required this.level,
  });

  final String cd_user;
  final String cd_shop;
  final String image;
  final String name;
  final String location;
  final String open;
  final String closed;
  final String level;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  String totalRating = '0';

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (widget.image.isNotEmpty) {
      imageBytes = base64Decode(widget.image);
    }

    return ListTile(
      leading: imageBytes != null
          ? SizedBox(
              width: 50,
              height: 50,
              child: Image.memory(imageBytes, fit: BoxFit.cover),
            )
          : Container(
              width: 50,
              height: 50,
              color: Colors.grey,
              child: Icon(Icons.image, color: Colors.white),
            ),
      title: Text(widget.name),
      subtitle: Text(widget.location),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.yellow),
          SizedBox(width: 2), // add space between star and rating text
          Text(totalRating),
        ],
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RatingPageAdmin(
            image: imageBytes,
            cd_user: widget.cd_user,
            cd_shop: widget.cd_shop,
            name: widget.name,
            time_open: widget.open,
            time_closed: widget.closed,
            location: widget.location,
            level: widget.level,
          );
        }));
      },
    );
  }
}

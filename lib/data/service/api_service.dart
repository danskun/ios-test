// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi/admin_app/navigation_barAdmin.dart';
import 'package:skripsi/restaurantList.dart';
import 'package:skripsi/signin.dart';
import 'package:skripsi/users_app/navigation_bar.dart';

// String URL = "192.168.0.2";
String URL = "192.168.0.7";
// String URL = "172.18.13.232";

class APIService {
  Future registerUser(BuildContext context, String name, String email,
      String password, String phone) async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_sign.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "sign_up",
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register Berhasil!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Register Gagal!")));
    }
  }

  Future loginUser(BuildContext context, String email, String password) async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_sign.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "sign_in",
      "email": email,
      "password": password,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString("codeUser", data["OK"]["cd_user"]);
      sp.setString("level", data["OK"]["level"]);
      sp.setBool('isLogin', true);
      print(data["OK"]);
      if (data["OK"]["level"] == "Admin") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarAdmin(),
          ),
        );
      } else if (data["OK"]["level"] == "User") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationBarUser(),
          ),
        );
      }
    } else {
      _showLoginFailedDialog(context);
    }
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login Failed"),
          content: Text("Incorrect email or password. Please try again."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getUser(String cd_user) async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_user.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "read",
      "cd_user": cd_user,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      return data["OK"];
    }
  }

  Future updateUser(BuildContext context, String cd_user, String name,
      String email, String password, String phone, File? image) async {
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_user.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "update",
      "cd_user": cd_user,
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "image": base64Image ?? '',
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Ubah!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Ubah!")));
    }
  }

  Future<List> getShop() async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_shop.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readAll",
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      return data["OK"];
    } else {
      return [];
    }
  }

  Future createShop(BuildContext context, String name, String time_open,
      String time_closed, String location, File? image) async {
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_shop.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "create",
      "name": name,
      "time_open": time_open,
      "time_closed": time_closed,
      "location": location,
      "image": base64Image ?? '',
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Buat!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarAdmin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Buat!")));
    }
  }

  Future updateShop(
      BuildContext context,
      String cd_shop,
      String name,
      String time_open,
      String time_closed,
      String location,
      File? image) async {
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_shop.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "update",
      "cd_shop": cd_shop,
      "name": name,
      "time_open": time_open,
      "time_closed": time_closed,
      "location": location,
      "image": base64Image ?? '',
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Ubah!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarAdmin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Ubah!")));
    }
  }

  Future deleteShop(BuildContext context, String cd_shop) async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_shop.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "delete",
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Hapus!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarAdmin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Hapus!")));
    }
  }

  Future<List> getPromo() async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_promo.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readAll",
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      return data["OK"];
    } else {
      return [];
    }
  }

  Future createPromo(BuildContext context, String description, String date_open,
      String date_closed, String min_trans, String terms, File? image) async {
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_promo.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "create",
      "description": description,
      "date_open": date_open,
      "date_closed": date_closed,
      "min_trans": min_trans,
      "terms": terms,
      "image": base64Image ?? '',
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Buat!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarAdmin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Buat!")));
    }
  }

  Future updatePromo(
      BuildContext context,
      String cd_promo,
      String description,
      String date_open,
      String date_closed,
      String min_trans,
      String terms,
      File? image) async {
    String? base64Image;
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_promo.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "update",
      "cd_promo": cd_promo,
      "description": description,
      "date_open": date_open,
      "date_closed": date_closed,
      "min_trans": min_trans,
      "terms": terms,
      "image": base64Image ?? '',
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Ubah!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarAdmin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Ubah!")));
    }
  }

  Future deletePromo(BuildContext context, String cd_promo) async {
    var url =
        Uri.http(URL, '/jakeats/lib/data/rest/rest_promo.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "delete",
      "cd_promo": cd_promo,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Hapus!")));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarAdmin(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Hapus!")));
    }
  }

  Future<List> getReview(String cd_user, String cd_shop) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_review.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readAll",
      "cd_user": cd_user,
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      return data["OK"];
    } else {
      return [];
    }
  }

  Future<List> getReviewAll(String cd_shop, String cd_user) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_review.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readAllComment",
      "cd_shop": cd_shop,
      "cd_user": cd_user,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      return data["OK"];
    } else {
      return [];
    }
  }

  Future<String> getTotalRating(String cd_shop) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_review.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readAvgRating",
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null && data["OK"]["rating"] != null) {
      return data["OK"]["rating"].toString();
    } else {
      return "0";
    }
  }

  Future<String> getTotRating(String cd_shop) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_review.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readTotRating",
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null && data["OK"]["rating"] != null) {
      return data["OK"]["rating"].toString();
    } else {
      return "0";
    }
  }

  Future createReview(
      BuildContext context,
      String cd_user,
      String cd_shop,
      String rating,
      String comment,
      String rasa,
      String kebersihan,
      String pelayanan,
      String harga,
      String vibes) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_review.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "create",
      "cd_user": cd_user,
      "cd_shop": cd_shop,
      "rating": rating,
      "comment": comment,
      "rasa": rasa,
      "kebersihan": kebersihan,
      "pelayanan": pelayanan,
      "harga": harga,
      "vibes": vibes,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Buat!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Buat!")));
    }
  }

  Future deleteReview(BuildContext context, String cd_review) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_review.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "delete",
      "cd_review": cd_review,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Hapus!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Hapus!")));
    }
  }

  Future<List> getFavorite(String cd_user) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_favorite.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readAll",
      "cd_user": cd_user,
    });
    var data = json.decode(response.body);
    if (data["OK"] != null) {
      return data["OK"];
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getFavoriteBool(
      String cd_user, String cd_shop) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_favorite.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "readFavorite",
      "cd_user": cd_user,
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    return data;
  }

  Future addFavorite(
      BuildContext context, String cd_user, String cd_shop) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_favorite.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "create",
      "cd_user": cd_user,
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Tambah!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Tambah!")));
    }
  }

  Future removeFavorite(
      BuildContext context, String cd_user, String cd_shop) async {
    var url = Uri.http(
        URL, '/jakeats/lib/data/rest/rest_favorite.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "type": "delete",
      "cd_user": cd_user,
      "cd_shop": cd_shop,
    });
    var data = json.decode(response.body);
    if (data == "OK") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Berhasil di Hapus!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data Gagal di Hapus!")));
    }
  }
}


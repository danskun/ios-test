import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi/aboutPage.dart';
import 'package:skripsi/admin_app/PromoPageInput.dart';
import 'package:skripsi/admin_app/rekomendasi.dart';
import 'package:skripsi/signin.dart';

class NavAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xff4682a9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                "assets/JAKEATS.png",
                width: 100,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
                title: Center(
                    child: Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                }),
            ListTile(
              title: Center(
                  child: Text(
                'Rekomendasi',
                style: TextStyle(color: Colors.white),
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRekomendasiView(),
                  ),
                );
              },
            ),
            ListTile(
              title: Center(
                  child: Text(
                'Promosi',
                style: TextStyle(color: Colors.white),
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PromoInput(),
                  ),
                );
              },
            ),
            Center(
              child: ListTile(
                textColor: Colors.red,
                title: Center(child: Text('Logout')),
                onTap: () {
                  _logout(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => SignInScreen()),
  );
}

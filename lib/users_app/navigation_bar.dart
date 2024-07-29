import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi/restaurantList.dart';
import 'package:skripsi/users_app/favorite.dart';
import 'package:skripsi/users_app/homepage.dart';
import 'package:skripsi/users_app/profile.dart';

class BottomNavigationBarUser extends StatefulWidget {
  const BottomNavigationBarUser({Key? key});

  @override
  State<BottomNavigationBarUser> createState() =>
      _BottomNavigationBarUserState();
}

class _BottomNavigationBarUserState extends State<BottomNavigationBarUser> {
  int _selectedIndex = 0;
  String codeUser = '';
  String level = '';
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  void loadSharedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      codeUser = (sp.getString('codeUser') ?? 'null');
      level = (sp.getString('level') ?? 'null');
      _pages = <Widget>[
        MyHomePage(
          cd_user: codeUser,
          level: level,
          title: '',
        ),
        RestaurantListPage(
          cd_user: codeUser,
          level: level,
        ),
        FavoritePage(
          cd_user: codeUser,
        ),
        ProfilePage(
          title: '',
          codeUser: codeUser,
        ),
      ];
    });
    print(codeUser);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
            ),
          ),
          BottomNavigationBar(
            backgroundColor: Colors.transparent,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                backgroundColor: Colors.white,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                backgroundColor: Colors.white,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                backgroundColor: Colors.white,
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                backgroundColor: Colors.white,
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xff4682a9),
            unselectedItemColor: Color(0xff9db2ce),
            onTap: _onItemTapped,
          ),
        ],
      ),
      body: _pages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
    );
  }
}

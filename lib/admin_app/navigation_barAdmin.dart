import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi/admin_app/crudpage.dart';
import 'package:skripsi/admin_app/crudpagepromo.dart';
import 'package:skripsi/admin_app/homepageAdmin.dart';
import 'package:skripsi/admin_app/profileAdmin.dart';

class BottomNavigationBarAdmin extends StatefulWidget {
  const BottomNavigationBarAdmin({Key? key});

  @override
  State<BottomNavigationBarAdmin> createState() =>
      _BottomNavigationBarAdminState();
}

class _BottomNavigationBarAdminState extends State<BottomNavigationBarAdmin> {
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
        MyHomePageAdmin(
          cd_user: codeUser,
          level: level,
          title: 'Home',
        ),
        CrudPage(),
        CrudPagePromo(),
        ProfilePageAdmin(
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
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: Colors.white,
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              backgroundColor: Colors.white,
              label: 'Edit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              backgroundColor: Colors.white,
              label: 'Edit Promo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: Colors.white,
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          
          selectedItemColor: Color(0xff4682a9),
          unselectedItemColor: Color(0xff9db2ce),

          onTap: _onItemTapped,
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

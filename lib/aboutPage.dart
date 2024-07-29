import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
                child: Image.asset(
                  "assets/JAKEATS.PNG",
                  width: 300,
                  height: 100,
                ),
            ),
            SizedBox(height: 30,),
            Center(
              child: Text(
                'About',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4682a9)
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Aplikasi Rating Tempat Makan Berbasis Android Di Daerah Jakarta Selatan merupakan aplikasi untuk membantu dalam proses informasi dalam memilih objek kuliner dalam bentuk aplikasi yang berbasis android. Aplikasi ini di namakan Jakeats, Jakeats sendiri adalah kepanjangan dari “Jakarta Eats” yang artinya makanan jakarta. namun untuk aplikasi ini di spesifikan di daerah Jakarta Selatan saja.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),

            SizedBox(height: 16),
            Spacer(),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color:Color(0xff4682a9) ),
            ),
  
            SizedBox(height: 16),
            Text(
              'Developed by: Mohammad Akhdaan Juliandra',
              style: TextStyle(fontSize: 8, color: Color(0xff4682a9)),
            ),
            
          ],
        ),
      ),
    );
  }
}

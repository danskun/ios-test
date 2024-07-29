// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  String cd_promo;
  String description;
  String date_open;
  String date_closed;
  int min_trans;
  String terms;
  Uint8List? image;
  SecondScreen({
    super.key,
    required this.cd_promo,
    required this.description,
    required this.date_open,
    required this.date_closed,
    required this.min_trans,
    required this.terms,
    required this.image,
  });
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String formatRupiah(int number) {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id_ID', 
    symbol: 'Rp', 
    decimalDigits: 2,
  );
  return formatter.format(number);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promo Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              widget.image!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Deskripsi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.description,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey,
              indent: 8,
              endIndent: 8,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Periode: ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${widget.date_open} - ${widget.date_closed}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Minimal transaksi: ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    formatRupiah(widget.min_trans),
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Syarat dan Ketentuan',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.terms,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:skripsi/admin_app/RatingSectionResult.dart';

void showModalResult(BuildContext context, String rasa,
    String kebersihan, String pelayanan, String harga, String vibes) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return ModalResultWidget(
              scrollController: scrollController,
              rasa: rasa,
              kebersihan: kebersihan,
              pelayanan: pelayanan,
              harga: harga,
              vibes: vibes
              );
        },
      );
    },
  );
}

class ModalResultWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String rasa;
  final String kebersihan;
  final String pelayanan;
  final String harga;
  final String vibes;

  ModalResultWidget(
      {required this.scrollController,
      required this.rasa,
      required this.kebersihan,
      required this.pelayanan,
      required this.harga,
      required this.vibes});

  @override
  _ModalResultWidgetState createState() => _ModalResultWidgetState();
}

class _ModalResultWidgetState extends State<ModalResultWidget> {
  @override
  void initState() {
    super.initState();
    print(widget.rasa);
    print(widget.kebersihan);
    print(widget.pelayanan);
    print(widget.harga);
    print(widget.vibes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Detail Rating',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            RatingSectionResult(
              title: 'Rasa',
              initialRating: double.parse(widget.rasa),
              onRatingUpdate: null,  // Disable rating update
            ),
            SizedBox(height: 8.0),
            RatingSectionResult(
              title: 'Kebersihan',
              initialRating: double.parse(widget.kebersihan),
              onRatingUpdate: null,  // Disable rating update
            ),
            SizedBox(height: 8.0),
            RatingSectionResult(
              title: 'Pelayanan',
              initialRating: double.parse(widget.pelayanan),
              onRatingUpdate: null,  // Disable rating update
            ),
            SizedBox(height: 8.0),
            RatingSectionResult(
              title: 'Harga',
              initialRating: double.parse(widget.harga),
              onRatingUpdate: null,  // Disable rating update
            ),
            SizedBox(height: 8.0),
            RatingSectionResult(
              title: 'Vibes',
              initialRating: double.parse(widget.vibes),
              onRatingUpdate: null,  // Disable rating update
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

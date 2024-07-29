import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingSectionResult extends StatelessWidget {
  final String title;
  final double initialRating;
  final void Function(double)? onRatingUpdate; // Change to void Function(double)?
  final bool isReadOnly;

  const RatingSectionResult({
    Key? key,
    required this.title,
    required this.initialRating,
    this.isReadOnly = true,
    this.onRatingUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          RatingBar.builder(
            initialRating: initialRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: isReadOnly ? (_) {} : onRatingUpdate!, 
            ignoreGestures: isReadOnly,
          ),
        ],
      ),
    );
  }
}

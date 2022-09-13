import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction>? onTap;
  final Color textColor;
  final Color bodyColor;
  final Color formColor;
  final Color cardColor;
  PredictionTile({
    required this.prediction,
    this.onTap,
    required this.textColor,
    required this.bodyColor,
    required this.cardColor,
    required this.formColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: RichText(
        text: TextSpan(
          children: _buildPredictionText(
              context, textColor, bodyColor, cardColor, formColor),
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap!(prediction);
        }
      },
    );
  }

  List<TextSpan> _buildPredictionText(BuildContext context, Color textColor,
      Color bodyColor, Color cardColor, Color formColor) {
    final List<TextSpan> result = <TextSpan>[];

    if (prediction.matchedSubstrings.length > 0) {
      MatchedSubstring matchedSubString = prediction.matchedSubstrings[0];
      // There is no matched string at the beginning.
      if (matchedSubString.offset > 0) {
        result.add(
          TextSpan(
            text: prediction.description
                ?.substring(0, matchedSubString.offset as int?),
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
          ),
        );
      }

      // Matched strings.
      result.add(
        TextSpan(
          text: prediction.description?.substring(
              matchedSubString.offset as int,
              matchedSubString.offset + matchedSubString.length as int?),
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );

      // Other strings.
      if (matchedSubString.offset + matchedSubString.length <
          (prediction.description?.length ?? 0)) {
        result.add(
          TextSpan(
            text: prediction.description?.substring(
                matchedSubString.offset + matchedSubString.length as int),
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
          ),
        );
      }
      // If there is no matched strings, but there are predicts. (Not sure if this happens though)
    } else {
      result.add(
        TextSpan(
          text: prediction.description,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
        ),
      );
    }

    return result;
  }
}

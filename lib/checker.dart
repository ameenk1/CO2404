import 'package:flutter/material.dart';
import 'package:g21097717/detailscreens/ActorDetails.dart';
import 'package:g21097717/detailscreens/TvSeriesDetails.dart';
import 'package:g21097717/detailscreens/MovieDetails.dart';
import 'package:g21097717/detailscreens/ActorDetails.dart';


class descriptioncheckui extends StatefulWidget {
  var newid;
  var newtype;
  descriptioncheckui(this.newid, this.newtype);

  @override
  State<descriptioncheckui> createState() => _descriptioncheckuiState();
}

class _descriptioncheckuiState extends State<descriptioncheckui> {
  checktype() {
    if (widget.newtype.toString() == 'movie') {
      return MovieDetails(
        id: widget.newid,
      );
    } else if (widget.newtype.toString() == 'tv') {
      return TvSeriesDetails(id: widget.newid);
    } else if (widget.newtype.toString() == 'person') {
       return ActorDetails(id: widget.newid);
    } else {
      return errorui(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return checktype();
  }
}

Widget errorui(context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Text('no Such page found'),
    ),
  );
}

import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paradox/models/member.dart';
import 'package:paradox/utilities/logo_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialogBox extends StatefulWidget {
  final ExeMemberProfile exeMemberProfile;

  CustomDialogBox(this.exeMemberProfile);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, Colors.blue),
    );
  }

  contentBox(context, customColor) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: customColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, offset: Offset(0, 0), blurRadius: 10),
              ]),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.exeMemberProfile.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                      color: Colors.blue.shade600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Column(
                  children: [
                    ClipRRect(
                      child: Container(
                        child: Image.network(
                          widget.exeMemberProfile.image,
                          fit: BoxFit.cover,
                        ),
                        height: 250,
                        width: 180,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.exeMemberProfile.category,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.github,
                        color: Color(0xFF211F1F),
                      ),
                      onPressed: () async {
                        String url = widget.exeMemberProfile.githubUrl;
                        if (await canLaunch(url)) {
                          await launch(url, forceWebView: false);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      iconSize: 45,
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.linkedin,
                        color: Color(0xFF2867B2),
                      ),
                      onPressed: () async {
                        String url = widget.exeMemberProfile.linkedInUrl;
                        if (await canLaunch(url)) {
                          await launch(url, forceWebView: false);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      iconSize: 45,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: customColor,
            radius: 40,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 36,
              child: Transform.rotate(
                angle: pi / 3,
                child: Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.all(10),
                  child: CustomPaint(
                    painter: MyLogoPainter(Colors.blue),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
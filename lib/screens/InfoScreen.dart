import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:paradox/models/brightness_options.dart';
import 'package:paradox/providers/GalleryProvider.dart';
import 'package:paradox/providers/theme_provider.dart';
import 'package:paradox/screens/image_gallery.dart';
import 'package:paradox/screens/photo_view.dart';
import 'package:paradox/utilities/Toast.dart';
import 'package:paradox/widgets/video_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const TextStyle textStyle = TextStyle(
    color: Colors.white,
    fontSize: 22,
    letterSpacing: 2,
    fontWeight: FontWeight.w400);

class InfoScreen extends StatefulWidget {
  static String routeName = "/info-screen";

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  bool load = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        await Provider.of<GalleryProvider>(context, listen: false)
            .fetchAndSetGallery();
        setState(() {
          load = false;
        });
      } catch (e) {
        createToast("There is some error. Please try again later");
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String title, descriptionText1, url1, descriptionText2, url2;
    title = 'Information';
    descriptionText1 = 'View our projects on ';
    url1 = 'https://github.com/teamexe';
    descriptionText2 = ' or visit our website ';
    url2 = 'https://teamexe.in';
    final brightness =
        Provider.of<ThemeProvider>(context, listen: true).brightnessOption;

    final images = Provider.of<GalleryProvider>(context, listen: true).images;
    print(images);
    final videos = Provider.of<GalleryProvider>(context, listen: true).videos;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '.exe information'.toUpperCase(),
          style: TextStyle(
            fontWeight: brightness == BrightnessOption.light
                ? FontWeight.w400
                : FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          padding: const EdgeInsets.all(10),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      backgroundColor: brightness == BrightnessOption.light
          ? Colors.white
          : Colors.grey[800],
      body: load
          ? SpinKitFoldingCube(
              color: brightness == BrightnessOption.light
                  ? Colors.blue
                  : Colors.white,
            )
          : SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      if (images.length != 0)
                        Center(
                          child: Text(
                            'image gallery'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: brightness == BrightnessOption.light
                                  ? FontWeight.w400
                                  : FontWeight.w300,
                              color: brightness == BrightnessOption.light
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      if (images.length != 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Carousel(
                                dotSize: 4.0,
                                autoplayDuration: Duration(seconds: 5),
                                images: images
                                    .map((item) => Container(
                                          child: CachedNetworkImage(
                                            imageUrl: item.url,
                                            placeholder: (context, url) =>
                                                new SpinKitCircle(
                                              color: Colors.blue,
                                              size: 60,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ))
                                    .toList(),
                                onImageTap: (item) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          ExpandedImageGalleryView(
                                              images: images,
                                              initialPage: item)));
                                }),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (images.length != 0)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(),
                        ),
                      if (images.length != 0) SizedBox(height: 5),
                      if (videos.length != 0)
                        Center(
                          child: Text(
                            'videos'.toUpperCase(),
                            style: TextStyle(
                                fontWeight: brightness == BrightnessOption.light
                                    ? FontWeight.w400
                                    : FontWeight.w300,
                                color: brightness == BrightnessOption.light
                                    ? Colors.blue
                                    : Colors.white,
                                letterSpacing: 2,
                                fontSize: 18),
                          ),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      if (videos.length != 0)
                        Column(
                          children:
                              videos.map((e) => VideoCard(video: e)).toList(),
                        ),
                      SizedBox(
                        height: 5,
                      ),
                      if (images.length != 0)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(),
                        ),
                      if (images.length != 0) SizedBox(height: 5),
                      Text(title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                            color: brightness == BrightnessOption.light
                                ? Colors.blue.shade600
                                : Colors.white70,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(height: 22),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                            children: [
                              TextSpan(text: descriptionText1),
                              TextSpan(
                                  text: url1,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (await canLaunch(url1)) {
                                        launch(url1);
                                      } else {
                                        throw 'Could not launch ${url1}';
                                      }
                                    }),
                              TextSpan(text: descriptionText2),
                              TextSpan(
                                  text: url2,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (await canLaunch(url2)) {
                                        launch(url2);
                                      } else {
                                        throw 'Could not launch ${url2}';
                                      }
                                    }),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(right: 28),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    if (await canLaunch(
                                        'mailto:teamexenith@gmail.com'))
                                      launch('mailto:teamexenith@gmail.com');
                                    else {
                                      throw 'Could not launch mailto:teamexenith@gmail.com';
                                    }
                                  },
                                  child: Container(
                                      child: Text('contact us'.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16)))),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      'https://docs.google.com/forms/d/e/1FAIpQLSdf7fcO6cUbLcHCt7uxJoOSeVY7eTxRCE25E_BKyPRzEyZMng/viewform')) {
                                    launch(
                                        'https://docs.google.com/forms/d/e/1FAIpQLSdf7fcO6cUbLcHCt7uxJoOSeVY7eTxRCE25E_BKyPRzEyZMng/viewform');
                                  } else {
                                    throw 'Could not launch https://docs.google.com/forms/d/e/1FAIpQLSdf7fcO6cUbLcHCt7uxJoOSeVY7eTxRCE25E_BKyPRzEyZMng/viewform';
                                  }
                                },
                                child: Container(
                                    child: Text('feedback'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15))),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      'https://instagram.com/teamexenith?igshid=q1zcaikgc08s')) {
                                    launch(
                                        'https://instagram.com/teamexenith?igshid=q1zcaikgc08s');
                                  } else {
                                    throw 'Could not launch https://instagram.com/teamexenith?igshid=q1zcaikgc08s';
                                  }
                                },
                                child: Container(
                                    child: Text('instagram'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15))),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: brightness == BrightnessOption.light
                            ? Colors.blue
                            : Colors.grey[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.github,
                                  size: 32,
                                  color: brightness == BrightnessOption.light
                                      ? Colors.black45
                                      : Colors.grey,
                                ),
                              ),
                              onTap: () async {
                                if (await canLaunch(url1)) {
                                  launch(url1);
                                } else {
                                  throw 'Could not launch $url1';
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                child: Icon(FontAwesomeIcons.globeAsia,
                                    size: 32,
                                    color: brightness == BrightnessOption.light
                                        ? Colors.white70
                                        : Colors.grey[600]),
                              ),
                              onTap: () async {
                                if (await canLaunch(url2)) {
                                  launch(url2);
                                } else {
                                  throw 'Could not launch $url2';
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                child: Icon(Icons.mail_outline_rounded,
                                    size: 40,
                                    color: brightness == BrightnessOption.light
                                        ? Colors.grey[300]
                                        : Colors.blue),
                              ),
                              onTap: () async {
                                if (await canLaunch(
                                    'mailto:teamexenith@gmail.com'))
                                  launch('mailto:teamexenith@gmail.com');
                                else {
                                  throw 'Could not launch mailto:teamexenith@gmail.com';
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                child: Icon(FontAwesomeIcons.wpforms,
                                    size: 32,
                                    color: brightness == BrightnessOption.light
                                        ? Colors.blue.shade200
                                        : Colors.blue),
                              ),
                              onTap: () async {
                                if (await canLaunch(
                                    'https://docs.google.com/forms/d/e/1FAIpQLSdf7fcO6cUbLcHCt7uxJoOSeVY7eTxRCE25E_BKyPRzEyZMng/viewform')) {
                                  launch(
                                      'https://docs.google.com/forms/d/e/1FAIpQLSdf7fcO6cUbLcHCt7uxJoOSeVY7eTxRCE25E_BKyPRzEyZMng/viewform');
                                } else {
                                  throw 'Could not launch https://docs.google.com/forms/d/e/1FAIpQLSdf7fcO6cUbLcHCt7uxJoOSeVY7eTxRCE25E_BKyPRzEyZMng/viewform';
                                }
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                child: Icon(FontAwesomeIcons.instagram,
                                    size: 35,
                                    color: brightness == BrightnessOption.light
                                        ? Colors.white
                                        : Colors.pink.shade700),
                              ),
                              onTap: () async {
                                if (await canLaunch(
                                    'https://instagram.com/teamexenith?igshid=q1zcaikgc08s')) {
                                  launch(
                                      'https://instagram.com/teamexenith?igshid=q1zcaikgc08s');
                                } else {
                                  throw 'Could not launch https://instagram.com/teamexenith?igshid=q1zcaikgc08s';
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

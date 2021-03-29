import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:code/consts/global.dart';
import 'package:code/controller.dart';
import 'package:code/utils/online.dart';
import 'package:code/widgets/photo_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ShowView extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !controller.internet.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 150,
                ),
                Center(
                    child: AutoSizeText(
                  "Please Check Your Internet",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ))
              ],
            )
          : !controller.ready.value
              ? Center(
                  child: InkWell(
                      onTap: () => controller.getShow(),
                      child: CircularProgressIndicator()))
              : ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                                blurRadius: 50,
                                color: Colors.black12)
                          ]),
                          height: Get.context.height * .6,
                          transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                          child: GestureDetector(
                            onTap: () => openFullImage(
                                controller.nowShow.value.backdrop),
                            child: ClipPath(
                              clipper: OvalBottomBorderClipper(),
                              child: Image.network(
                                controller.nowShow.value.backdrop,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress != null)
                                    return Container();
                                  return FadeIn(
                                    duration: 500.milliseconds,
                                    child: child,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          bottom: 10.0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: RawMaterialButton(
                              padding: EdgeInsets.all(10.0),
                              elevation: 12.0,
                              onPressed: () => openURL(
                                  "https://www.youtube.com/results?search_query=" +
                                      controller.nowShow.value.title +
                                      " Trailer"),
                              shape: CircleBorder(),
                              fillColor: Get.isDarkMode
                                  ? context.theme.accentColor
                                  : Colors.white,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 60.0,
                                color: !Get.isDarkMode
                                    ? context.theme.accentColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 20.0,
                          child: IconButton(
                            onPressed: () => controller.bookmarking(),
                            icon: Icon(!controller.found.value
                                ? Icons.bookmark
                                : Icons.delete),
                            iconSize: 40.0,
                            color: !Get.isDarkMode
                                ? Get.context.theme.accentColor
                                : Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 25.0,
                          child: IconButton(
                            onPressed: () => controller.getShow(),
                            icon: Icon(Icons.arrow_forward_ios),
                            iconSize: 35.0,
                            color: !Get.isDarkMode
                                ? Get.context.theme.accentColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AutoSizeText(
                            controller.nowShow.value.title,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          // Opacity(
                          //   opacity: .75,
                          //   child: Text(
                          //     "Action, Adventure, Drama",
                          //     style: TextStyle(
                          //       fontSize: 16.0,
                          //     ),
                          //   ),
                          // ),
                          SmoothStarRating(
                            size: 30,
                            color: Get.context.theme.accentColor,
                            borderColor: context.theme.accentColor,
                            rating: controller.nowShow.value.rate / 2,
                            isReadOnly: true,
                          ),
                          SizedBox(height: 15.0),
                          Opacity(
                            opacity: .75,
                            child: AutoSizeText(
                              controller.nowShow.value.overview,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: CarouselSlider(
                          items: controller.screenshots.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  height: Get.context.height * .3,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  // height: Get.context.height * .3,
                                  child: GestureDetector(
                                    onTap: () =>
                                        navigator.push(MaterialPageRoute(
                                      settings: RouteSettings(name: "image"),
                                      builder: (context) {
                                        return PhotoView(
                                            imageProvider: NetworkImage(
                                                anyImgUrl + i["file_path"]));
                                      },
                                    )),
                                    child: Image.network(
                                      anyImgUrl + i["file_path"],
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress != null)
                                          return Container();
                                        return FadeIn(
                                          duration: 500.milliseconds,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: Get.context.height * .4,

                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: 0,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            // onPageChanged: callbackFunction,
                            //  height: 400,
                            // enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                          )),
                    )
                  ],
                ),
    );
  }
}

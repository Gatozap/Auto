import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../main.dart';
import 'Helper.dart';
import 'ViewFotos.dart';

class PhotoScroller extends StatelessWidget {
  PhotoScroller(this.photoUrls,
      {this.altura = 240,
      this.largura = 240,
      this.fractionsize = .6,
      this.hide = false});

  double altura;
  double largura;
  double fractionsize;
  bool hide;
  final List photoUrls;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoUrls[index];

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: CachedNetworkImage(
        imageUrl: photo,
        width: largura,
        height: altura,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    Random r = new Random();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hide ? Container() : sb,
          hide
              ? Container()
              : Text(
                'Fotos',
                style: textTheme.subhead.copyWith(fontSize: 18.0),
              ),
          hide ? Container() : sb,
          SizedBox.fromSize(
            size: Size(largura, altura),

            child:photoUrls.length>1? Swiper(
              itemCount: photoUrls.length,
              scrollDirection: Axis.horizontal,
              autoplay: true,
              layout: SwiperLayout.DEFAULT,
              autoplayDelay: r.nextInt(1000 * (r.nextInt(10) + 30)),
              viewportFraction: fractionsize,
              //indicatorLayout: PageIndicatorLayout.DROP,
              customLayoutOption:
                  CustomLayoutOption(startIndex: 0, stateCount: photoUrls.length),
              containerHeight: altura,
              containerWidth: largura,
              autoplayDisableOnInteraction: false,
              onTap: (i) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewFotos(photoUrls, i)));
              },
              itemWidth: largura,
              itemHeight: altura,
              loop: true,
              itemBuilder: _buildPhoto,
            ): GestureDetector(child: _buildPhoto(context, 0 ), onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewFotos(photoUrls, 0)));
            },),
          ),
        ],
      ),
    );
  }
}

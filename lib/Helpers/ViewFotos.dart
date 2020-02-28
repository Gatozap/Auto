import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'PinchZoomImage.dart';

class ViewFotos extends StatefulWidget {
  @override
  _ViewFotosState createState() {
    return _ViewFotosState();
  }

  List fotos;
  int selected;
  ViewFotos(this.fotos, this.selected);
}

class _ViewFotosState extends State<ViewFotos> {
  SwiperController controller = new SwiperController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
          elevation: 5,
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: GestureDetector(
            onTap: () {
              controller.next();
            },
            onDoubleTap: () {
              controller.previous();
            },
            behavior: HitTestBehavior.deferToChild,
            child: Swiper(
              controller: controller,
              scrollDirection: Axis.horizontal,
              index: widget.selected,
              itemBuilder: (context, index) {
                return Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: PinchZoomImage(
                      image: Center(
                        child: CachedNetworkImage(
                          imageUrl: widget.fotos[index],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      zoomedBackgroundColor: Colors.black,
                      hideStatusBarWhileZooming: false,
                      onZoomStart: () {
                        print('Zoom started');
                      },
                      onZoomEnd: () {
                        print('Zoom finished');
                      },
                    ),
                  ),
                );
              },
              loop: false,
              itemCount: widget.fotos.length,
            ),
          ),
        ),
      ),
    );
  }
}

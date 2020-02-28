import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:shimmer/shimmer.dart';

import 'Styles.dart';

/// the concept of the widget inspired
/// from [Nikolay Kuchkarov](https://dribbble.com/shots/3368130-Stepper-Touch).
/// i extended  the functionality to be more useful in real world applications
class StepperTouch extends StatefulWidget {
  const StepperTouch({
    Key key,
    this.initialValue,
    this.onChanged,
    this.direction = Axis.horizontal,
    this.withSpring = true,
    this.text,
    this.canDecreasse = true,
    this.canIncreasse = true,
    this.width = 220,
    this.height = 60,
    this.iconSize = 40,
    this.fontSize = 56,
    this.fontColor = Colors.black,
    this.iconColor = corPrimaria,
    this.iconRight,
    this.iconLeft,
    this.iconCenter,
  }) : super(key: key);

  /// the orientation of the stepper its horizontal or vertical.
  final Axis direction;
  final text;
  final double width;
  final double height;
  final bool canDecreasse;
  final bool canIncreasse;
  final double iconSize;
  final double fontSize;
  final Color iconColor;
  final Color fontColor;
  final iconRight;
  final iconLeft;
  final iconCenter;

  /// the initial value of the stepper
  final double initialValue;

  /// called whenever the value of the stepper changed
  final ValueChanged<double> onChanged;

  /// if you want a springSimulation to happens the the user let go the stepper
  /// defaults to true
  final bool withSpring;

  @override
  _Stepper2State createState() => _Stepper2State();
}

class _Stepper2State extends State<StepperTouch>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  double _value;
  double _startAnimationPosX;
  double _startAnimationPosY;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? 0;
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction == Axis.horizontal) {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
          .animate(_controller);
    } else {
      _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 1.5))
          .animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    var test = GestureDetector(
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      child: SlideTransition(
        position: _animation,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: Container(
            height: widget.height,
            width: widget.width - 150,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: corPrimaria,
//                        border: Border(bottom: BorderSide(width: 1.0)),
              borderRadius: BorderRadius.only(
                topRight: Radius.elliptical(80, 30),
                topLeft: Radius.circular(0.0),
                bottomRight: Radius.elliptical(80, 35),
                bottomLeft: Radius.circular(0.0),
              ),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: myOrange,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: widget.text,
              ),
            ),
          ),
        ),
      ),
    );
    return Container(
      width: widget.width - 150,
      height: widget.height,
      child: Material(
        type: MaterialType.canvas,
        clipBehavior: Clip.antiAlias,
        color: Colors.white.withOpacity(0.2),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            widget.canDecreasse
                ? Positioned(
                    left: widget.direction == Axis.horizontal ? 15.0 : null,
                    bottom: widget.direction == Axis.horizontal ? null : 10.0,
                    child: Icon(widget.iconLeft,
                        size: widget.iconSize, color: widget.iconColor),
                  )
                : Container(),
            Positioned(
              right: widget.direction == Axis.horizontal ? 10.0 : null,
              top: widget.direction == Axis.horizontal ? null : 10.0,
              child: widget.iconRight,
            ),
            Positioned(
              child: widget.text,
              left: (MediaQuery.of(context).size.width * .1) + 44,
              top: widget.direction == Axis.horizontal ? null : 10.0,
            ),
            Positioned(
                left: widget.direction == Axis.horizontal ? 0.0 : null,
                top: widget.direction == Axis.horizontal ? null : 10.0,
                child: Container(
                  width: widget.width,
                  child: GestureDetector(
                    onHorizontalDragStart: _onPanStart,
                    onHorizontalDragUpdate: _onPanUpdate,
                    onHorizontalDragEnd: _onPanEnd,
                    child: SlideTransition(
                      position: _animation,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          width: widget.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Material(
                                color: Colors.white,
                                shape: const CircleBorder(),
                                elevation: 5.0,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        child: child, scale: animation);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .1,
                                    height:
                                        MediaQuery.of(context).size.width * .1,
                                    child: widget.iconCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    _startAnimationPosX = (((local.dx * 0.75) / box.size.width) - 0.4);
    _startAnimationPosY = ((local.dy * 0.75) / box.size.height) - 0.4;
    if (widget.direction == Axis.horizontal) {
      return (((local.dx + (widget.width / 2) * 0.75) / box.size.width) - 0.4);
    } else {
      return ((local.dy * 0.75) / box.size.height) - 0.4;
    }
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    bool isHor = widget.direction == Axis.horizontal;
    bool changed = false;
    /*if (_controller.value <= -0.20) {
      setState(() => isHor ? _value-- : _value++);
      changed = true;
    } else*/
    if (_controller.value >= 0.20) {
      setState(() => isHor ? _value++ : _value--);
      changed = true;
    }
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
          new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );
      if (widget.direction == Axis.horizontal) {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosX, 0.0, 0.0));
      } else {
        _controller.animateWith(
            SpringSimulation(_kDefaultSpring, _startAnimationPosY, 0.0, 0.0));
      }
    } else {
      _controller.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

    if (changed && widget.onChanged != null) {
      widget.onChanged(_value);
    }
  }
}

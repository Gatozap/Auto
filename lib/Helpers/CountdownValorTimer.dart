import 'package:flutter/material.dart';

class CountdownValorTimer extends StatefulWidget {
  const CountdownValorTimer(
      {Key key,
      int secondsRemaining,
      this.countDownTimerStyle,
      this.whenTimeExpires,
      this.countDownFormatter,
      this.startingSeconds,
      this.valor})
      : secondsRemaining = secondsRemaining,
        super(key: key);
  final double valor;
  final int secondsRemaining;
  final DateTime startingSeconds;
  final Function whenTimeExpires;
  final Function countDownFormatter;
  final TextStyle countDownTimerStyle;

  State createState() => new _CountdownValorTimerState();
}

class _CountdownValorTimerState extends State<CountdownValorTimer>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Duration duration;

  String get timerDisplayString {
    Duration d = DateTime.now().difference(widget.startingSeconds);
    //print('AQUI DURACAO ${(d.inMinutes)}');
    //print(d.inMinutes);
    double v = (d.inSeconds) * ((widget.valor / 60) / 60);
    //v = v < 1 ? 1 : v;
    return 'R\$ ${v.toStringAsFixed(2)}';
    // In case user doesn't provide formatter use the default one
    // for that create a method which will be called formatHHMMSS or whatever you like
  }

  String DurationToString(Duration d) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twiDigitHour = twoDigits(d.inHours.remainder(60));
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "$twiDigitHour:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();
    duration = new Duration(seconds: widget.secondsRemaining);
    _controller = new AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller.reverse(from: widget.secondsRemaining.toDouble());
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.whenTimeExpires();
      }
    });
  }

  @override
  void didUpdateWidget(CountdownValorTimer oldWidget) {
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = new Duration(seconds: widget.secondsRemaining);
        _controller.dispose();
        _controller = new AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller.reverse(from: widget.secondsRemaining.toDouble());
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.whenTimeExpires();
          } else if (status == AnimationStatus.dismissed) {
            print("Animation Complete");
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (_, Widget child) {
          return Text(
            timerDisplayString,
            style: widget.countDownTimerStyle,
          );
        });
  }
}

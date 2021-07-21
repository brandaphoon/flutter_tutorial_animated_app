import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

///SingleTicker is for one animation.
class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  /// late modifier is used for non-nullable variable that is initialized after declaration.
  late AnimationController animController;
  late Animation<double> animation;

  ///Tweens are like modifiers for an animation. They can change its range or even output type

  @override
  void initState() {
    super.initState();

    ///Vsync: refreshing per second, animController is 0 to 1
    animController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    final curvedAnimation = CurvedAnimation(
        parent: animController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut
    );

    ///Tween will change the range of animation from 0 to 2 pi
    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).chain(CurveTween(curve: Curves.bounceIn))
        .animate(animController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DiceImage( animation: animation)
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}

///Stateful widget
///SetState is implicitly called by this widget
class DiceImage extends AnimatedWidget {

  DiceImage({
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    
    final animation = super.listenable as Animation<double>;

    return Scaffold(
        body: Transform.rotate(
            ///Changing animation value, upon changed value it will reload accordingly
            angle: animation.value,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(30),
              child: Image.asset('assets/dice.png'),
            )));
  }
}
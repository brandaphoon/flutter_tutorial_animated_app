import 'package:flutter/material.dart';

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
        reverseCurve: Curves.easeOut);

    ///Tween will change the range of animation from 0 to 2 pi
    animation = Tween<double>(begin: 0, end: 2).animate(curvedAnimation)
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
        body: FadeTransition(
      opacity: animation,
      child: DiceImage(),
    )
        //RotatingTransition(angle: animation, child: DiceImage(),)
        );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}

class RotatingTransition extends StatelessWidget {
  RotatingTransition({
    // Give the animation a better fitting name - we're animating the angle of rotation.
    required this.angle,
    required this.child,
  });

  final Widget child;
  final Animation<double> angle;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      // This child will be pre-built by the AnimatedBuilder for performance optimizations
      // since it won't be rebuilt on every "animation tick".
      child: child,
      builder: (context, child) {
        return Transform.rotate(
          angle: angle.value,
          child: child,
        );
      },
    );
  }
}

class DiceImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      child: Image.asset(
        'assets/dice.png',
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ? what is the differnece between import over package vs relative?
import '../../constants/image_strings.dart';
import '../../routing/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// ! This widget handles the decision between the login screen and the main screen
// it also fetches a first item from the web, if the user is logged in and there is internet

// TODO: Improvement: use go_router redirect to handle login logic
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // TODO remove this

    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.replaceNamed(AppRoute.now.name);
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Image(image: AssetImage(logo)),
        )
      ],
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

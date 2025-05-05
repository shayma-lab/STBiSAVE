import 'package:flutter/material.dart';
import 'package:my_first_project/services/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this)
        ..repeat(reverse: true);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        loadAndNavigate();
      }
    });
    _controller.forward();
  }

  void loadAndNavigate() async {
    try {
      Auth auth = Auth();
      bool isLoggedIn = await auth.autoLogin(context);
      if (!mounted) return;
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ScaleTransition(
        scale: _animation,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}

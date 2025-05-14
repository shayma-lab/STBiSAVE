import 'package:flutter/material.dart';
import 'package:my_first_project/models/user.dart';
import 'package:my_first_project/pages/admin/admin.dart';
import 'package:my_first_project/pages/client/tab_screen.dart';
import 'package:my_first_project/pages/home_page.dart';
import 'package:my_first_project/services/auth.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/SplashScreen";
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

  Auth auth = Auth();
  UserData user =
      UserData("", "", "", "", "", "", "", DateTime.now(), 0, UserRole.user, "");

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
      bool isLoggedIn = await auth.autoLogin(context);
      if (!mounted) return;
      if (isLoggedIn) {
        await fetchData();
        if (user.role == UserRole.admin) {
          Navigator.pushReplacementNamed(context, AdminPage.routeName);
        } else {
          Navigator.pushReplacementNamed(context, TabScreen.routeName);
        }
      } else {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> fetchData() async {
    final userData = await auth.userData();
    setState(() {
      user = userData;
    });
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
            child: Image.asset('assets/images/stb_bank.png'),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:paisamate/screens/home.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gotoTodo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedContainer(duration: Duration(seconds: 3),
        color: Colors.amber,
        width: 200.0,
        
          child: Text('PaisaMate',

          ),
        ),
        
      ),
    );
  }

  Future<void> gotoTodo() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) =>  ScreenHome()),
    );
  }
}
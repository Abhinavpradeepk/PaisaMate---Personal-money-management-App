
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C88FF),
        Color(0xFFFFFFFF),
              
            ]
          )
        ),
      
      
        
      
      
      
      
        
        child: Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      
      children: [
        Image.asset(
          'lib/assets/pngegg (22) 1.png',
          height: 150,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paisa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Text('Mate',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )
          ],
        ),
      ],
        ),
      )
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
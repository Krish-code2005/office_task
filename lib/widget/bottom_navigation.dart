import 'package:flutter/material.dart';


class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
         color: Color(0xFF1B1B1B),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(Icons.rocket, size: 30, color: Color(0xFFFF4400)),
                Text('Home', style: TextStyle(color: Color(0xFFFF4400)),)
              ],
            ),
            Column(
              children: [
                Icon(Icons.sms_outlined, size: 30, color: Colors.white70),
                Text('Home', style: TextStyle(color:  Colors.white70),)
              ],
            ),
             Column(
              children: [
                Icon(Icons.shopping_cart_outlined, size: 30, color: Colors.white70),
                Text('cart', style: TextStyle(color:  Colors.white70),)
              ],
            ),
             Column(
              children: [
                Icon(Icons.account_circle_outlined, size: 30, color: Colors.white70),
                Text('Account', style: TextStyle(color:  Colors.white70),)
              ],
            ),
          ],
        ),
    );
  }
}
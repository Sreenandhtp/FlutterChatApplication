import 'package:flutter/material.dart';
import 'package:mychatapp/pages/homepage.dart';
import 'setting_page.dart';
import 'update_page.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  List<Widget> bottomtabs = [
    const Updates(),
    const Homepage(),
    const Settings(),
  ];
  int indexnum = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: indexnum,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outlined), label: "Chats"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (int index) {
          setState(() {
            indexnum = index;
          });
        },
      ),
      body: Center(child: bottomtabs.elementAt(indexnum)),
    );
  }
}

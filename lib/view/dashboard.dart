import 'package:flutter/material.dart';
class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {

  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            color: const Color.fromARGB(255, 116, 12, 12),
          ),
          Expanded(
        child: Container(
          color: Colors.grey[200],
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.lightGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () {
                      // TODO: Add your logic here
                    },
                    tooltip: 'Portfolio',
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {
                      // TODO: Add your logic here
                    },
                    tooltip: 'Favorites',
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // TODO: Add your logic here
                    },
                    tooltip: 'Notifications',
                  ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      // TODO: Add your logic here
                    },
                    tooltip: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
    ));
  }
  }

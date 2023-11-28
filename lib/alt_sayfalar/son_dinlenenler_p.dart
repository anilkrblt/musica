import 'package:flutter/material.dart';

class SonDinlenenler extends StatefulWidget {
  const SonDinlenenler({super.key});

  @override
  State<SonDinlenenler> createState() => _SonDinlenenlerState();
}

class _SonDinlenenlerState extends State<SonDinlenenler> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Hello World'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search song',
                onPressed: () {
                 
                },
              ),
            ],

            
          ),

          
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class CalmaListesi extends StatefulWidget {
  const CalmaListesi({super.key});

  @override
  State<CalmaListesi> createState() => _CalmaListesiState();
}

class _CalmaListesiState extends State<CalmaListesi> {
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
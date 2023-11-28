import 'package:flutter/material.dart';

class TumSarkilarSayfasi extends StatefulWidget {
  const TumSarkilarSayfasi({super.key});

  @override
  State<TumSarkilarSayfasi> createState() => _TumSarkilarSayfasiState();
}

class _TumSarkilarSayfasiState extends State<TumSarkilarSayfasi> {
    final SearchController controller = SearchController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Şarkılarım'),
            actions: [
              SearchAnchor(
                  searchController: controller,
                  builder: (BuildContext context, SearchController controller) {
                    return IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        controller.openView();
                      },
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  }),
              Center(
                child: controller.text.isEmpty
                    ? const Text('No item selected')
                    : Text('Selected item: ${controller.value.text}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

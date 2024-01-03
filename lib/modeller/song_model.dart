class Song {
  final String title;
  final String description;
  // final String url;
  final String coverUrl;


  Song(
      {required this.title,
      required this.description,
      //required this.url,
      required this.coverUrl});
  static List<Song> songs = [
    Song(
      title: 'Pop',
      description: 'Pop',
      coverUrl: 'assets/image/Pop.jpg',

    ),
    Song(
      title: 'Rock',
      description: 'Rock',
      coverUrl: 'assets/image/Rock.jpg',

    ),
    Song(
      title: 'Jazz',
      description: 'Jazz',
      coverUrl: 'assets/image/jazz.jpg',

    ),
    Song(
      title: 'Rap',
      description: 'Rap',
      coverUrl: 'assets/image/Rap.jpg',

    ),
    Song(
      title: 'Country',
      description: 'Türkü',
      coverUrl: 'assets/image/Turku.jpg',

    ),
  ];
}

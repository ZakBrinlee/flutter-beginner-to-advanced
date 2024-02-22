import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ), // Wrap your app with ProviderScope
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const allFilms = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description: 'Description for The Shawshank Redemption',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'The Godfather',
    description: 'Description for The Godfather',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The Dark Knight',
    description: 'Description for The Dark Knight',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'The Godfather Part II',
    description: 'Description for The Godfather Part II',
    isFavorite: false,
  )
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void update(Film film, bool isFavorite) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? film.copyFilm(isFavorite: isFavorite)
            : thisFilm)
        .toList();
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

// Favorite status
final favoriteStatusProvider = StateProvider<FavoriteStatus>((_) {
  return FavoriteStatus.all;
});

// All films
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

// All Favorite Films
// Plain provider that filters the films based on the favorite status
final favoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => film.isFavorite,
      ),
);

// All Not Favorite Films
// Plain provider that filters the films based on the favorite status
final notFavoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where(
        (film) => !film.isFavorite,
      ),
);

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copyFilm({
    required bool isFavorite,
  }) =>
      Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() =>
      'Film(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hashAll([
        id,
        isFavorite,
      ]);
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Every time date changes, the widget will rebuild
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        // Consumer widgets allow for granular control of the rebuilds
        title: const Text('Films'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(builder: (context, ref, child) {
            final filter = ref.watch(favoriteStatusProvider);
            switch (filter) {
              case FavoriteStatus.all:
                return FilmsWidget(provider: allFilmsProvider);
              case FavoriteStatus.favorite:
                return FilmsWidget(provider: favoriteFilmsProvider);
              case FavoriteStatus.notFavorite:
                return FilmsWidget(provider: notFavoriteFilmsProvider);
            }
          })
        ],
      ),
    );
  }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsWidget({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    // Every time date changes, the widget will rebuild
    return Expanded(
      child: ListView.builder(
          itemCount: films.length,
          itemBuilder: (context, index) {
            final film = films.elementAt(index);
            return ListTile(
              title: Text(film.title),
              subtitle: Text(film.description),
              trailing: IconButton(
                icon: Icon(
                  film.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  final isFavorite = !film.isFavorite;
                  ref.read(allFilmsProvider.notifier).update(film, isFavorite);
                },
              ),
            );
          }),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return DropdownButton(
        value: ref.watch(favoriteStatusProvider),
        items: FavoriteStatus.values
            .map(
              (fs) => DropdownMenuItem(
                value: fs,
                child: Text(fs.toString().split('.').last),
              ),
            )
            .toList(),
        onChanged: (FavoriteStatus? fs) {
          // Does a syncronous read of the providers state controller and setting it's status
          ref.read(favoriteStatusProvider.notifier).state = fs!;
        },
      );
    });
  }
}

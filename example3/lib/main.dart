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

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> fetchWeather(City city) {
  // Imagine that this function is fetching the weather from the internet
  return Future.delayed(
    const Duration(
      seconds: 1,
    ),
    () => {
      City.stockholm: '🌧️',
      City.paris: '🌤️',
      City.tokyo: '🌪️',
    }[city]!,
  );
}

// Will be changed by the UI
// UI will write to this provider and Reads from
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '🤷';

// UI will read from this provider
final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      return fetchWeather(city);
    }
    return unknownWeatherEmoji;
  },
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    // Every time date changes, the widget will rebuild
    return Scaffold(
      appBar: AppBar(
        // Consumer widgets allow for granular control of the rebuilds
        title: const Text('Weather App'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (weather) => Text(
              weather,
              style: const TextStyle(fontSize: 60),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (context, index) {
                final city = City.values[index];
                final isSelected = city == ref.watch(currentCityProvider);
                return ListTile(
                  title: Text(city.toString()),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

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

const names = [
  'John',
  'Jane',
  'Doe',
  'Smith',
  'Brown',
  'Johnson',
  'Williams',
  'Jones',
  // ... and so on
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.future).asStream().map(
        (count) => names.getRange(
          0,
          count,
        ),
      ),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Every time date changes, the widget will rebuild
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        // Consumer widgets allow for granular control of the rebuilds
        title: const Text('StreamProvider Example'),
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) =>
            const Text('Error: Reached the end of the list'),
      ),
    );
  }
}

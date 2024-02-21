import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ), // Wrap your app with ProviderScope
  );
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

void testIt() {
  final int? int1 = 1;
  final int? int2 = null;
  final result = int1 + int2;
  print(result);
}

class CounterNotifier extends StateNotifier<int?> {
  CounterNotifier() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
  int? get value => state;
}

final counterProvider = StateNotifierProvider<CounterNotifier, int?>((ref) {
  return CounterNotifier();
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    testIt();
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

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Every time date changes, the widget will rebuild
    return Scaffold(
      appBar: AppBar(
        // Consumer widgets allow for granular control of the rebuilds
        title: Consumer(builder: (context, ref, child) {
          final count = ref.watch(counterProvider);
          final text = count == null ? 'Press the button' : 'counter: $count';
          return Text(text);
        }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            // if you call a void function inside another void function, you can add it like this
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text('Increment counter'),
          )
        ],
      ),
    );
  }
}

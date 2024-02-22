import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

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

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.name,
    required this.age,
    String? uuid,
  }) : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

  String get displayName => '$name ($age years old)';

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age, uuid: $uuid)';
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [
    Person(name: 'John', age: 30),
    Person(name: 'Jane', age: 25),
  ];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void addPerson(String name, int age) {
    _people.add(Person(name: name, age: age));
    notifyListeners();
  }

  void removePerson(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void updatePerson(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final prevPerson = _people[index];

    if (prevPerson.name != updatedPerson.name ||
        prevPerson.age != updatedPerson.age) {
      _people[index] = prevPerson.updated(
        updatedPerson.name,
        updatedPerson.age,
      );
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider(
  (_) => DataModel(),
);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Every time date changes, the widget will rebuild
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        // Consumer widgets allow for granular control of the rebuilds
        title: const Text('Example 5'),
      ),
      // Consumer for the body so the appbar is not rebuilt
      body: Consumer(
        builder: (context, ref, child) {
          final dataModel = ref.watch(peopleProvider);
          return ListView.builder(
            itemCount: dataModel.count,
            itemBuilder: (context, index) {
              final person = dataModel._people[index];
              return ListTile(
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    dataModel.removePerson(person);
                  },
                ),
                title: GestureDetector(
                  onTap: () async {
                    final updatedPerson = await createOrUpdatePersonDialog(
                      context,
                      person,
                    );
                    if (updatedPerson != null) {
                      dataModel.updatePerson(updatedPerson);
                    }
                  },
                  child: Text(person.displayName),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final person = await createOrUpdatePersonDialog(context, null);
          if (person != null) {
            final dataModel = ref.read(peopleProvider);
            dataModel.addPerson(person.name, person.age);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context,
  Person? existingPerson,
) async {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? '';
  ageController.text = age?.toString() ?? '';

  final result = await showDialog<Person>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(existingPerson == null ? 'Create Person' : 'Update Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: 'Enter name here...'),
              onChanged: (value) => name = value,
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Enter age here...'),
              keyboardType: TextInputType.number,
              onChanged: (value) => age = int.tryParse(value),
            ),
            Text(existingPerson?.toString() ?? 'no person')
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final age = int.tryParse(ageController.text);

              if (name.isNotEmpty && age != null) {
                if (existingPerson != null) {
                  // existing person, update it
                  final newPerson = existingPerson.updated(
                    name,
                    age,
                  );
                  Navigator.of(context).pop(
                    newPerson,
                  );
                } else {
                  // no existing person, create a new one
                  Navigator.of(context).pop(
                    Person(
                      name: name,
                      age: age,
                    ),
                  );
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(existingPerson == null ? 'Create' : 'Update'),
          ),
        ],
      );
    },
  );

  return result;
}

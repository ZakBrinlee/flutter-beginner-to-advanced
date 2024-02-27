extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
        this,
        (acc, value) => acc.replaceAll(
          value,
          '',
        ),
      );
}

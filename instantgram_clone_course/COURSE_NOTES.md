# [Notes]()

## Links
- [Riverpod family modifer](https://riverpod.dev/docs/concepts/modifiers/family)

## Top Notes
- Tappable areas on mobile should have a minimum height of 44px. 
  - Quote from course instructor
  - Mentioned it was stated and agreed upon by Material Design (Google) and Apple

- `<Provider>.family` is used to create a provider that can be used with a parameter
  - Example: `Provider.family((ref, id) => ...)`

- Take advantage of `typedef` typedefinitions to put a name to a value type
  - Example: `StateNotifier<bool> || typedef IsLoading = bool; StateNotifier<IsLoading>`

- Any DateTime values should **NOT** be created by the client device. This is because the client device could be manipulated to create a false date and time. 
  - Instead, use the server's date and time.
  - `FieldValue.serverTimestamp()`
  - [Related article](https://medium.com/firebase-developers/the-secrets-of-firestore-fieldvalue-servertimestamp-revealed-29dd7a38a82b)
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instantgram_clone_course/state/constants/firebase_collection_name.dart';
import 'package:instantgram_clone_course/state/constants/firebase_field_name.dart';
import 'package:instantgram_clone_course/state/user_info/models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required String userId,
    required String displayName,
    required String? email,
  }) async {
    try {
      // Check if we have user info from before
      final userInfo = await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .where(
            FirebaseFieldName.userId,
            isEqualTo: userId,
          )
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        // We already have the user profile, save the new data instead
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }

      // We don't have user info from before, create new user
      final payload = UserInfoPayload(
        userId: userId,
        displayName: displayName,
        email: email,
      );

      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .add(payload);

      return true;
    } catch (e) {
      log('saveUserInfo error: ${e.toString()}');
      return false;
    }
  }
}

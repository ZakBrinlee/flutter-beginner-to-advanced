import 'package:flutter/foundation.dart' show immutable;
import 'package:instantgram_clone_course/views/components/dialogs/alert_dialog_model.dart';
import 'package:instantgram_clone_course/views/components/constants/strings.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({required String titleOfObjectToDelete})
      : super(
          title: '${Strings.delete} $titleOfObjectToDelete?',
          message:
              '${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectToDelete?',
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}

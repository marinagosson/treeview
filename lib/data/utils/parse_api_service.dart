import 'package:treeview_tractian/data/utils/app_errors.dart';

String? parseString(Map<String, dynamic> json, String key, String source) {
  try {
    if (json[key] == null) return null;
    if (json[key] is! String) {
      throw AppError(
          '\n=== Parsing error ===\n$source -> Formato inválido para "$key", o que veio: ${json[key]}.\nFormato esperado é do tipo String.\n=======================\n');
    }
    return json[key];
  } catch (e) {
    throw AppError('Error no parseString "$key"\n$e');
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/data/database/database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

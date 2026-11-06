import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class BusinessExpensesService {
  final AppDatabase _db;
  BusinessExpensesService(this._db);

  static BusinessExpense fromRow(BusinessExpense row) {
    return BusinessExpense(
      id: row.id,
      remoteId: row.remoteId,
      title: row.title,
      amount: row.amount,
      date: row.date,
      category: row.category,
      vendorName: row.vendorName,
      notes: row.notes,
      createdAt: row.createdAt,
      lastUpdated: row.lastUpdated,
      isActive: row.isActive,
    );
  }

  Future<Result<List<BusinessExpense>>> getExpensesPaginated(
    int page,
    int limit,
    SortType sortType,
  ) async {
    try {
      var query = _db.select(_db.businessExpenses);
      switch (sortType) {
        case SortType.nameAsc:
          query = query
            ..orderBy([(e) => OrderingTerm(expression: e.title)])
            ..limit(limit, offset: page * limit);
        case SortType.nameDesc:
          query = query
            ..orderBy([
              (e) => OrderingTerm(expression: e.title, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.newest:
          query = query
            ..orderBy([
              (e) => OrderingTerm(
                expression: e.createdAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.oldest:
          query = query
            ..orderBy([(e) => OrderingTerm(expression: e.createdAt)])
            ..limit(limit, offset: page * limit);
        case SortType.priceAsc:
          query = query
            ..orderBy([(e) => OrderingTerm(expression: e.amount)])
            ..limit(limit, offset: page * limit);
        case SortType.priceDesc:
          query = query
            ..orderBy([
              (e) =>
                  OrderingTerm(expression: e.amount, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: page * limit);
        default:
          query = query
            ..orderBy([
              (e) => OrderingTerm(
                expression: e.createdAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(limit, offset: page * limit);
      }
      final rows = await query.get();
      return Success(rows.map((r) => fromRow(r)).toList());
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred fetching products: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<BusinessExpense>> insertExpense(BusinessExpense expense) async {
    try {
      final companion = expense
          .toCompanion(true)
          .copyWith(
            id: Value.absent(),
            remoteId: Value(uuid.v4()),
            createdAt: Value(DateTime.now()),
          );

      final generatedId = await _db
          .into(_db.businessExpenses)
          .insert(companion);
      final savedExpense = expense.copyWith(id: generatedId);
      print(savedExpense);

      return Success(savedExpense);
    } catch (e) {
      return Error(
        AppFailure.database("An unexpected error occurred saving expense: $e"),
      );
    }
  }

  Future<Result<BusinessExpense>> updateExpense(BusinessExpense expense) async {
    try {
      final updatedExpense = expense.copyWith(
        lastUpdated: Value(DateTime.now()),
      );
      await (_db.update(
        _db.businessExpenses,
      )..where((e) => e.remoteId.equals(expense.remoteId))).write(
        BusinessExpensesCompanion(
          title: Value(updatedExpense.title),
          amount: Value(updatedExpense.amount),
          date: Value(updatedExpense.date),
          category: Value(updatedExpense.category),
          vendorName: Value(updatedExpense.vendorName),
          notes: Value(updatedExpense.notes),
          createdAt: Value(updatedExpense.createdAt),
          lastUpdated: Value(updatedExpense.lastUpdated),
        ),
      );
      return Success(updatedExpense);
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred updating expense: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<void>> deleteExpense(BusinessExpense expense) async {
    try {
      await (_db.update(_db.businessExpenses)
            ..where((e) => e.remoteId.equals(expense.remoteId)))
          .write(BusinessExpensesCompanion(isActive: Value(false)));
      return Success(null);
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred archiving expense: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<void>> forceDeleteExpense(BusinessExpense expense) async {
    try {
      await (_db.delete(
        _db.businessExpenses,
      )..where((e) => e.remoteId.equals(expense.remoteId))).go();
      return Success(null);
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred deleting expense: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<double> getTotalExpenses() async {
    final amountSum = _db.businessExpenses.amount.sum();

    final query = _db.selectOnly(_db.businessExpenses)..addColumns([amountSum]);

    final result = await query.map((row) => row.read(amountSum)).getSingle();

    return result ?? 0.0;
  }

  Future<BusinessExpense?> getExpenseByRemoteId(BusinessExpense expense) async {
    try {
      final row = await (_db.select(
        _db.businessExpenses,
      )..where((e) => e.remoteId.equals(expense.remoteId))).getSingleOrNull();
      if (row == null) return null;
      return fromRow(row);
    } catch (e) {
      debugPrint(
        'Warning: Failed to find expense by remoteId ${expense.remoteId}: $e',
      );
      return null;
    }
  }
}

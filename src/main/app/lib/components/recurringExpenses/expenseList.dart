import 'dart:math';

import 'package:spend_spent_spent/components/recurringExpenses/addExpense.dart';
import 'package:spend_spent_spent/components/recurringExpenses/expense.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/recurringExpense.dart';
import 'package:flutter/cupertino.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class ExpenseList extends StatelessWidget {
  List<RecurringExpense> expenses, daily = [], weekly = [], monthly = [], yearly = [];
  Function refreshExpenses;

  ExpenseList({required this.expenses, required this.refreshExpenses}) {
    splitExpenses(this.expenses);
  }

  void splitExpenses(List<RecurringExpense> expenses) {
    expenses.forEach((e) {
      switch (e.type) {
        case 0:
          daily.add(e);
          return;
        case 1:
          weekly.add(e);
          return;
        case 2:
          monthly.add(e);
          return;
        case 3:
          yearly.add(e);
          return;
      }
    });
    print(' total: ${expenses.length} daily: ${daily.length}, weekly: ${weekly.length}, monthly: ${monthly.length}, yearly: ${yearly.length}');
  }

  List<Widget> expensesFromSplit(AppColors colors, List<RecurringExpense> expenses, String title) {
    List<Widget> results = [];

    if (expenses.length > 0) {
      results.add(Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: TextStyle(color: colors.main),
          ),
        ),
      ));

      List<Widget> expensesWidget = [];
      expenses.forEach((e) {
        expensesWidget.add(Expense(
          key: Key(e.id.toString()),
          expense: e,
          refreshExpenses: refreshExpenses,
        ));
      });

      results.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Wrap(runSpacing: 10, spacing: 10, alignment: WrapAlignment.center, children: expensesWidget),
      ));

      double total = expenses.map((e) => e.amount).reduce((value, element) => value + element);

      results.add(Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total: '),
            Text(
              '${formatCurrency(total)}',
              style: TextStyle(color: colors.main),
            )
          ],
        ),
      ));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    List<Widget> children = [];

    children.addAll(expensesFromSplit(colors, this.daily, 'Daily'));
    children.addAll(expensesFromSplit(colors, this.weekly, 'Weekly'));
    children.addAll(expensesFromSplit(colors, this.monthly, 'Monthly'));
    children.addAll(expensesFromSplit(colors, this.yearly, 'Yearly'));

    children.add(AddExpense(
      refreshExpenses: refreshExpenses,
    ));

    return ListView(
      children: children,
    );
  }
}

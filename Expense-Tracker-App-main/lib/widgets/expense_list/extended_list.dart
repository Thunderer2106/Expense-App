import 'package:expense_tracker/widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';


class ExtendedList extends StatelessWidget {
  const ExtendedList(this.expenses, this.removeExp, {Key? key})
      : super(key: key);
  final List<Expense> expenses;
  final void Function(Expense expense) removeExp;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expenses.length, itemBuilder: (ctx, ind) =>
        Dismissible(
          key: ValueKey(expenses[ind]),
          onDismissed: (direction) {
            removeExp(expenses[ind]);
          },
          child: ExpenseItem(expenses[ind]),));
  }
}

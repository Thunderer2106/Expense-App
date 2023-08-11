import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_list/extended_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expPre = [
    Expense(
        category: Category.food,
        title: "Hotel",
        date: DateTime.now(),
        amount: 100.00),
    Expense(
        category: Category.work,
        title: "Work",
        date: DateTime.now(),
        amount: 1500.00)
  ];

  void _openOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(_addNewExpense));
  }

  void _addNewExpense(Expense expense) {
    setState(() {
      _expPre.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expInd = _expPre.indexOf(expense);

    setState(() {
      _expPre.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Expense Deleted"),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          setState(() {
            _expPre.insert(expInd, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent=const Center( child: Text("No Expenses added",));
    if(_expPre.isNotEmpty){
      mainContent=Column(
        children: [
          Chart(expenses: _expPre),
          Expanded(child: ExtendedList(_expPre, _removeExpense)),
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: mainContent,
    );
  }
}

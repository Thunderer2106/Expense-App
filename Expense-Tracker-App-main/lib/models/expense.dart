import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid=Uuid();
final formatter=DateFormat.yMd();

enum Category {work,leisure,food,travel}

final catIcons={
  Category.food: Icons.lunch_dining,
  Category.work: Icons.work,
  Category.leisure:Icons.movie,
  Category.travel:Icons.flight_takeoff
};

class Expense {

  Expense({required this.category,required this.title, required this.date, required this.amount}):id=uuid.v4();

  final String title;
  final String id;
  final DateTime date;
  final double amount;
  final Category category;

  String get formatDate{
    return formatter.format(date);
  }

}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
      .where((expense) => expense.category == category)
      .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
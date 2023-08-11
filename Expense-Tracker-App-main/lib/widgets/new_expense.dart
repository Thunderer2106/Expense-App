import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense(this.addNewExpense,{Key? key}) : super(key: key);
  final Function(Expense expense)addNewExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleControl = TextEditingController();
  final _amtControl = TextEditingController();
  DateTime? _selectedDate;
   Category _selected=Category.leisure;
  @override
  void dispose() {
    _titleControl.dispose();
    _amtControl.dispose();
    super.dispose();
  }

  void _openDatePicker() async {
    final date = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(date.year - 1, date.month, date.day),
        lastDate: date);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _onSubmitNew(){
    final selectedAmt=double.tryParse(_amtControl.text);
    final isValidAmt=selectedAmt==null||selectedAmt<=0;
    if(isValidAmt||_titleControl.text.trim().isEmpty||_selectedDate==null){
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: const Text("Invalid Input"),
        content: const Text("Enter valid input and fill all the boxes"),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: const Text("Okay"))
        ],
      ));
      return;
    }
    final exp=Expense(category: _selected, title: _titleControl.text, date:_selectedDate!, amount: selectedAmt);
    widget.addNewExpense(exp);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleControl,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Title"),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amtControl,
                  decoration: const InputDecoration(
                    label: Text("Amount"),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_selectedDate == null
                      ? "No Date Selected"
                      : formatter.format(_selectedDate!)),
                  IconButton(
                      onPressed: _openDatePicker,
                      icon: const Icon(Icons.calendar_month))
                ],
              ))
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              DropdownButton(
                value: _selected,
                  items: Category.values.map(
                    (cat) => DropdownMenuItem(value:cat ,

                      child: Text(
                        cat.name.toUpperCase(),
                      ),
                    ),
                  ).toList(),
                  onChanged: (value) {
                  if(value==null)return;
                  setState(() {
                    _selected=value;
                  });
                  }),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(onPressed: _onSubmitNew, child: const Text("Submit"))
            ],
          )
        ],
      ),
    );
  }
}

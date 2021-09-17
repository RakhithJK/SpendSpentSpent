import 'package:after_layout/after_layout.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_spent_spent/components/dummies/dummyExpenses.dart';
import 'package:spend_spent_spent/components/rightColumn/oneDay.dart';
import 'package:spend_spent_spent/globals.dart';
import 'package:spend_spent_spent/models/appColors.dart';
import 'package:spend_spent_spent/models/dayExpense.dart';
import 'package:spend_spent_spent/utils/colorUtils.dart';

class RightColumn extends StatefulWidget {
  RightColumnState createState() => RightColumnState();
}

class RightColumnState extends State<RightColumn> with AfterLayoutMixin {
  List<String> months = [];
  String selected = '';
  Map<String, DayExpense> expenses = {};
  double total = 0;
  Widget expensesWidget = DummyExpenses();

  void getMonths() async {
    List<String> months = await service.getExpensesMonths();
    String now = DateFormat("yyyy-MM").format(DateTime.now());
    int nowIndex = months.indexWhere((element) => element == now);
    if (this.mounted) {
      setState(() {
        this.months = months;
        if (months.length > 0 && selected == '' && nowIndex != -1) {
          selected = months[nowIndex];
        } else if (months.length > 0 && selected == '') {
          selected = months[months.length - 1];
        }
        getExpenses();
      });
    }
  }

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);
    super.dispose();
  }

  void monthChanged(value) {
    if (this.mounted) {
      setState(() {
        selected = value ?? '';
        getExpenses();
      });
    }
  }

  String convertDate(String date) {
    return DateFormat('MMMM yyyy').format(DateFormat('yyyy-MM-dd').parse('$date-01'));
  }

  getExpenses() async {
    setState(() {
      expensesWidget = DummyExpenses();
    });
    var expenses = await service.getMonthExpenses(selected);
    var total = expenses.values.map((e) => e.total).reduce((value, element) => value + element);
    if (this.mounted) {
      setState(() {
        this.expenses = expenses;
        this.total = total;
        expensesWidget = getExpensesWidget();
      });
    }
  }

  Widget getExpensesWidget() {
    List<String> expensesKeys = expenses.keys.toList();
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return OneDay(expense: expenses[expensesKeys[index]]!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppColors colors = get(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              gradient: defaultGradient(context),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: DropdownButton<String>(
                      value: selected,
                      items: months
                          .map((e) => DropdownMenuItem(
                                child: Text(convertDate(e), style: TextStyle(color: colors.textOnMain),),
                                value: e,
                              ))
                          .toList(),
                      style: TextStyle(color: colors.textOnMain),
                      isExpanded: true,
                      iconEnabledColor: colors.textOnMain,
                      underline: SizedBox.shrink(),
                      isDense: true,
                      dropdownColor: colors.main,
                      onChanged: monthChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Total:', style: TextStyle(color: colors.text)),
                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatCurrency(total),
                          style: TextStyle(color: colors.main),
                        ))),
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(duration: panelTransition, child: expensesWidget),
          )
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getMonths();
    FBroadcast.instance().register(BROADCAST_REFRESH_EXPENSES, (context, somethingElse) => getExpenses());
  }
}

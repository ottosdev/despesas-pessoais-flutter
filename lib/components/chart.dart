import 'package:expenses/components/char_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart({super.key, required this.recentTransaction});

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final letterDayWeek = DateFormat.E().format(weekDay)[0];

      double totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      return {
        'day': letterDayWeek,
        'value': totalSum,
      };
    }).reversed.toList();
  }

  double get _weekTotalValuePercent {
    return groupedTransactions.fold(0.0, (sum, tr) {
      double total = tr['value'] as double;
      return sum + total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map(
            (e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    label: e['day'] as String,
                    value: e['value'] as double,
                    percentage:_weekTotalValuePercent == 0 ? 0 : (e['value'] as double) / _weekTotalValuePercent),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}

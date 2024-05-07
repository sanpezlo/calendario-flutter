import 'package:calendario_flutter/components/app_colors.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const CustomDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      headingRowColor:
          MaterialStateColor.resolveWith((states) => AppColor.primary),
      headingTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
        color: AppColor.white,
      ),
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      dataTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'Inter',
        color: AppColor.text,
      ),
      dividerThickness: 1,
      columns: columns,
      rows: rows,
    );
  }
}

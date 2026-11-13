import 'package:home_widget_generator/home_widget_generator.dart';

@HomeWidget(
  name: 'ExpenseSummaryWidget',
  android: HomeWidgetAndroidConfiguration(),
  widget: HWColumn(
    crossAxisAlignment: HWCrossAxisAlignment.start,
    mainAxisAlignment: HWMainAxisAlignment.center,
    children: [
      HWText.fixed(
        'Monthly Expenses',
        style: HWRoleTextStyle(role: HWTextStyleRole.caption),
      ),
      HWText(
        HWString('monthlyTotal', defaultValue: '\$0.00'),
        style: HWRoleTextStyle(
          role: HWTextStyleRole.title,
          fontWeight: HWFontWeight.bold,
        ),
      ),
    ],
  ),
)
class ExpenseSummaryWidgetSchema {}

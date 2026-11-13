// dart format off
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:home_widget/home_widget.dart';

class ExpenseSummaryWidgetSchemaHomeWidget {
  const ExpenseSummaryWidgetSchemaHomeWidget._();

  static const String _$paramPrefix = 'home_widget.ExpenseSummaryWidgetSchema';

  static Future<void> saveData({
    String? monthlyTotal,
  }) {
    return Future.wait([
      if (monthlyTotal != null) HomeWidget.saveWidgetData<String>('${_$paramPrefix}.monthlyTotal', monthlyTotal),
    ]);
  }

  static Future<void> deleteData({
    bool monthlyTotal = false,
  }) {
    return Future.wait([
      if (monthlyTotal) HomeWidget.saveWidgetData('${_$paramPrefix}.monthlyTotal', null),
    ]);
  }

  static Future<({String? monthlyTotal})> getData() async {
    return (
      monthlyTotal: await HomeWidget.getWidgetData<String>('${_$paramPrefix}.monthlyTotal', defaultValue: '\$0.00'),
    );
  }


  static Future<bool?> updateWidget() {
    return HomeWidget.updateWidget(
      androidName: 'ExpenseSummaryWidgetSchemaHomeWidgetReceiver',
    );
  }

  /// Asks the launcher to re-render this widget's gallery preview.
  ///
  /// Android 15 and newer only; returns false elsewhere and when the system
  /// rate limit (about two updates per hour and widget) was hit. The plugin
  /// registers the preview automatically when the app starts, so this is only
  /// needed after data changes that should show in the gallery right away.
  static Future<bool> updatePreview() async {
    return await HomeWidget.updateWidgetPreview(
      androidName: 'ExpenseSummaryWidgetSchemaHomeWidgetReceiver',
    ) ?? false;
  }

  /// Whether the launcher lets the app ask to add this widget to the home
  /// screen: Android 8 or newer with a launcher that supports pinning. Always
  /// false on iOS.
  static Future<bool> isRequestPinWidgetSupported() async {
    return await HomeWidget.isRequestPinWidgetSupported() ?? false;
  }

  /// Asks the launcher to add this widget to the home screen.
  ///
  /// Shows the system pin dialog where [isRequestPinWidgetSupported] is true
  /// and does nothing anywhere else.
  static Future<void> requestPinWidget() {
    return HomeWidget.requestPinWidget(
      androidName: 'ExpenseSummaryWidgetSchemaHomeWidgetReceiver',
    );
  }

  /// Every instance of this widget currently placed on a home screen.
  ///
  /// Android reports one entry per placed instance, iOS one entry per family
  /// the widget is placed in.
  static Future<List<HomeWidgetInfo>> getInstalledWidgets() async {
    final widgets = await HomeWidget.getInstalledWidgets();
    return widgets.where(_$isThisWidget).toList();
  }

  /// Whether at least one instance of this widget is on a home screen.
  static Future<bool> isInstalled() async {
    return (await getInstalledWidgets()).isNotEmpty;
  }

  /// Whether [info] describes this widget.
  ///
  /// Android reports the provider's short class name — `.Receiver` when it
  /// lives in the package of the application id, and the qualified name
  /// otherwise — which is why the suffix is matched.
  static bool _$isThisWidget(HomeWidgetInfo info) {
    final androidClassName = info.androidClassName;
    if (androidClassName != null) {
      return androidClassName.endsWith('.ExpenseSummaryWidgetSchemaHomeWidgetReceiver');
    }
    return false;
  }
}

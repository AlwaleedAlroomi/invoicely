// GENERATED CODE - DO NOT MODIFY BY HAND
package com.example.invoicely

import android.content.Context
import es.antonborri.home_widget.HomeWidgetGlanceWidgetReceiver

class ExpenseSummaryWidgetSchemaHomeWidgetReceiver : HomeWidgetGlanceWidgetReceiver<ExpenseSummaryWidgetSchemaHomeWidget>() {
  override val glanceAppWidget = ExpenseSummaryWidgetSchemaHomeWidget()

  override fun previewFingerprint(context: Context): String =
      glanceAppWidget.previewFingerprint(context)
}

package com.example.invoicely

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import androidx.core.net.toUri

/** Implementation of App Widget functionality. */
class NewInvoice : HomeWidgetProvider() {
    override fun onUpdate(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetIds: IntArray,
            widgetData: SharedPreferences
    ) {
        // There may be multiple widgets active, so update all of them
        appWidgetIds.forEach { appWidgetId ->
            updateAppWidget(context, appWidgetManager, appWidgetId, widgetData)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

internal fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        widgetData: SharedPreferences
) {
    val views =
            RemoteViews(context.packageName, R.layout.new_invoice).apply {
                val pending = widgetData.getString("pending_count", "0")?.toIntOrNull() ?: 0
                setTextViewText(R.id.widget_pending_count, "$pending pending")

                val newInvoiceIntent =
                        HomeWidgetLaunchIntent.getActivity(
                                context,
                                MainActivity::class.java,
                            "myapp://invoice/new".toUri()
                        )
                setOnClickPendingIntent(R.id.btn_new_invoice, newInvoiceIntent)
            }
    appWidgetManager.updateAppWidget(appWidgetId, views)
}

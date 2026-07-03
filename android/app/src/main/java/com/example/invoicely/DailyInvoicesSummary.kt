package com.example.invoicely

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.graphics.Color
import android.widget.RemoteViews
import android.os.Build

/**
 * Implementation of App Widget functionality.
 */
class DailyInvoicesSummary : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
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
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.daily_invoices_summary)

    val configIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
    val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    }else{
        PendingIntent.FLAG_UPDATE_CURRENT
    }

    val pendingIntent = PendingIntent.getActivity(context,0,configIntent,flag)
    views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

    // 1. Access the SharedPreferences created by the Flutter 'home_widget' package
    val prefs: SharedPreferences = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

    // 2. Fetch the values sent from Flutter (falling back to placeholder zeros)
    val revenue = prefs.getString("revenue", "$0") ?: "$0"
    val pending = prefs.getString("pending_count", "0") ?: "0"
    val clients = prefs.getString("clients_count", "0") ?: "0"
    val lowStock = prefs.getString("low_stock_count", "0") ?: "0"

    // 3. Bind the fetched string values to your actual XML layout views
    views.setTextViewText(R.id.val_revenue, revenue)
    views.setTextViewText(R.id.val_pending, pending)
    views.setTextViewText(R.id.val_clients, clients)
    views.setTextViewText(R.id.val_low_stock, lowStock)

    // 4. Mimic your dynamic Flutter UI text color logic for low stock
    try {
        val lowStockInt = lowStock.toInt()
        if (lowStockInt > 0) {
            views.setTextColor(R.id.val_low_stock, Color.RED)
        } else {
            views.setTextColor(R.id.val_low_stock, Color.GRAY)
        }
    } catch (e: NumberFormatException) {
        views.setTextColor(R.id.val_low_stock, Color.GRAY)
        print(e)
    }

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}
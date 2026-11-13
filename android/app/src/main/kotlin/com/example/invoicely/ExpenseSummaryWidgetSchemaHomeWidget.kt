// GENERATED CODE - DO NOT MODIFY BY HAND
//
// This is a placeholder Glance (Jetpack Compose) widget.
package com.example.invoicely

import androidx.compose.runtime.Composable
import android.content.Context
import androidx.compose.ui.graphics.Color
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Box
import androidx.glance.layout.fillMaxSize
import androidx.glance.text.Text
import es.antonborri.home_widget.HomeWidgetGlanceState
import es.antonborri.home_widget.HomeWidgetGlanceStateDefinition
import es.antonborri.home_widget.HomeWidgetPlugin
import androidx.glance.layout.Column
import androidx.glance.layout.Alignment
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxHeight
import androidx.glance.text.TextStyle
import androidx.glance.GlanceTheme
import androidx.compose.ui.unit.sp
import androidx.glance.text.FontWeight
import androidx.core.os.ConfigurationCompat
import java.util.Locale
import androidx.glance.color.ColorProvider
import androidx.compose.ui.unit.dp
import androidx.glance.layout.padding
import androidx.glance.action.clickable
import androidx.glance.action.actionStartActivity

class ExpenseSummaryWidgetSchemaHomeWidget : GlanceAppWidget() {
  override val stateDefinition = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent { WidgetContent(context, currentState()) }
  }

  override suspend fun providePreview(context: Context, widgetCategory: Int) {
    provideContent { WidgetContent(context, HomeWidgetGlanceState(HomeWidgetPlugin.getData(context))) }
  }

  fun previewFingerprint(context: Context): String {
    val hwLocales = hwCurrentLocales(context)
    val hwPreviewData =
        ExpenseSummaryWidgetSchemaData.fromPreferences(HomeWidgetPlugin.getData(context))
    return listOf(
      "dba65f33",
      hwLocales.joinToString(","),
      hwPreviewData.toString(),
    ).joinToString("|")
  }

  @Composable
  private fun WidgetContent(context: Context, currentState: HomeWidgetGlanceState) {
    val prefs = currentState.preferences
    val widgetData = ExpenseSummaryWidgetSchemaData.fromPreferences(prefs)
    GlanceTheme {
            Box(modifier = GlanceModifier.background(GlanceTheme.colors.widgetBackground).padding(16.dp).fillMaxSize().clickable(onClick = actionStartActivity<MainActivity>()), contentAlignment = Alignment.Center) {
                Column(modifier = GlanceModifier.fillMaxHeight(), horizontalAlignment = Alignment.Start) {
                    Spacer(modifier = GlanceModifier.defaultWeight())
                    Text(text = "Monthly Expenses", style = TextStyle(color = GlanceTheme.colors.onSurface, fontSize = 12.sp, fontWeight = FontWeight.Normal))
                    Text(text = widgetData.monthlyTotal ?: "", style = TextStyle(color = GlanceTheme.colors.onSurface, fontSize = 22.sp, fontWeight = FontWeight.Bold))
                    Spacer(modifier = GlanceModifier.defaultWeight())
                }
            }
    }

  }
}

data class ExpenseSummaryWidgetSchemaData(
    val monthlyTotal: String? = null,
) {
    companion object {
        private const val PREFERENCES_PREFIX = "home_widget.ExpenseSummaryWidgetSchema"

        fun fromPreferences(prefs: android.content.SharedPreferences): ExpenseSummaryWidgetSchemaData {
            return ExpenseSummaryWidgetSchemaData(
                monthlyTotal = prefs.getString("${PREFERENCES_PREFIX}.monthlyTotal", "\$0.00"),
            )
        }
    }
}


private fun hwCurrentLocales(context: Context): List<String> {
    val configured = ConfigurationCompat
        .getLocales(context.resources.configuration)
    val tags = mutableListOf<String>()
    for (index in 0 until configured.size()) {
        val locale = configured[index] ?: continue
        val tag = locale.toLanguageTag()
        if (tag.isNotEmpty() && tag != "und") tags.add(tag)
    }
    if (tags.isEmpty()) {
        val fallback = Locale.getDefault().toLanguageTag()
        if (fallback.isNotEmpty() && fallback != "und") tags.add(fallback)
    }
    return tags
}

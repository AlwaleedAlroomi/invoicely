import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePDFService {
  Future<String?> savePDF(pw.Document pdf, String fileName) async {
    final selectedDir = await FilePicker.getDirectoryPath(
      dialogTitle: 'Save Invoice PDF',
    );

    if (selectedDir == null) return null;
    final filePath = '$selectedDir/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }

  Future<pw.Document> generateInvoicePDF(InvoiceModel invoice) async {
    final pdf = pw.Document();
    final client = invoice.client.value;

    // colors
    const primaryColor = PdfColor.fromInt(0xFF1A1A2E);
    const accentColor = PdfColor.fromInt(0xFF4F46E5);
    const lightGrey = PdfColor.fromInt(0xFFF8F9FA);
    const borderColor = PdfColor.fromInt(0xFFE5E7EB);
    const textGrey = PdfColor.fromInt(0xFF6B7280);

    String formatDate(DateTime date) => DateFormat.yMMMd('en_US').format(date);

    String formatCurrency(double amount) => '\$${amount.toStringAsFixed(2)}';

    // status color
    PdfColor statusColor() {
      switch (invoice.status) {
        case InvoiceStatus.paid:
          return PdfColors.green700;
        case InvoiceStatus.overdue:
          return PdfColors.red700;
        case InvoiceStatus.sent:
          return PdfColors.blue700;
        case InvoiceStatus.cancelled:
          return PdfColors.orange700;
        default:
          return PdfColors.grey700;
      }
    }

    // ── HEADER ────────────────────────────────────────
    pw.Widget buildHeader(pw.Context context) {
      return pw.Container(
        decoration: const pw.BoxDecoration(color: primaryColor),
        padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // company / app name
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Invoicely',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Professional Invoice',
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),

            // invoice number + status + QR
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // invoice number + status
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          invoice.invoiceNumber,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: pw.BoxDecoration(
                            color: statusColor(),
                            borderRadius: const pw.BorderRadius.all(
                              pw.Radius.circular(4),
                            ),
                          ),
                          child: pw.Text(
                            invoice.status.name.toUpperCase(),
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(width: 16),

                    // QR code
                    pw.Container(
                      height: 60,
                      width: 60,
                      padding: const pw.EdgeInsets.all(4),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.all(
                          pw.Radius.circular(4),
                        ),
                      ),
                      child: pw.BarcodeWidget(
                        data: invoice.invoiceNumber,
                        barcode: pw.Barcode.qrCode(),
                        color: primaryColor,
                        drawText: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    // ── FOOTER ────────────────────────────────────────
    pw.Widget buildFooter(pw.Context context) {
      return pw.Container(
        decoration: const pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: borderColor)),
        ),
        padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated by Invoicely',
              style: const pw.TextStyle(fontSize: 8, color: textGrey),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: textGrey),
            ),
          ],
        ),
      );
    }

    // ── BILL TO + INVOICE INFO ────────────────────────
    pw.Widget buildMetaSection() {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // bill to
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'BILL TO',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: textGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    client?.name ?? 'N/A',
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  if (client?.email != null)
                    pw.Text(
                      client!.email,
                      style: const pw.TextStyle(fontSize: 10, color: textGrey),
                    ),
                  if (client?.phone != null)
                    pw.Text(
                      client!.phone!,
                      style: const pw.TextStyle(fontSize: 10, color: textGrey),
                    ),
                  pw.SizedBox(height: 4),
                  if (client?.addressLine1 != null)
                    pw.Text(
                      client!.addressLine1!,
                      style: const pw.TextStyle(fontSize: 10, color: textGrey),
                    ),
                  if (client?.addressLine2 != null)
                    pw.Text(
                      client!.addressLine2!,
                      style: const pw.TextStyle(fontSize: 10, color: textGrey),
                    ),
                  pw.Text(
                    [
                      client?.city,
                      client?.state,
                      client?.zipCode,
                    ].whereType<String>().join(', '),
                    style: const pw.TextStyle(fontSize: 10, color: textGrey),
                  ),
                  if (client?.country != null)
                    pw.Text(
                      client!.country!,
                      style: const pw.TextStyle(fontSize: 10, color: textGrey),
                    ),
                ],
              ),
            ),

            // invoice details
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  _metaRow(
                    'Issue Date',
                    formatDate(invoice.issueDate),
                    primaryColor,
                    textGrey,
                  ),
                  pw.SizedBox(height: 6),
                  _metaRow(
                    'Due Date',
                    formatDate(invoice.dueDate),
                    primaryColor,
                    textGrey,
                  ),
                  if (invoice.terms != null) ...[
                    pw.SizedBox(height: 6),
                    _metaRow('Terms', invoice.terms!, primaryColor, textGrey),
                  ],
                  if (client?.taxNumber != null) ...[
                    pw.SizedBox(height: 6),
                    _metaRow(
                      'Tax Number',
                      client!.taxNumber!,
                      primaryColor,
                      textGrey,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── ITEMS TABLE ───────────────────────────────────
    pw.Widget buildItemsTable() {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 40),
        child: pw.Column(
          children: [
            // table header
            pw.Container(
              decoration: const pw.BoxDecoration(color: accentColor),
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Text(
                      'ITEM',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'QTY',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'UNIT PRICE',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'TOTAL',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // table rows
            ...invoice.items.asMap().entries.map((entry) {
              final isEven = entry.key.isEven;
              final item = entry.value;
              return pw.Container(
                decoration: pw.BoxDecoration(
                  color: isEven ? lightGrey : PdfColors.white,
                ),
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        item.productName,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        '${item.quantity}',
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: textGrey,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        formatCurrency(item.unitPrice),
                        textAlign: pw.TextAlign.right,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: textGrey,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        formatCurrency(item.total),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    // ── TOTALS ────────────────────────────────────────
    pw.Widget buildTotals() {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 40),
        child: pw.Row(
          children: [
            // notes
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (invoice.notes != null) ...[
                    pw.Text(
                      'NOTES',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: textGrey,
                        letterSpacing: 1.5,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      invoice.notes!,
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: textGrey,
                        lineSpacing: 2,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // totals box
            pw.Expanded(
              flex: 1,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  color: lightGrey,
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                ),
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  children: [
                    _totalRow(
                      'Subtotal',
                      formatCurrency(invoice.subTotal),
                      textGrey,
                      false,
                    ),
                    pw.SizedBox(height: 6),
                    _totalRow(
                      'Tax (${invoice.taxRate.toStringAsFixed(0)}%)',
                      formatCurrency(invoice.taxAmount),
                      textGrey,
                      false,
                    ),
                    pw.Container(
                      margin: const pw.EdgeInsets.symmetric(vertical: 8),
                      height: 1,
                      color: borderColor,
                    ),
                    _totalRow(
                      'Total',
                      formatCurrency(invoice.totalAmount),
                      accentColor,
                      true,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── TERMS ─────────────────────────────────────────
    pw.Widget buildTerms() {
      if (invoice.terms == null) return pw.SizedBox();
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 40),
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: borderColor),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Payment Terms: ',
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: primaryColor,
              ),
            ),
            pw.Text(
              invoice.terms!,
              style: const pw.TextStyle(fontSize: 9, color: textGrey),
            ),
          ],
        ),
      );
    }

    // ── THANK YOU BANNER ──────────────────────────────
    pw.Widget buildThankYou() {
      return pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 40),
        padding: const pw.EdgeInsets.symmetric(vertical: 12),
        decoration: const pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: borderColor)),
        ),
        child: pw.Center(
          child: pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontSize: 11,
              color: accentColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        header: buildHeader,
        footer: buildFooter,
        build: (context) => [
          buildMetaSection(),
          pw.Divider(color: borderColor, indent: 40, endIndent: 40),
          pw.SizedBox(height: 16),
          buildItemsTable(),
          pw.SizedBox(height: 24),
          buildTotals(),
          pw.SizedBox(height: 16),
          buildTerms(),
          pw.SizedBox(height: 16),
          buildThankYou(),
        ],
      ),
    );

    return pdf;
  }

  // ── HELPERS ───────────────────────────────────────

  pw.Widget _metaRow(
    String label,
    String value,
    PdfColor primary,
    PdfColor grey,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('$label: ', style: pw.TextStyle(fontSize: 10, color: grey)),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: primary,
          ),
        ),
      ],
    );
  }

  pw.Widget _totalRow(
    String label,
    String value,
    PdfColor color,
    bool bold, {
    double fontSize = 10,
  }) {
    final style = pw.TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: style),
        pw.Text(value, style: style),
      ],
    );
  }
}

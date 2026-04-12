import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:weeklet/core/utils/number_formatter.dart';
import 'package:weeklet/domain/entities/income.dart';
import 'package:weeklet/domain/usecases/base/use_case.dart';

class ExportIncomeParams {
  const ExportIncomeParams({
    required this.incomes,
    required this.currencySymbol,
    required this.year,
    required this.month,
  });

  final List<Income> incomes;
  final String currencySymbol;
  final int year;
  final int month;
}

class ExportIncomeUseCase implements UseCase<String, ExportIncomeParams> {
  const ExportIncomeUseCase();

  @override
  Future<String> call(ExportIncomeParams params) async {
    await initializeDateFormatting('en');

    final incomes = params.incomes;
    final currencySymbol = params.currencySymbol;
    final year = params.year;
    final month = params.month;

    // Compute totals
    final total = incomes.fold(0.0, (sum, i) => sum + i.amount);

    // Colors
    const headerColor = PdfColor.fromInt(0xFF1447E6);
    const tableHeaderFill = PdfColor.fromInt(0xFFF2F2F5);
    const tableHeaderText = PdfColor.fromInt(0xFF030213);
    const bodyText = PdfColor.fromInt(0xFF262626);
    const dividerColor = PdfColor.fromInt(0xFFE6E6E6);
    const evenRow = PdfColor.fromInt(0xFFFAFAFA);
    const oddRow = PdfColors.white;
    const mutedColor = PdfColor.fromInt(0xFF878B93);
    const totalsColor = PdfColor.fromInt(0xFF1447E6);
    const incomeAmountColor = PdfColor.fromInt(0xFF16A34A);

    // Fonts
    final regularFont = pw.Font.helvetica();
    final boldFont = pw.Font.helveticaBold();

    // Date formatters
    final monthNameFormatter = DateFormat('MMMM', 'en');
    final subtitleFormatter = DateFormat.yMMMM('en');
    final generatedFormatter = DateFormat('d MMMM yyyy', 'en');
    final rowDateFormatter = DateFormat('dd MMM yyyy', 'en');

    final monthLower = monthNameFormatter
        .format(DateTime(year, month))
        .toLowerCase();
    final subtitleDate = subtitleFormatter.format(DateTime(year, month));
    final generatedDate = generatedFormatter.format(DateTime.now());

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Section 1: Header block
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: const pw.BoxDecoration(color: headerColor),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Weeklet',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 24,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Income Report \u00b7 $subtitleDate',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 14,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Generated: $generatedDate',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 11,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              // Section 2: Summary row
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                decoration: const pw.BoxDecoration(color: tableHeaderFill),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Records: ${incomes.length}',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 11,
                        color: bodyText,
                      ),
                    ),
                    pw.Text(
                      'Total: ${NumberFormatter.formatCurrency(total, currencySymbol)}',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 11,
                        color: bodyText,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),
              // Section 3: Data table or empty state
              if (incomes.isEmpty)
                pw.Center(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(24),
                    child: pw.Text(
                      'No records for ${monthNameFormatter.format(DateTime(year, month))} $year',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                        color: mutedColor,
                      ),
                    ),
                  ),
                )
              else ...[
                pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(20),
                    1: pw.FlexColumnWidth(55),
                    2: pw.FlexColumnWidth(25),
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: tableHeaderFill,
                      ),
                      children: ['Date', 'Description', 'Amount']
                          .asMap()
                          .entries
                          .map(
                            (entry) => pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 4,
                              ),
                              child: pw.Text(
                                entry.value,
                                textAlign: entry.key == 2
                                    ? pw.TextAlign.right
                                    : pw.TextAlign.left,
                                style: pw.TextStyle(
                                  font: boldFont,
                                  fontSize: 11,
                                  color: tableHeaderText,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    // Body rows
                    ...incomes.asMap().entries.map((entry) {
                      final index = entry.key;
                      final income = entry.value;
                      final rowColor = index.isOdd ? evenRow : oddRow;
                      final dateStr = rowDateFormatter.format(income.date);
                      final amountStr = NumberFormatter.formatCurrency(
                        income.amount,
                        currencySymbol,
                      );

                      return pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: rowColor,
                          border: const pw.Border(
                            bottom: pw.BorderSide(
                              color: dividerColor,
                              width: 0.5,
                            ),
                          ),
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 4,
                            ),
                            child: pw.Text(
                              dateStr,
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 10,
                                color: bodyText,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 4,
                            ),
                            child: pw.Text(
                              income.description,
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 10,
                                color: bodyText,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 4,
                            ),
                            child: pw.Text(
                              amountStr,
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 10,
                                color: incomeAmountColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                pw.SizedBox(height: 4),
                // Section 4: Totals row
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  decoration: const pw.BoxDecoration(color: totalsColor),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 11,
                          color: PdfColors.white,
                        ),
                      ),
                      pw.Text(
                        NumberFormatter.formatCurrency(total, currencySymbol),
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 11,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
        ),
      ),
    );

    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    await Directory(dir.path).create(recursive: true);
    final filePath = '${dir.path}/weeklet_income_${monthLower}_$year.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }
}

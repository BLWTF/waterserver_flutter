import 'dart:io';
import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/utilities/generics/number_format.dart';
import 'package:waterserver/widgets/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

class BillPrintPreview extends StatefulWidget {
  final Bill bill;

  const BillPrintPreview({Key? key, required this.bill}) : super(key: key);

  @override
  State<BillPrintPreview> createState() => _BillPrintPreviewState();
}

class _BillPrintPreviewState extends State<BillPrintPreview>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: const DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.center,
            child: Text('Print'),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(FluentIcons.back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: Row(
          children: const [
            Spacer(),
            WindowButtons(),
          ],
        ),
      ),
      content: ScaffoldPage.scrollable(
        header: const PageHeader(
          title: Text('Print Bill'),
        ),
        children: [
          SizedBox(
            width: 300,
            height: 500,
            child: PdfPreview(
              allowSharing: false,
              canChangePageFormat: false,
              canDebug: false,
              maxPageWidth: 700,
              // previewPageMargin: EdgeInsets.zero,
              actions: [
                PdfPreviewAction(
                  icon: const Icon(FluentIcons.save),
                  onPressed: _saveAsFile,
                )
              ],
              build: (format) {
                final document = pw.Document();
                document.addPage(
                  pw.Page(
                    margin: const pw.EdgeInsets.all(0),
                    pageFormat: format,
                    build: (context) {
                      return pw.Column(
                        children: [
                          pw.Container(
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                  bottom: pw.BorderSide(
                                      width: 2, style: pw.BorderStyle.dotted)),
                            ),
                            child: pw.Expanded(
                              child: SingleBill(
                                name: 'Kaduna State Waterboard',
                                address:
                                    'Obasanjo House, Yakubu Gowon Way, PMB 2133, Kaduna, Nigeria',
                                bill: widget.bill,
                              ),
                            ),
                          ),
                          // pw.Expanded(
                          //   child: SingleBill(
                          //     name: 'Kaduna State Waterboard',
                          //     address:
                          //         'Obasanjo House, Yakubu Gowon Way, PMB 2133, Kaduna, Nigeria',
                          //   ),
                          // ),
                        ],
                      );
                    },
                  ),
                );
                return document.save();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
  }
}

class SingleBill extends pw.StatelessWidget {
  final String name;
  final String address;
  final Bill bill;

  SingleBill({
    required this.name,
    required this.address,
    required this.bill,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10),
      child: pw.Stack(
        children: [
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              name.toUpperCase(),
                              textScaleFactor: 1.7,
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                    fontWeight: pw.FontWeight.bold,
                                    color: const PdfColor.fromInt(0x2E8CC0),
                                  ),
                            ),
                            pw.Text(
                              'Office: ${address.toUpperCase()}',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                            ),
                            pw.Text(
                              'Customer care: 08065889644, 09076432567, Website: www.kadswac.com',
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                    fontWeight: pw.FontWeight.bold,
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                            ),
                          ],
                        )
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 15,
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Contract No.:'),
                          ),
                        ),
                        pw.Spacer(flex: 1),
                        pw.Expanded(
                          flex: 15,
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('Current Bill(NGN):'),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Text('Period:'),
                                ),
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Text('To:'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 10,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 5),
                            decoration: const pw.BoxDecoration(
                              border:
                                  pw.Border(right: pw.BorderSide(width: 0.5)),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Name:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Connection address:'),
                                ),
                                pw.SizedBox(height: 45),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('DPC:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Meter No.:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 3),
                                  child: pw.Text('Old A/C No.:'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // pw.Expanded(
                        //   flex: 1,
                        //   child: pw.Transform.rotateBox(
                        //     angle: pi / 2,
                        //     child: pw.Divider(height: 20),
                        //   ),
                        // ),
                        pw.Expanded(
                          flex: 10,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Invoice No:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Consumption:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Present Reading:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Previous Reading:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Current charge:'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Arrear Advance(NGN):'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 5),
                                  child: pw.Text('TOTAL DUE(NGN):'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(
                      thickness: 1,
                      borderStyle: pw.BorderStyle.dotted,
                    ),
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text(
                              name.toUpperCase(),
                              textScaleFactor: 1.4,
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                    fontWeight: pw.FontWeight.bold,
                                    color: const PdfColor.fromInt(0x2E8CC0),
                                  ),
                            ),
                            pw.Text(
                              'Office: ${address.toUpperCase()}',
                              textScaleFactor: 0.8,
                              style: pw.Theme.of(context)
                                  .defaultTextStyle
                                  .copyWith(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                            ),
                          ],
                        )
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 15,
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(3),
                            child:
                                pw.Text('Contract No.:', textScaleFactor: 0.7),
                          ),
                        ),
                        pw.Spacer(flex: 1),
                        pw.Expanded(
                          flex: 15,
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Text('Current Bill(NGN):',
                                textScaleFactor: 0.7),
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(
                                width: 0.5,
                              ),
                            ),
                            padding: const pw.EdgeInsets.all(3),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 5,
                                  child:
                                      pw.Text('Period:', textScaleFactor: 0.7),
                                ),
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Text('To:', textScaleFactor: 0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 10,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 5),
                            decoration: const pw.BoxDecoration(
                              border:
                                  pw.Border(right: pw.BorderSide(width: 0.5)),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Name:', textScaleFactor: 0.7),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('DPC:', textScaleFactor: 0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 10,
                          child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 5),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('Arrears(NGN):',
                                      textScaleFactor: 0.7),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: pw.Text('TOTAL DUE(NGN):',
                                      textScaleFactor: 0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          ...[
            // contract no
            pw.Positioned(
              top: 75,
              left: 240,
              child: pw.Text(bill.contractNo!),
            ),
            // current bill
            pw.Positioned(
              top: 75,
              right: 40,
              child: pw.Text(bill.currentCharges!.format()),
            ),
            // period from
            pw.Positioned(
              top: 100,
              left: 220,
              child: pw.Text(bill.monthStart!.toString().split(' ').first),
            ),
            // period to
            pw.Positioned(
              top: 100,
              right: 50,
              child: pw.Text(bill.monthEnd!.toString().split(' ').first),
            ),
            // name
            pw.Positioned(
              top: 124,
              left: 90,
              child: pw.Text(bill.name),
            ),
            // connection address
            pw.Positioned(
              top: 143,
              left: 130,
              child: pw.SizedBox(
                width: 150,
                height: 50,
                child: pw.Text(bill.connectionAddress!),
              ),
            ),
            // dpc
            pw.Positioned(
              top: 207,
              left: 100,
              child: pw.Text(bill.dpc!),
            ),
            // meter no
            pw.Positioned(
              top: 228,
              left: 100,
              child: pw.Text(bill.meterNo!),
            ),
            // old a/c no
            pw.Positioned(
              top: 247,
              left: 100,
              child: pw.Text(''),
            ),
            // invoice no
            pw.Positioned(
              top: 123,
              right: 100,
              child: pw.Text(''),
            ),
            // consumption
            pw.Positioned(
              top: 142,
              right: 100,
              child: pw.Text(bill.currentConsumption!.toString()),
            ),
            // present reading
            pw.Positioned(
              top: 161,
              right: 100,
              child: pw.Text(''),
            ),
            // previous reading
            pw.Positioned(
              top: 180,
              right: 100,
              child: pw.Text(''),
            ),
            // current charge
            pw.Positioned(
              top: 201,
              right: 100,
              child: pw.Text(bill.currentCharges!.format()),
            ),
            // arrear
            pw.Positioned(
              top: 220,
              right: 100,
              child: pw.Text(bill.openingBalance!.format()),
            ),
            // total
            pw.Positioned(
              top: 242,
              right: 100,
              child:
                  pw.Text(bill.closingBalance!.format(), textScaleFactor: 1.2),
            ),
            // contract no 2
            pw.Positioned(
              top: 327,
              left: 100,
              child: pw.Text(bill.contractNo!, textScaleFactor: 0.7),
            ),
            // current charges 2
            pw.Positioned(
              top: 327,
              right: 100,
              child:
                  pw.Text(bill.currentCharges!.format(), textScaleFactor: 0.7),
            ),
            // period from
            pw.Positioned(
              top: 342,
              left: 100,
              child: pw.Text(bill.monthStart!.toString().split(' ').first,
                  textScaleFactor: 0.7),
            ),
            // period to
            pw.Positioned(
              top: 342,
              right: 100,
              child: pw.Text(bill.monthEnd!.toString().split(' ').first,
                  textScaleFactor: 0.7),
            ),
            // name 2
            pw.Positioned(
              top: 358,
              left: 100,
              child: pw.Text(bill.name, textScaleFactor: 0.7),
            ),
            // arrears 2
            pw.Positioned(
              top: 358,
              right: 100,
              child:
                  pw.Text(bill.openingBalance!.format(), textScaleFactor: 0.7),
            ),
            // dpc 2
            pw.Positioned(
              top: 373,
              left: 100,
              child: pw.Text(bill.dpc!, textScaleFactor: 0.7),
            ),
            // total 2
            pw.Positioned(
              top: 374,
              right: 100,
              child:
                  pw.Text(bill.closingBalance!.format(), textScaleFactor: 0.8),
            ),
          ],
        ],
      ),
    );
  }
}

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class CustomData {
  const CustomData({this.name = '[your name]'});

  final String name;
}

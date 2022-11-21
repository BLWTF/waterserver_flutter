import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:window_manager/window_manager.dart';

import '../widgets/single_bill.dart';

class BillPrintPreview extends StatefulWidget {
  final List<Bill> bills;
  final String name;

  const BillPrintPreview({Key? key, required this.bills, required this.name})
      : super(key: key);

  @override
  State<BillPrintPreview> createState() => _BillPrintPreviewState();
}

class _BillPrintPreviewState extends State<BillPrintPreview> {
  bool showBackground = false;
  PdfPageFormat format = PdfPageFormat.a4;

  LayoutCallback get layoutCallBack {
    final List<List<Bill>> billPreviews =
        widget.bills.fold<List<List<Bill>>>([], (prev, bill) {
      final billPreview = bill;
      if (prev.isEmpty) {
        prev.add([billPreview]);
      } else if (prev.last.length < 2) {
        prev.last.add(billPreview);
      } else {
        prev.add([billPreview]);
      }
      return prev;
    });

    return (format) async {
      final document = pw.Document();
      for (var billPreviewPair in billPreviews) {
        document.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(0),
            pageFormat: format,
            build: (context) {
              return pw.Column(
                children: [
                  ...billPreviewPair.map(
                    (bill) => SingleBill(
                      name: 'Kaduna State Waterboard',
                      address:
                          'Obasanjo House, Yakubu Gowon Way, PMB 2133, Kaduna, Nigeria',
                      bill: bill,
                      showBackground: showBackground,
                    ),
                  )
                ],
              );
            },
          ),
        );
      }

      return await document.save();
    };
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
            icon: const Icon(FluentIcons.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
      ),
      content: ScaffoldPage.scrollable(
        header: const PageHeader(
          title: Text('Print Bill'),
        ),
        children: [
          Card(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Print Bills',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' (${widget.bills.length})',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 90, 95, 97),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Icon(FluentIcons.date_time,
                                    color: Color.fromARGB(255, 90, 95, 97)),
                              ),
                              TextSpan(
                                text:
                                    ' ${widget.bills.first.monthStart.toString().split(' ').first}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 90, 95, 97),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ToggleSwitch(
                          checked: showBackground,
                          leadingContent: true,
                          content: const Text('Show Background'),
                          onChanged: (value) =>
                              setState(() => showBackground = !showBackground),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Button(
                                child: const Icon(FluentIcons.print, size: 24),
                                onPressed: () =>
                                    _print(layoutCallBack, documentName),
                              ),
                              const SizedBox(width: 10),
                              Button(
                                child: const Icon(FluentIcons.save, size: 24),
                                onPressed: () =>
                                    _saveAsFile(layoutCallBack, format),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 400,
                    child: PdfPreview(
                      allowSharing: false,
                      canChangePageFormat: false,
                      canDebug: false,
                      maxPageWidth: 300,
                      useActions: false,
                      initialPageFormat: format,
                      build: layoutCallBack,
                      // previewPageMargin: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get documentName => widget.name;

  Future<void> _print(LayoutCallback layoutCallback, String name) async {
    await Printing.layoutPdf(
      name: documentName,
      onLayout: layoutCallback,
    );
    Navigator.pop(context, true);
  }

  Future<void> _saveAsFile(
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);
    final appDocDir = await getApplicationDocumentsDirectory();
    final pickDirPath = await FilePicker.platform.getDirectoryPath(
      initialDirectory: appDocDir.path,
      lockParentWindow: true,
    );

    if (pickDirPath == null) return;

    final file = File('$pickDirPath/$documentName.pdf');
    await file.writeAsBytes(bytes);
    Navigator.pop(context, true);
  }
}

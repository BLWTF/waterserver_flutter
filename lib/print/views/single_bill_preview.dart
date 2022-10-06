import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/widgets/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

import '../widgets/single_bill.dart';

class SingleBillPrintPreview extends StatefulWidget {
  final Bill bill;
  const SingleBillPrintPreview({Key? key, required this.bill})
      : super(key: key);

  @override
  State<SingleBillPrintPreview> createState() => _SingleBillPrintPreviewState();
}

class _SingleBillPrintPreviewState extends State<SingleBillPrintPreview>
    with WindowListener {
  bool showBackground = false;
  PdfPageFormat format = PdfPageFormat.a4;

  LayoutCallback get layoutCallBack {
    return (format) async {
      final document = pw.Document();
      document.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(0),
          pageFormat: format,
          build: (context) {
            return pw.Column(
              children: [
                SingleBill(
                  name: 'Kaduna State Waterboard',
                  address:
                      'Obasanjo House, Yakubu Gowon Way, PMB 2133, Kaduna, Nigeria',
                  bill: widget.bill,
                  showBackground: showBackground,
                ),
              ],
            );
          },
        ),
      );
      return await document.save();
    };
  }

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
                            TextSpan(
                              text: widget.bill.name,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' (${widget.bill.contractNo})',
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
                                    ' ${widget.bill.monthStart.toString().split(' ').first}',
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

  String get documentName =>
      '${widget.bill.lastName}_${widget.bill.contractNo}_${widget.bill.monthStart.toString().split(' ').first}';

  Future<void> _print(LayoutCallback layoutCallback, String name) async {
    await Printing.layoutPdf(
      name: name,
      onLayout: layoutCallback,
    );
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
  }
}

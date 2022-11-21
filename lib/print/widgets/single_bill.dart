import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:waterserver/bill/bill.dart';
import 'package:waterserver/utilities/generics/number_format.dart';

class SingleBill extends StatelessWidget {
  final String name;
  final String address;
  final Bill bill;
  final bool showBackground;

  SingleBill({
    required this.name,
    required this.address,
    required this.bill,
    this.showBackground = false,
  });

  @override
  Widget build(Context context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, style: BorderStyle.dotted)),
      ),
      child: Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              _PrintBackground(
                showBackground: showBackground,
                name: name,
                address: address,
              ),
              ...[
                // contract no
                Positioned(
                  top: 75,
                  left: 240,
                  child: Text(bill.contractNo!),
                ),
                // current bill
                Positioned(
                  top: 75,
                  right: 40,
                  child: Text(bill.currentCharges == null
                      ? ''
                      : bill.currentCharges!.format()),
                ),
                // period from
                Positioned(
                  top: 100,
                  left: 220,
                  child: Text(bill.monthStart!.toString().split(' ').first),
                ),
                // period to
                Positioned(
                  top: 100,
                  right: 50,
                  child: Text(bill.monthEnd!.toString().split(' ').first),
                ),
                // name
                Positioned(
                  top: 122,
                  left: 74,
                  child: Text(bill.name),
                ),
                // connection address
                Positioned(
                  top: 143,
                  left: 130,
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: Text(bill.connectionAddress!),
                  ),
                ),
                // dpc
                Positioned(
                  top: 207,
                  left: 100,
                  child: Text(bill.dpc!),
                ),
                // meter no
                Positioned(
                  top: 228,
                  left: 100,
                  child: Text(bill.meterNo ?? ''),
                ),
                // old a/c no
                Positioned(
                  top: 247,
                  left: 100,
                  child: Text(''),
                ),
                // invoice no
                Positioned(
                  top: 123,
                  right: 100,
                  child: Text(''),
                ),
                // consumption
                Positioned(
                  top: 142,
                  right: 100,
                  child: Text(bill.currentConsumption!.toString()),
                ),
                // present reading
                Positioned(
                  top: 161,
                  right: 100,
                  child: Text(''),
                ),
                // previous reading
                Positioned(
                  top: 180,
                  right: 100,
                  child: Text(''),
                ),
                // current charge
                Positioned(
                  top: 201,
                  right: 100,
                  child: Text(bill.currentCharges!.format()),
                ),
                // arrear
                Positioned(
                  top: 220,
                  right: 100,
                  child: Text(bill.openingBalance!.format()),
                ),
                // total
                Positioned(
                  top: 242,
                  right: 100,
                  child:
                      Text(bill.closingBalance!.format(), textScaleFactor: 1.2),
                ),
                // contract no 2
                Positioned(
                  top: 312,
                  left: 100,
                  child: Text(bill.contractNo!, textScaleFactor: 0.7),
                ),
                // current charges 2
                Positioned(
                  top: 312,
                  right: 100,
                  child:
                      Text(bill.currentCharges!.format(), textScaleFactor: 0.7),
                ),
                // period from
                Positioned(
                  top: 327,
                  left: 100,
                  child: Text(bill.monthStart!.toString().split(' ').first,
                      textScaleFactor: 0.7),
                ),
                // period to
                Positioned(
                  top: 327,
                  right: 100,
                  child: Text(bill.monthEnd!.toString().split(' ').first,
                      textScaleFactor: 0.7),
                ),
                // name 2
                Positioned(
                  top: 342,
                  left: 100,
                  child: Text(bill.name, textScaleFactor: 0.7),
                ),
                // arrears 2
                Positioned(
                  top: 342,
                  right: 100,
                  child:
                      Text(bill.openingBalance!.format(), textScaleFactor: 0.7),
                ),
                // dpc 2
                Positioned(
                  top: 358,
                  left: 100,
                  child: Text(bill.dpc!, textScaleFactor: 0.7),
                ),
                // total 2
                Positioned(
                  top: 358,
                  right: 100,
                  child:
                      Text(bill.closingBalance!.format(), textScaleFactor: 0.8),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PrintBackground extends StatelessWidget {
  final bool showBackground;
  final String name;
  final String address;

  _PrintBackground({
    required this.showBackground,
    required this.name,
    required this.address,
  });

  @override
  Widget build(Context context) {
    return Opacity(
      opacity: showBackground ? 1 : 0,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name.toUpperCase(),
                          textScaleFactor: 1.7,
                          style: Theme.of(context).defaultTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0x2E8CC0),
                              ),
                        ),
                        Text(
                          'Office: ${address.toUpperCase()}',
                          style: Theme.of(context).defaultTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Customer care: 08065889644, 09076432567, Website: www.kadswac.com',
                          style: Theme.of(context).defaultTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text('Contract No.:'),
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text('Current Bill(NGN):'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text('Period:'),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text('To:'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, style: BorderStyle.dotted),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            border: Border(right: BorderSide(width: 0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Name:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Connection address:'),
                              ),
                              SizedBox(height: 45),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('DPC:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Meter No.:'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text('Old A/C No.:'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: Transform.rotateBox(
                      //     angle: pi / 2,
                      //     child: Divider(height: 20),
                      //   ),
                      // ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Invoice No:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Consumption:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Present Reading:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Previous Reading:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Current charge:'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text('Arrear Advance(NGN):'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text('TOTAL DUE(NGN):'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name.toUpperCase(),
                          textScaleFactor: 1.4,
                          style: Theme.of(context).defaultTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const PdfColor.fromInt(0x2E8CC0),
                              ),
                        ),
                        Text(
                          'Office: ${address.toUpperCase()}',
                          textScaleFactor: 0.8,
                          style: Theme.of(context).defaultTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Text('Contract No.:', textScaleFactor: 0.7),
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Text('Current Bill(NGN):', textScaleFactor: 0.7),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text('Period:', textScaleFactor: 0.7),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text('To:', textScaleFactor: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(width: 0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text('Name:', textScaleFactor: 0.7),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text('DPC:', textScaleFactor: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child:
                                  Text('Arrears(NGN):', textScaleFactor: 0.7),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child:
                                  Text('TOTAL DUE(NGN):', textScaleFactor: 0.7),
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
    );
  }
}

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/order.dart';

class PrintService {
  Future<void> printReceipt(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('DESITRACKER', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.Center(
                child: pw.Text('Order Receipt', style: pw.TextStyle(fontSize: 14)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Order ID: ${order.id?.substring(0, 8) ?? ''}'),
              pw.Text('Date: ${order.createdAt?.toString().split('.')[0] ?? ''}'),
              pw.Divider(),
              pw.SizedBox(height: 10),
              ...order.items.map((item) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text('${item.quantity}x ${item.productName}')),
                    pw.Text('£${(item.price * item.quantity).toStringAsFixed(2)}'),
                  ],
                ),
              )),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('£${order.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Center(
                child: pw.Text('Thank you for your order!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'dart:html' as html;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

final Color kBg = Color(0xFFF0DDC9);
final Color kText = Color(0xFF333333);
final Color kAccent = Color(0xFF71503C);
final Color kCardLight = const Color.fromARGB(255, 251, 241, 234);

class OrdersScreen extends StatefulWidget {
  static const screenRoute = '/adminPannel/orderingList_screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

Future<void> _generateOrderPDF(Map<String, dynamic> orderData) async {
  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();
  final Size pageSize = page.getClientSize();
  final PdfGraphics graphics = page.graphics;

  final ByteData logoData = await rootBundle.load('images/logo.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();
  final PdfBitmap logo = PdfBitmap(logoBytes);

  final PdfColor kBg = PdfColor(240, 221, 201);
  final PdfColor kText = PdfColor(51, 51, 51);
  final PdfColor kAccent = PdfColor(113, 80, 60);

  final PdfFont titleFont =
      PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
  final PdfFont subtitleFont =
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
  final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
  final PdfFont boldFont =
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

  const double margin = 20;
  const double sectionSpacing = 20;
  const double lineSpacing = 18;
  double y = margin;

  // === Logo and Header ===
  graphics.drawImage(logo, Rect.fromLTWH(pageSize.width - 140, 20, 100, 75));
  graphics.drawString('Qahwaty', titleFont,
      brush: PdfSolidBrush(kAccent),
      bounds: Rect.fromLTWH(margin, y, pageSize.width - 120, 30));
  y += 30;

  graphics.drawString('123 Street, City, Country', normalFont,
      brush: PdfSolidBrush(kText),
      bounds: Rect.fromLTWH(margin, y, 300, lineSpacing));
  y += lineSpacing;
  graphics.drawString(
      'Phone: +212 624-035473 | Email: qahwaty@gmail.com', normalFont,
      brush: PdfSolidBrush(kText),
      bounds: Rect.fromLTWH(margin, y, 400, lineSpacing));
  y += sectionSpacing;

  // === Client Info ===
  graphics.drawString('Invoice To:', subtitleFont,
      brush: PdfSolidBrush(kAccent),
      bounds: Rect.fromLTWH(margin, y, pageSize.width, lineSpacing));
  y += lineSpacing;

  final List<String> clientLines = [
    'Name: ${orderData['name'] ?? ''}',
    'Phone: ${orderData['phone'] ?? ''}',
    'Email: ${orderData['email'] ?? ''}',
    'Address: ${orderData['address'] ?? ''}',
    'City: ${orderData['city'] ?? 'Unknown'}',
    'Delivery: ${orderData['deliverySpeed'] ?? 'Standard'}',
    'Order Date: ${orderData['orderDate']?.toString().split('T').first ?? 'Unknown'}',
  ];

  for (var line in clientLines) {
    graphics.drawString(line, normalFont,
        brush: PdfSolidBrush(kText),
        bounds:
            Rect.fromLTWH(margin, y, pageSize.width - margin * 2, lineSpacing));
    y += lineSpacing;
  }

  y += sectionSpacing;

  // === Products Table ===
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 4);
  grid.headers.add(1);
  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'Product';
  header.cells[1].value = 'Quantity';
  header.cells[2].value = 'Unit Price';
  header.cells[3].value = 'Total';
  header.style = PdfGridRowStyle(
    backgroundBrush: PdfSolidBrush(kAccent),
    textPen: PdfPens.white,
  );

  List<Map<String, dynamic>> products =
      List<Map<String, dynamic>>.from(orderData['products'] ?? []);
  for (var product in products) {
    final PdfGridRow row = grid.rows.add();
    double quantity = double.tryParse(product['quantity'].toString()) ?? 0;
    double price = double.tryParse(product['price'].toString()) ?? 0;
    double total = quantity * price;

    row.cells[0].value = product['name'] ?? '';
    row.cells[1].value = quantity.toStringAsFixed(0);
    row.cells[2].value = '\$${price.toStringAsFixed(2)}';
    row.cells[3].value = '\$${total.toStringAsFixed(2)}';
  }

  grid.style = PdfGridStyle(
    font: normalFont,
    backgroundBrush: PdfSolidBrush(kBg),
    cellPadding: PdfPaddings(left: 4, right: 4, top: 2, bottom: 2),
  );

  final PdfLayoutResult layoutResult = grid.draw(
    page: page,
    bounds: Rect.fromLTWH(
        margin, y, pageSize.width - margin * 2, pageSize.height - y - 100),
  )!;
  y = layoutResult.bounds.bottom + sectionSpacing;

  // === Total ===
  graphics.drawString(
      'Grand Total: \$${orderData['totalPrice'].toStringAsFixed(2)}', boldFont,
      brush: PdfSolidBrush(kAccent),
      bounds:
          Rect.fromLTWH(margin, y, pageSize.width - margin * 2, lineSpacing));

  // === Footer ===
  graphics.drawLine(
      PdfPen(PdfColor(180, 180, 180), width: 0.5),
      Offset(0, pageSize.height - 50),
      Offset(pageSize.width, pageSize.height - 50));

  graphics.drawString(
    'Thank you for your purchase!',
    normalFont,
    brush: PdfSolidBrush(kText),
    bounds: Rect.fromLTWH(0, pageSize.height - 40, pageSize.width, 20),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );

  // === Save ===
  List<int> bytes = await document.save();
  document.dispose();

  final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'invoice_${orderData['name']}.pdf')
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<void> _generateOrderPDFMobile(Map<String, dynamic> orderData) async {
  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();
  final Size pageSize = page.getClientSize();
  final PdfGraphics graphics = page.graphics;

  final ByteData logoData = await rootBundle.load('images/logo.png');
  final Uint8List logoBytes = logoData.buffer.asUint8List();
  final PdfBitmap logo = PdfBitmap(logoBytes);

  final PdfColor kBg = PdfColor(240, 221, 201);
  final PdfColor kText = PdfColor(51, 51, 51);
  final PdfColor kAccent = PdfColor(113, 80, 60);

  final PdfFont titleFont =
      PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
  final PdfFont subtitleFont =
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
  final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
  final PdfFont boldFont =
      PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

  const double margin = 20;
  const double sectionSpacing = 20;
  const double lineSpacing = 18;
  double y = margin;

  graphics.drawImage(logo, Rect.fromLTWH(pageSize.width - 140, 20, 100, 75));
  graphics.drawString('Qahwaty', titleFont,
      brush: PdfSolidBrush(kAccent),
      bounds: Rect.fromLTWH(margin, y, pageSize.width - 120, 30));
  y += 30;

  graphics.drawString('123 Street, City, Country', normalFont,
      brush: PdfSolidBrush(kText),
      bounds: Rect.fromLTWH(margin, y, 300, lineSpacing));
  y += lineSpacing;

  graphics.drawString(
      'Phone: +212 624-035473 | Email: qahwaty@gmail.com', normalFont,
      brush: PdfSolidBrush(kText),
      bounds: Rect.fromLTWH(margin, y, 400, lineSpacing));
  y += sectionSpacing;

  graphics.drawString('Invoice To:', subtitleFont,
      brush: PdfSolidBrush(kAccent),
      bounds: Rect.fromLTWH(margin, y, pageSize.width, lineSpacing));
  y += lineSpacing;

  final List<String> clientLines = [
    'Name: ${orderData['name'] ?? ''}',
    'Phone: ${orderData['phone'] ?? ''}',
    'Email: ${orderData['email'] ?? ''}',
    'Address: ${orderData['address'] ?? ''}',
    'City: ${orderData['city'] ?? ''}',
    'Delivery Speed: ${orderData['deliverySpeed'] ?? ''}',
    'Order Date: ${orderData['orderDate']?.toString().split('T').first ?? 'Unknown'}',
  ];

  for (var line in clientLines) {
    graphics.drawString(line, normalFont,
        brush: PdfSolidBrush(kText),
        bounds:
            Rect.fromLTWH(margin, y, pageSize.width - margin * 2, lineSpacing));
    y += lineSpacing;
  }

  y += sectionSpacing;

  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 4);
  grid.headers.add(1);

  final PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'Product';
  header.cells[1].value = 'Quantity';
  header.cells[2].value = 'Unit Price';
  header.cells[3].value = 'Total';
  header.style = PdfGridRowStyle(
    backgroundBrush: PdfSolidBrush(kAccent),
    textPen: PdfPens.white,
  );

  final List<Map<String, dynamic>> products =
      List<Map<String, dynamic>>.from(orderData['products'] ?? []);

  for (var product in products) {
    final PdfGridRow row = grid.rows.add();
    final double quantity =
        double.tryParse(product['quantity'].toString()) ?? 0;
    final double price = double.tryParse(product['price'].toString()) ?? 0;
    final double total = quantity * price;

    row.cells[0].value = product['name'] ?? '';
    row.cells[1].value = quantity.toStringAsFixed(0);
    row.cells[2].value = '\$${price.toStringAsFixed(2)}';
    row.cells[3].value = '\$${total.toStringAsFixed(2)}';
  }

  grid.style = PdfGridStyle(
    font: normalFont,
    backgroundBrush: PdfSolidBrush(kBg),
    cellPadding: PdfPaddings(left: 4, right: 4, top: 2, bottom: 2),
  );

  final PdfLayoutResult layoutResult = grid.draw(
    page: page,
    bounds: Rect.fromLTWH(
        margin, y, pageSize.width - margin * 2, pageSize.height - y - 100),
  )!;

  y = layoutResult.bounds.bottom + sectionSpacing;

  final totalPrice = double.tryParse(orderData['totalPrice'].toString()) ?? 0;
  graphics.drawString(
      'Grand Total: \$${totalPrice.toStringAsFixed(2)}', boldFont,
      brush: PdfSolidBrush(kAccent),
      bounds:
          Rect.fromLTWH(margin, y, pageSize.width - margin * 2, lineSpacing));

  graphics.drawLine(
      PdfPen(PdfColor(180, 180, 180), width: 0.5),
      Offset(0, pageSize.height - 50),
      Offset(pageSize.width, pageSize.height - 50));

  graphics.drawString('Thank you for your purchase!', normalFont,
      brush: PdfSolidBrush(kText),
      bounds: Rect.fromLTWH(0, pageSize.height - 40, pageSize.width, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.center));

  final List<int> bytes = await document.save();
  document.dispose();

  final directory = await getApplicationDocumentsDirectory();
  final file = File(
    '${directory.path}/invoice_${(orderData['name'] ?? 'order').toString().replaceAll(" ", "_")}.pdf',
  );
  await file.writeAsBytes(bytes, flush: true);

  await OpenFile.open(file.path);
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Orders",
          style: GoogleFonts.playfairDisplay(
            color: kText,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: kText),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0DDC9), Color(0xFFE6D2BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('No orders found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final products =
                    List<Map<String, dynamic>>.from(data['products'] ?? []);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 14),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Name + Download Button
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data['name'] ?? 'Unnamed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: kAccent,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _generateOrderPDF(data),
                                icon: const Icon(Icons.download_rounded,
                                    size: 20, color: Colors.white),
                                label: const Text(
                                  "Download",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 6,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  shadowColor: kAccent.withOpacity(0.3),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Contact info with subtle styling
                          Text(
                            data['email'] ?? '',
                            style: TextStyle(
                                color: kText.withOpacity(0.65),
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            data['phone'] ?? '',
                            style: TextStyle(color: kText.withOpacity(0.65)),
                          ),
                          Text(
                            data['address'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: kText.withOpacity(0.65)),
                          ),

                          const SizedBox(height: 8),

                          // City & Delivery Speed with labels bolded and colored
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: kText.withOpacity(0.8)),
                              children: [
                                TextSpan(
                                  text: "City: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kAccent),
                                ),
                                TextSpan(
                                  text: data['city'] ?? 'Unknown',
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: kText.withOpacity(0.8)),
                              children: [
                                TextSpan(
                                  text: "Delivery: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kAccent),
                                ),
                                TextSpan(
                                  text: data['deliverySpeed'] ?? 'Standard',
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),
                          Divider(color: Colors.grey.shade300),

                          // Order Date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Date:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: kAccent.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                data['orderDate']
                                        ?.toString()
                                        .split('T')
                                        .first ??
                                    'Unknown',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Products Header
                          Text(
                            "Products:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: kAccent),
                          ),
                          const SizedBox(height: 8),

                          // Products List
                          Column(
                            children: products.map((product) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        product['imageURL'] ?? '',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image,
                                                color: Colors.grey),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'] ?? 'Product',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            "Qty: ${product['quantity'] ?? 1}",
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "\$${product['price']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 12),
                          Divider(color: Colors.grey.shade300),

                          // Total Price
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Total: \$${data['totalPrice']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

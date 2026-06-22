import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models.dart';

// ═══════════════════════════════════════════════════════
//  ORDER SERVICE — PDF + WhatsApp Routing
//  Pure COD (Cash on Delivery) — no GPS tracking
// ═══════════════════════════════════════════════════════

class OrderService {
  // ─── Générer le PDF de la commande ─────────────────
  static Future<Uint8List> generateOrderPdf({
    required String orderId,
    required String restaurantName,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    required DateTime date,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DELIVIP',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.teal,
                        ),
                      ),
                      pw.Text(
                        'Commande #$orderId',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Date: ${_formatDate(date)}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'COD — Espèces',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(),
            pw.SizedBox(height: 12),

            // Restaurant
            pw.Header(level: 1, text: restaurantName),
            pw.SizedBox(height: 8),

            // Items table
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
              },
              headers: ['Produit', 'Qté', 'Prix'],
              data: items.map((ci) {
                return [
                  ci.item.name,
                  '${ci.quantity}',
                  '${ci.totalPrice.toStringAsFixed(2)} DH',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 12),
            pw.Divider(),
            pw.SizedBox(height: 8),

            // Totals
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Sous-total:     ${subtotal.toStringAsFixed(2)} DH',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                    pw.Text(
                      'Livraison:      ${deliveryFee.toStringAsFixed(2)} DH',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'TOTAL:          ${total.toStringAsFixed(2)} DH',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 12),

            // Adresse de livraison
            pw.Header(level: 2, text: 'Adresse de livraison'),
            pw.Text(
              deliveryAddress.isNotEmpty
                  ? deliveryAddress
                  : 'À définir sur place',
            ),
            pw.SizedBox(height: 12),

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Text(
              'Paiement à la livraison (COD) — Merci de votre confiance !',
              style: pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ─── Envoyer la commande vers WhatsApp ──────────────
  static Future<void> sendToWhatsApp({
    required String orderId,
    required String restaurantName,
    required String restaurantPhone,
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    String? customerPhone,
  }) async {
    // Construire le message
    final buf = StringBuffer();
    buf.writeln('🛵 *NOUVELLE COMMANDE DELIVIP*');
    buf.writeln('═' * 25);
    buf.writeln('*Commande #$orderId*');
    buf.writeln('*Restaurant:* $restaurantName');
    buf.writeln('');

    // Items
    for (final ci in items) {
      buf.writeln(
        '${ci.quantity}x ${ci.item.name} — ${ci.totalPrice.toStringAsFixed(2)} DH',
      );
    }
    buf.writeln('');
    buf.writeln('═' * 25);
    if (deliveryFee > 0) {
      buf.writeln('Sous-total: ${subtotal.toStringAsFixed(2)} DH');
      buf.writeln('Livraison: ${deliveryFee.toStringAsFixed(2)} DH');
    }
    buf.writeln('*Total: ${total.toStringAsFixed(2)} DH*');
    buf.writeln('');
    buf.writeln('*Adresse:* $deliveryAddress');
    if (customerPhone != null && customerPhone.isNotEmpty) {
      buf.writeln('*Client:* $customerPhone');
    }
    buf.writeln('');
    buf.writeln('💰 Paiement à la livraison (COD)');

    final message = buf.toString();
    final encoded = Uri.encodeComponent(message);
    final phone = restaurantPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final whatsappUrl = 'https://wa.me/$phone?text=$encoded';

    final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Impossible d\'ouvrir WhatsApp');
    }
  }

  // ─── Imprimer / partager le PDF ─────────────────────
  static Future<void> printOrSharePdf(Uint8List pdfBytes) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: 'delivip_commande.pdf');
  }

  // ─── Helpers ───────────────────────────────────────
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} à '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  /// Génère un ID de commande unique lisible
  static String generateOrderId() {
    final now = DateTime.now();
    final suffix = (now.millisecondsSinceEpoch % 10000).toString().padLeft(
      4,
      '0',
    );
    return 'D${now.day}${now.month}${now.year % 100}-$suffix';
  }
}


import 'package:e_katalog/models/product_model.dart';
import 'package:e_katalog/models/saved_card_model.dart';
import 'package:e_katalog/views/add_card_screen.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final List<Data> cartProducts;

  const PaymentScreen({super.key, required this.cartProducts});

  @override
  State<PaymentScreen> createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final List<SavedCard> _savedCards = [];
  SavedCard? _selectedCard;

  static const Color primary = Color(0xFF3B5BDB);
  static const Color accent = Color(0xFFEDF2FF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF868E96);

  double get _totalPrice {
    double total = 0;
    for (final item in widget.cartProducts) {
      final cleaned = (item.price ?? '0')
          .replaceAll(RegExp(r'[^0-9.,]'), '')
          .replaceAll(',', '.');
      total += double.tryParse(cleaned) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts = widget.cartProducts;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ödeme",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textDark,
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE9ECEF)),
        ),
      ),
      body: SafeArea(
        child: cartProducts.isEmpty
            ? _buildEmptyState()
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartProducts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _buildProductCard(cartProducts[index]),
                    ),
                  ),
                  buildBottomSection(cartProducts),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined, size: 48, color: primary),
          ),
          const SizedBox(height: 16),
          const Text(
            "Sepetiniz boş",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Sepetinizde henüz ürün bulunmuyor.",
            style: TextStyle(fontSize: 14, color: textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Data item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.image ?? "",
              width: 68,
              height: 68,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 68,
                height: 68,
                color: accent,
                child: const Icon(Icons.image_not_supported_outlined, color: primary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if ((item.tagline ?? "").isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.tagline ?? "",
                    style: const TextStyle(fontSize: 12, color: textGrey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${item.price ?? ''} ${item.currency ?? ''}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: primary,
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

  Widget buildBottomSection(List<Data> cartProducts) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Toplam Tutar",
                style: TextStyle(
                  fontSize: 15,
                  color: textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${_totalPrice.toStringAsFixed(2)} ${cartProducts.first.currency ?? ''}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDEE2E6)),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFAFAFA),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SavedCard>(
                      value: _selectedCard,
                      isExpanded: true,
                      hint: const Text(
                        "Kayıtlı kart seçin",
                        style: TextStyle(fontSize: 14, color: textGrey),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: textGrey),
                      items: _savedCards.map((card) {
                        return DropdownMenuItem<SavedCard>(
                          value: card,
                          child: Row(
                            children: [
                              const Icon(Icons.credit_card_rounded, size: 18, color: primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "${card.maskedNumber} – ${card.holderName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (card) => setState(() => _selectedCard = card),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final newCard = await Navigator.push<SavedCard>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddCardScreen(),
                    ),
                  );
                  if (newCard != null) {
                    setState(() {
                      _savedCards.add(newCard);
                      _selectedCard = newCard;
                    });
                  }
                },
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Ekle"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: const BorderSide(color: primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _selectedCard == null
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Row(
                            children: const [
                              Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                              SizedBox(width: 10),
                              Text("Ödeme Başarılı",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            ],
                          ),
                          content: Text(
                            "${_selectedCard!.maskedNumber} kartıyla ödemeniz tamamlandı.",
                            style: const TextStyle(fontSize: 14, color: textGrey),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Tamam",
                                  style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                disabledBackgroundColor: const Color(0xFFADB5BD),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Güvenli Ödeme Yap",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
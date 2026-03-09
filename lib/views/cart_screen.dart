import 'package:e_katalog/models/product_model.dart';
import 'package:e_katalog/views/payment_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Data> products;
  final Set<int> cartIds;
  final Future<void> Function(Set<int> updatedIds) onCartChanged;

  const CartScreen({
    super.key,
    required this.products,
    required this.cartIds,
    required this.onCartChanged,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color _primary = Color(0xFF3B5BDB);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textGrey = Color(0xFF868E96);

  double totalPrice(List<Data> items) {
    double total = 0;
    for (final item in items) {
      final cleaned = (item.price ?? '0')
          .replaceAll(RegExp(r'[^0-9.,]'), '')
          .replaceAll(',', '.');
      total += double.tryParse(cleaned) ?? 0;
    }
    return total;
  }

  Future<void> _removeFromCart(int? id) async {
    if (id == null) return;
    setState(() => widget.cartIds.remove(id));
    await widget.onCartChanged(widget.cartIds);
  }

  @override
  Widget build(BuildContext context) {
    final cartProducts =
        widget.products.where((p) => widget.cartIds.contains(p.id)).toList();
    final total = totalPrice(cartProducts);
    final currency =
        cartProducts.isNotEmpty ? (cartProducts.first.currency ?? '') : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Sepetim",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: _textDark,
              letterSpacing: -0.3,
            )),
        actions: [
          if (cartProducts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${cartProducts.length} ürün",
                    style: const TextStyle(
                        fontSize: 13,
                        color: _primary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
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
                      itemBuilder: (_, index) =>
                          _buildCartItem(cartProducts[index]),
                    ),
                  ),
                  _buildBottomSection(cartProducts, total, currency),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
                color: Color(0xFFEDF2FF), shape: BoxShape.circle),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 52, color: _primary),
          ),
          const SizedBox(height: 20),
          const Text("Sepetiniz Boş",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textDark)),
          const SizedBox(height: 8),
          const Text("Haydi alışverişe başlayalım!",
              style: TextStyle(fontSize: 14, color: _textGrey)),
        ],
      ),
    );
  }

  Widget _buildCartItem(Data item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
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
                color: const Color(0xFFEDF2FF),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: _primary),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name ?? "",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _textDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                if ((item.tagline ?? "").isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(item.tagline ?? "",
                      style:
                          const TextStyle(fontSize: 12, color: _textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDF2FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${item.price ?? ''} ${item.currency ?? ''}",
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _primary),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeFromCart(item.id),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: Colors.red.shade400, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
      List<Data> cartProducts, double total, String currency) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9DB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE066)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline_rounded,
                    color: Color(0xFFE67700), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Siparişiniz kargo ile 2-4 iş günü içinde teslim edilir.",
                    style:
                        TextStyle(fontSize: 12, color: Color(0xFF6D4C00)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Toplam",
                  style: TextStyle(
                      fontSize: 15,
                      color: _textGrey,
                      fontWeight: FontWeight.w500)),
              Text(
                "${total.toStringAsFixed(2)} $currency",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                    letterSpacing: -0.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: cartProducts.isEmpty
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentScreen(cartProducts: cartProducts),
                        ),
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                disabledBackgroundColor: const Color(0xFFADB5BD),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment_rounded, size: 20),
                  SizedBox(width: 8),
                  Text("Ödeme Yap",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
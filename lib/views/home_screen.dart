import 'package:e_katalog/compenents/product_card.dart';
import 'package:e_katalog/models/product_model.dart';
import 'package:e_katalog/services/api_service.dart';
import 'package:e_katalog/services/cart_storage.dart';
import 'package:e_katalog/views/cart_screen.dart';
import 'package:e_katalog/views/product_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  List<Data> allProducts = [];
  final ApiService apiService = ApiService();
  Set<int> cartIds = {};
  String searchQuery = "";

  static const Color _primary = Color(0xFF3B5BDB);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textGrey = Color(0xFF868E96);

  @override
  void initState() {
    super.initState();
    _loadCart();
    loadProducts();
  }

  Future<void> _loadCart() async {
    final saved = await CartStorage.loadCart();
    setState(() => cartIds = saved);
  }

  Future<void> _updateCart(void Function() change) async {
    setState(change);
    await CartStorage.saveCart(cartIds);
  }

  Future<void> loadProducts() async {
    try {
      setState(() => isLoading = true);
      final resData = await apiService.fetchProducts();
      setState(() => allProducts = resData.data ?? []);
    } catch (e) {
      setState(() => errorMessage = "Ürünler yüklenemedi.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts.where((p) {
      return (p.name ?? "").toUpperCase().contains(searchQuery.toUpperCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Shopinn",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: _textDark,
                            letterSpacing: -1,
                          )),
                      Text("Mükemmel cihazınızı bulun.",
                          style: TextStyle(fontSize: 14, color: _textGrey)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartScreen(
                            products: allProducts,
                            cartIds: cartIds,
                            onCartChanged: (updatedIds) async {
                              setState(() => cartIds = updatedIds);
                              await CartStorage.saveCart(cartIds);
                            },
                          ),
                        ),
                      );
                      await _loadCart();
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined,
                              color: _textDark, size: 26),
                        ),
                        if (cartIds.isNotEmpty)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: _primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (v) => setState(() => searchQuery = v),
                  decoration: InputDecoration(
                    hintText: "Ürün ara...",
                    hintStyle:
                        const TextStyle(color: _textGrey, fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: _textGrey),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: _textGrey, size: 18),
                            onPressed: () {
                              searchController.clear();
                              setState(() => searchQuery = "");
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  "https://wantapi.com/assets/banner.png",
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDF2FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: _primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!isLoading && errorMessage.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text("${filteredProducts.length} ürün bulundu",
                      style: const TextStyle(
                          fontSize: 13,
                          color: _textGrey,
                          fontWeight: FontWeight.w500)),
                ),
              if (isLoading)
                const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: _primary)))
              else if (errorMessage.isNotEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 48, color: _textGrey),
                        const SizedBox(height: 12),
                        Text(errorMessage,
                            style: const TextStyle(
                                color: _textGrey, fontSize: 15)),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: loadProducts,
                          icon: const Icon(Icons.refresh_rounded,
                              color: _primary),
                          label: const Text("Tekrar Dene",
                              style: TextStyle(color: _primary)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: product,
                                cartIds: cartIds,
                                onCartChanged: (id, added) async {
                                  await _updateCart(() {
                                    added
                                        ? cartIds.add(id)
                                        : cartIds.remove(id);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
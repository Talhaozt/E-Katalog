import 'package:e_katalog/compenents/product_card.dart';
import 'package:e_katalog/models/product_model.dart';
import 'package:e_katalog/services/api_service.dart';
import 'package:e_katalog/views/card_screen.dart';
import 'package:e_katalog/views/product_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController =TextEditingController();
  bool isLoading = false;
  String errorMessage = "";
  List<Data> allProducts = [];
  ApiService apiService = ApiService();
  final Set<int> cartIds = {};
  String searchQuery = "";

  @override
  void initState() {
    loadProducts();
    super.initState();
  }
  Future<void> loadProducts()async{
    try {
      setState(() {
        isLoading = true;
      });

      ProductModel resData = await apiService.fetchProducts();
      setState(() {
        allProducts = resData.data ?? [];
      });

    } catch (e) {
      setState(() {
        errorMessage = "Failed to load products";
      });
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts.where((product){
      final name = product.name ?? "";
      return name.toUpperCase().contains(searchQuery.toUpperCase());
    },).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discover", style: TextStyle(
                fontSize: 34,
                fontWeight: .bold,
                letterSpacing: 0.5
              ),),
              IconButton(onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => CardScreen(products: allProducts, cartIds: cartIds))
                );
              },
                iconSize: 32,
                icon:
                
                Icon(Icons.shopping_bag_outlined))
            ],
          ),

          SizedBox(height: 8),

          Text(
            "Find ypur perfect device", style: TextStyle(
            fontSize: 16,
            color: Colors.grey
          ),
          ),
          SizedBox(height: 14),

          Container(
            decoration: BoxDecoration(
              color: Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(12),

            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search products",
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search,
                  color: Colors.grey,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14)
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(height: 16),

          Container(
            width: double.infinity,
            height: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(
                  "https://wantapi.com/assets/banner.png",
                ),
              fit: BoxFit.fitWidth,  
              ),
            ),
          ),

          SizedBox(height: 16),

          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty) 
            Center(child: Text(errorMessage),)
          else 
            Expanded(child:
            GridView.builder(
              itemCount: filteredProducts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7
                ),
              itemBuilder: (context, index){
                final product =filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product, cartIds: cartIds))
                     );
                  },
                  child: ProductCard(product: product)
                  
                  );
                }
            )
          )

        ],
        ),
       )
      ),
    );
  }
}
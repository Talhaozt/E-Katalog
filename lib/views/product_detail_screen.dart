import 'package:e_katalog/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Data product;
  final Set<int> cartIds;

  const ProductDetailScreen({super.key, required this.product, required this.cartIds});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Back", ),
        backgroundColor: Colors.white,
        leadingWidth: 20,
      ),
      body: SafeArea(child:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.product.id ?? 0,
              child: Image.network(widget.product.image ?? "",
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(widget.product.name ?? "" ,style: TextStyle(fontSize: 28,fontWeight: .bold),),
                  SizedBox(height: 4,),
                  Text(widget.product.tagline ?? "", style: TextStyle(
                    fontStyle: .italic,
                    color: Colors.grey.shade600
                  ),),
                  SizedBox(height: 16,),
                  Text("Description", style: TextStyle(
                    fontWeight: .bold,
                    fontSize: 20
                  ),),
                  SizedBox(height: 4,),
                  Text(widget.product.description ?? "", ),
                  SizedBox(height: 10,),
                  Text(widget.product.price ?? "N/A",style: TextStyle(fontSize: 20,fontWeight: .bold),),
                  SizedBox(height: 4,),
        
                  ElevatedButton(onPressed: () {
                    setState(() {
                      
                      widget.cartIds.add(widget.product.id ?? 0);

                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Added to cart"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      margin: EdgeInsets.only(
                        bottom: 80,
                        left: 20,
                        right: 20

                      ),
                      )
                    );
                  },style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size.fromHeight(50)
                  ),
                   child: Text("Add to Card",style: TextStyle(
                    color: Colors.white
                  ),))
                ],
              ),
            )
          ],
        ),
      ) 
      ),
    );
  }
}
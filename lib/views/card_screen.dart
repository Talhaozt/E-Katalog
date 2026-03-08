import 'package:e_katalog/models/product_model.dart';
import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  final List<Data> products;
  final Set<int> cartIds;
  const CardScreen({super.key, required this.products, required this.cartIds});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProducts =widget.products.where((product) => widget.cartIds.contains(product.id) ,).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Card"),
        backgroundColor: Colors.white,
        leadingWidth: 20,
      ),
      body: SafeArea(child: 
      Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(child:
          
            cartProducts.isEmpty ? 
            Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  
                  Icon(Icons.shopping_cart_outlined, size: 64,
                  color: Colors.grey,),

                  SizedBox(height: 12,),

                  Text("Your card is empty.",style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                  ),),

                  SizedBox(height: 12,),

                  Text("Add items to starrs shopping.",style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                  ),)

                ],
                
              ),
            )
            
            : ListView.builder(
            itemCount: cartProducts.length,
            itemBuilder: (context, index){
              final item = cartProducts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(
                            item.image ?? ""
                          ),
                        fit: BoxFit.fitWidth,  
                        ),
                      ),
                    ),

                    SizedBox(width: 16,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(item.name ?? "", style: TextStyle(
                            fontSize: 16,
                            fontWeight: .bold
                          ),),
                          Text(item.tagline ?? ""),
                          Text(item.price ?? "")
                        ],
                      ),
                    ),
                    IconButton(onPressed: (){
                      setState(() {
                        widget.cartIds.remove(item.id);
                      });
                    }, icon: Icon(Icons.remove_circle_outline)
                    )
                  ],
                ),
              );
            }
            )
          ),
          SizedBox(height: 20,),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius:BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200)
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,color: Colors.grey.shade600,),
                SizedBox(width: 8,),
                Text("Lorem Inpus is simply dummy text",style: TextStyle(
                  color: Colors.grey.shade600
                ),)
              ],
            ),
            padding: EdgeInsets.all(12),
          ),

          SizedBox(height: 10,),


          ElevatedButton(onPressed: (){

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8))
          ),
          child: Text(
            "Checkout",style: TextStyle(
              color: Colors.white
            ),
          )
          )
        ],
      ),
      )
      ),
    );
  }
}
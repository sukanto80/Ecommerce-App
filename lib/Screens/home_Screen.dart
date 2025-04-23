import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interview_ecommerce_app/Screens/product_details_page.dart';
import 'package:interview_ecommerce_app/Screens/product_search_page.dart';
import '../Widgets/products_card.dart';
import '../controller/product_&_category_controler.dart';
import 'category_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductCategoryController controller = Get.put(ProductCategoryController());

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:Obx((){
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }else{
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by product name...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: (){
                      Get.to(()=>SearchPage());
                      controller.searchResults.value.clear();
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 12,top: 12,bottom: 8),
                  child: Text('Categories',
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: CategoryCardView()
                ),


                 Padding(
                   padding: const EdgeInsets.only(left: 12,top: 12,bottom: 8),
                   child: Text('All Products',
                     style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                   ),
                 ),
                // Grid

                buildGridView()
              ],
            );
          }

        })





      ),

    );
  }

  Expanded buildGridView() {
    if (controller.productsInfo.value.products == null || controller.productsInfo.value.products!.isEmpty) {
      return Expanded(child: Center(child: Text("No products found")));
    }else{
      return Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount:controller.productsInfo.value.products!.length,
          itemBuilder: (context, index) {
            final product = controller.productsInfo.value.products![index];
            final image = product.images![0];
            return GestureDetector(
              onTap: (){
                Get.to(()=>ProductDetailsPage(product: product),
                  transition: Transition.fadeIn,
                  duration: Duration(milliseconds: 700),
                );
                print('ID..............:${product.id}');
              },
              child: GridProductCard(
                imageUrl: image,
                title: product.title,
                price: product.price,
                rating: product.rating,
                category: product.category,
                id: product.id,
              ),
            );
          },
        ),
      );
    }


  }
  Widget CategoryCardView() {
    return SizedBox(
      height: 50, // Set height since ListView is horizontal
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return GestureDetector(
              onTap: (){
               controller.loadProductsByCategory(category['slug']);
               Get.to(()=>CategoryProducts());
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  height: 30,
                  constraints: BoxConstraints(minWidth: 130, maxWidth: 160),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: Text(category['name'],
                      style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),
                    ),
                  ),

                ),
              ),
            );
            /*return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CategoryCard(
                imageUrl: 'https://images.pexels.com/photos/2587370/pexels-photo-2587370.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                title: 'Perfume',
              ),
            );*/
          },
        ),

    );
  }

}

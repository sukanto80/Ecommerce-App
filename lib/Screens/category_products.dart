import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:interview_ecommerce_app/Screens/product_details_page.dart';

import '../Widgets/products_card.dart';
import '../controller/product_&_category_controler.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({super.key});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final ProductCategoryController controller = Get.put(ProductCategoryController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("All Product"),
            backgroundColor: Colors.white,
          ),
          body:Obx((){
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }else{
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildGridView()
                ],
              );
            }

          })





      ),

    );
  }
  Expanded buildGridView() {
    if (controller.categoryProducts.value.products == null || controller.categoryProducts.value.products!.isEmpty) {
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
          itemCount:controller.categoryProducts.value.products!.length,
          itemBuilder: (context, index) {
            final product = controller.categoryProducts.value.products![index];
            final image = product.images![0];
            return GestureDetector(
              onTap: (){
                Get.to(()=>ProductDetailsPage(product: product),
                  transition: Transition.fadeIn,
                  duration: Duration(milliseconds: 700),
                );
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
}

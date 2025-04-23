

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Model_Class/products_info.dart';
import '../Screens/category_products.dart';
import '../Screens/home_Screen.dart';
import '../Screens/product_details_page.dart';
import '../Screens/product_search_page.dart';
import '../Widgets/page_route_animation.dart';


class AppRoutes{


  static const home ='/';
  static const productDetails ='/product_details';
  static const categoryProduct ='/category_product';
  static const searchProduct ='/search_product';


  static Route<dynamic> generateRoute(RouteSettings setting){

    switch(setting.name){
      case home:
        return animatedRoute(page: HomeScreen(),
          duration: Duration(milliseconds: 500),
        );
      case productDetails:
        final product = setting.arguments as Product;
        return animatedRoute(
            page:ProductDetailsPage(product: product),
          transitionType: PageTransitionType.fade
        );
      case categoryProduct:
        return animatedRoute(page: CategoryProducts(),
          transitionType: PageTransitionType.slideFromRight,
          duration: Duration(milliseconds: 500),
        );
      case searchProduct:
        return animatedRoute(page: SearchPage(),
          transitionType: PageTransitionType.slideFromBottom,
          duration: Duration(milliseconds: 500),
        );
      default:
        return MaterialPageRoute(builder: (_) => const UndefinedRouteScreen());
    }

  }


}

class UndefinedRouteScreen extends StatelessWidget {
  const UndefinedRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("404 - Route Not Found")),
    );
  }
}
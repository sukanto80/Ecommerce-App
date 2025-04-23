import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../Model_Class/products_info.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Product"),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildImageCarousel(isHero: true)),
                const SizedBox(width: 24),
                Expanded(child: _buildDetails(context)),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCarousel(isHero: true),
                const SizedBox(height: 24),
                _buildDetails(context),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add to cart logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart!',style: TextStyle(color: Colors.white),)),
          );
        },
        label: const Text("Add to Cart",style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.shopping_cart,color: Colors.white,),
        backgroundColor: Colors.orange,

      ),

    );
  }

  Widget _buildImageCarousel({bool isHero = false}) {
    final images = product.images ?? [];

    if (images.length > 1) {
      // Use Carousel for multiple images
      return CarouselSlider.builder(
        itemCount: images.length,
        options: CarouselOptions(
          height: 300,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          viewportFraction: 0.85,
          autoPlay: true,
        ),
        itemBuilder: (context, index, realIndex) {
          final imageUrl = images[index];

          final imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl:  imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 100),
            ),
          );

          // Hero only on the first image
          return index == 0
              ? Hero(
            tag: 'product-image-${product.id}-${product.title}',
            child: imageWidget,
          )
              : imageWidget;
        },
      );
    } else if (images.isNotEmpty) {
      // Use regular Hero for single image
      return Hero(
        tag: 'product-image-${product.id}-${product.title}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: images[0],
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
            errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 100),
          ),
        ),
      );
    } else {
      // No images case
      return const SizedBox(
        height: 300,
        child: Center(child: Icon(Icons.image_not_supported, size: 60)),
      );
    }
  }



  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          product.title ?? '',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)
        ),
        const SizedBox(height: 8),

        // Price
        Text(
          "\$${product.price?.toStringAsFixed(2) ?? 'N/A'}",
          style: const TextStyle(fontSize: 20, color: Colors.green),
        ),
        const SizedBox(height: 12),

        // Rating
        Row(
          children: [
            RatingBarIndicator(
              rating: product.rating ?? 0,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 22.0,
              direction: Axis.horizontal,
            ),
            const SizedBox(width: 8),
            Text("(${product.rating ?? 0})"),
          ],
        ),
        const SizedBox(height: 20),

        // Description
        Text(
          "Description",
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
        ),
        const SizedBox(height: 8),
        Text(
          product.description ?? 'No description available.',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

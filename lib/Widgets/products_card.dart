import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridProductCard extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  final double? price;
  final double? rating;
  final String? category;
  final int? id;

  const GridProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.rating,
    required this.category,
    required this.id,
  });

  @override
  State<GridProductCard> createState() => _GridProductCardState();
}

class _GridProductCardState extends State<GridProductCard> {

  bool showCounter = false;
  int quantity = 1;

  void toggleCounter() {
    setState(() {
      showCounter = !showCounter;
    });
  }

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) quantity--;
      else showCounter = false; // hide counter if quantity is 0 or 1 and user presses -
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double imageHeight = screenHeight < 700 ? 140 : 120; // adjust as needed
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Stack(
        clipBehavior: Clip.none, // This allows overflow!
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Hero(
                tag:'product-image-${widget.id}-${widget.title}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl!,
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: imageHeight,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )
                ),
              ),

              // Product Info
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true, // 🔥 ensures wrapping if needed
                    ),

                    const SizedBox(height: 4),

                    // Category
                    Text(
                      widget.category!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400, // ✨ makes the title stand out more
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Rating + Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_half_rounded, size: 14, color: Colors.amber[700]),
                            const SizedBox(width: 2),
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          '\$${widget.price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: -5,
            right: -5,

            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: showCounter
                  ? Container(
                height: 40,
                width: 155,
                key: const ValueKey('counter'),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical:0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white, size: 14),
                      onPressed: decrement,
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 14),
                      onPressed: increment,
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 13),
                      onPressed: (){
                        setState(() {
                          showCounter = false;
                        });
                      },
                    ),
                  ],
                ),
              )
                  : Container(
                height: 25,
                width: 40,
                key: const ValueKey('addIcon'),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.7),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart,size: 16, color: Colors.white),
                  onPressed: toggleCounter,
                ),
              ),
            ),
          ),




        ],
      )


    );
  }
}

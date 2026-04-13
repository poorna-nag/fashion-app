import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:royalmart/BottomNavigation/food_app_home_screen.dart';

import 'package:royalmart/dbhelper/CarrtDbhelper.dart';
import 'package:royalmart/dbhelper/database_helper.dart';
import 'package:royalmart/grocery/BottomNavigation/grocery_app_home_screen.dart';
import 'package:royalmart/grocery/General/AppConstant.dart';
import 'package:royalmart/grocery/General/Home.dart';
import 'package:royalmart/screen/productlist.dart';
import 'package:royalmart/model/CategaryModal.dart';

import 'package:royalmart/service_app/General/AppConstant.dart';

import 'package:royalmart/General/AppConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorCategories extends StatefulWidget {
  const VendorCategories({Key? key}) : super(key: key);

  @override
  State<VendorCategories> createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  bool isLoading = true;
  List<Categary> vendorCategories = [];
  List<Categary> productCategories = []; // For "Shop by Product" section
  final DbProductManager dbmanager = new DbProductManager();
  SharedPreferences? preferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    // Load vendor categories (mv_cats)
    get_Category("0").then((value) {
      setState(() {
        vendorCategories.addAll(value!);
        _checkLoadingComplete();
      });
    });
    // Load product categories (p_category)
    DatabaseHelper.getData("0").then((value) {
      setState(() {
        productCategories.addAll(value!);
        _checkLoadingComplete();
      });
    });
  }

  _checkLoadingComplete() {
    if (vendorCategories.isNotEmpty && productCategories.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
    }
  }

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Search Bar Section
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 24),
                SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for any product",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              GroceryAppColors.tela),
                        ),
                      ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shop by Product Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "SHOP BY PRODUCT",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Product Categories Grid (4x2 layout matching the reference)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: productCategories.length > 8
                                ? 8
                                : productCategories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return _buildCategoryItem(
                                context,
                                productCategories[index],
                                () {
                                  // Handle product category tap
                                  if (productCategories[index]
                                      .pCats!
                                      .toLowerCase()
                                      .contains("grocery")) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroceryAppHomeScreen(),
                                      ),
                                    );
                                  } else if (productCategories[index]
                                          .pCats!
                                          .toLowerCase()
                                          .contains("mobile") ||
                                      productCategories[index]
                                          .pCats!
                                          .toLowerCase()
                                          .contains("dish")) {
                                    // Handle recharge services
                                    _showRechargeDialog(context,
                                        productCategories[index].pCats!);
                                  } else {
                                    // Handle other categories
                                    _navigateToCategory(
                                        context, productCategories[index]);
                                  }
                                },
                                true, // This is for product categories
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 30),

                        // Promotional Banner
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFF3B8), Color(0xFFFFE082)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                top: 20,
                                bottom: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Groceries Available",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8B4513),
                                      ),
                                    ),
                                    Text(
                                      "At Your Doorstep",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8B4513),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "SHOP NOW",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                bottom: 10,
                                width: 140,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/banner-2.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30),

                        // Shop by Vendor Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "SHOP BY VENDOR",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Vendor Categories Grid (4 items per row)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: vendorCategories.length > 4
                                ? 4
                                : vendorCategories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return _buildCategoryItem(
                                context,
                                vendorCategories[index],
                                () {
                                  preferences!.setInt("itemCount", 0);
                                  setState(() {
                                    FoodAppConstant.foodAppCartItemCount = 0;
                                    ServiceAppConstant.serviceAppCartItemCount =
                                        0;
                                    GroceryAppConstant.groceryAppCartItemCount =
                                        0;
                                  });
                                  if (vendorCategories[index]
                                      .pCats!
                                      .toLowerCase()
                                      .startsWith("food")) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FoodAppHomeScreen(),
                                      ),
                                    );
                                  } else if (vendorCategories[index]
                                      .pCats!
                                      .toLowerCase()
                                      .startsWith("grocery")) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GroceryAppHomeScreen(),
                                      ),
                                    );
                                  } else if (vendorCategories[index]
                                      .pCats!
                                      .toLowerCase()
                                      .startsWith("service")) {
                                    // Navigate to Service
                                    _showServiceDialog(context);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GroceryApp(),
                                      ),
                                    );
                                  }
                                },
                                false, // This is for vendor categories
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build category items with consistent styling
  Widget _buildCategoryItem(BuildContext context, Categary category,
      VoidCallback onTap, bool isProductCategory) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFE53E3E), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: FoodAppConstant.logo_Image_cat + (category.img ?? ''),
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      color: GroceryAppColors.tela,
                      strokeWidth: 2.0,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.category,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category.pCats ?? "",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Method to handle recharge services
  void _showRechargeDialog(BuildContext context, String serviceType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$serviceType Recharge'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select your $serviceType provider:'),
              SizedBox(height: 20),
              // Add provider selection UI here
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: GroceryAppColors.tela,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to recharge page
                },
                child: Text('Proceed', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to handle service categories
  void _showServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Service Categories'),
          content: Text('Service categories will be available soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to navigate to specific category
  void _navigateToCategory(BuildContext context, Categary category) {
    // Navigate to ProductList with category ID and name for product categories
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductList(
          category.pcatId ?? "", 
          category.pCats ?? "Products"
        ),
      ),
    );
  }
}

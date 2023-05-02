import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'screen-main.dart';
import 'screen-product-detail.dart';

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  bool isAvailable;
  String stockStatus;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.stockStatus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['images'].isNotEmpty ? json['images'][0]['src'] : '',
      isAvailable: json['stock_status'] == 'instock',
      stockStatus: json['stock_status'],
    );
  }
}

class CategoryProductsPage extends StatefulWidget {
  @override
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  List<Category> _categories = [];
  List<Product> _products = [];
  bool _isLoading = false;
  int? _selectedCategoryId;

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.get(
        Uri.parse(
            'https://test.biancouk.co/wp-json/wc/v3/products/categories?per_page=100'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _categories = (responseData as List)
              .map((json) => Category.fromJson(json))
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch categories'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchProductsByCategory(int categoryId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var response = await http.get(
        Uri.parse(
            'https://test.biancouk.co/wp-json/wc/v3/products?category=$categoryId&per_page=100'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _products = (responseData as List)
              .map((json) => Product.fromJson(json))
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch products'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Products'),
        actions: [
          IconButton(
              onPressed: () {
                signOut(context);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<int>(
                  hint: Text('Select a category'),
                  value: _selectedCategoryId,
                  items: _categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _selectedCategoryId = value;
                    });
                    if (value != null) {
                      _fetchProductsByCategory(value);
                    }
                  },
                ),
                Expanded(
                  child: _products.isEmpty
                      ? Center(
                          child: Text('No products found'),
                        )
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ListTile(
                              //leading: Image.network(product.imageUrl),
                              title: Text(product.name),
                              subtitle: Text('£${product.price}'),
                              trailing: SwitchExample(product: product),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPageDet(productId: product.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  final Product product;

  SwitchExample({required this.product, Key? key}) : super(key: key);

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.product.stockStatus == 'instock';
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isAvailable,
      activeColor: Colors.green,
      onChanged: (bool value) async {
        setState(() {
          _isAvailable = value;
        });

        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          var response = await http.put(
            Uri.parse(
                'https://test.biancouk.co/wp-json/wc/v3/products/${widget.product.id}'),
            headers: {
              'Authorization': 'Bearer $token',
            },
            body: {
              'stock_status': value ? 'instock' : 'outofstock',
            },
          );

          if (response.statusCode != 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update product availability'),
              ),
            );
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }
}

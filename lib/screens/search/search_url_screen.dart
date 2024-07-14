import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../load_data/models/product.dart';

class SearchUrlScreen extends StatefulWidget {
  const SearchUrlScreen({super.key});

  @override
  State<SearchUrlScreen> createState() => _SearchUrlScreenState();
}

class _SearchUrlScreenState extends State<SearchUrlScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _validationError;

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _validationError = null;
    });
    try {
      final response = await http.get(
          Uri.parse('https://abdelfattah90.github.io/json-data/products.json'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _allProducts = data.map((json) => Product.fromJson(json)).toList();
          _filterProducts();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load data: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    final query = _searchController.text.trim().toLowerCase();
    if (_validateSearchQuery(query)) {
      setState(() {
        _filteredProducts = _allProducts
            .where(
                (product) => product.productName.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  bool _validateSearchQuery(String query) {
    if (query.isEmpty) {
      setState(() {
        _validationError = 'Search query cannot be empty';
      });
      return false;
    }

    final validCharacters = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (!validCharacters.hasMatch(query)) {
      setState(() {
        _validationError =
            'Search query can only contain letters, numbers, and spaces';
      });
      return false;
    }

    setState(() {
      _validationError = null;
    });
    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products from URL'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: const OutlineInputBorder(),
                      errorText: _validationError,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    final query = _searchController.text.trim().toLowerCase();
                    if (_validateSearchQuery(query)) {
                      _fetchProducts();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : _filteredProducts.isEmpty && !_isLoading
                        ? const Center(child: Text('No products found'))
                        : ListView.builder(
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return Card(
                                margin: const EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Text(product.productDescription),
                                      const SizedBox(height: 10.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Category: ${product.categoryName}',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          Text(
                                            'Date: ${product.dateCreate}',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

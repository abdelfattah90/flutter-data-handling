import 'package:flutter/material.dart';
import 'load_data/models/product.dart';
import 'load_data/local_data_screen.dart';
import 'load_data/url_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data handling'),
        backgroundColor: const Color(0xFF587994),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocalDataScreen()),
                );
              },
              child: const Text('Load Data from Assets'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UrlDataScreen()),
                );
              },
              child: const Text('Load Data from URL'),
            ),
          ],
        ),
      ),
    );
  }
}

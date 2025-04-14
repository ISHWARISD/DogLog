import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PerformancePage extends StatefulWidget {
  @override
  _PerformancePageState createState() => _PerformancePageState();
}

class _PerformancePageState extends State<PerformancePage> {
  late Future<List<int>> futureData;

  @override
  void initState() {
    super.initState();
    // Background processing
    futureData = compute(generateDataInBackground, 1000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Performance Demo")),
      body: FutureBuilder<List<int>>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: 'https://picsum.photos/id/${(index % 100) + 1}/50/50',
                  placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                title: Text('Dog ID: ${data[index]}'),
              );
            },
          );
        },
      ),
    );
  }
}

// Background data generator
List<int> generateDataInBackground(int count) {
  final rand = Random();
  return List.generate(count, (_) => rand.nextInt(10000));
}

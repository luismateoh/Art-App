import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArtworkScreen extends StatelessWidget {
  final String artistName;

  const ArtworkScreen({Key? key, required this.artistName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$artistName Artworks'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchArtworks(artistName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> artworks = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: artworks.length,
              itemBuilder: (context, index) {
                final artwork = artworks[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          artwork['image_id'] != null
                              ? 'https://www.artic.edu/iiif/2/${artwork['image_id']}/full/843,/0/default.jpg'
                              : 'https://via.placeholder.com/300x300?text=No+Image',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        artwork['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

Future<List<dynamic>> fetchArtworks(String artistName) async {
  final response = await http.get(Uri.parse(
      'https://api.artic.edu/api/v1/artworks/search?q=$artistName?&fields=id,title,image_id&limit=100'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    return data;
  } else {
    throw Exception('Failed to fetch artworks');
  }
}

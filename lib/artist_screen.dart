import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'artwork_screen.dart';
import 'dart:convert';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artists'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchArtists(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> artists = snapshot.data!;
            return ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {
                final artist = artists[index];
                return Card(
                  child: ListTile(
                    title: Text(artist['title']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArtworkScreen(artistName: artist['title']),
                        ),
                      );
                    },
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

Future<List<dynamic>> fetchArtists() async {
  final response = await http.get(Uri.parse(
      'https://api.artic.edu/api/v1/artists?limit=100&fields=id,title'));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'];
    return data;
  } else {
    throw Exception('Failed to fetch artists');
  }
}
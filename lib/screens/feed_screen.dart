import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('WorldScout'),
          floating: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // TODO: Implement messages
              },
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => TravelPostCard(),
            childCount: 10, // Temporary count for testing
          ),
        ),
      ],
    );
  }
}

class TravelPostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://placeholder.com/150'),
            ),
            title: const Text('Travel Enthusiast'),
            subtitle: const Text('Paris, France'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          Image.network(
            'https://placeholder.com/500x300',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Text(
                  'Exploring the beautiful streets of Paris! 🗼',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'The city of lights never fails to amaze me. Here are some tips for fellow travelers...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
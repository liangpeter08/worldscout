import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId = 'NE7w7xFBM7GOxgxoBAPE'; // Replace with actual user ID

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: StreamBuilder<DocumentSnapshot>(
                    stream: _firestoreService.getUserProfile(userId).asStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return _buildProfileHeader(userData);
                    },
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: const [
                      Tab(icon: Icon(Icons.grid_on), text: 'Posts'),
                      Tab(icon: Icon(Icons.bookmark), text: 'Saved'),
                    ],
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                ),
                pinned: true,
              ),
            ],
        body: TabBarView(children: [_buildPostsGrid(), _buildSavedGrid()]),
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage('https://placeholder.com/100x100'),
        ),
        const SizedBox(height: 8.0),
        const Text(
          'Travel Explorer',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Exploring the world, one adventure at a time 🌎✈️',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatColumn('Posts', '156'),
            _buildStatColumn('Followers', '10.5K'),
            _buildStatColumn('Following', '825'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildPostsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.8, // Make posts taller than they are wide
      ),
      itemCount: 30,
      itemBuilder:
          (context, index) => _buildGridItem(
            imageUrl: 'https://placeholder.com/400x500',
            location: 'Paris, France',
            likes: '1.2K',
          ),
    );
  }

  Widget _buildSavedGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: 15,
      itemBuilder:
          (context, index) => _buildGridItem(
            imageUrl: 'https://placeholder.com/400x500',
            location: 'Bali, Indonesia',
            likes: '856',
          ),
    );
  }

  Widget _buildGridItem({
    required String imageUrl,
    required String location,
    required String likes,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl, fit: BoxFit.cover),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          // Location and likes
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      likes,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tap overlay
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Implement post detail view
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Posts Collection
  Future<void> createPost({
    required String userId,
    required String imageUrl,
    required String location,
    required String caption,
  }) async {
    await _db.collection('posts').add({
      'userId': userId,
      'imageUrl': imageUrl,
      'location': location,
      'caption': caption,
      'likes': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserPosts(String userId) {
    return _db
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // User Profiles Collection
  Future<void> createUserProfile({
    required String userId,
    required String username,
    required String bio,
    String? profileImageUrl,
  }) async {
    await _db.collection('users').doc(userId).set({
      'username': username,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'followers': 0,
      'following': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserProfile(String userId) async {
    final userData = await _db.collection('users').doc(userId).get();
    if (!userData.exists) {
      throw Exception('User not found');
    }
    return userData;
  }

  // Saved Posts Collection
  Future<void> savePost({
    required String userId,
    required String postId,
  }) async {
    await _db.collection('saved_posts').add({
      'userId': userId,
      'postId': postId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getSavedPosts(String userId) {
    return _db
        .collection('saved_posts')
        .where('userId', isEqualTo: userId)
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  // Likes Collection
  Future<void> toggleLike({
    required String userId,
    required String postId,
  }) async {
    final likeDoc =
        await _db
            .collection('likes')
            .where('userId', isEqualTo: userId)
            .where('postId', isEqualTo: postId)
            .get();

    if (likeDoc.docs.isEmpty) {
      // Add like
      await _db.collection('likes').add({
        'userId': userId,
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Increment post likes counter
      await _db.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      });
    } else {
      // Remove like
      await likeDoc.docs.first.reference.delete();
      // Decrement post likes counter
      await _db.collection('posts').doc(postId).update({
        'likes': FieldValue.increment(-1),
      });
    }
  }
}

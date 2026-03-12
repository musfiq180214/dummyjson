import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/features/social/domain/post.dart';
import 'package:dummyjson/features/social/providers/post_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch posts when page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postNotifierProvider.notifier).fetchPosts();
    });
  }

  final TextEditingController _controller = TextEditingController();
  bool isPosting = false;

  Future<void> _createPost() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => isPosting = true);

    await ref.read(postNotifierProvider.notifier).createPost(text: text);

    _controller.clear();
    setState(() => isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Social Feed"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          /// POST INPUT BOX
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isPosting ? null : _createPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isPosting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Post",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          /// POSTS FEED
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return const Center(child: Text("No posts yet"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _buildPostCard(post);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text("Error: $error")),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(Post post) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Comment"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Write a comment"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                final comment = controller.text.trim();
                if (comment.isNotEmpty) {
                  ref
                      .read(postNotifierProvider.notifier)
                      .addComment(post.id, comment);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPostCard(Post post) {
    final createdAtStr = "${post.createdAt.day.toString().padLeft(2, '0')}/"
              "${post.createdAt.month.toString().padLeft(2, '0')}/"
              "${post.createdAt.year} "
              "${post.createdAt.hour.toString().padLeft(2, '0')}:"
              "${post.createdAt.minute.toString().padLeft(2, '0')}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER: Avatar + Username + Date
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue[800],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Post ID ${post.id.substring(0, 5)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1877F2), // Facebook Blue
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        createdAtStr,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),

          /// POST TEXT
          if (post.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                post.text,
                style: const TextStyle(fontSize: 15, color: Color(0xFF1C1E21)),
              ),
            ),

          const SizedBox(height: 8),

          /// POST IMAGE
          if (post.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                post.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),

          const SizedBox(height: 8),

          /// ACTIONS ROW
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  Icons.thumb_up_alt_outlined,
                  "Like (${post.likes})",
                  () {
                    ref.read(postNotifierProvider.notifier).likePost(post.id);
                  },
                ),
                _buildActionButton(
                  Icons.comment_outlined,
                  "Comment (${post.comments.length})",
                  () {
                    _showCommentDialog(post);
                  },
                ),
                _buildActionButton(Icons.share_outlined, "Share", () {}),
              ],
            ),
          ),

          if (post.comments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: post.comments
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "💬 $c",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      splashColor: const Color(0xFF1877F2).withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

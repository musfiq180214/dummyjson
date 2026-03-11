import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/features/social/domain/post.dart';
import 'package:flutter/material.dart';
import '../data/post_repository.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final TextEditingController _controller = TextEditingController();
  final PostRepository _repository = PostRepository();

  bool isPosting = false;

  Future<void> createPost() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => isPosting = true);

    await _repository.createPost(text: _controller.text.trim());

    _controller.clear();

    setState(() => isPosting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Social Feed"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          /// POST BOX
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
                    onPressed: isPosting ? null : createPost,
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
            child: StreamBuilder<List<Post>>(
              stream: _repository.getPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No posts yet"));
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// POST ID
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                                children: [
                                  const TextSpan(
                                    text: "Post ID: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: post.id),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            /// POST TEXT
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                                children: [
                                  const TextSpan(
                                    text: "Post Text: ",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: post.text),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            /// IMAGE
                            if (post.imageUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  post.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const SizedBox(
                                      height: 150,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Center(child: Icon(Icons.broken_image)),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
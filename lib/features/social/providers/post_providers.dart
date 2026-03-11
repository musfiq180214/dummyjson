import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/social/data/post_repository.dart';
import 'package:dummyjson/features/social/domain/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provide the repository as IPostRepository
final postRepositoryProvider = Provider<IPostRepository>((ref) {
  return PostRepository();
});

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final IPostRepository _repository;
  late final Stream<List<Post>> _postsStream;

  PostNotifier(this._repository) : super(const AsyncValue.loading()) {
    _subscribeToPosts();
  }

  void _subscribeToPosts() {
    _postsStream = _repository.getPosts();
    _postsStream.listen(
      (posts) {
        state = AsyncValue.data(posts);
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
  }

  /// Explicitly fetch posts once
  Future<void> fetchPosts() async {
    state = const AsyncValue.loading();
    try {
      final posts = await _repository.getPosts().first;
      state = AsyncValue.data(posts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createPost({required String text}) async {
    try {
      await _repository.createPost(text: text);
      await fetchPosts(); // Refresh immediately after posting
    } catch (e, st) {
      AppLogger.e('Failed to create post: $e\n$st');
    }
  }

  Future<void> likePost(String postId) async {
    await _repository.likePost(postId);
  }

  Future<void> addComment(String postId, String comment) async {
    await _repository.addComment(postId, comment);
  }
}

final postNotifierProvider =
    StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>(
      (ref) => PostNotifier(ref.watch(postRepositoryProvider)),
    );

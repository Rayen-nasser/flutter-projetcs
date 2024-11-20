import 'package:flutter/material.dart';
import '../model/post.dart';
import '../service/post_service.dart';
import '../widgets/post_widget.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostService _postService = PostService();
  final List<Post> _posts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMorePosts = true;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadMorePosts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMorePosts) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_isLoading && _hasMorePosts) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newPosts = await _postService.fetchPosts(page: _page);
        setState(() {
          if (newPosts.isEmpty) {
            _hasMorePosts = false;
          } else {
            _posts.addAll(newPosts);
            _page++;
          }
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more posts')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _posts.clear();
          _page = 1;
          _hasMorePosts = true;
        });
        await _loadMorePosts();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length + (_hasMorePosts ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _posts.length) {
            return PostWidget(post: _posts[index]);
          } else if (_hasMorePosts) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

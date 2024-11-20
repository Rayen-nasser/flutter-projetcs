import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media/model/comment.dart';
import 'package:social_media/model/post.dart';
import '../service/comment_service.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final Post post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final CommentService _commentService = CommentService();
  final List<Comment> _commentList = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _loading = true;
    });

    try {
      final comments = await _commentService.fetchCommentsByPost(postId: widget.post.id);
      setState(() {
        _commentList.addAll(comments);
      });
    } catch (e) {
      // Handle error if needed
      print('Error fetching comments: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colorScheme),
            SizedBox(height: 12.0),
            if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty)
              _buildImage(),
            SizedBox(height: 12.0),
            _buildBody(colorScheme),
            SizedBox(height: 16.0),
            _buildActions(colorScheme),
            SizedBox(height: 16.0),
            _buildCommentsSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: widget.post.author?.profileImageUrl != null
              ? NetworkImage(widget.post.author!.profileImageUrl!)
              : null,
          child: widget.post.author?.profileImageUrl == null
              ? Icon(Icons.person, color: colorScheme.onSurface)
              : null,
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.post.author?.username ?? 'Unknown User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _formatDate(widget.post.createdAt),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
          onPressed: () {
            // Handle more options
          },
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(widget.post.imageUrl!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.post.title != null && widget.post.title!.isNotEmpty)
          Text(
            widget.post.title!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: colorScheme.onSurface,
            ),
          ),
        if (widget.post.title != null && widget.post.title!.isNotEmpty)
          SizedBox(height: 8.0),
        Text(
          widget.post.body ?? '',
          style: TextStyle(fontSize: 16.0, color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildActions(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.thumb_up, size: 20, color: colorScheme.primary),
            SizedBox(width: 8),
            Text(
              '1.5K Likes',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            Spacer(),
            Text(
              '${widget.post.commentsCount} Comments',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            SizedBox(width: 8),
            Text(
              '50 Shares',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ],
        ),
        Divider(color: colorScheme.onSurface.withOpacity(0.2)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(Icons.thumb_up_outlined, 'Like', colorScheme),
            _buildActionButton(Icons.comment_outlined, 'Comment', colorScheme),
            _buildActionButton(Icons.share_outlined, 'Share', colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, ColorScheme colorScheme) {
    return TextButton.icon(
      onPressed: () {
        // Handle button press
      },
      icon: Icon(icon, color: colorScheme.onSurface),
      label: Text(label, style: TextStyle(color: colorScheme.onSurface)),
    );
  }

  Widget _buildCommentsSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.0),
        if (_loading)
          Center(child: CircularProgressIndicator(color: colorScheme.primary))
        else if (_commentList.isEmpty)
          Text(
            'No comments yet.',
            style: TextStyle(color: Colors.grey),
          )
        else
          ..._commentList.map((comment) => _buildCommentItem(comment, colorScheme)),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: comment.author?.profileImageUrl != null
                ? NetworkImage(comment.author!.profileImageUrl!)
                : null,
            child: comment.author?.profileImageUrl == null
                ? Icon(Icons.person, color: colorScheme.onSurface)
                : null,
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author?.username ?? 'Unknown User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  comment.body ?? '',
                  style: TextStyle(color: colorScheme.onSurface),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat.yMMMd().add_jm().format(date);
    } catch (e) {
      return dateString;
    }
  }
}

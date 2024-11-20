import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/post.dart';
import '../screens/post_detail.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  PostWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: post),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          margin: EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: colorScheme.surface, // Use the surface color from the theme
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: _buildHeader(colorScheme),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: _buildBody(colorScheme),
              ),
              SizedBox(height: 12.0),
              _buildImage(),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: _buildActions(colorScheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: post.author?.profileImageUrl != null
              ? NetworkImage(post.author!.profileImageUrl!)
              : null,
          child: post.author?.profileImageUrl == null
              ? Icon(Icons.person, color: colorScheme.onSurface)
              : null,
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.author?.username ?? 'Unknown User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                _formatDate(post.createdAt),
                style: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 12.0,
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

  Widget _buildBody(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.title != null && post.title!.isNotEmpty)
          Text(
            post.title!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: colorScheme.onSurface,
            ),
          ),
        if (post.title != null && post.title!.isNotEmpty)
          SizedBox(height: 8.0),
        Text(
          post.body ?? '',
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildImage() {
    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      return Image.network(
        post.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300, // Increased height for a more prominent image
        errorBuilder: (context, error, stackTrace) =>
            Center(child: Icon(Icons.error)),
      );
    }
    return SizedBox.shrink();
  }

  Widget _buildActions(ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.thumb_up, size: 16, color: colorScheme.primary),
            SizedBox(width: 4),
            Text(
              '1.5K',
              style: TextStyle(color: colorScheme.onSurface),
            ),
            Spacer(),
            Text(
              '${post.commentsCount} Comments',
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

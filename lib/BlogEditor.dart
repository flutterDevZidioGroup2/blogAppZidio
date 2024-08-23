import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class BlogEditor extends StatefulWidget {
  final Map<String, dynamic>? blog;
  BlogEditor({this.blog});

  @override
  _BlogEditorState createState() => _BlogEditorState();
}

class _BlogEditorState extends State<BlogEditor> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.blog != null) {
      _titleController.text = widget.blog!['title'];
      _contentController.text = widget.blog!['content'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.blog == null ? 'New Blog' : 'Edit Blog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBlog,
              child: Text('Save Blog'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBlog() async {
    final SupabaseClient _supabaseClient = Supabase.instance.client;
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) {
      print('Title or content cannot be empty');
      return;
    }

    try {
      final uuid = Uuid();

      final blogData = {
        'id': uuid.v4(),
        'title': title,
        'content': content,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      // Insert a new blog
      if (widget.blog == null) {
        final response = await _supabaseClient
            .from('public.blogs')
            .insert(blogData)
            .execute();

        print('Response: ${response.data}'); // Debugging info
        if (response.error != null) {
          print('Error inserting data: ${response.error!.message}');
          return;
        } else {
          print('Data inserted successfully');
        }
      } else {
        // Update an existing blog
        final response = await _supabaseClient
            .from('public.blogs')
            .update({
          'title': title,
          'content': content,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
            .eq('id', widget.blog!['id'])
            .execute();

        print('Response: ${response.data}'); // Debugging info
        if (response.error != null) {
          print('Error updating data: ${response.error!.message}');
          return;
        } else {
          print('Data updated successfully');
        }
      }

      Navigator.of(context).pop();
    } catch (error) {
      print('Error saving blog: $error');
    }
  }
}

extension on PostgrestFilterBuilder {
  execute() {}
}

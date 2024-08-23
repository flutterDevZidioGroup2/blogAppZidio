import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ProfilePage.dart';
import 'BlogEditor.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Blogs'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getBlogs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final blogs = snapshot.data as List;
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(blogs[index]['title']),
                subtitle: Text('Created: ${blogs[index]['created_at']}'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlogEditor(blog: blogs[index]),
                )),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BlogEditor()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List> _getBlogs() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final response = await Supabase.instance.client
          .from('blogs')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .execute();

      if (response.error != null) {
        throw response.error!;
      }

      if (response.data == null) {
        return [];
      }

      return response.data as List;
    } catch (error) {
      print('Error fetching blogs: $error');
      return [];
    }
  }
}

extension on PostgrestTransformBuilder<PostgrestList> {
  execute() {}
}

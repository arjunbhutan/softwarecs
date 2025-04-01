/*import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic> usersData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await _database.child('users').get();
    if (snapshot.exists) {
      setState(() {
        usersData = Map<dynamic, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  Future<void> _deleteUser(String userId) async {
    await _database.child('users/$userId').remove();
    _loadData();
  }

  Future<void> _deleteCodeSnippet(String userId, String snippetId) async {
    await _database.child('users/$userId/$snippetId').remove();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: usersData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: usersData.length,
        itemBuilder: (context, index) {
          String userId = usersData.keys.elementAt(index);
          dynamic userData = usersData[userId];

          return ExpansionTile(
            title: Text(
              userData['email'] ?? 'User: $userId',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Created: ${DateTime.fromMillisecondsSinceEpoch(userData['createdAt'] ?? 0)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirm(context, 'user', userId),
            ),
            children: _buildCodeSnippets(userId, userData),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Widget> _buildCodeSnippets(String userId, dynamic userData) {
    List<Widget> snippets = [];

    userData.forEach((key, value) {
      if (key.startsWith('-')) { // Code snippet entries start with '-'
        snippets.add(
          ListTile(
            title: Text(value['name'] ?? 'Unnamed'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language: ${value['language']}'),
                Text('Description: ${value['description']}'),
                Text('Downloads: ${value['downloads'] ?? 0}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, userId, key, value),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirm(context, 'snippet', userId, key),
                ),
              ],
            ),
          ),
        );
      }
    });
    return snippets;
  }

  void _showDeleteConfirm(BuildContext context, String type, String userId, [String? snippetId]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this ${type}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (type == 'user') {
                _deleteUser(userId);
              } else {
                _deleteCodeSnippet(userId, snippetId!);
              }
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String userId, String snippetId, Map<dynamic, dynamic> data) {
    TextEditingController nameController = TextEditingController(text: data['name']);
    TextEditingController descController = TextEditingController(text: data['description']);
    TextEditingController codeController = TextEditingController(text: data['code']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Code'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _database.child('users/$userId/$snippetId').update({
                'name': nameController.text,
                'description': descController.text,
                'code': codeController.text,
              });
              _loadData();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AdminCatalogScreen extends StatefulWidget {
  const AdminCatalogScreen({Key? key}) : super(key: key);

  @override
  _AdminCatalogScreenState createState() => _AdminCatalogScreenState();
}

class _AdminCatalogScreenState extends State<AdminCatalogScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Map<dynamic, dynamic> usersData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await _database.child('users').get();
    if (snapshot.exists) {
      setState(() {
        usersData = Map<dynamic, dynamic>.from(snapshot.value as Map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[800],
        title: const Text(
          'Code Catalog Admin',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            color: Colors.white,
          ),
        ],
      ),
      body: usersData.isEmpty
          ? const Center(
          child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: usersData.entries.map((entry) {
              return _buildUserCard(entry.key, entry.value);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(String userId, dynamic userData) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userData['email'] ?? 'User: $userId',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirm(context, 'user', userId),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Created: ${DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(userData['createdAt'] ?? 0))}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 24),
            ..._buildCodeSnippets(userId, userData),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCodeSnippets(String userId, dynamic userData) {
    List<Widget> snippets = [];

    userData.forEach((key, value) {
      if (key.startsWith('-')) {
        snippets.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value['name'] ?? 'Unnamed',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[900],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Language: ${value['language']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Downloads: ${value['downloads'] ?? 0}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value['description'] ?? '',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(context, userId, key, value),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirm(context, 'snippet', userId, key),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    });
    return snippets;
  }

  void _showDeleteConfirm(BuildContext context, String type, String userId, [String? snippetId]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this ${type}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (type == 'user') {
                _database.child('users/$userId').remove();
              } else {
                _database.child('users/$userId/$snippetId').remove();
              }
              _loadData();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String userId, String snippetId, Map<dynamic, dynamic> data) {
    TextEditingController nameController = TextEditingController(text: data['name']);
    TextEditingController descController = TextEditingController(text: data['description']);
    TextEditingController codeController = TextEditingController(text: data['code']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Edit Code Snippet'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () async {
              await _database.child('users/$userId/$snippetId').update({
                'name': nameController.text,
                'description': descController.text,
                'code': codeController.text,
              });
              _loadData();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
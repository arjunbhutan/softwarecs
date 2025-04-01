import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'User_Screens.dart';
import 'create_catalogue.dart';

class CatalogueStoreScreen extends StatefulWidget {
  final String email;

  const CatalogueStoreScreen({Key? key, required this.email}) : super(key: key);

  @override

  State<CatalogueStoreScreen> createState() => _CatalogueStoreScreenState();
}

class _CatalogueStoreScreenState extends State<CatalogueStoreScreen> {
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    // Print the email when the widget is initialized
    print("Received email: ${widget.email}");
  }
  final List<Map<String, String>> _catalogItems = [
    {'name': 'Login Form', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Responsive login form with validation', 'author': 'John Doe', 'category': 'Forms', 'downloads': '2.5k'},
    {'name': 'Custom AppBar', 'languages': 'Dart, Flutter', 'type': 'Navigation', 'description': 'Animated app bar with search', 'author': 'Jane Smith', 'category': 'Navigation', 'downloads': '1.8k'},
    {'name': 'Data Grid', 'languages': 'Dart, Flutter', 'type': 'Data Display', 'description': 'Sortable data table widget', 'author': 'Mike Chen', 'category': 'Data', 'downloads': '3.1k'},
    {'name': 'Pie Chart', 'languages': 'Dart, Flutter', 'type': 'Visualization', 'description': 'Interactive pie chart component', 'author': 'Sarah Lee', 'category': 'Charts', 'downloads': '1.9k'},
    {'name': 'Dropdown Menu', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Customizable dropdown selector', 'author': 'Alex Brown', 'category': 'Forms', 'downloads': '2.2k'},
    {'name': 'Sidebar Menu', 'languages': 'Dart, Flutter', 'type': 'Navigation', 'description': 'Collapsible sidebar navigation', 'author': 'Emma Wilson', 'category': 'Navigation', 'downloads': '1.6k'},
    {'name': 'Image Carousel', 'languages': 'Dart, Flutter', 'type': 'Media', 'description': 'Smooth image slider with indicators', 'author': 'Tom Clark', 'category': 'Media', 'downloads': '2.8k'},
    {'name': 'Profile Card', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'User profile display card', 'author': 'Lisa Ray', 'category': 'Cards', 'downloads': '1.4k'},
    {'name': 'Loading Spinner', 'languages': 'Dart, Flutter', 'type': 'Animation', 'description': 'Custom loading animation', 'author': 'David Kim', 'category': 'Animations', 'downloads': '2.0k'},
    {'name': 'Alert Dialog', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Styled alert popup', 'author': 'Kelly White', 'category': 'Dialogs', 'downloads': '1.7k'},
    {'name': 'Tab Bar', 'languages': 'Dart, Flutter', 'type': 'Navigation', 'description': 'Animated tab navigation', 'author': 'Ryan Patel', 'category': 'Navigation', 'downloads': '2.3k'},
    {'name': 'Form Validator', 'languages': 'Dart', 'type': 'Utility', 'description': 'Form input validation library', 'author': 'Maria Garcia', 'category': 'Utilities', 'downloads': '3.0k'},
    {'name': 'Chat Bubble', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Chat message UI component', 'author': 'Chris Evans', 'category': 'Messaging', 'downloads': '1.5k'},
    {'name': 'Date Picker', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Custom date selection widget', 'author': 'Anna Bell', 'category': 'Forms', 'downloads': '2.1k'},
    {'name': 'Video Player', 'languages': 'Dart, Flutter', 'type': 'Media', 'description': 'Custom video playback controls', 'author': 'Peter Wong', 'category': 'Media', 'downloads': '1.9k'},
    {'name': 'Rating Stars', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Interactive rating widget', 'author': 'Sophie Turner', 'category': 'Forms', 'downloads': '1.3k'},
    {'name': 'Search Bar', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Animated search input field', 'author': 'Mark Taylor', 'category': 'Search', 'downloads': '2.4k'},
    {'name': 'Timeline View', 'languages': 'Dart, Flutter', 'type': 'Data Display', 'description': 'Event timeline component', 'author': 'Laura Adams', 'category': 'Data', 'downloads': '1.6k'},
    {'name': 'Button Set', 'languages': 'Dart, Flutter', 'type': 'UI Component', 'description': 'Styled button collection', 'author': 'James Miller', 'category': 'Buttons', 'downloads': '2.7k'},
    {'name': 'Accordion Menu', 'languages': 'Dart, Flutter', 'type': 'Navigation', 'description': 'Expandable menu widget', 'author': 'Emily Davis', 'category': 'Navigation', 'downloads': '1.8k'},
  ];

  @override
  Widget build(BuildContext context) {

    final filteredItems = _catalogItems
        .where((item) =>
    item['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item['description']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3A66DB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Catalogue Store',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF3A66DB)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersScreen()),
              );
            },
          ),

        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Component Marketplace',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Browse 20+ professional components',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search components...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF3A66DB)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF3A66DB)),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCatalogueCard(
                      name: item['name']!,
                      languages: item['languages']!,
                      type: item['type']!,
                      description: item['description']!,
                      author: item['author']!,
                      category: item['category']!,
                      downloads: item['downloads']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3A66DB),
        child: const Icon(Icons.upload_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateCatalogueScreen(email: widget.email)),
          );
        },
      ),

    );
  }

  Widget _buildCatalogueCard({
    required String name,
    required String languages,
    required String type,
    required String description,
    required String author,
    required String category,
    required String downloads,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: Color(0xFF3A66DB)),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: '// Sample code here'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(category),
                  backgroundColor: const Color(0xFFE6EEFF),
                  labelStyle: const TextStyle(color: Color(0xFF3A66DB)),
                ),
                Chip(
                  label: Text(type),
                  backgroundColor: const Color(0xFFE6FFF6),
                  labelStyle: const TextStyle(color: Color(0xFF10B981)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18, color: Color(0xFF3A66DB)),
                    const SizedBox(width: 4),
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.download_rounded, size: 18, color: Color(0xFF3A66DB)),
                    const SizedBox(width: 4),
                    Text(
                      downloads,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5568),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Languages: $languages',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Upload New Component'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Languages')),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Type')),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              TextField(decoration: const InputDecoration(labelText: 'Category')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A66DB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              // Implement upload logic here
              Navigator.pop(context);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
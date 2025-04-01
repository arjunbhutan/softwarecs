
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateCatalogueScreen extends StatefulWidget {
  final String email;
  const CreateCatalogueScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<CreateCatalogueScreen> createState() => _CreateCatalogueScreenState();
}


class _CreateCatalogueScreenState extends State<CreateCatalogueScreen> {

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _namenController = TextEditingController();
  String? _selectedLanguage;
  String? _uploadedFileName;
  late DatabaseReference _databaseRef;

  final List<String> _languages = [
    'Dart',
    'Python',
    'JavaScript',
    'Java',
    'C++',
    'Others'
  ];

  @override
  void initState() {
    print("Received email: ${widget.email}");

    super.initState();
    _databaseRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.email.replaceAll('.', '_'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Catalogue Entry'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Component',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details below to add a new component to your catalogue.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _namenController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 32),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Programming Language',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              value: _selectedLanguage,
              items: _languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Brief Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Code Snippet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: 6,
            ),

            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _submitCatalogEntry();
                    _clearForm();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Component added successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Component',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitCatalogEntry() {
    if (_selectedLanguage != null ||
        _descriptionController.text.isNotEmpty ||
        _codeController.text.isNotEmpty ||
        _uploadedFileName != null) {
      final entry = {
        'language': _selectedLanguage ?? 'Not specified',
        'description': _descriptionController.text,
        'code': _codeController.text,
        'fileName': _uploadedFileName ?? 'No file uploaded',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'name':_namenController.text,
      };
      _databaseRef.push().set(entry);
    }
  }

  void _clearForm() {
    _codeController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedLanguage = null;
      _uploadedFileName = null;
    });
  }
}

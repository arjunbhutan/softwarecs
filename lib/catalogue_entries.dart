/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatalogEntriesScreen extends StatefulWidget {
  final String email;
  const CatalogEntriesScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<CatalogEntriesScreen> createState() => _CatalogEntriesScreenState();
}

class _CatalogEntriesScreenState extends State<CatalogEntriesScreen> {
  late DatabaseReference _databaseRef;

  @override
  void initState() {
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
        title: const Text('Your Catalogue'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: _databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No catalogue entries yet.'));
          }

          Map<dynamic, dynamic> entries = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<String, dynamic>> entryList = [];
          entries.forEach((key, value) {
            entryList.add(Map<String, dynamic>.from(value));
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: entryList.length,
            itemBuilder: (context, index) {
              final entry = entryList[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Language: ${entry['language']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description: ${entry['description']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Code: ${entry['code']}',
                        style: TextStyle(color: Colors.grey[700], fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'File: ${entry['fileName']}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Added: ${DateTime.fromMillisecondsSinceEpoch(entry['timestamp']).toString()}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

 */
/*
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CatalogEntriesScreen extends StatefulWidget {
  final String email;
  const CatalogEntriesScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<CatalogEntriesScreen> createState() => _CatalogEntriesScreenState();
}

class _CatalogEntriesScreenState extends State<CatalogEntriesScreen> {
  late DatabaseReference _databaseRef;
  bool _isLoading = false;

  // Color Palette
  static const Color primaryColor = Color(0xFF2A9D8F); // Teal
  static const Color secondaryColor = Color(0xFFE76F51); // Coral
  static const Color backgroundColor = Color(0xFFF8FAFB); // Light Blue-Grey
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF264653); // Dark Teal

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.email.replaceAll('.', '_'));
  }

  Future<void> _deleteEntry(String entryId) async {
    setState(() => _isLoading = true);
    try {
      await _databaseRef.child(entryId).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted Successfully',
            style: GoogleFonts.nunito(color: Colors.white),
          ),
          backgroundColor: secondaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Oops! Something went wrong',
            style: GoogleFonts.nunito(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _editEntry(String entryId, Map<String, dynamic> entryData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntryScreen(
          email: widget.email,
          entryId: entryId,
          entryData: entryData,
        ),
      ),
    );
  }

  void _showCodeDetails(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry['fileName'] ?? 'Unnamed Code',
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey[600]),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry['language'] ?? 'Unknown',
                      style: GoogleFonts.nunito(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Description',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    entry['description'] ?? 'No description added',
                    style: GoogleFonts.nunito(fontSize: 15, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        entry['code'] ?? 'No code available',
                        style: GoogleFonts.sourceCodePro(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'My Code Library',
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : StreamBuilder(
        stream: _databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong!',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 80,
                    color: primaryColor.withOpacity(0.7),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your Library is Empty',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start by adding some code!',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_circle_outline),
                    label: Text(
                      'Add Code',
                      style: GoogleFonts.nunito(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.snapshot.value;
          Map<dynamic, dynamic> entriesMap =
          data is Map ? data : <dynamic, dynamic>{};
          List<MapEntry<dynamic, dynamic>> entries = entriesMap.entries
              .where((entry) => entry.value is Map)
              .toList();

          entries.sort((a, b) {
            int tsA = (a.value['timestamp'] is int) ? a.value['timestamp'] : 0;
            int tsB = (b.value['timestamp'] is int) ? b.value['timestamp'] : 0;
            return tsB.compareTo(tsA);
          });

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entryId = entries[index].key.toString();
              final Map<String, dynamic> entry =
              Map<String, dynamic>.from(entries[index].value);

              String codePreview = entry['code']?.toString() ?? '';
              codePreview = codePreview.length > 40
                  ? '${codePreview.substring(0, 40)}...'
                  : codePreview;

              String timeDisplay = 'Just now';
              if (entry['timestamp'] is int) {
                final date =
                DateTime.fromMillisecondsSinceEpoch(entry['timestamp']);
                final diff = DateTime.now().difference(date);
                if (diff.inDays > 0) {
                  timeDisplay = '${diff.inDays}d ago';
                } else if (diff.inHours > 0) {
                  timeDisplay = '${diff.inHours}h ago';
                } else if (diff.inMinutes > 0) {
                  timeDisplay = '${diff.inMinutes}m ago';
                }
              }

              return GestureDetector(
                onTap: () => _showCodeDetails(entry),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['fileName'] ?? 'Unnamed Code',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Text(
                              entry['description'] ?? 'No description',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    entry['language'] ?? 'Unknown',
                                    style: GoogleFonts.nunito(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  timeDisplay,
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: primaryColor),
                            onPressed: () => _editEntry(entryId, entry),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: secondaryColor),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Text(
                                  'Delete this code?',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                content: Text(
                                  'This action cannot be undone.',
                                  style: GoogleFonts.nunito(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.nunito(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Delete',
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deleteEntry(entryId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        child: Icon(Icons.add, size: 28, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tooltip: 'Add New Code',
      ),
    );
  }
}

class EditEntryScreen extends StatefulWidget {
  final String email;
  final String entryId;
  final Map<String, dynamic> entryData;

  const EditEntryScreen({
    Key? key,
    required this.email,
    required this.entryId,
    required this.entryData,
  }) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _fileNameController;
  late TextEditingController _languageController;
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color secondaryColor = Color(0xFFE76F51);
  static const Color backgroundColor = Color(0xFFF8FAFB);
  static const Color textColor = Color(0xFF264653);

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.entryData['code'] ?? '');
    _descriptionController =
        TextEditingController(text: widget.entryData['description'] ?? '');
    _fileNameController =
        TextEditingController(text: widget.entryData['fileName'] ?? '');
    _languageController =
        TextEditingController(text: widget.entryData['language'] ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _fileNameController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final databaseRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(widget.email.replaceAll('.', '_'))
          .child(widget.entryId);

      await databaseRef.update({
        'code': _codeController.text,
        'description': _descriptionController.text,
        'fileName': _fileNameController.text,
        'language': _languageController.text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Saved Successfully',
              style: GoogleFonts.nunito(color: Colors.white),
            ),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Oops! Something went wrong',
              style: GoogleFonts.nunito(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Edit Code',
          style: GoogleFonts.nunito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _isLoading ? null : _saveChanges,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _fileNameController,
                decoration: InputDecoration(
                  labelText: 'File Name',
                  labelStyle: GoogleFonts.nunito(color: textColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.title, color: primaryColor),
                ),
                style: GoogleFonts.nunito(color: textColor),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a file name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _languageController,
                decoration: InputDecoration(
                  labelText: 'Programming Language',
                  labelStyle: GoogleFonts.nunito(color: textColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.code, color: primaryColor),
                ),
                style: GoogleFonts.nunito(color: textColor),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a language' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: GoogleFonts.nunito(color: textColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.description, color: primaryColor),
                ),
                style: GoogleFonts.nunito(color: textColor),
                maxLines: 3,
                validator: (value) =>
                value!.isEmpty ? 'Please add a description' : null,
              ),
              SizedBox(height: 20),
              Text(
                'Your Code',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Paste your code here...',
                    hintStyle: GoogleFonts.sourceCodePro(
                      color: Colors.grey[400],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: GoogleFonts.sourceCodePro(color: Colors.black87),
                  maxLines: 10,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your code' : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 */
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'create_catalogue.dart';

class CatalogEntriesScreen extends StatefulWidget {
  final String email;
  const CatalogEntriesScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<CatalogEntriesScreen> createState() => _CatalogEntriesScreenState();
}

class _CatalogEntriesScreenState extends State<CatalogEntriesScreen> {
  late DatabaseReference _databaseRef;
  bool _isLoading = false;

  // Enhanced Color Palette
  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color secondaryColor = Color(0xFFE76F51);
  static const Color accentColor = Color(0xFFF4A261);
  static const Color backgroundColor = Color(0xFFF6F8FA);
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF1E2A38);


  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.email.replaceAll('.', '_'));
  }

  Future<void> _deleteEntry(String entryId) async {
    setState(() => _isLoading = true);
    try {
      await _databaseRef.child(entryId).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted Successfully', style: GoogleFonts.nunito(color: Colors.white)),
          backgroundColor: secondaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 6,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Couldn\'t delete', style: GoogleFonts.nunito(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _editEntry(String entryId, Map<String, dynamic> entryData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntryScreen(
          email: widget.email,
          entryId: entryId,
          entryData: entryData,
        ),
      ),
    );
  }

  void _showCodeDetails(Map<String, dynamic> entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FadeInUp(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundColor, cardColor],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))],
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            entry['name'] ?? 'Unnamed Code',
                            style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: textColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.grey),
                              tooltip: 'Copy code',
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: entry['code'] ?? ''));
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(Icons.check_circle, color: Colors.green),
                                          SizedBox(width: 10),
                                          Text('Success'),
                                        ],
                                      ),
                                      content: Text('You have copied it in your clipboard.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            entry['language'] ?? 'Unknown',
                            style: GoogleFonts.nunito(fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: primaryColor.withOpacity(0.15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copy All Details'),
                          onPressed: () {
                            final allContent = 'Name: ${entry['name']}\nLanguage: ${entry['language']}\nDescription: ${entry['description']}\n\nCode:\n${entry['code']}';
                            Clipboard.setData(ClipboardData(text: allContent));
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Success'),
                                    ],
                                  ),
                                  content: Text('You have copied it in your clipboard.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                          tooltip: 'Copy description',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: entry['description'] ?? ''));
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Success'),
                                    ],
                                  ),
                                  content: Text('You have copied it in your clipboard.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      entry['description'] ?? 'No description provided',
                      style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[700], height: 1.5),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.grey[600]),
                            tooltip: 'Copy code',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: entry['code'] ?? ''));
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green),
                                        SizedBox(width: 10),
                                        Text('Success'),
                                      ],
                                    ),
                                    content: Text('You have copied it in your clipboard.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              entry['code'] ?? 'No code available',
                              style: GoogleFonts.sourceCodePro(fontSize: 15, color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, Color(0xFF23887D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Code Vault',
          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : StreamBuilder(
        stream: _databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred!',
                style: GoogleFonts.nunito(fontSize: 18, color: Colors.redAccent),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(
              child: FadeIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.code_rounded, size: 100, color: primaryColor.withOpacity(0.8)),
                    const SizedBox(height: 20),
                    Text(
                      'Your Code Vault is Empty',
                      style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w800, color: textColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add some code snippets to get started!',
                      style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text('Add Code', style: GoogleFonts.nunito(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!.snapshot.value;
          Map<dynamic, dynamic> entriesMap = data is Map ? data : <dynamic, dynamic>{};
          List<MapEntry<dynamic, dynamic>> entries =
          entriesMap.entries.where((entry) => entry.value is Map).toList();

          entries.sort((a, b) {
            int tsA = (a.value['timestamp'] is int) ? a.value['timestamp'] : 0;
            int tsB = (b.value['timestamp'] is int) ? b.value['timestamp'] : 0;
            return tsB.compareTo(tsA);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entryId = entries[index].key.toString();
              final Map<String, dynamic> entry = Map<String, dynamic>.from(entries[index].value);

              String codePreview = entry['code']?.toString() ?? '';
              codePreview = codePreview.length > 50 ? '${codePreview.substring(0, 50)}...' : codePreview;

              String timeDisplay = 'Just now';
              if (entry['timestamp'] is int) {
                final date = DateTime.fromMillisecondsSinceEpoch(entry['timestamp']);
                final diff = DateTime.now().difference(date);
                if (diff.inDays > 0) {
                  timeDisplay = '${diff.inDays}d ago';
                } else if (diff.inHours > 0) {
                  timeDisplay = '${diff.inHours}h ago';
                } else if (diff.inMinutes > 0) {
                  timeDisplay = '${diff.inMinutes}m ago';
                }
              }

              return FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: GestureDetector(
                  onTap: () => _showCodeDetails(entry),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry['name'] ?? 'Unnamed Code',
                                style: GoogleFonts.nunito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                entry['description'] ?? 'No description',
                                style: GoogleFonts.nunito(fontSize: 15, color: Colors.grey[700], height: 1.4),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      entry['language'] ?? 'Unknown',
                                      style: GoogleFonts.nunito(
                                        color: primaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    backgroundColor: primaryColor.withOpacity(0.15),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    timeDisplay,
                                    style: GoogleFonts.nunito(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: primaryColor),
                              onPressed: () => _editEntry(entryId, entry),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: secondaryColor),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: Text(
                                    'Delete Code?',
                                    style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: textColor),
                                  ),
                                  content: Text(
                                    'This action is permanent.',
                                    style: GoogleFonts.nunito(color: Colors.grey[700]),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.grey[600])),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: secondaryColor,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: Text('Delete', style: GoogleFonts.nunito(color: Colors.white)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteEntry(entryId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              tooltip: 'Delete',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCatalogueScreen(email: widget.email),
            ),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        tooltip: 'Add New Code',
      ),
    );
  }
}

class EditEntryScreen extends StatefulWidget {
  final String email;
  final String entryId;
  final Map<String, dynamic> entryData;

  const EditEntryScreen({
    Key? key,
    required this.email,
    required this.entryId,
    required this.entryData,
  }) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _fileNameController;
  late TextEditingController _languageController;
  late TextEditingController _nameController;
  bool _isLoading = false;

  static const Color primaryColor = Color(0xFF2A9D8F);
  static const Color secondaryColor = Color(0xFFE76F51);
  static const Color backgroundColor = Color(0xFFF6F8FA);
  static const Color textColor = Color(0xFF1E2A38);

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.entryData['code'] ?? '');
    _descriptionController = TextEditingController(text: widget.entryData['description'] ?? '');
    _fileNameController = TextEditingController(text: widget.entryData['fileName'] ?? '');
    _nameController = TextEditingController(text: widget.entryData['name'] ?? '');
    _languageController = TextEditingController(text: widget.entryData['language'] ?? '');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _fileNameController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final databaseRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(widget.email.replaceAll('.', '_'))
          .child(widget.entryId);

      await databaseRef.update({
        'code': _codeController.text,
        'description': _descriptionController.text,
        'fileName': _fileNameController.text,
        'language': _languageController.text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved Successfully', style: GoogleFonts.nunito(color: Colors.white)),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Couldn\'t save', style: GoogleFonts.nunito(color: Colors.white)),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, Color(0xFF23887D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Edit Code Snippet',
          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _isLoading ? null : _saveChanges,
            tooltip: 'Save Changes',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _fileNameController,
                  decoration: InputDecoration(
                    labelText: 'File Name',
                    labelStyle: GoogleFonts.nunito(color: textColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.title, color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  style: GoogleFonts.nunito(color: textColor),
                  validator: (value) => value!.isEmpty ? 'Please enter a file name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _languageController,
                  decoration: InputDecoration(
                    labelText: 'Programming Language',
                    labelStyle: GoogleFonts.nunito(color: textColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.code, color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  style: GoogleFonts.nunito(color: textColor),
                  validator: (value) => value!.isEmpty ? 'Please enter a language' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.nunito(color: textColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.description, color: primaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  style: GoogleFonts.nunito(color: textColor),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please add a description' : null,
                ),
                const SizedBox(height: 25),
                Text(
                  'Your Code',
                  style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: textColor),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      hintText: 'Paste your code here...',
                      hintStyle: GoogleFonts.sourceCodePro(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                    style: GoogleFonts.sourceCodePro(fontSize: 15, color: Colors.black87),
                    maxLines: 12,
                    validator: (value) => value!.isEmpty ? 'Please enter your code' : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
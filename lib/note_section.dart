import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note_storage.dart';

class NotesSection extends StatefulWidget {
  const NotesSection({super.key});

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  final TextEditingController _noteController =
  TextEditingController();

  final NoteStorage _storage = NoteStorage();

  String _statusMessage = '';

  Future<void> _saveNote() async {
    try {
      await _storage.writeNote(_noteController.text);

      setState(() {
        _statusMessage = 'Note saved to disk!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving note: $e';
      });
    }
  }

  Future<void> _printNote() async {
    try {
      final content = await _storage.readRawContent();

      debugPrint('Saved Note Contents:\n$content');

      setState(() {
        _statusMessage = 'File contents printed to console!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error reading note: $e';
      });
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'My Notes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _noteController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type your notes here...',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: _saveNote,
            child: const Text('Save Note'),
          ),

          OutlinedButton(
            onPressed: _printNote,
            child: const Text('Print File to Console'),
          ),

          const SizedBox(height: 12),

          Text(
            _statusMessage,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
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
  String _savedNote = 'No notes saved yet.';

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  // Load existing note when the widget starts.
  Future<void> _loadNote() async {
    final note = await _storage.readNote();

    if (!mounted) return;

    setState(() {
      _savedNote = note;
      _noteController.text =
      note == 'No notes saved yet.' ? '' : note;
    });
  }

  // Save note to disk and update display.
  Future<void> _saveNote() async {
    try {
      final text = _noteController.text;

      await _storage.writeNote(text);

      if (!mounted) return;

      setState(() {
        _savedNote = text;
        _statusMessage = 'Note saved to disk!';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statusMessage = 'Error saving note: $e';
      });
    }
  }

  // Read note from disk.
  Future<void> _printNote() async {
    try {
      final content = await _storage.readNote();

      debugPrint('Saved Note Contents:\n$content');

      if (!mounted) return;

      setState(() {
        _statusMessage = 'File contents printed to console!';
      });
    } catch (e) {
      if (!mounted) return;

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

          const SizedBox(height: 20),

          // Display saved note.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saved Note',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(_savedNote),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
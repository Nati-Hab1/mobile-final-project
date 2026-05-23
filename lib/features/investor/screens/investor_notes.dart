import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';
import 'package:menesha/core/network/dio_client.dart';
import 'package:menesha/core/constants/api_constants.dart';
import 'package:menesha/core/utils/secure_storage.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

class InvestorNotes extends ConsumerStatefulWidget {
  const InvestorNotes({super.key, required this.role});
  final String role;

  @override
  ConsumerState<InvestorNotes> createState() =>
      _InvestorNotesState();
}

class _InvestorNotesState
    extends ConsumerState<InvestorNotes> {
  late TextEditingController _noteController;
  int? _bookmarkId;
  String? _startupName;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get data passed from bookmarks page using GoRouter's extra parameter
    final extra = GoRouterState.of(context).extra as Map?;
    if (extra != null) {
      _bookmarkId = extra['bookmarkId'];
      _startupName = extra['startupName'];
      final currentNote = extra['currentNote'] ?? '';

      _noteController =
          TextEditingController(text: currentNote);
    } else {
      _noteController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_bookmarkId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error: No bookmark selected'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final token = await SecureStorage.getInvestorToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      // Update the note for the bookmark
      final response = await DioClient.patch(
        ApiConstants.bookmarkById(_bookmarkId!),
        data: {
          'note': _noteController.text.trim(),
        },
      );

      if (response.data['success'] == true) {
        _showSavedDialog();
      } else {
        throw Exception(response.data['message'] ??
            'Failed to save note');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${e.toString().replaceFirst('Exception: ', '')}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showSavedDialog() {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(255, 232, 230, 230)
          .withOpacity(0.3),
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(
                      color: Color(0xFF0022BA), width: 2),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Color(0xFF20C997),
                          size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        "Note Saved",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your note for $_startupName has been saved",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.goNamed('bookmarks');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF3F48CC),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        10)),
                          ),
                          child: const Text("Close",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(
        ClipboardData(text: _noteController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Note copied to clipboard'),
          duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                const Header(role: 'investor'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () =>
                              context.goNamed('bookmarks'),
                          icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.white),
                          label: const Text("Back",
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      ),
                      const Text(
                        "Notes",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Add a note on your bookmarked startup",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          _startupName ?? 'Startup',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                            height: 30, thickness: 1),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Colors.grey.shade300),
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              TextField(
                                controller: _noteController,
                                maxLines: 10,
                                decoration:
                                    const InputDecoration(
                                  hintText:
                                      'Write your notes here...',
                                  border: InputBorder.none,
                                ),
                              ),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(
                                    Icons.drag_handle,
                                    size: 16,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _buildMiniAction(context,
                                Icons.copy_outlined, "Copy",
                                onTap: _copyToClipboard),
                            const SizedBox(width: 10),
                            _buildMiniAction(
                                context, null, "Clear",
                                onTap: () => _noteController
                                    .clear()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _isSaving ? null : _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF0022BA),
                            foregroundColor: Colors.white,
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12)),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color:
                                              Colors.white))
                              : const Text("Save",
                                  style: TextStyle(
                                      fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding:
                                const EdgeInsets.symmetric(
                                    vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12)),
                          ),
                          child: const Text("Back",
                              style:
                                  TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAction(
      BuildContext context, IconData? icon, String label,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 4),
            ],
            Text(label,
                style:
                    TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

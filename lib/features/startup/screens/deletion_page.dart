import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeleteAccountPage(),
    );
  }
}

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  String? _selectedReason;

  final _reasons = [
    'I Have A Privacy Concern',
    'I No Longer Need The Account',
    'I Have A Duplicate Account',
    'I Have A Security Concern',
    'Other',
  ];

  // Shared dialog shell
  void _showDialog(BuildContext context, Widget content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.blue.shade900, width: 3),
        ),
        child: Padding(padding: const EdgeInsets.all(24), child: content),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    _showDialog(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Are You Sure You Want To\nDelete Your Account?",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 20),
          _badgeIcon(
            Icons.person_outline,
            Colors.grey,
            Icon(Icons.close, color: Colors.white, size: 14),
            Colors.red,
          ),
          SizedBox(height: 16),
          Text(
            "By Deleting Your Account You Will Lose Your Data Permanently.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Back"),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    showSuccessDialog(context);
                  },
                  child: Text("Delete"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    _showDialog(
      context,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _badgeIcon(
            null,
            Colors.grey.shade300,
            Icon(Icons.check, color: Colors.white, size: 12),
            Colors.grey.shade500,
            mainIcon: Icon(Icons.check, color: Colors.white, size: 36),
          ),
          SizedBox(height: 16),
          Text(
            "Successfully!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 8),
          Text(
            "Your Account Has Been Successfully Deleted, We're Sorry To See You Go",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badgeIcon(
    IconData? icon,
    Color bgColor,
    Widget badgeChild,
    Color badgeColor, {
    Widget? mainIcon,
  }) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: icon != null ? Colors.transparent : bgColor,
            child: mainIcon ?? Icon(icon, color: bgColor, size: 60),
          ),
          if (icon != null) Icon(icon, color: bgColor, size: 60),
          Positioned(
            right: 0,
            bottom: 2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(child: badgeChild),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A6FA8), Color(0xFF3F5C8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              //Custom header
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Image.asset('assets/images/me.png', height: 100),
                  ],
                ),
              ),

              // Title bar
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Delete Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Main page person + ! icon
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 60,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '!',
                                    style: TextStyle(
                                      color: Color(0xFF3F5C8A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tell Us The Reason For Closing Your Account ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedReason,
                              hint: Text(
                                'I Have A Privacy Concern',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                              ),
                              items: _reasons
                                  .map(
                                    (r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedReason = val),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Things To Check When Deleting Your Account:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      buildChecklistBox(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => showConfirmationDialog(context),
                        child: Text("Delete"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChecklistBox() {
    final items = [
      'You Can\'t Log In To Application With This Account After Deleting It.',
      'You Can\'t Register A New Account Using The Email Address Linked To This Account.',
      'Your Requests And Other Related Data Will Be Deleted Permanently.',
      'Your Account Will Be Permanently Deleted In 14 Days.',
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .expand(
              (text) => [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                if (text != items.last) SizedBox(height: 12),
              ],
            )
            .toList(),
      ),
    );
  }
}

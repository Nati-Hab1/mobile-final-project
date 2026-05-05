import 'package:flutter/material.dart';
import 'package:menesha/core/widgets/common/startup_appbar.dart';

class CreateIntro extends StatelessWidget {
  const CreateIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateIntroPage(),
    );
  }
}

class CreateIntroPage extends StatelessWidget {
  const CreateIntroPage({super.key});

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.blue.shade900, width: 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Intro Sent",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StartupAppbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A6FA8), Color(0xFF3F5C8A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),

                Text(
                  "Create Intro Drafts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Create and customize your investor introductions before sending.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),

                SizedBox(height: 20),

                // Card 1
                buildCard(
                  title: "Abebe Beso",
                  content:
                      "• We help companies reduce churn by 40% with AI\n• Already working with 50+ enterprise customers\n• Raising \$1M series A",
                ),

                // Card 2
                buildCard(
                  title: "kebedechala@gmail.com",
                  content:
                      "Hi Kebede,\n\nI wanted to introduce you to a fintech platform that's solving payment reconciliation for B2B companies. They've already seen 3x revenue growth in 6 months.\n\nCheck out their pitch:[https://abc.com]\n\nBest,\nFounder",
                ),

                const SizedBox(height: 30),

                // Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade900,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => showSuccessDialog(context),
                          child: Text("Send"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {},
                          child: Text("Back"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard({required String title, required String content}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(content),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton(onPressed: () {}, child: Text("Copy")),
              SizedBox(width: 10),
              OutlinedButton(onPressed: () {}, child: Text("Edit")),
            ],
          ),
        ],
      ),
    );
  }
}

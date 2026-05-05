import 'package:flutter/material.dart';
import 'package:menesha/core/widgets/common/startup_appbar.dart';

class MyStartup extends StatelessWidget {
  const MyStartup({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyStartupsPage(),
    );
  }
}

class MyStartupsPage extends StatefulWidget {
  const MyStartupsPage({super.key});
  @override
  State<MyStartupsPage> createState() => _MyStartupsPageState();
}

class _MyStartupsPageState extends State<MyStartupsPage> {
  List<Map<String, dynamic>> startups = [
    {
      "name": "Startup 1",
      "desc": "We help SaaS Companies reduce churn by 40%",
      "intros": 17,
      "investors": 9,
    },
  ];

  void showDeleteDialog(int index) {
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
                  backgroundColor: Colors.red,
                  child: Icon(Icons.error, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Confirm delete: Are you sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          startups.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Yes"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                  ],
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
          child: Column(
            children: [
              SizedBox(height: 20),

              Text(
                "My Startups",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Manage your startup profiles",
                style: TextStyle(color: Colors.white70),
              ),

              SizedBox(height: 16),

              // New Intro Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(61, 61, 180, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.add),
                    label: Text("New Intro"),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // List
              Expanded(
                child: ListView.builder(
                  itemCount: startups.length,
                  itemBuilder: (context, index) {
                    final item = startups[index];

                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(item["desc"]),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Intros Sent"),
                                        Text(
                                          item["intros"].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 40),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Investors"),
                                        Text(
                                          item["investors"].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Delete button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => showDeleteDialog(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

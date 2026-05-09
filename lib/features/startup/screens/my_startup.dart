import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:menesha/core/widgets/common/header.dart';

class MyStartups extends StatelessWidget {
  const MyStartups({
    super.key,
    required this.role,
  });

  final String role;

  // Static startup list
  static final List<Map<String, dynamic>> startups = [
    {
      "name": "Startup 1",
      "desc": "We help SaaS Companies reduce churn by 40%",
      "intros": 17,
      "investors": 9,
    },
  ];

  // Delete confirmation dialog
  void showDeleteDialog(
    BuildContext context,
    int index,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.blue.shade900,
              width: 3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Confirm delete: Are you sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(75, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        // Only closes dialog
                        context.pop();
                      },
                      child: const Text("Yes"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(75, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text("No"),
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
      appBar: Header(role: role),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "My Startups",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Manage your startup profiles",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 16),

              // New Intro Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                        61,
                        61,
                        180,
                        1,
                      ),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(
                        "createIntro",
                        pathParameters: {
                          "role": "startup",
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("New Intro"),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Startup list
              Expanded(
                child: ListView.builder(
                  itemCount: startups.length,
                  itemBuilder: (context, index) {
                    final item = startups[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(16),
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
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(item["desc"]),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Intros Sent",
                                        ),
                                        Text(
                                          item["intros"].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 80,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Investors",
                                        ),
                                        Text(
                                          item["investors"].toString(),
                                          style: const TextStyle(
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
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDeleteDialog(
                                  context,
                                  index,
                                );
                              },
                            ),
                          )
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

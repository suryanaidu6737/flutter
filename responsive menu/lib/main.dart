import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // =========================
        // RESPONSIVE APP BAR
        // =========================
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            "Responsive UI",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          // MOBILE
          leading: width < 600
              ? PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 30,
                  ),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: "Home",
                        child: Text("Home"),
                      ),
                      const PopupMenuItem(
                        value: "About",
                        child: Text("About"),
                      ),
                      const PopupMenuItem(
                        value: "Services",
                        child: Text("Services"),
                      ),
                      const PopupMenuItem(
                        value: "Contact",
                        child: Text("Contact"),
                      ),
                    ];
                  },
                )
              : null,

          // DESKTOP MENU
          actions: width >= 600
              ? [
                  menuItem("Home"),
                  menuItem("About"),
                  menuItem("Services"),
                  menuItem("Contact"),
                  const SizedBox(width: 20),
                ]
              : null,
        ),

        // =========================
        // BODY
        // =========================
        body: Stack(
          children: [
            // Background wallpaper
            Positioned.fill(
              child: Image.asset(
                'assets/background.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // Screen text
            Center(
              child: Text(
                width < 600 ? "Mobile Screen" : "Large Screen",
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Desktop menu item
  static Widget menuItem(String title) {
    return TextButton(
      onPressed: () {
        print(title);
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}

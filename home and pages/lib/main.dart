import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Responsive UI",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        useMaterial3: true,
      ),
      home: const MenuHomePage(),
    );
  }
}

// =====================================================
// MAIN PAGE
// =====================================================

class MenuHomePage extends StatelessWidget {
  const MenuHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
        elevation: 2,

        title: const Text(
          "Responsive UI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // =========================
        // MOBILE MENU
        // =========================
        leading: width < 600
            ? PopupMenuButton<String>(
                icon: const Icon(
                  Icons.menu,
                  size: 28,
                ),
                onSelected: (value) {
                  if (value == "Home") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  } else if (value == "Services") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicesPage(),
                      ),
                    );
                  } else if (value == "Feedback") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeedbackPage(),
                      ),
                    );
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: "Home",
                      child: Row(
                        children: [
                          Icon(Icons.home_outlined),
                          SizedBox(width: 10),
                          Text("Home"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "Services",
                      child: Row(
                        children: [
                          Icon(Icons.miscellaneous_services_outlined),
                          SizedBox(width: 10),
                          Text("Services"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: "Feedback",
                      child: Row(
                        children: [
                          Icon(Icons.feedback_outlined),
                          SizedBox(width: 10),
                          Text("Feedback"),
                        ],
                      ),
                    ),
                  ];
                },
              )
            : null,

        // =========================
        // DESKTOP MENU
        // =========================
        actions: width >= 600
            ? [
                menuItem(context, "Home"),
                menuItem(context, "Services"),
                menuItem(context, "Feedback"),
                const SizedBox(width: 15),
              ]
            : null,
      ),

      // =========================
      // BODY
      // =========================
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.35),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                width < 600 ? "Mobile Screen" : "Large Screen",
                style: const TextStyle(
                  fontSize: 25,
                  color: Color(0xFF263238),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DESKTOP MENU ITEM
  // =====================================================

  static Widget menuItem(
    BuildContext context,
    String title,
  ) {
    return TextButton(
      onPressed: () {
        if (title == "Home") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else if (title == "Services") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServicesPage(),
            ),
          );
        } else if (title == "Feedback") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FeedbackPage(),
            ),
          );
        }
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

// =====================================================
// HOME PAGE
// =====================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "Welcome to the Home Page",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// SERVICES PAGE
// =====================================================

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
        title: const Text(
          "Services",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.miscellaneous_services,
                  size: 55,
                  color: Color(0xFF3949AB),
                ),
                SizedBox(height: 15),
                Text(
                  "Our Services",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "• Web Development\n"
                  "• Mobile App Development\n"
                  "• UI/UX Design\n"
                  "• Cloud Services",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.8,
                    color: Color(0xFF546E7A),
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

// =====================================================
// FEEDBACK PAGE
// =====================================================

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // TextEditingController
  final TextEditingController feedbackController = TextEditingController();

  String message = "";

  // =====================================================
  // SUBMIT FEEDBACK
  // =====================================================

  void submitFeedback() {
    String feedback = feedbackController.text.trim();

    if (feedback.isNotEmpty) {
      setState(() {
        message = "Feedback Submitted";
      });

      feedbackController.clear();
    } else {
      setState(() {
        message = "Please enter your feedback";
      });
    }
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check screen orientation
    final orientation = MediaQuery.of(context).orientation;

    final bool isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3949AB),
        foregroundColor: Colors.white,
        title: const Text(
          "Feedback",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? 60 : 20,
            vertical: isLandscape ? 15 : 30,
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            padding: EdgeInsets.all(
              isLandscape ? 22 : 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // =========================
                // ICON
                // =========================

                const Icon(
                  Icons.rate_review_outlined,
                  size: 42,
                  color: Color(0xFF3949AB),
                ),

                const SizedBox(height: 8),

                // =========================
                // TITLE
                // =========================

                const Text(
                  "Share Your Feedback",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "We would love to hear your thoughts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF78909C),
                  ),
                ),

                const SizedBox(height: 18),

                // =========================
                // TEXT FIELD
                // =========================

                TextField(
                  controller: feedbackController,
                  maxLines: isLandscape ? 3 : 4,
                  decoration: InputDecoration(
                    hintText: "Write your feedback here...",
                    hintStyle: const TextStyle(
                      color: Color(0xFF90A4AE),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF7F8FC),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFCFD8DC),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFCFD8DC),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF3949AB),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // =========================
                // SUBMIT BUTTON
                // =========================

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3949AB),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Submit Feedback",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // =========================
                // RESULT MESSAGE
                // =========================

                if (message.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: message == "Feedback Submitted"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SmartWaterApp());
}

class SmartWaterApp extends StatelessWidget {
  const SmartWaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Water Tracker',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A8E8),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ------------------------------------------------------------
// MODEL
// ------------------------------------------------------------

class WaterEntry {
  final int amount;
  final String time;

  WaterEntry({
    required this.amount,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'time': time,
    };
  }

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      amount: json['amount'],
      time: json['time'],
    );
  }
}

// ------------------------------------------------------------
// HOME SCREEN
// ------------------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int dailyGoal = 2000;
  int totalConsumed = 0;

  List<WaterEntry> entries = [];

  static const Color darkBlue = Color(0xFF0066A1);
  static const Color brightBlue = Color(0xFF00A8E8);
  static const Color cyan = Color(0xFF00C6D7);
  static const Color lightBlue = Color(0xFFE6F7FC);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ----------------------------------------------------------
  // STORAGE
  // ----------------------------------------------------------

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedGoal = prefs.getInt('dailyGoal') ?? 2000;
    final savedConsumed = prefs.getInt('totalConsumed') ?? 0;
    final savedEntries = prefs.getString('entries');

    List<WaterEntry> loadedEntries = [];

    if (savedEntries != null) {
      final List<dynamic> data = jsonDecode(savedEntries);

      loadedEntries = data.map((item) => WaterEntry.fromJson(item)).toList();
    }

    setState(() {
      dailyGoal = savedGoal;
      totalConsumed = savedConsumed;
      entries = loadedEntries;
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('dailyGoal', dailyGoal);
    await prefs.setInt('totalConsumed', totalConsumed);

    final data = entries.map((entry) => entry.toJson()).toList();

    await prefs.setString('entries', jsonEncode(data));
  }

  // ----------------------------------------------------------
  // CALCULATIONS
  // ----------------------------------------------------------

  int get remainingWater {
    final value = dailyGoal - totalConsumed;
    return value > 0 ? value : 0;
  }

  double get completionPercentage {
    if (dailyGoal <= 0) return 0;

    return ((totalConsumed / dailyGoal) * 100).clamp(0, 100);
  }

  double get progress {
    if (dailyGoal <= 0) return 0;

    return (totalConsumed / dailyGoal).clamp(0.0, 1.0);
  }

  // ----------------------------------------------------------
  // ADD WATER
  // ----------------------------------------------------------

  Future<void> addWater(int amount) async {
    if (amount <= 0) {
      showMessage('Please enter a value greater than 0 mL.');
      return;
    }

    setState(() {
      totalConsumed += amount;

      entries.insert(
        0,
        WaterEntry(
          amount: amount,
          time: TimeOfDay.now().format(context),
        ),
      );
    });

    await saveData();

    showMessage('$amount mL added successfully 💧');
  }

  // ----------------------------------------------------------
  // CUSTOM INPUT
  // ----------------------------------------------------------

  void showAddWaterDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Add Water 💧',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Water amount',
              suffixText: 'mL',
              filled: true,
              fillColor: lightBlue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brightBlue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final amount = int.tryParse(controller.text);

                if (amount == null || amount <= 0) {
                  showMessage(
                    'Enter a value greater than 0 mL.',
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                addWater(amount);
              },
              child: const Text('Add Water'),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // RESET
  // ----------------------------------------------------------

  void showResetConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Reset Today?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to remove all water '
            'entries recorded today?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE05252),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await resetData();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  Future<void> resetData() async {
    setState(() {
      totalConsumed = 0;
      entries.clear();
    });

    await saveData();

    showMessage('Today\'s intake has been reset.');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;

            return Column(
              children: [
                // COMPACT HEADER
                buildHeader(isLandscape),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLandscape ? 28 : 16,
                      vertical: 16,
                    ),
                    child: isLandscape
                        ? buildLandscapeLayout()
                        : buildPortraitLayout(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // COMPACT HEADER
  // ----------------------------------------------------------

  Widget buildHeader(bool isLandscape) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 30 : 20,
        vertical: isLandscape ? 12 : 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            darkBlue,
            brightBlue,
            cyan,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay Hydrated',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Small sips. Better days.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // RESET
          IconButton(
            tooltip: 'Reset',
            onPressed: showResetConfirmation,
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PORTRAIT
  // ----------------------------------------------------------

  Widget buildPortraitLayout() {
    return Column(
      children: [
        buildProgressCard(),
        const SizedBox(height: 16),
        buildStatistics(),
        const SizedBox(height: 24),
        buildQuickAdd(),
        const SizedBox(height: 26),
        buildEntries(),
        const SizedBox(height: 15),
        buildResetButton(),
        const SizedBox(height: 10),
      ],
    );
  }

  // ----------------------------------------------------------
  // LANDSCAPE
  // ----------------------------------------------------------

  Widget buildLandscapeLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  buildProgressCard(),
                  const SizedBox(height: 15),
                  buildStatistics(),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // RIGHT SIDE
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  buildQuickAdd(),
                  const SizedBox(height: 20),
                  buildEntries(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        buildResetButton(),
        const SizedBox(height: 10),
      ],
    );
  }

  // ----------------------------------------------------------
  // PROGRESS CARD
  // ----------------------------------------------------------

  Widget buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE6F8FF),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: brightBlue.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Today\'s Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 160,
            width: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 160,
                  width: 160,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: Colors.blue.shade50,
                    valueColor: const AlwaysStoppedAnimation(
                      brightBlue,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${completionPercentage.round()}%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '$totalConsumed mL',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
          Text(
            'of $dailyGoal mL daily goal',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STATISTICS
  // ----------------------------------------------------------

  Widget buildStatistics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: statCard(
                'Consumed',
                '$totalConsumed mL',
                Icons.water_drop,
                brightBlue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: statCard(
                'Remaining',
                '$remainingWater mL',
                Icons.hourglass_bottom,
                const Color(0xFFFFA62B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: statCard(
                'Entries',
                '${entries.length}',
                Icons.local_drink,
                const Color(0xFF20B486),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: statCard(
                'Goal',
                '$dailyGoal mL',
                Icons.flag,
                const Color(0xFF8E67D4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // QUICK ADD
  // ----------------------------------------------------------

  Widget buildQuickAdd() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Add',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B52),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: quickButton(
                  250,
                  brightBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: quickButton(
                  500,
                  darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: showAddWaterDialog,
              icon: const Icon(Icons.add),
              label: const Text('Custom Amount'),
              style: OutlinedButton.styleFrom(
                foregroundColor: darkBlue,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                side: const BorderSide(
                  color: Color(0xFFBDEAF5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ENTRIES
  // ----------------------------------------------------------

  Widget buildEntries() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today\'s Intake',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123B52),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${entries.length}',
                  style: const TextStyle(
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 40,
                      color: brightBlue,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'No water recorded yet',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FBFD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.water_drop,
                      color: brightBlue,
                    ),
                    title: Text(
                      '${entry.amount} mL',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(entry.time),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF20B486),
                      size: 20,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // RESET BUTTON
  // ----------------------------------------------------------

  Widget buildResetButton() {
    return TextButton.icon(
      onPressed: showResetConfirmation,
      icon: const Icon(
        Icons.refresh,
        color: Color(0xFFE05252),
      ),
      label: const Text(
        'Reset Today\'s Intake',
        style: TextStyle(
          color: Color(0xFFE05252),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // STAT CARD
  // ----------------------------------------------------------

  Widget statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // QUICK BUTTON
  // ----------------------------------------------------------

  Widget quickButton(int amount, Color color) {
    return ElevatedButton(
      onPressed: () {
        addWater(amount);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        '+ $amount mL',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

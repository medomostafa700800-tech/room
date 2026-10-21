import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const NetGuardApp());
}

class NetGuardApp extends StatelessWidget {
  const NetGuardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NetGuard Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primarySwatch: Colors.blue,
      ),
      home: const RoomSelectionScreen(),
    );
  }
}

class RoomSelectionScreen extends StatefulWidget {
  const RoomSelectionScreen({Key? key}) : super(key: key);

  @override
  _RoomSelectionScreenState createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  final TextEditingController roomController = TextEditingController();

  void joinRoom() {
    String roomCode = roomController.text.trim();
    if (roomCode.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen(roomCode: roomCode)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'NetGuard Pro',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              const Text(
                'أدخل كود الغرفة للاتصال بالشبكة وإدارة الباقة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: roomController,
                decoration: InputDecoration(
                  labelText: 'كود الغرفة (مثال: 12345)',
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: joinRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('دخول الغرفة', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String roomCode;
  const DashboardScreen({Key? key, required this.roomCode}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double usedGb = 6.4;
  double limitGb = 10.0;
  bool isBlocked = false;

  void toggleVpnBlock(bool value) {
    setState(() {
      isBlocked = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = usedGb / limitGb;
    if (progress > 1.0) progress = 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('غرفة رقم: ${widget.roomCode}'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('استهلاكك من الباقة', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text('$usedGb GB / $limitGb GB', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[800],
                    color: isBlocked ? Colors.red : Colors.blueAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('حظر الإنترنت (VPN محلي)', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('قطع النت عن الجهاز عند نفاد الباقة', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Switch(
                    value: isBlocked,
                    onChanged: toggleVpnBlock,
                    activeColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


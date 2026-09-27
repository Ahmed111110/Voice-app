import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

void main() {
  runApp(const VoiceApp());
}

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomIdController = TextEditingController(text: '100');
  final TextEditingController _userNameController = TextEditingController(text: 'أنس');
  bool isHost = true;
  final String userId = Random().nextInt(1000000).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الغرف الصوتية الحية', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurpleAccent.withOpacity(0.15),
              ),
              child: const Icon(Icons.record_voice_over, size: 70, color: Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 24),
            const Text(
              'سهرة الأصدقاء الصوتية',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'صوت مباشر بتقنية ZEGOCLOUD وبدون تأخير',
              style: TextStyle(fontSize: 13, color: Colors.white54),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _userNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'اسمك المستعار',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.person, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: const Color(0xFF1E1B38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomIdController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'رقم الغرفة (Room ID)',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.meeting_room, color: Colors.deepPurpleAccent),
                filled: true,
                fillColor: const Color(0xFF1E1B38),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isHost ? Colors.deepPurpleAccent : const Color(0xFF1E1B38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => setState(() => isHost = true),
                    child: Text('صاحب الغرفة (Host)', style: TextStyle(color: isHost ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isHost ? Colors.deepPurpleAccent : const Color(0xFF1E1B38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => setState(() => isHost = false),
                    child: Text('ضيف / مستمع', style: TextStyle(color: !isHost ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  if (_roomIdController.text.trim().isEmpty || _userNameController.text.trim().isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveAudioRoomPage(
                        roomID: _roomIdController.text.trim(),
                        isHost: isHost,
                        userId: userId,
                        userName: _userNameController.text.trim(),
                      ),
                    ),
                  );
                },
                child: const Text('دخول الغرفة الآن 🎙️', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveAudioRoomPage extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final String userId;
  final String userName;

  const LiveAudioRoomPage({
    super.key,
    required this.roomID,
    required this.isHost,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: 519145504,
        appSign: '4492c846daf92639ffdf76e508d550396adb95793a662ce6ee32f8249f96a38b',
        userID: userId,
        userName: userName,
        roomID: roomID,
        config: (isHost
            ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
            : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()),
      ),
    );
  }
}

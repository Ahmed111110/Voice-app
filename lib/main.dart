import 'package:flutter/material.dart';

void main() {
  runApp(const VoiceRoomApp());
}

class VoiceRoomApp extends StatelessWidget {
  const VoiceRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Room',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
      ),
      home: const LiveAudioRoomScreen(),
    );
  }
}

class LiveAudioRoomScreen extends StatefulWidget {
  const LiveAudioRoomScreen({super.key});

  @override
  State<LiveAudioRoomScreen> createState() => _LiveAudioRoomScreenState();
}

class _LiveAudioRoomScreenState extends State<LiveAudioRoomScreen> {
  bool isMuted = false;
  int? activeMicIndex = 0; // مقعد المضيف نشط افتراضياً

  final List<String> messages = [
    'النظام: مرحباً بكم في الغرفة الصوتية 🎉',
    'أنس: السلام عليكم جميعاً، منورين الروم!',
  ];
  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    if (_msgController.text.trim().isNotEmpty) {
      setState(() {
        messages.add('أنا: ${_msgController.text.trim()}');
        _msgController.clear();
      });
    }
  }

  void _showGiftSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1B38),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إرسال هدية 🎁',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  children: [
                    _buildGiftItem('🌹', 'وردة', '10'),
                    _buildGiftItem('👑', 'تاج فخم', '500'),
                    _buildGiftItem('🚀', 'صاروخ', '1000'),
                    _buildGiftItem('🏎️', 'سيارة رياضية', '2500'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGiftItem(String emoji, String name, String price) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 28)),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text('$price 🪙', style: const TextStyle(fontSize: 10, color: Colors.amberAccent)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('سهرة الأصدقاء ✨', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('ID: 882910 • 14 مستمع', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // شبكة المقاعد الصوتية (8 مقاعد)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                final bool isTaken = (index == 0); // مقعد المضيف محجوز
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      activeMicIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: isTaken ? Colors.deepPurpleAccent : Colors.white.withOpacity(0.08),
                            child: isTaken
                                ? const Icon(Icons.person, size: 34, color: Colors.white)
                                : const Icon(Icons.mic_none, size: 28, color: Colors.white38),
                          ),
                          if (isTaken)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: isMuted ? Colors.red : Colors.green,
                                child: Icon(
                                  isMuted ? Icons.mic_off : Icons.mic,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isTaken ? 'المضيف' : 'مقعد ${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isTaken ? Colors.white : Colors.white54,
                          fontWeight: isTaken ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Spacer(),

          // منطقة الشات النصي التفاعلي
          Container(
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                );
              },
            ),
          ),

          // شريط التحكم السفلي
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF16132D),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgController,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: const InputDecoration(
                              hintText: 'اكتب رسالة...',
                              hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, size: 18, color: Colors.deepPurpleAccent),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isMuted = !isMuted;
                    });
                  },
                  icon: CircleAvatar(
                    backgroundColor: isMuted ? Colors.redAccent.withOpacity(0.2) : Colors.white.withOpacity(0.08),
                    child: Icon(
                      isMuted ? Icons.mic_off : Icons.mic,
                      color: isMuted ? Colors.redAccent : Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showGiftSheet,
                  icon: const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.card_giftcard, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

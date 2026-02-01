import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const SkyLabDragonApp());

class SkyLabDragonApp extends StatefulWidget {
  const SkyLabDragonApp({super.key});
  @override
  State<SkyLabDragonApp> createState() => _SkyLabDragonAppState();
}

class _SkyLabDragonAppState extends State<SkyLabDragonApp> {
  bool isArabic = true;
  void toggleLang() => setState(() => isArabic = !isArabic);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070B10),
        primaryColor: Colors.cyanAccent,
      ),
      home: MainNavigation(isArabic: isArabic, onLangToggle: toggleLang),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onLangToggle;
  const MainNavigation({super.key, required this.isArabic, required this.onLangToggle});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  String txt(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InvestmentTab(isArabic: widget.isArabic),
      ReferralTab(isArabic: widget.isArabic),
      SupportTab(isArabic: widget.isArabic),
      ProfileTab(isArabic: widget.isArabic),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text(txt("سكاي لاب - SKY LAB", "SKY LAB WORLD"), style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(onPressed: widget.onLangToggle, icon: const Icon(Icons.translate, color: Colors.cyanAccent)),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F151C),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white24,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.bolt), label: txt("الاستثمار", "Invest")),
          BottomNavigationBarItem(icon: const Icon(Icons.account_tree), label: txt("الإحالات", "Team")),
          BottomNavigationBarItem(icon: const Icon(Icons.headset_mic), label: txt("الدعم", "Support")),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: txt("حسابي", "Profile")),
        ],
      ),
    );
  }
}

// --- صفحة الاستثمار (مستوحاة من الفيديو) ---
class InvestmentTab extends StatefulWidget {
  final bool isArabic;
  const InvestmentTab({super.key, required this.isArabic});
  @override
  State<InvestmentTab> createState() => _InvestmentTabState();
}

class _InvestmentTabState extends State<InvestmentTab> {
  double liveBalance = 15.21667;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (t) => setState(() => liveBalance += 0.00015));
  }

  @override
  Widget build(BuildContext context) {
    String txt(String ar, String en) => widget.isArabic ? ar : en;
    return ListView(padding: const EdgeInsets.all(15), children: [
      _buildBalanceCard(txt),
      const SizedBox(height: 20),
      _sectionTitle(txt("باقات الاستثمار المتاحة", "Available Plans")),
      _planCard("VIP 1", 50, 1.08, 396),
      _planCard("VIP 2", 100, 2.17, 792),
      _planCard("VIP 3", 500, 10.85, 3960),
    ]);
  }

  Widget _buildBalanceCard(Function txt) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF1B2430), Color(0xFF0D1219)]),
      borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
    ),
    child: Column(children: [
      Text(txt("الأرباح المتراكمة", "Accumulated Profits"), style: const TextStyle(color: Colors.white38)),
      Text("\$${liveBalance.toStringAsFixed(6)}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      const SizedBox(height: 15),
      ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), child: Text(txt("نقل الأرباح للمحفظة", "Collect to Wallet"), style: const TextStyle(color: Colors.black))),
    ]),
  );

  Widget _planCard(String n, double p, double d, double y) => Card(
    color: const Color(0xFF151C24), margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      title: Text(n, style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      subtitle: Text("Daily: \$$d | Yearly: \$$y", style: const TextStyle(fontSize: 10, color: Colors.white54)),
      trailing: Text("\$$p", style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget _sectionTitle(String t) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
}

// --- صفحة الدعم الفني (3 أقسام كما في الفيديو) ---
class SupportTab extends StatelessWidget {
  final bool isArabic;
  const SupportTab({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    String txt(String ar, String en) => isArabic ? ar : en;
    return ListView(padding: const EdgeInsets.all(20), children: [
      _supportCard(txt("القسم المالي", "Finance Dept"), txt("للإيداع والسحب", "Deposit & Withdraw"), Icons.wallet),
      _supportCard(txt("الإدارة", "Administration"), txt("للشكاوى المباشرة", "Direct Complaints"), Icons.admin_panel_settings),
      _supportCard(txt("الدعم الفني", "Tech Support"), txt("للمشاكل التقنية", "Technical Issues"), Icons.settings_suggest),
    ]);
  }

  Widget _supportCard(String t, String s, IconData i) => Card(
    color: const Color(0xFF151C24),
    child: ListTile(
      leading: Icon(i, color: Colors.cyanAccent),
      title: Text(t, style: const TextStyle(color: Colors.white)),
      subtitle: Text(s, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
    ),
  );
}

// --- صفحة الإحالات 3 أجيال ---
class ReferralTab extends StatelessWidget {
  final bool isArabic;
  const ReferralTab({super.key, required this.isArabic});
  @override
  Widget build(BuildContext context) {
    String txt(String ar, String en) => isArabic ? ar : en;
    return Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      _refLevel(txt("الجيل الأول", "Level 1"), "7%", Colors.greenAccent),
      _refLevel(txt("الجيل الثاني", "Level 2"), "3%", Colors.orangeAccent),
      _refLevel(txt("الجيل الثالث", "Level 3"), "1%", Colors.blueAccent),
    ]));
  }
  Widget _refLevel(String l, String p, Color c) => ListTile(leading: Icon(Icons.group, color: c), title: Text(l), trailing: Text(p, style: TextStyle(color: c, fontWeight: FontWeight.bold)));
}

// --- صفحة الحساب (بريدك ومحفظتك) ---
class ProfileTab extends StatelessWidget {
  final bool isArabic;
  const ProfileTab({super.key, required this.isArabic});
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircleAvatar(radius: 45, backgroundColor: Colors.cyanAccent, child: Icon(Icons.person, size: 40, color: Colors.black)),
      const SizedBox(height: 15),
      const Text("sajjadalkut121@gmail.com", style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 10),
      const Text("ID: 8C40A949", style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
      const SizedBox(height: 30),
      const Text("Wallet (USDT TRC20):", style: TextStyle(color: Colors.white38, fontSize: 10)),
      const SelectableText("0xdebe6cddf95631cff63368483995608d4d8263d3", style: TextStyle(color: Colors.white54, fontSize: 10)),
    ]));
  }
}

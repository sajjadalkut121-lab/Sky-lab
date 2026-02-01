import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const SkyLabEliteApp());

class SkyLabEliteApp extends StatefulWidget {
  const SkyLabEliteApp({super.key});
  @override
  State<SkyLabEliteApp> createState() => _SkyLabEliteAppState();
}

class _SkyLabEliteAppState extends State<SkyLabEliteApp> {
  bool isArabic = true;
  void toggleLang() => setState(() => isArabic = !isArabic);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(isArabic ? 'ar' : 'en'),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF06090E),
        primaryColor: Colors.cyanAccent,
      ),
      home: DragonNavigation(isArabic: isArabic, onLangToggle: toggleLang),
    );
  }
}

class DragonNavigation extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onLangToggle;
  const DragonNavigation({super.key, required this.isArabic, required this.onLangToggle});

  @override
  State<DragonNavigation> createState() => _DragonNavigationState();
}

class _DragonNavigationState extends State<DragonNavigation> {
  int _currentIndex = 0;
  String txt(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      InvestmentHome(isArabic: widget.isArabic),
      CalculatorTab(isArabic: widget.isArabic),
      SupportCenter(isArabic: widget.isArabic),
      ProfileSection(isArabic: widget.isArabic),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text(txt("منصة التنين - SKY LAB", "SKY LAB DRAGON"), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: widget.onLangToggle, child: Text(widget.isArabic ? "EN" : "AR", style: const TextStyle(color: Colors.cyanAccent))),
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
          BottomNavigationBarItem(icon: const Icon(Icons.auto_graph), label: txt("الاستثمار", "Invest")),
          BottomNavigationBarItem(icon: const Icon(Icons.calculate_outlined), label: txt("الحاسبة", "Calc")),
          BottomNavigationBarItem(icon: const Icon(Icons.support_agent), label: txt("الدعم", "Support")),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: txt("حسابي", "Me")),
        ],
      ),
    );
  }
}

// --- قسم الاستثمار المستوحى من الفيديو ---
class InvestmentHome extends StatefulWidget {
  final bool isArabic;
  const InvestmentHome({super.key, required this.isArabic});
  @override
  State<InvestmentHome> createState() => _InvestmentHomeState();
}

class _InvestmentHomeState extends State<InvestmentHome> {
  double accumulated = 15.21667;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (t) => setState(() => accumulated += 0.00015));
  }

  @override
  Widget build(BuildContext context) {
    String t(String ar, String en) => widget.isArabic ? ar : en;
    return ListView(padding: const EdgeInsets.all(15), children: [
      _buildBalanceBox(t),
      const SizedBox(height: 15),
      _payoutTicker(t),
      const SizedBox(height: 25),
      Text(t("باقات النخبة", "Elite Plans"), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 15),
      _vipCard("VIP 1", 50, 1.08, 32.5, 396),
      _vipCard("VIP 2", 100, 2.17, 65, 792),
      _vipCard("VIP 3", 500, 10.85, 325, 3960),
    ]);
  }

  Widget _buildBalanceBox(Function t) => Container(
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFF1B2430), Color(0xFF0D1219)]),
      borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
    ),
    child: Column(children: [
      Text(t("أرباح التعدين النشطة", "Active Mining Profits"), style: const TextStyle(color: Colors.white38, fontSize: 12)),
      const SizedBox(height: 10),
      Text("\$${accumulated.toStringAsFixed(6)}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      const SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: (){}, icon: const Icon(Icons.bolt, color: Colors.black),
        label: Text(t("سحب الأرباح الآن", "Withdraw Now"), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
    ]),
  );

  Widget _payoutTicker(Function t) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
    child: Row(children: [
      const Icon(Icons.verified, color: Colors.greenAccent, size: 14),
      const SizedBox(width: 8),
      Text(t("المستخدم S***d سحب 120\$ بنجاح", "User S***d successfully withdrew 120\$"), style: const TextStyle(fontSize: 10, color: Colors.white54)),
    ]),
  );

  Widget _vipCard(String n, double p, double d, double m, double y) => Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: const Color(0xFF151C24), borderRadius: BorderRadius.circular(15)),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(n, style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
        Text("\$$p", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ]),
      const Divider(color: Colors.white10, height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _statItem(widget.isArabic ? "يومي" : "Daily", "\$$d"),
        _statItem(widget.isArabic ? "شهري" : "Monthly", "\$$m"),
        _statItem(widget.isArabic ? "سنوي" : "Yearly", "\$$y"),
      ]),
    ]),
  );

  Widget _statItem(String l, String v) => Column(children: [Text(l, style: const TextStyle(color: Colors.white38, fontSize: 10)), Text(v, style: const TextStyle(color: Colors.white, fontSize: 14))]);
}

// --- قسم الحاسبة الذكية ---
class CalculatorTab extends StatefulWidget {
  final bool isArabic;
  const CalculatorTab({super.key, required this.isArabic});
  @override
  State<CalculatorTab> createState() => _CalculatorTabState();
}

class _CalculatorTabState extends State<CalculatorTab> {
  double inputAmount = 100.0;
  @override
  Widget build(BuildContext context) {
    String t(String ar, String en) => widget.isArabic ? ar : en;
    return Padding(padding: const EdgeInsets.all(25), child: Column(children: [
      Text(t("حاسبة أرباح التنين", "Dragon Profit Calculator"), style: const TextStyle(fontSize: 20, color: Colors.cyanAccent)),
      const SizedBox(height: 30),
      TextField(
        keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: t("مبلغ الاستثمار", "Invest Amount"), filled: true, fillColor: Colors.white10),
        onChanged: (v) => setState(() => inputAmount = double.tryParse(v) ?? 0),
      ),
      const SizedBox(height: 30),
      _calcRow(t("الربح المتوقع شهرياً:", "Monthly Profit:"), "\$${(inputAmount * 0.65).toStringAsFixed(2)}"),
      _calcRow(t("الربح المتوقع سنوياً:", "Yearly Profit:"), "\$${(inputAmount * 7.92).toStringAsFixed(2)}", color: Colors.cyanAccent),
    ]));
  }
  Widget _calcRow(String t, String v, {Color color = Colors.white70}) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t), Text(v, style: TextStyle(color: color, fontWeight: FontWeight.bold))]));
}

// --- مركز الدعم كما في الفيديو ---
class SupportCenter extends StatelessWidget {
  final bool isArabic;
  const SupportCenter({super.key, required this.isArabic});
  @override
  Widget build(BuildContext context) {
    String t(String ar, String en) => isArabic ? ar : en;
    return ListView(padding: const EdgeInsets.all(20), children: [
      _supportTile(t("القسم المالي", "Finance Dept"), t("لطلبات الإيداع والسحب", "For Payments"), Icons.account_balance_wallet),
      _supportTile(t("الإدارة العامة", "Admin"), t("للشكاوى المباشرة", "Direct Support"), Icons.shield),
      _supportTile(t("الدعم التقني", "Tech Support"), t("للمشاكل البرمجية", "App Issues"), Icons.terminal),
    ]);
  }
  Widget _supportTile(String t, String s, IconData i) => Card(color: const Color(0xFF151C24), child: ListTile(leading: Icon(i, color: Colors.cyanAccent), title: Text(t), subtitle: Text(s, style: const TextStyle(fontSize: 10, color: Colors.white24)), trailing: const Icon(Icons.telegram, color: Colors.blueAccent)));
}

// --- الملف الشخصي ---
class ProfileSection extends StatelessWidget {
  final bool isArabic;
  const ProfileSection({super.key, required this.isArabic});
  @override
  Widget build(BuildContext context) {
    String t(String ar, String en) => isArabic ? ar : en;
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircleAvatar(radius: 50, backgroundColor: Colors.cyanAccent, child: Icon(Icons.person, size: 50, color: Colors.black)),
      const SizedBox(height: 15),
      const Text("sajjadalkut121@gmail.com", style: TextStyle(color: Colors.white, fontSize: 16)),
      const SizedBox(height: 5),
      const Text("ID: 8C40A949", style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
      const SizedBox(height: 40),
      Text(t("رابط الإيداع المعتمد:", "Official Deposit Address:"), style: const TextStyle(color: Colors.white38, fontSize: 10)),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 40), child: SelectableText("0xdebe6cddf95631cff63368483995608d4d8263d3", style: TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.center)),
    ]));
  }
}

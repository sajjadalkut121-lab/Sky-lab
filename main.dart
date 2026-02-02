import 'package:flutter/material.dart';

void main() {
  runApp(const SkyLabApp());
}

class SkyLabApp extends StatelessWidget {
  const SkyLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKY LAB PRO',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SkyLabWebsitePage extends StatefulWidget {
  @override
  _SkyLabWebsitePageState createState() => _SkyLabWebsitePageState();
}

class _SkyLabWebsitePageState extends State<SkyLabWebsitePage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse('https://www.skylab.com')); // رابط موقعك
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("بوابة Sky Lab الإلكترونية"),
        backgroundColor: Color(0xFF1A1A2E), // اللون الاحترافي
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final String adminEmail = "sajjadalkut121@gmail.com"; // التحكم الكامل لسجاد
  final String myReferralCode = "1"; // رمز إحالة سجاد
  
  // شاشات المنصة
  final List<Widget> _screens = [
    const HomeScreen(),      // التجميع التلقائي والباقات
    const StoriesScreen(),   // القصص والبثوث
    const ReferralScreen(),  // نظام الإحالة (2% عمولة)
    const WalletScreen(),    // السحب الأسبوعي والمحفظة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'تجميع'),
          BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'بثوث'),
          BottomNavigationBarItem(icon: Icon(Icons.group_add), label: 'إحالات'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'محفظة'),
        ],
      ),
    );
  }
}

// --- شاشة التجميع التلقائي والباقات ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainType.center,
        children: [
          const Text("SKY LAB - التجميع التلقائي", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("الربح الصافي: 55% شهرياً \n المدة: 365 يوم", textAlign: TextAlign.center),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("تفعيل الباقة الاستثمارية"))
        ],
      ),
    );
  }
}

// --- شاشة الإحالات ---
class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});
  final double referralBonus = 0.02; // 2% عمولة

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, size: 80, color: Colors.amber),
          const Text("كود الإحالة الخاص بك: 1"),
          const Text("اربح 2% من إيداع أصدقائك فوراً"),
        ],
      ),
    );
  }
}

// --- شاشة القصص والبثوث (هيكل) ---
class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("قسم البثوث المباشرة والقصص اليومية"));
  }
}

// --- شاشة المحفظة والسحب الأسبوعي ---
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("السحب متاح مرة واحدة في الأسبوع"));
  }
}

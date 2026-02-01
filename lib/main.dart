import 'package:flutter/material.dart';

void main() => runApp(SkyLabPro());

class SkyLabPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    Center(child: Text("الصفحة الرئيسية: الباقات والاستثمار")),
    Center(child: Text("صفحة الإيداع والسحب")),
    Center(child: Text("نظام الإحالات (Referral)")),
    Center(child: Text("الملف الشخصي والإعدادات")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SKY LAB - المنصة الاحترافية"), centerTitle: true),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: "باقات"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "إيداع"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "إحالات"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
        ],
      ),
    );
  }
}

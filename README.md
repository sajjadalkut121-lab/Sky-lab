import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() => runApp(const MaterialApp(
      home: SkyAuthScreen(),
      debugShowCheckedModeBanner: false,
    ));

class SkyAuthScreen extends StatefulWidget {
  const SkyAuthScreen({super.key});
  @override
  State<SkyAuthScreen> createState() => _SkyAuthScreenState();
}

class _SkyAuthScreenState extends State<SkyAuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController refController = TextEditingController();

  void login() {
    String email = emailController.text.trim();
    if (email.isEmpty) return;
    String myRefCode = email.split('@')[0] + "121"; 
    bool isAdmin = (email == "sajjadalkut121@gmail.com");
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDashboard(
      userEmail: email, myRefCode: myRefCode, isAdmin: isAdmin, referredBy: refController.text,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Icon(Icons.stars, size: 100, color: Colors.amber),
              const Text('SKY LAB WORLD', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              _inputField(Icons.email, 'البريد الإلكتروني', emailController),
              const SizedBox(height: 15),
              _inputField(Icons.person_pin, 'رمز إحالة الداعي', refController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity, height: 60,
                child: ElevatedButton(onPressed: login, child: const Text('دخول المنصة')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(IconData icon, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.right,
      decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.blueAccent), hintText: hint, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)),
    );
  }
}

class UserDashboard extends StatefulWidget {
  final String userEmail;
  final String myRefCode;
  final String referredBy;
  final bool isAdmin;
  const UserDashboard({super.key, required this.userEmail, required this.myRefCode, required this.isAdmin, required this.referredBy});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final String myWallet = "0xdebe6cddf95631cff63368483995608d4d8263d3";
  final TextEditingController withdrawAddressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  late AnimationController _ctrl;
  late Animation<double> _ani;
  List<String> items = ["1\$", "5\$", "10\$", "50\$", "حظ أوفر", "2\$"];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _ani = Tween<double>(begin: 0, end: 0).animate(_ctrl);
  }

  void _spin() {
    double move = _ani.value + (Random().nextDouble() * 5 + 5) * 2 * pi;
    setState(() { _ani = Tween<double>(begin: _ani.value, end: move).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)); });
    _ctrl.reset(); _ctrl.forward();
  }

  void _handleWithdraw() {
    double amount = double.tryParse(amountController.text) ?? 0;
    if (amount < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الحد الأدنى للسحب هو 5 دولار')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استلام طلب السحب. المعالجة تتم يوم الأحد فقط')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: Text(widget.isAdmin ? "لوحة سجاد" : "SKY LAB"), backgroundColor: widget.isAdmin ? Colors.redAccent : const Color(0xFF1E293B)),
      body: IndexedStack(
        index: _selectedIndex,
        children: [_investTab(), _liveTab(), _gamesTab(), _withdrawTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white38,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'استثمار'),
          BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: 'بث'),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'ألعاب'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'سحب'),
        ],
      ),
    );
  }

  Widget _investTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        _infoBox("رمز إحالتك", widget.myRefCode),
        const SizedBox(height: 20),
        const Text("إيداع (USDT/BNB)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        _depositBox(),
        _actionBtn("إرفاق صورة التحويل", Icons.image, Colors.blueAccent),
        const SizedBox(height: 20),
        _vipTile("VIP 1", "50\$", "ربح 1.08\$"),
        _vipTile("VIP 2", "100\$", "ربح 2.17\$"),
      ]),
    );
  }

  Widget _withdrawTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        const Text("سحب الأرباح (Binance / OKX)", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("الشبكة المدعومة: Tron TRC20 حصراً", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
        const SizedBox(height: 20),
        _inputField("عنوان المحفظة (TRC20)", withdrawAddressController),
        const SizedBox(height: 15),
        _inputField("المبلغ (أقل حد 5\$)", amountController, isNumber: true),
        const SizedBox(height: 30),
        const Text("يتم السحب يوم واحد في الأسبوع (الأحد)", style: TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: _handleWithdraw, child: const Text("تقديم طلب السحب"))),
      ]),
    );
  }

  Widget _gamesTab() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("عجلة الحظ", style: TextStyle(color: Colors.white, fontSize: 22)),
      const SizedBox(height: 20),
      AnimatedBuilder(animation: _ani, builder: (context, child) => Transform.rotate(angle: _ani.value, child: _wheelBody())),
      const Icon(Icons.arrow_drop_down, color: Colors.amber, size: 50),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: _spin, child: const Text("دور العجلة!")),
    ]));
  }

  Widget _liveTab() => const Center(child: Text("قريباً: بثوث مباشرة", style: TextStyle(color: Colors.white)));

  // --- أدوات مساعدة ---
  Widget _inputField(String hint, TextEditingController controller, {bool isNumber = false}) => TextField(
    controller: controller,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    style: const TextStyle(color: Colors.white),
    textAlign: TextAlign.right,
    decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
  );

  Widget _wheelBody() => Container(width: 250, height: 250, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.amber, width: 4), color: Colors.white10), child: Stack(children: List.generate(items.length, (i) => Transform.rotate(angle: (2 * pi / items.length) * i, child: Center(child: Padding(padding: const EdgeInsets.only(bottom: 140), child: Text(items[i], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))))));

  Widget _depositBox() => Container(margin: const EdgeInsets.symmetric(vertical: 10), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(15)), child: Column(children: [SelectableText(myWallet, style: const TextStyle(color: Colors.amber, fontSize: 11)), IconButton(icon: const Icon(Icons.copy, color: Colors.blueAccent), onPressed: () => Clipboard.setData(ClipboardData(text: myWallet)))]));

  Widget _vipTile(String n, String p, String r) => Card(color: const Color(0xFF1E293B), child: ListTile(title: Text(n, style: const TextStyle(color: Colors.amber)), subtitle: Text("$p | $r", style: const TextStyle(color: Colors.white70)), trailing: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: widget.isAdmin ? Colors.green : Colors.blueAccent), child: Text(widget.isAdmin ? "تفعيل مجاني" : "شراء"))));

  Widget _infoBox(String t, String d) => Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Column(children: [Text(t, style: const TextStyle(color: Colors.white60)), Text(d, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))]));

  Widget _actionBtn(String t, IconData i, Color c) => SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: (){}, icon: Icon(i, color: c), label: Text(t, style: const TextStyle(color: Colors.white)), style: OutlinedButton.styleFrom(side: BorderSide(color: c))));
}

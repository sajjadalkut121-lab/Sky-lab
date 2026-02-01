import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MaterialApp(
      home: DragonAuthScreen(),
      debugShowCheckedModeBanner: false,
    ));

class DragonAuthScreen extends StatefulWidget {
  const DragonAuthScreen({super.key});
  @override
  State<DragonAuthScreen> createState() => _DragonAuthScreenState();
}

class _DragonAuthScreenState extends State<DragonAuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.length >= 6) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DragonDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Icon(Icons.account_tree, size: 80, color: Colors.redAccent),
              const Text('DRAGON SKY LAB', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const Text('الجيل الثالث من الاستثمار', style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 50),
              _input("البريد الإلكتروني", Icons.email, emailController, false),
              const SizedBox(height: 15),
              _input("رمز الدخول", Icons.lock, passwordController, true),
              const SizedBox(height: 40),
              SizedBox(width: double.infinity, height: 55, child: ElevatedButton(onPressed: login, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: const Text("تسجيل الدخول"))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String h, IconData i, TextEditingController c, bool p) => TextField(controller: c, obscureText: p, style: const TextStyle(color: Colors.white), decoration: InputDecoration(prefixIcon: Icon(i, color: Colors.redAccent), hintText: h, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none)));
}

class DragonDashboard extends StatefulWidget {
  const DragonDashboard({super.key});
  @override
  State<DragonDashboard> createState() => _DragonDashboardState();
}

class _DragonDashboardState extends State<DragonDashboard> {
  int _tab = 0;
  final List<Widget> _screens = [const InvestTab(), const DepositTab(), const WithdrawTab(), const HistoryTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: _screens[_tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab, onTap: (i) => setState(() => _tab = i),
        backgroundColor: Colors.black, selectedItemColor: Colors.redAccent, unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'استثمار'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'إيداع'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'سحب'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'سجل'),
        ],
      ),
    );
  }
}

// --- قسم السحب مع الضريبة 5% ---
class WithdrawTab extends StatefulWidget {
  const WithdrawTab({super.key});
  @override
  State<WithdrawTab> createState() => _WithdrawTabState();
}

class _WithdrawTabState extends State<WithdrawTab> {
  String selectedCoin = 'USDT';
  double amount = 0.0;
  final double taxPercent = 0.05;

  @override
  Widget build(BuildContext context) {
    double taxAmount = amount * taxPercent;
    double finalAmount = amount - taxAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 40),
        const Text("سحب الأرباح", style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("تطبق ضريبة 5% لدعم نظام المكافآت", style: TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 30),
        DropdownButton<String>(
          value: selectedCoin, dropdownColor: Colors.black, isExpanded: true,
          style: const TextStyle(color: Colors.amber, fontSize: 18),
          items: ['USDT', 'BNB'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => selectedCoin = v!),
        ),
        const SizedBox(height: 20),
        _inputField("عنوان المحفظة (BSC/TRC20)", (v){}),
        const SizedBox(height: 15),
        _inputField("المبلغ (أقل حد 5\$)", (v) {
          setState(() { amount = double.tryParse(v) ?? 0.0; });
        }),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            _row("المبلغ المطلوب:", "\$${amount.toStringAsFixed(2)}"),
            _row("ضريبة السحب (5%):", "-\$${taxAmount.toStringAsFixed(2)}"),
            const Divider(color: Colors.white10),
            _row("يصلك الصافي:", "\$${(finalAmount > 0 ? finalAmount : 0).toStringAsFixed(2)}", color: Colors.green),
          ]),
        ),
        const SizedBox(height: 30),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text("تأكيد السحب"))),
      ]),
    );
  }

  Widget _row(String t, String v, {Color color = Colors.white70}) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: const TextStyle(color: Colors.white54)), Text(v, style: TextStyle(color: color, fontWeight: FontWeight.bold))]);
  
  Widget _inputField(String h, Function(String) onChanged) => TextField(onChanged: onChanged, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: h, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))));
}

// --- قسم سجل العمليات ---
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 40),
        const Text("سجل المعاملات", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              _historyItem("سحب USDT", "50.00\$", "مكتمل", Colors.green),
              _historyItem("إيداع BNB", "120.00\$", "قيد الانتظار", Colors.amber),
              _historyItem("سحب USDT", "10.00\$", "مرفوض", Colors.red),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _historyItem(String title, String price, String status, Color statusColor) => Card(
    color: Colors.white10,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text("2026-02-02", style: const TextStyle(color: Colors.white24, fontSize: 10)),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(price, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        Text(status, style: TextStyle(color: statusColor, fontSize: 10)),
      ]),
    ),
  );
}

// --- قسم الإيداع (محفظتك) ---
class DepositTab extends StatelessWidget {
  const DepositTab({super.key});
  final String myWallet = "0xdebe6cddf95631cff63368483995608d4d8263d3";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.qr_code, size: 100, color: Colors.redAccent),
        const SizedBox(height: 20),
        const Text("عنوان الإيداع الموحد", style: TextStyle(color: Colors.white, fontSize: 18)),
        const Text("تقبل العملات: USDT (TRC20/BEP20) & BNB", style: TextStyle(color: Colors.white38, fontSize: 10)),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.redAccent.withOpacity(0.5))),
          child: SelectableText(myWallet, style: const TextStyle(color: Colors.amber, fontSize: 12), textAlign: TextAlign.center),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(onPressed: () => Clipboard.setData(ClipboardData(text: myWallet)), icon: const Icon(Icons.copy), label: const Text("نسخ العنوان")),
      ]),
    );
  }
}

// --- قسم الاستثمار ---
class InvestTab extends StatelessWidget {
  const InvestTab({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      const SizedBox(height: 40),
      const Text("باقات التنين الأسطورية", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      _card("تنين البركان", "100\$", "ربح 3.5\$ يومي"),
      _card("تنين الرعد", "500\$", "ربح 18\$ يومي"),
      _card("ملك التنانين", "2000\$", "ربح 75\$ يومي"),
    ]);
  }
  Widget _card(String t, String p, String r) => Card(color: Colors.white10, margin: const EdgeInsets.symmetric(vertical: 10), child: ListTile(leading: const Icon(Icons.local_fire_department, color: Colors.redAccent), title: Text(t, style: const TextStyle(color: Colors.white)), subtitle: Text(r, style: const TextStyle(color: Colors.green)), trailing: Text(p, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ───────────────────────── Theme Colors ─────────────────────────
const kGreen = Color(0xFF20C96A);
const kGreenBg = Color(0xFFE8F8EF);
const kInk = Color(0xFF1E293B);
const kMuted = Color(0xFF64748B);
const kBorder = Color(0xFFF1F5F9);
const kRed = Color(0xFFFF4D4F);
const kRedBg = Color(0xFFFFF1F0);
const kBlue = Color(0xFF4285F4);
const kOrange = Color(0xFFFBBC05);

void main() => runApp(const NutritionApp());

// ───────────────────────── Admin Auth State ─────────────────────────
class AdminAuth extends ChangeNotifier {
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  bool login(String email, String password) {
    // กำหนดให้เป็น true เสมอ ไม่ว่าจะกรอกอะไรมาก็ตาม (สำหรับการจำลอง)
    _isAdmin = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAdmin = false;
    notifyListeners();
  }
}

// ───────────────────────── App Data State ─────────────────────────
class AppContent extends ChangeNotifier {
  // จำลองข้อมูลผู้ใช้
  final Map<String, Map<String, String>> users = {
    '6701': {'name': 'แคทเธอรีน ภูชาง', 'email': 'Doradaymon@gmail.com', 'role': 'User'},
    '6702': {'name': 'ปิติโชค โดราเอม่อน', 'email': 'user2@gmail.com', 'role': 'User'},
    '6703': {'name': 'มะม่วง ใจดี', 'email': 'user3@gmail.com', 'role': 'User'},
  };

  // จำลองข้อมูลอาหาร
  final List<Map<String, String>> foods = [];

  // วันเกิดที่ผู้ใช้เลือกจากหน้า Date of Birth
  DateTime? birthDate;

  // ข้อมูลอาหารหลักที่ Admin เพิ่มเท่านั้น (ไม่รวมข้อมูลที่ผู้ใช้ทั่วไปบันทึก)
  List<Map<String, String>> get adminFoods =>
      foods.where((f) => f['source'] == 'admin').toList();

  void addFood(Map<String, String> foodData) {
    foods.add(foodData);
    notifyListeners();
  }

  void updateUser(String id, Map<String, String> data) {
    if (users.containsKey(id)) {
       users[id]!.addAll(data);
       notifyListeners();
    }
  }
}

// ───────────────────────── Root App ─────────────────────────
class NutritionApp extends StatefulWidget {
  const NutritionApp({super.key});
  @override
  State<NutritionApp> createState() => _NutritionAppState();
}

class _NutritionAppState extends State<NutritionApp> {
  final _auth = AdminAuth();
  final _content = AppContent();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_auth, _content]),
      builder: (context, _) => _Providers(
        auth: _auth,
        content: _content,
        child: MaterialApp(
          title: 'Nutritional Analysis',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: kGreen, primary: kGreen),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (_) => const IntroScreen(),
            '/register': (_) => const RegisterScreen(),
            '/dob': (_) => const DobScreen(),
            '/health': (_) => const HealthScreen(),
            '/goal': (_) => const GoalScreen(),
            '/home': (_) => const DashboardScreen(),
            '/capture': (_) => const CaptureScreen(),
            '/analysis': (_) => const AnalysisScreen(),
            '/save': (_) => const SaveMealScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/change_password': (_) => const ChangePasswordScreen(),
            '/account': (_) => const AccountScreen(),
            // เส้นทางสำหรับแอดมิน
            '/admin/home': (_) => const AdminHomeScreen(),
            '/admin/users': (_) => const AdminUsersScreen(),
            '/admin/users/edit': (_) => const AdminEditUserScreen(),
            '/admin/foods': (_) => const AdminFoodsScreen(),
            '/admin/foods/add': (_) => const AdminAddFoodScreen(),
          },
        ),
      ),
    );
  }
}

// ───────────────────────── InheritedWidget Providers ─────────────────────────
class _Providers extends InheritedWidget {
  final AdminAuth auth;
  final AppContent content;
  const _Providers({required this.auth, required this.content, required super.child});

  static _Providers of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Providers>()!;

  @override
  bool updateShouldNotify(_Providers old) => true;
}

// Convenience accessors
extension ProviderAccess on BuildContext {
  AdminAuth get auth => _Providers.of(this).auth;
  AppContent get content => _Providers.of(this).content;
  bool get isAdmin => _Providers.of(this).auth.isAdmin;
}

// ───────────────────────── Shared Widgets ─────────────────────────
class CleanAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const CleanAppBar({super.key, this.title = '', this.showBack = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kInk)),
      leading: showBack
          ? Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16, color: kInk),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  const PrimaryButton(this.text, this.onTap, {super.key, this.color = kGreen, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class CleanTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool obscure;
  final TextEditingController? controller;
  const CleanTextField({super.key, required this.hint, this.icon, this.suffixIcon, this.obscure = false, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kMuted, fontSize: 14),
          prefixIcon: icon != null ? Icon(icon, color: kMuted) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: kMuted, size: 18) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class BaseNavLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  const BaseNavLayout({super.key, required this.body, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: kBorder, width: 1))),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: currentIndex,
          selectedItemColor: kGreen,
          unselectedItemColor: kMuted,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (i) {
            if (i == currentIndex) return;
            if (i == 0) Navigator.pushReplacementNamed(context, '/home');
            if (i == 1) Navigator.pushReplacementNamed(context, '/capture');
            if (i == 2) Navigator.pushReplacementNamed(context, '/profile');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 28), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ฟังก์ชัน Login สำหรับแอดมิน
Future<bool> showAdminLoginDialog(BuildContext context) async {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  var error = '';

  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Admin Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            if (error.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(error, style: const TextStyle(color: kRed, fontSize: 12)),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kGreen),
            onPressed: () {
              final auth = _Providers.of(context).auth;
              if (auth.login(emailCtrl.text.trim(), passCtrl.text)) {
                Navigator.pop(ctx, true);
              } else {
                setState(() => error = 'Invalid credentials');
              }
            },
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}

// ───────────────────────── 1. Login / Intro ─────────────────────────
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const CircleAvatar(radius: 50, backgroundColor: kGreenBg, child: Icon(Icons.restaurant, size: 50, color: kGreen)),
                const SizedBox(height: 24),
                const Text('Nutrition AI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('แอปพลิเคชันวิเคราะห์โภชนาการอาหาร\nจากรูปภาพด้วยปัญญาประดิษฐ์', style: TextStyle(color: kMuted), textAlign: TextAlign.center),
                const Spacer(),
                const CleanTextField(hint: 'Email', icon: Icons.email_outlined),
                const CleanTextField(hint: 'Password', icon: Icons.lock_outline, obscure: true),
                const SizedBox(height: 8),
                PrimaryButton('Log In', () => Navigator.pushReplacementNamed(context, '/home')),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Create an account', style: TextStyle(color: kMuted)),
                ),
                TextButton(
                  onPressed: () async {
                    final ok = await showAdminLoginDialog(context);
                    if (ok && context.mounted) {
                      // วิ่งไปหน้า Admin Dashboard (มีเมนูให้เลือก)
                      Navigator.pushReplacementNamed(context, '/admin/home');
                    }
                  },
                  child: const Text('Login as Admin', style: TextStyle(color: kGreen)),
                ),
              ],
            ),
          ),
        ),
      );
}

// ───────────────────────── 2. Register ─────────────────────────
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CleanAppBar(title: 'Sign Up'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CleanTextField(hint: 'Full Name'),
              const CleanTextField(hint: 'Email'),
              const CleanTextField(hint: 'Password', obscure: true),
              const Spacer(),
              PrimaryButton('Continue', () => Navigator.pushNamed(context, '/dob')),
            ],
          ),
        ),
      );
}

// ───────────────────────── 3. Health Info ─────────────────────────
class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CleanAppBar(title: 'Health Data'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CleanTextField(hint: 'Age'),
              Row(
                children: const [
                  Expanded(child: CleanTextField(hint: 'Weight (kg)')),
                  SizedBox(width: 16),
                  Expanded(child: CleanTextField(hint: 'Height (cm)')),
                ],
              ),
              const Spacer(),
              PrimaryButton('Continue', () => Navigator.pushNamed(context, '/goal')),
            ],
          ),
        ),
      );
}

// ───────────────────────── 4. Goals ─────────────────────────
class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CleanAppBar(title: 'Your Goals'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Daily Calorie Target', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const CleanTextField(hint: 'e.g. 1900 kcal'),
              const SizedBox(height: 24),
              const Text('Activity Level', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const CleanTextField(hint: 'Light / Active / Very Active'),
              const Spacer(),
              PrimaryButton('Save & Finish', () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      );
}

// ───────────────────────── 5. Home Dashboard ─────────────────────────
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseNavLayout(
      currentIndex: 0,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
                child: Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 16, color: kInk),
                    SizedBox(width: 8),
                    Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
                    Icon(Icons.keyboard_arrow_down, size: 18),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: kMuted),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorder, width: 1.5),
              boxShadow: [BoxShadow(color: kGreen.withValues(alpha: 0.10), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 190,
                  height: 190,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 190,
                        height: 190,
                        child: CircularProgressIndicator(
                          value: 0.79,
                          strokeWidth: 16,
                          strokeCap: StrokeCap.round,
                          backgroundColor: kGreenBg,
                          color: kGreen,
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: kGreenBg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('79%', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: kInk)),
                            SizedBox(height: 2),
                            Text('of 1900 kcal', style: TextStyle(fontSize: 13, color: kMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Total Calories', style: TextStyle(color: kMuted, fontSize: 14)),
                const SizedBox(height: 4),
                const Text('1280 kcal', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kInk)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: kGreenBg, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.circle, size: 8, color: kGreen),
                      SizedBox(width: 6),
                      Flexible(child: Text('On track for your daily goal', style: TextStyle(fontSize: 12, color: kGreen, fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('ประวัติการรับประทานอาหาร', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
            child: Row(
              children: [
                Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.fastfood, color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('ข้าวกระเพราหมูสับไข่ดาว', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(height: 4),
                      Text('พลังงาน 540 Kcal', style: TextStyle(fontSize: 12, color: kMuted)),
                    ],
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

// ───────────────────────── 6. Capture ─────────────────────────
class CaptureScreen extends StatelessWidget {
  const CaptureScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseNavLayout(
      currentIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(24), border: Border.all(color: kBorder)),
                child: const Center(child: Icon(Icons.camera_alt, size: 64, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CircleAvatar(radius: 28, backgroundColor: Colors.grey[100], child: const Icon(Icons.photo, color: kInk)),
                    const SizedBox(height: 8),
                    const Text('Gallery', style: TextStyle(fontSize: 12)),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, '/analysis'),
                  child: const CircleAvatar(radius: 40, backgroundColor: kGreen, child: Icon(Icons.camera_alt, color: Colors.white, size: 32)),
                ),
                Column(
                  children: [
                    CircleAvatar(radius: 28, backgroundColor: Colors.grey[100], child: const Icon(Icons.flash_off, color: kInk)),
                    const SizedBox(height: 8),
                    const Text('Flash', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── 7. Analysis ─────────────────────────
class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CleanAppBar(title: 'Analysis Result'),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(height: 200, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 24),
            const Text('ข้าวกระเพราหมูสับไข่ดาว', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kGreenBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Flexible(child: Text('พลังงานรวม (Total Calories)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kInk))),
                  Text('540 kcal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreen)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            PrimaryButton('Save to Diary', () => Navigator.pushNamed(context, '/save')),
          ],
        ),
      );
}

// ───────────────────────── 8. Save Meal ─────────────────────────
class SaveMealScreen extends StatelessWidget {
  const SaveMealScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CleanAppBar(title: 'Save Meal'),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CleanTextField(hint: 'Meal Name (e.g. Breakfast, Lunch)'),
              const SizedBox(height: 16),
              const Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const CleanTextField(hint: '09:00 AM', icon: Icons.access_time),
              const Spacer(),
              PrimaryButton('Confirm', () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
            ],
          ),
        ),
      );
}

// ───────────────────────── 9. Profile ─────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseNavLayout(
      currentIndex: 2,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Expanded(child: Center(child: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
            ],
          ),
          const SizedBox(height: 32),
          const Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white, size: 40))),
          const SizedBox(height: 32),

          _InfoCard(title: 'ข้อมูลบัญชี', items: const {
            'FULL-NAME': 'แคทเธอรีน ภูชาง',
            'Email': 'Doradaymon@gmail.com',
            'Birthdate': '12 ธันวาคม 2001',
          }),
          const SizedBox(height: 16),

          InkWell(
            onTap: () {
               Navigator.pushNamed(context, '/change_password');
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50], 
                borderRadius: BorderRadius.circular(16), 
                border: Border.all(color: kBorder)
              ),
              child: const Center(
                child: Text('เปลี่ยนรหัสผ่าน', style: TextStyle(fontWeight: FontWeight.bold))
              ),
            ),
          ),
          const SizedBox(height: 16),

          _InfoCard(title: 'ข้อมูลส่วนตัว', items: const {
            'น้ำหนัก (Weight)': '--',
            'ส่วนสูง (Height)': '--',
            'อายุ (Age)': '--',
            'เป้าหมาย (Goal)': '--',
            'ระดับกิจกรรม (Activity)': '--',
          }),
          const SizedBox(height: 32),

          PrimaryButton(
            'Logout', 
            () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('ออกจากระบบ', style: TextStyle(fontWeight: FontWeight.bold)),
                  content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx), 
                      child: const Text('ยกเลิก', style: TextStyle(color: kMuted))
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: kRed),
                      onPressed: () {
                        context.auth.logout();
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      },
                      child: const Text('ยืนยัน', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }, 
            color: kRedBg, 
            textColor: kRed
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Map<String, String> items;
  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...items.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: const TextStyle(color: kMuted, fontSize: 13)),
                    Flexible(child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CleanAppBar(title: 'เปลี่ยนรหัสผ่าน', showBack: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รหัสผ่านเดิม', style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
            const SizedBox(height: 8),
            const CleanTextField(hint: 'กรอกรหัสผ่านเดิม', obscure: true),
            const SizedBox(height: 16),
            const Text('รหัสผ่านใหม่', style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
            const SizedBox(height: 8),
            const CleanTextField(hint: 'กรอกรหัสผ่านใหม่', obscure: true),
            const SizedBox(height: 16),
            const Text('ยืนยันรหัสผ่านใหม่', style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
            const SizedBox(height: 8),
            const CleanTextField(hint: 'กรอกรหัสผ่านใหม่อีกครั้ง', obscure: true),
            
            const Spacer(),
            PrimaryButton('บันทึกรหัสผ่านใหม่', () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('บันทึกรหัสผ่านใหม่สำเร็จแล้ว!'), backgroundColor: kGreen),
              );
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CleanAppBar(title: 'Settings'),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notifications'),
              trailing: Switch(value: true, onChanged: (v) {}, activeTrackColor: kGreen),
            ),
            const Divider(color: kBorder),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Theme'),
              trailing: Icon(Icons.chevron_right, color: kMuted),
            ),
          ],
        ),
      );
}


// ───────────────────────── ADMIN SCREENS ─────────────────────────

// หน้าหลักสำหรับ Admin เพื่อเลือกว่าจะไปจัดการส่วนไหน
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kInk)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kRed),
            onPressed: () {
              context.auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _AdminMenuCard(
              title: 'จัดการบัญชีผู้ใช้',
              icon: Icons.people,
              onTap: () => Navigator.pushNamed(context, '/admin/users'),
            ),
            const SizedBox(height: 16),
            _AdminMenuCard(
              title: 'จัดการโภชนาการอาหาร',
              icon: Icons.fastfood,
              onTap: () => Navigator.pushNamed(context, '/admin/foods'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminMenuCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: kGreenBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: kGreen),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            const Icon(Icons.chevron_right, color: kMuted),
          ],
        ),
      ),
    );
  }
}


// ───────────────────────── 11. Admin Users ─────────────────────────
class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = context.content.users;
    
    return Scaffold(
      appBar: const CleanAppBar(title: 'จัดการบัญชีผู้ใช้', showBack: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // รูปโปรไฟล์และคำว่า Admin (ไม่มีไอคอนดินสอ)
          const Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white, size: 40))),
          const SizedBox(height: 16),
          const Center(child: Text('Admin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const SizedBox(height: 24),
          
          const CleanTextField(hint: 'search ID', icon: Icons.search),
          const SizedBox(height: 8),
          ...users.entries.map((entry) => _UserCard(id: entry.key, userData: entry.value)),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String id;
  final Map<String, String> userData;
  const _UserCard({required this.id, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
      child: Column(
        children: [
          Row(
            children: [
              Text('UserID : $id', style: const TextStyle(fontWeight: FontWeight.bold, color: kMuted)),
              const Spacer(),
              Row(children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pushNamed(context, '/admin/users/edit', arguments: id),
                  child: _outlineBtn('แก้ไข', kGreen, Icons.edit),
                ),
                const SizedBox(width: 8),
                _outlineBtn('ลบ', kRed, Icons.delete_outline),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('username :', style: TextStyle(color: kMuted)),
              Flexible(child: Text(userData['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Email :', style: TextStyle(color: kMuted)),
              Flexible(child: Text(userData['email'] ?? '', style: const TextStyle(color: kBlue))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _outlineBtn(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ───────────────────────── 12. Admin Foods ─────────────────────────
class AdminFoodsScreen extends StatelessWidget {
  const AdminFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CleanAppBar(title: 'จัดการโภชนาการอาหาร'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PrimaryButton('เพิ่มข้อมูลโภชนาการอาหาร', () => Navigator.pushNamed(context, '/admin/foods/add')),
        ],
      ),
    );
  }
}

// ───────────────────────── 13. Admin Add Food ─────────────────────────
class AdminAddFoodScreen extends StatefulWidget {
  const AdminAddFoodScreen({super.key});
  @override
  State<AdminAddFoodScreen> createState() => _AdminAddFoodScreenState();
}

class _AdminAddFoodScreenState extends State<AdminAddFoodScreen> {
  final _name = TextEditingController();
  final _energy = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _energy.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final energy = _energy.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกชื่ออาหาร'), backgroundColor: kRed),
      );
      return;
    }

    context.content.addFood({
      'name': name,
      'energy': energy.isNotEmpty ? energy : '0',
      'source': 'admin',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เพิ่มข้อมูลโภชนาการอาหารสำเร็จ'), backgroundColor: kGreen),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'เพิ่มโภชนาการอาหาร',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: kInk),
                      ),
                      const SizedBox(height: 4),
                      const Text('กรอกข้อมูลโภชนาการของอาหาร', style: TextStyle(color: kMuted, fontSize: 13)),
                      const SizedBox(height: 28),
                      _FoodField(label: 'ชื่ออาหาร', hint: 'กรอกชื่ออาหาร', controller: _name),
                      _FoodField(label: 'พลังงาน (Calories)', hint: '0', controller: _energy, numeric: true),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: kBorder, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('ยกเลิก', style: TextStyle(color: kInk, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(color: kGreen.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          ),
                          onPressed: _save,
                          child: const Text('บันทึกข้อมูล', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool numeric;
  const _FoodField({required this.label, required this.hint, required this.controller, this.numeric = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: kInk)),
          const SizedBox(height: 8),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorder, width: 1.5),
              boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
            ),
            child: TextField(
              controller: controller,
              keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
              inputFormatters: numeric ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))] : null,
              style: const TextStyle(fontSize: 14, color: kInk),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Date of Birth ─────────────────────────
const kGreenDark = Color(0xFF0E9F55);

class DobScreen extends StatefulWidget {
  const DobScreen({super.key});
  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const int _minYear = 1900;
  final int _maxYear = DateTime.now().year;

  int _day = 14;
  int _month = 3;
  int _year = 1997;

  late final FixedExtentScrollController _dayCtrl;
  late final FixedExtentScrollController _monthCtrl;
  late final FixedExtentScrollController _yearCtrl;

  @override
  void initState() {
    super.initState();
    _dayCtrl = FixedExtentScrollController(initialItem: _day - 1);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtrl = FixedExtentScrollController(initialItem: _year - _minYear);
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  int _daysIn(int year, int month) => DateTime(year, month + 1, 0).day;

  // เมื่อเปลี่ยนเดือน/ปี ให้ปรับวันไม่ให้เกินจำนวนวันจริงของเดือนนั้น
  void _clampDay() {
    final max = _daysIn(_year, _month);
    if (_day > max) {
      _day = max;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_dayCtrl.hasClients) _dayCtrl.jumpToItem(_day - 1);
      });
    }
  }

  void _next() {
    final date = DateTime(_year, _month, _day);
    final now = DateTime.now();
    if (date.isAfter(DateTime(now.year, now.month, now.day))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('วันเกิดต้องไม่เป็นวันที่ในอนาคต'), backgroundColor: kRed),
      );
      return;
    }
    context.content.birthDate = date;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('วันเกิดของคุณ', style: TextStyle(fontWeight: FontWeight.bold, color: kInk)),
        content: Text(
          '$_day ${_months[_month - 1]} $_year',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: kGreenDark),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/health');
            },
            child: const Text('ตกลง', style: TextStyle(color: kGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final itemExtent = (c.maxHeight * 0.075).clamp(40.0, 56.0);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'when were you born',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This will be used to calibrate your custom nutrition plan.',
                          style: TextStyle(fontSize: 13, color: kMuted),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(12, 18, 12, 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8, bottom: 14),
                                child: Text(
                                  'Date of birth',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kInk),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _Wheel(
                                      label: 'DAY',
                                      count: _daysIn(_year, _month),
                                      selected: _day - 1,
                                      controller: _dayCtrl,
                                      itemExtent: itemExtent,
                                      textOf: (i) => '${i + 1}',
                                      onChanged: (i) => setState(() => _day = i + 1),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: _Wheel(
                                      label: 'MONTH',
                                      count: 12,
                                      selected: _month - 1,
                                      controller: _monthCtrl,
                                      itemExtent: itemExtent,
                                      fontSize: 14,
                                      textOf: (i) => _months[i],
                                      onChanged: (i) => setState(() {
                                        _month = i + 1;
                                        _clampDay();
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _Wheel(
                                      label: 'YEAR',
                                      count: _maxYear - _minYear + 1,
                                      selected: _year - _minYear,
                                      controller: _yearCtrl,
                                      itemExtent: itemExtent,
                                      textOf: (i) => '${_minYear + i}',
                                      onChanged: (i) => setState(() {
                                        _year = _minYear + i;
                                        _clampDay();
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: kGreen.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      onPressed: _next,
                      child: const Text(
                        'NEXT',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  final String label;
  final int count;
  final int selected;
  final FixedExtentScrollController controller;
  final double itemExtent;
  final double fontSize;
  final String Function(int) textOf;
  final ValueChanged<int> onChanged;

  const _Wheel({
    required this.label,
    required this.count,
    required this.selected,
    required this.controller,
    required this.itemExtent,
    required this.textOf,
    required this.onChanged,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kMuted, letterSpacing: 1)),
        const SizedBox(height: 8),
        SizedBox(
          height: itemExtent * 5,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: itemExtent,
            physics: const FixedExtentScrollPhysics(),
            diameterRatio: 100,
            perspective: 0.0001,
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: count,
              builder: (context, i) {
                final sel = i == selected;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? kGreenBg : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? kGreen.withOpacity(0.4) : const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: Text(
                      textOf(i),
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                        color: sel ? kGreenDark : kInk,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── 14. Admin Edit User ─────────────────────────
class AdminEditUserScreen extends StatefulWidget {
  const AdminEditUserScreen({super.key});
  @override
  State<AdminEditUserScreen> createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends State<AdminEditUserScreen> {
  TextEditingController? _name;
  TextEditingController? _email;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _resetPassword = TextEditingController();
  String _id = '';
  String _role = 'User';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_name == null) {
      _id = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
      final userData = context.content.users[_id] ?? {};
      _name = TextEditingController(text: userData['name'] ?? '');
      _email = TextEditingController(text: userData['email'] ?? '');
      _role = userData['role'] ?? 'User';
      _password.text = '12345678';
    }
  }

  @override
  void dispose() {
    _name?.dispose();
    _email?.dispose();
    _password.dispose();
    _resetPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CleanAppBar(title: 'จัดการบัญชีผู้ใช้'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(radius: 40, backgroundColor: kBorder, child: Icon(Icons.person, color: kInk, size: 40)),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 16, color: kMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Change Profile Photo', style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            const Text('ชื่อ - นามสกุล', style: TextStyle(fontWeight: FontWeight.bold, color: kMuted, fontSize: 12)),
            const SizedBox(height: 8),
            CleanTextField(hint: 'ชื่อ นามสกุล', controller: _name, suffixIcon: Icons.edit_square),
            
            const Text('อีเมล', style: TextStyle(fontWeight: FontWeight.bold, color: kMuted, fontSize: 12)),
            const SizedBox(height: 8),
            CleanTextField(hint: 'อีเมล', controller: _email, suffixIcon: Icons.edit_square),
            
            const Text('Role', style: TextStyle(fontWeight: FontWeight.bold, color: kMuted, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBorder, width: 1.5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _role,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: kMuted),
                  items: ['User', 'Admin'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 14, color: kInk)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _role = newValue!;
                    });
                  },
                ),
              ),
            ),

            const Text('รหัสผ่าน', style: TextStyle(fontWeight: FontWeight.bold, color: kMuted, fontSize: 12)),
            const SizedBox(height: 8),
            CleanTextField(hint: 'รหัสผ่าน', controller: _password, obscure: true),

            const Text('รีเซ็ตรหัสผ่าน', style: TextStyle(fontWeight: FontWeight.bold, color: kMuted, fontSize: 12)),
            const SizedBox(height: 8),
            CleanTextField(hint: 'Reset password', controller: _resetPassword),
            
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: kBorder, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ยกเลิก', style: TextStyle(color: kMuted, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {
                      context.content.updateUser(_id, {
                        'name': _name!.text.trim(),
                        'email': _email!.text.trim(),
                        'role': _role,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกข้อมูลผู้ใช้สำเร็จ'), backgroundColor: kGreen),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('บันทึกข้อมูล', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
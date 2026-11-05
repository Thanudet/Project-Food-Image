import 'package:flutter/material.dart';

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
    // กำหนดให้เป็น true เสมอ ไม่ว่าจะกรอกอะไรมาก็ตาม
    _isAdmin = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAdmin = false;
    notifyListeners();
  }
}

// ───────────────────────── Editable Content State ─────────────────────────
class AppContent extends ChangeNotifier {
  final Map<String, String> _data = {
    // Intro
    'intro.title': 'Nutrition AI',
    'intro.subtitle': 'แอปพลิเคชันวิเคราะห์โภชนาการอาหาร\nจากรูปภาพด้วยปัญญาประดิษฐ์',
    'intro.login': 'Log In',
    'intro.create': 'Create an account',
    'intro.admin': 'Login as Admin',
    // Register
    'register.title': 'Sign Up',
    'register.continue': 'Continue',
    // Health
    'health.title': 'Health Data',
    'health.continue': 'Continue',
    // Goal
    'goal.title': 'Your Goals',
    'goal.calorie_label': 'Daily Calorie Target',
    'goal.activity_label': 'Activity Level',
    'goal.save': 'Save & Finish',
    // Dashboard
    'dash.today': 'Today',
    'dash.percent': '79%',
    'dash.of_goal': 'of 1900 kcal',
    'dash.total_label': 'Total Calories',
    'dash.total_value': '1280 kcal',
    'dash.track_msg': 'On track for your daily goal',
    'dash.history_title': 'ประวัติการรับประทานอาหาร',
    'dash.meal_name': 'ข้าวกระเพราหมูสับไข่ดาว',
    'dash.meal_cal': 'พลังงาน 540 Kcal',
    // Capture
    'capture.gallery': 'Gallery',
    'capture.flash': 'Flash',
    // Analysis
    'analysis.title': 'Analysis Result',
    'analysis.food_name': 'ข้าวกระเพราหมูสับไข่ดาว',
    'analysis.cal_label': 'พลังงานรวม (Total Calories)',
    'analysis.cal_value': '540 kcal',
    'analysis.save_btn': 'Save to Diary',
    // Save Meal
    'save.title': 'Save Meal',
    'save.time_label': 'Time',
    'save.confirm': 'Confirm',
    // Profile
    'profile.title': 'Profile',
    'profile.account_title': 'ข้อมูลบัญชี',
    'profile.full_name': 'แคทเธอรีน ภูชาง',
    'profile.email': 'Doradaymon@gmail.com',
    'profile.birthdate': '12 ธันวาคม 2001',
    'profile.change_pw': 'เปลี่ยนรหัสผ่าน',
    'profile.personal_title': 'ข้อมูลส่วนตัว',
    'profile.weight': '--',
    'profile.height': '--',
    'profile.age': '--',
    'profile.goal': '--',
    'profile.activity': '--',
    'profile.edit': 'แก้ไข',
    'profile.logout': 'Logout',
    // Account / Settings
    'account.title': 'Settings',
    'account.notif': 'Notifications',
    'account.theme': 'Theme',
    // Admin Users
    'admin_users.admin_label': 'Admin',
    'admin_users.edit': 'แก้ไข',
    'admin_users.delete': 'ลบ',
    // Admin Foods
    'admin_foods.title': 'Manage Foods',
    'admin_foods.add': 'Add New Food',
    'admin_foods.placeholder': 'Food Database Items...',
    // User data
    'user.6701.name': 'แคทเธอรีน ภูชาง',
    'user.6701.email': 'Doradaymon@gmail.com',
    'user.6702.name': 'ปิติโชค โดราเอม่อน',
    'user.6702.email': 'user2@gmail.com',
    'user.6703.name': 'มะม่วง ใจดี',
    'user.6703.email': 'user3@gmail.com',
  };

  String get(String key) => _data[key] ?? key;

  void set(String key, String value) {
    _data[key] = value;
    notifyListeners();
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
            '/health': (_) => const HealthScreen(),
            '/goal': (_) => const GoalScreen(),
            '/home': (_) => const DashboardScreen(),
            '/capture': (_) => const CaptureScreen(),
            '/analysis': (_) => const AnalysisScreen(),
            '/save': (_) => const SaveMealScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/change_password': (_) => const ChangePasswordScreen(), // เพิ่มเส้นทางใหม่
            '/account': (_) => const AccountScreen(),
            '/admin/users': (_) => const AdminUsersScreen(),
            '/admin/foods': (_) => const AdminFoodsScreen(),
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
  String t(String key) => _Providers.of(this).content.get(key);
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
                  // แก้ไขปุ่มย้อนกลับให้ตรวจสอบก่อนว่า pop ได้หรือไม่
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
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
  final bool obscure;
  final TextEditingController? controller;
  const CleanTextField({super.key, required this.hint, this.icon, this.obscure = false, this.controller});

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
          hintStyle: const TextStyle(color: kMuted),
          prefixIcon: icon != null ? Icon(icon, color: kMuted) : null,
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

// ───────────────────────── Admin Edit Helpers ─────────────────────────

/// Inline-editable text: shows the content string normally; when admin taps
/// the pencil icon, a dialog lets them edit the value in real time.
class EditableLabel extends StatelessWidget {
  final String contentKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  const EditableLabel(this.contentKey, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    final text = context.t(contentKey);
    if (!context.isAdmin) {
      return Text(text, style: style, textAlign: textAlign);
    }
    return GestureDetector(
      onTap: () => _showEditDialog(context, contentKey, text),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(text, style: style, textAlign: textAlign)),
          const SizedBox(width: 4),
          const Icon(Icons.edit, size: 14, color: kGreen),
        ],
      ),
    );
  }
}

void _showEditDialog(BuildContext context, String key, String current) {
  final ctrl = TextEditingController(text: current);
  final content = context.content;
  ctrl.addListener(() => content.set(key, ctrl.text));
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Edit "$key"', style: const TextStyle(fontSize: 14)),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        maxLines: null,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
      ],
    ),
  );
}

/// Shows the admin login dialog. Returns true if login succeeded.
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

/// Small conditional widget for admin-only actions
class AdminOnly extends StatelessWidget {
  final Widget child;
  const AdminOnly({super.key, required this.child});
  @override
  Widget build(BuildContext context) => context.isAdmin ? child : const SizedBox.shrink();
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
                EditableLabel('intro.title', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                EditableLabel('intro.subtitle', style: const TextStyle(color: kMuted), textAlign: TextAlign.center),
                const Spacer(),
                const CleanTextField(hint: 'Email', icon: Icons.email_outlined),
                const CleanTextField(hint: 'Password', icon: Icons.lock_outline, obscure: true),
                const SizedBox(height: 8),
                PrimaryButton(context.t('intro.login'), () => Navigator.pushReplacementNamed(context, '/home')),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(context.t('intro.create'), style: const TextStyle(color: kMuted)),
                ),
                TextButton(
                  onPressed: () async {
                    final ok = await showAdminLoginDialog(context);
                    if (ok && context.mounted) {
                      Navigator.pushNamed(context, '/admin/users');
                    }
                  },
                  child: Text(context.t('intro.admin'), style: const TextStyle(color: kGreen)),
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
        appBar: CleanAppBar(title: context.t('register.title')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CleanTextField(hint: 'Full Name'),
              const CleanTextField(hint: 'Email'),
              const CleanTextField(hint: 'Password', obscure: true),
              const Spacer(),
              PrimaryButton(context.t('register.continue'), () => Navigator.pushNamed(context, '/health')),
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
        appBar: CleanAppBar(title: context.t('health.title')),
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
              PrimaryButton(context.t('health.continue'), () => Navigator.pushNamed(context, '/goal')),
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
        appBar: CleanAppBar(title: context.t('goal.title')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditableLabel('goal.calorie_label', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const CleanTextField(hint: 'e.g. 1900 kcal'),
              const SizedBox(height: 24),
              EditableLabel('goal.activity_label', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const CleanTextField(hint: 'Light / Active / Very Active'),
              const Spacer(),
              PrimaryButton(context.t('goal.save'), () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
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
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: kInk),
                    const SizedBox(width: 8),
                    EditableLabel('dash.today', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Icon(Icons.keyboard_arrow_down, size: 18),
                  ],
                ),
              ),
              Row(
                children: [
                  AdminOnly(child: const Icon(Icons.edit_note, color: kMuted)),
                  const SizedBox(width: 16),
                  const Icon(Icons.more_horiz, color: kMuted),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),

          // Total Calories
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(value: 0.79, strokeWidth: 8, backgroundColor: Colors.grey[100], color: kGreen),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EditableLabel('dash.percent', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          EditableLabel('dash.of_goal', style: const TextStyle(fontSize: 9, color: kMuted)),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditableLabel('dash.total_label', style: const TextStyle(color: kMuted, fontSize: 13)),
                      const SizedBox(height: 4),
                      EditableLabel('dash.total_value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.circle, size: 8, color: kGreen),
                          const SizedBox(width: 6),
                          Flexible(child: EditableLabel('dash.track_msg', style: const TextStyle(fontSize: 11, color: kMuted))),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          EditableLabel('dash.history_title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),

          // Meal Item
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
                    children: [
                      EditableLabel('dash.meal_name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      EditableLabel('dash.meal_cal', style: const TextStyle(fontSize: 12, color: kMuted)),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: kGreen,
                  radius: 22,
                  child: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () {}),
                )
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
                    EditableLabel('capture.gallery', style: const TextStyle(fontSize: 12)),
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
                    EditableLabel('capture.flash', style: const TextStyle(fontSize: 12)),
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
        appBar: CleanAppBar(title: context.t('analysis.title')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(height: 200, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 24),
            EditableLabel('analysis.food_name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                children: [
                  Flexible(child: EditableLabel('analysis.cal_label', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kInk))),
                  EditableLabel('analysis.cal_value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kGreen)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            PrimaryButton(context.t('analysis.save_btn'), () => Navigator.pushNamed(context, '/save')),
          ],
        ),
      );
}

// ───────────────────────── 8. Save Meal ─────────────────────────
class SaveMealScreen extends StatelessWidget {
  const SaveMealScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CleanAppBar(title: context.t('save.title')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CleanTextField(hint: 'Meal Name (e.g. Breakfast, Lunch)'),
              const SizedBox(height: 16),
              EditableLabel('save.time_label', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const CleanTextField(hint: '09:00 AM', icon: Icons.access_time),
              const Spacer(),
              PrimaryButton(context.t('save.confirm'), () => Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false)),
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
              InkWell(
                onTap: () {
                  // แก้ไขปุ่มย้อนกลับให้ตรวจสอบก่อนว่า pop ได้หรือไม่
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16),
                ),
              ),
              Expanded(child: Center(child: EditableLabel('profile.title', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 32),
          const Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white, size: 40))),
          const SizedBox(height: 32),

          // Account Info Card
          _InfoCard(title: 'profile.account_title', items: const {
            'FULL-NAME': 'profile.full_name',
            'Email': 'profile.email',
            'Birthdate': 'profile.birthdate',
          }),
          const SizedBox(height: 16),

          // Change Password - เปลี่ยนให้เด้งไปหน้าจอใหม่
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
              child: Center(
                child: EditableLabel('profile.change_pw', style: const TextStyle(fontWeight: FontWeight.bold))
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Personal Info Card
          _InfoCard(title: 'profile.personal_title', items: const {
            'น้ำหนัก (Weight)': 'profile.weight',
            'ส่วนสูง (Height)': 'profile.height',
            'อายุ (Age)': 'profile.age',
            'เป้าหมาย (Goal)': 'profile.goal',
            'ระดับกิจกรรม (Activity)': 'profile.activity',
          }),
          const SizedBox(height: 32),

          // ปุ่ม Log Out แบบมี Dialog แจ้งเตือน
          PrimaryButton(
            context.t('profile.logout'), 
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
  final Map<String, String> items; // label → content key
  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EditableLabel(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...items.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key, style: const TextStyle(color: kMuted, fontSize: 13)),
                    Flexible(child: EditableLabel(e.value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.centerRight,
            child: AdminOnly(
              child: InkWell(
                onTap: () {},
                child: Text(context.t('profile.edit'), style: const TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── หน้าต่างตั้งค่ารหัสผ่านใหม่ (เพิ่มใหม่) ─────────────────────────
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
              // แจ้งเตือนและกลับไปยังหน้าโปรไฟล์
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

// ───────────────────────── 10. Account (Settings) ─────────────────────────
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CleanAppBar(title: context.t('account.title')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: EditableLabel('account.notif'),
              trailing: Switch(value: true, onChanged: (v) {}, activeTrackColor: kGreen),
            ),
            const Divider(color: kBorder),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: EditableLabel('account.theme'),
              trailing: const Icon(Icons.chevron_right, color: kMuted),
            ),
          ],
        ),
      );
}

// ───────────────────────── 11. Admin Users ─────────────────────────
class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  static const _users = [
    {'id': '6701'},
    {'id': '6702'},
    {'id': '6703'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CleanAppBar(title: '', showBack: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Center(child: CircleAvatar(radius: 40, backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white, size: 40))),
          const SizedBox(height: 16),
          Center(child: EditableLabel('admin_users.admin_label', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const SizedBox(height: 24),
          const CleanTextField(hint: 'search ID', icon: Icons.search),
          const SizedBox(height: 8),
          for (final u in _users) _UserCard(id: u['id']!),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String id;
  const _UserCard({required this.id});

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
              AdminOnly(child: Row(children: [
                _outlineBtn(context.t('admin_users.edit'), kGreen, Icons.edit),
                const SizedBox(width: 8),
                _outlineBtn(context.t('admin_users.delete'), kRed, Icons.delete_outline),
              ])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('username :', style: TextStyle(color: kMuted)),
              Flexible(child: EditableLabel('user.$id.name', style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Email :', style: TextStyle(color: kMuted)),
              Flexible(child: EditableLabel('user.$id.email', style: const TextStyle(color: kBlue))),
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
  Widget build(BuildContext context) => Scaffold(
        appBar: CleanAppBar(title: context.t('admin_foods.title')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const CleanTextField(hint: 'Search food...', icon: Icons.search),
            PrimaryButton(context.t('admin_foods.add'), () {}),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorder)),
              child: EditableLabel('admin_foods.placeholder', style: const TextStyle(color: kMuted)),
            ),
          ],
        ),
      );
}
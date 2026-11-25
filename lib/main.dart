import 'package:flutter/material.dart';
import 'theme/design_tokens.dart';
import 'security/app_lock.dart';
import 'security/session_timer.dart';
import 'screens/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WorkDeskApp());
}

class WorkDeskApp extends StatelessWidget {
  const WorkDeskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkDesk',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF005aa3),
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Color(0xFF005aa3),
          secondary: Color(0xFF00d4ff),
          surface: Color(0xFFF5F7FA),
          background: Color(0xFFF5F7FA),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF0066cc),
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF0066cc),
          secondary: Color(0xFF00d4ff),
          surface: Color(0xFF1a1a1a),
          background: Color(0xFF0f0f0f),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const WorkDeskHome(),
    );
  }
}

class WorkDeskHome extends StatefulWidget {
  const WorkDeskHome({Key? key}) : super(key: key);

  @override
  State<WorkDeskHome> createState() => _WorkDeskHomeState();
}

class _WorkDeskHomeState extends State<WorkDeskHome>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isLocked = false;
  late SessionTimer _sessionTimer;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Check if PIN is set - if yes, show lock screen
    if (await AppLock.hasPin()) {
      setState(() => _isLocked = true);
    }

    // Initialize session timer for background lock
    _sessionTimer = SessionTimer(
      onLockRequired: () async {
        setState(() => _isLocked = true);
      },
    );
  }

  void _onUnlocked() {
    setState(() => _isLocked = false);
  }

  Future<void> _setupPin() async {
    // Show PIN setup dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PinSetupDialog(onComplete: (pin) async {
        await AppLock.setPin(pin);
        setState(() => _isLocked = true);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ПИН-код установлен')),
        );
      }),
    );
  }

  @override
  void dispose() {
    _sessionTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocked && (AppLock.hasPin() as Future<bool>).asStream().isEmpty) {
      return Scaffold(
        body: LockScreen(onUnlocked: _onUnlocked),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WorkDesk v1.5.3',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF005aa3),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),

              // Logo
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF005aa3), Color(0xFF00d4ff)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.desktop_mac,
                  size: 48,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 32),

              Text(
                'WorkDesk',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Color(0xFF005aa3),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Удалённый доступ к компьютерам через server.hrgov.kz',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48),

              // Features
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeature('Защита ПИН-кодом', Icons.lock),
                    SizedBox(height: 12),
                    _buildFeature('Биометрическая проверка', Icons.fingerprint),
                    SizedBox(height: 12),
                    _buildFeature('Таймер блокировки', Icons.timer),
                    SizedBox(height: 12),
                    _buildFeature('Дизайн workdesk.kz', Icons.palette),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Security Status
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF005aa3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: Color(0xFF005aa3),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Безопасность активна',
                        style: TextStyle(
                          color: Color(0xFF005aa3),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 48),

              // Actions
              ElevatedButton.icon(
                onPressed: _setupPin,
                icon: Icon(Icons.lock_outline),
                label: Text('Установить ПИН'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF005aa3),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),

              SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Справка: worktime.kz/help'),
                    ),
                  );
                },
                icon: Icon(Icons.help_outline),
                label: Text('Справка'),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),

              SizedBox(height: 48),

              Text(
                '© 2026 WorkDesk\nСервер: server.hrgov.kz (89.126.206.53)\nВсе ссылки: worktime.kz',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Безопасность'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'О нас'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildFeature(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF005aa3), size: 20),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Dialog for PIN setup
class _PinSetupDialog extends StatefulWidget {
  final Function(String pin) onComplete;

  const _PinSetupDialog({required this.onComplete});

  @override
  State<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends State<_PinSetupDialog> {
  List<String> _pin1 = List.filled(4, '');
  List<String> _pin2 = List.filled(4, '');
  String _stage = 'first'; // first, confirm
  String _error = '';

  void _addDigit(String digit) {
    final target = _stage == 'first' ? _pin1 : _pin2;
    final emptyIdx = target.indexWhere((d) => d.isEmpty);
    if (emptyIdx != -1) {
      setState(() {
        target[emptyIdx] = digit;
      });
      if (emptyIdx == 3) {
        if (_stage == 'first') {
          setState(() => _stage = 'confirm');
        } else {
          final pin1 = _pin1.join();
          final pin2 = _pin2.join();
          if (pin1 == pin2) {
            widget.onComplete(pin1);
          } else {
            setState(() {
              _error = 'ПИН не совпадает';
              _pin1 = List.filled(4, '');
              _pin2 = List.filled(4, '');
              _stage = 'first';
            });
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) setState(() => _error = '');
            });
          }
        }
      }
    }
  }

  void _removeDigit() {
    final target = _stage == 'first' ? _pin1 : _pin2;
    final lastIdx = target.lastIndexWhere((d) => d.isNotEmpty);
    if (lastIdx != -1) {
      setState(() => target[lastIdx] = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = _stage == 'first' ? _pin1 : _pin2;

    return AlertDialog(
      title: Text('Установите ПИН'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_stage == 'first' ? 'Введите новый ПИН' : 'Подтвердите ПИН'),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (i) => Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(target[i].isEmpty ? '' : '●'),
                ),
              ),
            ),
          ),
          if (_error.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              _error,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Отмена'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WaziCodeApp());
}

class WaziCodeApp extends StatelessWidget {
  const WaziCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaziCode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00D4AA)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4AA),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final res = await http.get(Uri.parse('http://localhost:3011/api/stats'));
      if (res.statusCode == 200) {
        setState(() => stats = json.decode(res.body));
      }
    } catch (e) {
      // Offline mode
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💻 WAZICODE', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _currentIndex == 0
          ? _buildHome()
          : _currentIndex == 1
              ? _buildSandbox()
              : _buildProfile(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Sandbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Plateforme Développeur Africaine',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Sandbox vérifiée • Mobile Money • SMS • USSD',
          style: TextStyle(color: Colors.grey[400]),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard(icon: Icons.people, value: '${stats['users'] ?? 0}', label: 'Développeurs'),
            _StatCard(icon: Icons.vpn_key, value: '${stats['api_keys'] ?? 0}', label: 'Clés API'),
            _StatCard(icon: Icons.receipt, value: '${stats['transactions'] ?? 0}', label: 'Transactions'),
            _StatCard(icon: Icons.inventory, value: '${stats['sdks'] ?? 0}', label: 'SDKs'),
          ],
        ),
      ],
    );
  }

  Widget _buildSandbox() {
    return const Center(child: Text('Bac à Sable — Testez les APIs'));
  }

  Widget _buildProfile() {
    return const Center(child: Text('Profil développeur'));
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 32),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

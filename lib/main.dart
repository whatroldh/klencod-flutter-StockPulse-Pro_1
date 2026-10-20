import 'package:flutter/material.dart';

void main() {
  runApp(const StockTradingApp());
}

class StockTradingApp extends StatelessWidget {
  const StockTradingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StockPulse Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isBotActive = false;
  double stockPrice = 189.50;
  String botStatusMessage = 'التداول الآلي متوقف';

  void _toggleBot() {
    setState(() {
      isBotActive = !isBotActive;
      botStatusMessage = isBotActive ? 'التداول الآلي يعمل بنجاح (Active)' : 'تم إيقاف التداول الآلي';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(botStatusMessage),
        duration: const Duration(seconds: 2),
        backgroundColor: isBotActive ? Colors.green : Colors.red,
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم التداول الذكي'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              _showInfoDialog('التنبيهات', 'لا توجد تنبيهات جديدة حتى الآن. السوق مستقر.');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مؤشرات الأداء العامة (قابلة للضغط)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showInfoDialog('نمو السهم', 'معدل النمو الحالي يقدر بـ +14.8% بناءً على آخر إغلاق أسبوعي.'),
                    child: _buildMetricCard('نمو السهم', '+14.8%', Colors.green, Icons.trending_up),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showInfoDialog('حجم التداول', 'إجمالي حجم التداول المباشر وصل إلى 2.4 مليون سهم اليوم.'),
                    child: _buildMetricCard('حجم التداول', '2.4M', Colors.blue, Icons.bar_chart),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // بطاقة السهم الرئيسي وإدارة الصفقات الآلية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AAPL - Apple Inc.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$$stockPrice',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white24),
                  _buildPriceRow('أرخص نقطة شراء (دعم):', '\$175.20', Colors.cyan),
                  const SizedBox(height: 8),
                  _buildPriceRow('أعلى نقطة ربح (هدف):', '\$210.00', Colors.green),
                  const SizedBox(height: 8),
                  _buildPriceRow('إيقاف الخسارة الضروري:', '\$170.00', Colors.redAccent),
                  const SizedBox(height: 16),
                  
                  // زر تفعيل التداول الآلي الحقيقي
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _toggleBot,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBotActive ? Colors.red.shade700 : Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isBotActive ? 'إيقاف التداول الآلي (Bot OFF)' : 'تشغيل التداول الآلي (Bot ON)',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // سجل المؤشرات اللحظية (قابلة للضغط)
            const Text(
              'حالة المؤشرات والتحليل الفني',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _showInfoDialog('مؤشر القوة النسبية (RSI)', 'القيمة الحالية 58.4 تعني أن السهم في منطقة استقرار ومحايد إلى صاعد.'),
              child: _buildIndicatorItem('مؤشر القوة النسبية (RSI)', '58.4 (محايد إلى صاعد)', Colors.orange),
            ),
            GestureDetector(
              onTap: () => _showInfoDialog('متوسط الحركة (SMA 50)', 'السعر يتحرك فوق المتوسط المتحرك، مما يعطي إشارة شراء قوية للمدى القصير.'),
              child: _buildIndicatorItem('متوسط الحركة (SMA 50)', 'إشارة شراء قوية', Colors.green),
            ),
            GestureDetector(
              onTap: () => _showInfoDialog('مؤشر البولنجر باند', 'التقلبات منخفضة وسعر السهم مستقر داخل النطاق الطبيعي للتداول.'),
              child: _buildIndicatorItem('مؤشر البولنجر باند (Bollinger)', 'استقرار سعر السهم ضمن النطاق', Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildIndicatorItem(String name, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
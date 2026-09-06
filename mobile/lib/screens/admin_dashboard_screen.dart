import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Nook Admin & Concierge Dashboard'),
        iconTheme: const IconThemeData(color: AppTheme.textWhite),
        titleTextStyle: const TextStyle(color: AppTheme.textWhite, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Locality Launch Mode Card
            _buildAdminCard(
              title: '📍 Locality Launch Mode',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Locality: Koramangala, Bengaluru', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
                  SizedBox(height: 4),
                  Text('Status: LAUNCHED (124 Providers, 89 Seekers)', style: TextStyle(color: AppTheme.successGreen, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('Supply Gap Alert: Event Decorators & Doctors low density', style: TextStyle(color: AppTheme.starGold, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Provider Seeding Dashboard
            _buildAdminCard(
              title: '🌱 Provider Seeding Dashboard',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Invite local professionals directly via SMS/WhatsApp referral', style: TextStyle(color: AppTheme.textMuted)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.person_add_alt, size: 16),
                    label: const Text('Send Provider Invite Code'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Seeding code generated: NOOK-KORAMANGALA-2026')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Analytics Conversion Funnel
            _buildAdminCard(
              title: '📊 Conversion Funnel Analytics',
              child: const Column(
                children: [
                  _MetricRow(label: 'Needs Submitted', value: '42'),
                  _MetricRow(label: 'Connection Requests Sent', value: '38'),
                  _MetricRow(label: 'Requests Accepted', value: '31'),
                  _MetricRow(label: 'Funnel Conversion Rate', value: '81.5%'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Validation & Concierge Workspace
            _buildAdminCard(
              title: '📋 Validation & Interview Workspace',
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Target Respondents Approached: 24 / 25', style: TextStyle(color: AppTheme.textMuted)),
                  SizedBox(height: 4),
                  Text('Top Trust Concern: "Exposing exact home address before meeting"', style: TextStyle(color: AppTheme.textWhite)),
                  SizedBox(height: 4),
                  Text('Willingness to connect via Nook: HIGH (92%)', style: TextStyle(color: AppTheme.successGreen)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardDarkElevated),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textWhite)),
            const Divider(height: 20, color: AppTheme.cardDarkElevated),
            child,
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryPurple)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/api_service_provider.dart';
import '../models/api_response.dart';
import '../utils/pages.dart';

class MomoConfirmationScreen extends ConsumerStatefulWidget {
  final String serviceRequestId;
  final double amount;
  final String providerName;
  final String? reference;
  final String? serviceType; // 'towing' or 'water'
  const MomoConfirmationScreen({super.key, required this.serviceRequestId, required this.amount, required this.providerName, this.reference, this.serviceType});

  @override
  ConsumerState<MomoConfirmationScreen> createState() => _MomoConfirmationScreenState();
}

class _MomoConfirmationScreenState extends ConsumerState<MomoConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _amountCard(),
                    const SizedBox(height: 24),
                    const Text(
                      'Please confirm the prompt sent to you via USSD to  complete payment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                    ),
                  ],
                ),
              ),
            ),
            _confirmButton(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            InkWell(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.customerHome);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_left, size: 24),
              ),
            ),
            const SizedBox(width: 4),
            const Text('Payment', style: TextStyle(color: Color(0xFF086788), fontSize: 18, fontWeight: FontWeight.w500)),
          ]),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x1A086788))),
            child: const Icon(Icons.notifications_none, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _amountCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEBFBFE), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0x1A086788), width: 4)),
      child: Column(
        children: [
          const Text('Confirm payment of:', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E))),
          const SizedBox(height: 8),
          Text('GHS ${widget.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, color: Color(0xFFE30C00), fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          const Text('To:', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E))),
          const SizedBox(height: 4),
          Text(widget.providerName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: Color(0xFF086788), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _confirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () async {
          final api = ref.read(apiServiceProvider);
          final listRes = await api.getPaymentsForServiceRequest(widget.serviceRequestId);
          String? paymentId;
          if (listRes.success && listRes.data != null && listRes.data!.isNotEmpty) {
            final items = listRes.data!;
            final pending = items.firstWhere(
              (e) => (e['status']?.toString() ?? '').toLowerCase() == 'pending',
              orElse: () => items.first,
            );
            paymentId = (pending['id'] ?? '').toString();
          }
          ApiResponse<Map<String, dynamic>> result;
          if (paymentId != null && paymentId.isNotEmpty) {
            result = await api.confirmPayment(paymentId);
          } else {
            result = await api.createPayment(data: {
              'service_request_id': widget.serviceRequestId,
              'amount': widget.amount,
              'currency': 'GHS',
              'method': 'momo',
              'status': 'completed',
              'reference': widget.reference ?? '',
            });
          }
          final ok = result.success;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Payment confirmed' : 'Payment failed: ${result.message}')));
          if (ok) {
            if ((widget.serviceType ?? '').toLowerCase() == 'water') {
              context.go(AppRoutes.customerActiveWaterJob, extra: {
                'serviceRequestId': widget.serviceRequestId,
                'reference': widget.reference,
                'amount': widget.amount,
                'providerName': widget.providerName,
              });
            } else {
              context.go(AppRoutes.customerActiveTowingJob, extra: {
                'serviceRequestId': widget.serviceRequestId,
                'reference': widget.reference,
                'amount': widget.amount,
                'providerName': widget.providerName,
              });
            }
          }
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(color: const Color(0xFF086788), borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(width: 325, child: Center(child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14)))),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.arrow_forward, color: Color(0xFF086788))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
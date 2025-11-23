import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/api_service_provider.dart';
import '../models/api_response.dart';
import '../utils/pages.dart';

class WalletConfirmationScreen extends ConsumerStatefulWidget {
  final String serviceRequestId;
  final double amount;
  final String providerName;
  final String? reference;
  final String? serviceType; // 'towing' or 'water'
  const WalletConfirmationScreen({super.key, required this.serviceRequestId, required this.amount, required this.providerName, this.reference, this.serviceType});

  @override
  ConsumerState<WalletConfirmationScreen> createState() => _WalletConfirmationScreenState();
}

class _WalletConfirmationScreenState extends ConsumerState<WalletConfirmationScreen> {
  String _pin = '';

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
                    const SizedBox(height: 32),
                    const Text('Enter your WATO Wallet Pin to Continue', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E))),
                    const SizedBox(height: 12),
                    _pinBoxes(),
                  ],
                ),
              ),
            ),
            _confirmButton(context),
            _keypad(),
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

  Widget _pinBoxes() {
    final boxes = List.generate(4, (i) {
      final ch = i < _pin.length ? _pin[i] : '';
      final selected = i == _pin.length;
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF086788) : const Color(0xFFF4F4F4)),
        ),
        child: Center(child: Text(ch.isEmpty ? '' : ch, style: const TextStyle(fontSize: 28, color: Color(0xFF086788))))
      );
    });
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [for (final b in boxes) ...[b, const SizedBox(width: 16)]]);
  }

  Widget _confirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () async {
          if (_pin.length != 4) return;
          final api = ref.read(apiServiceProvider);
          try {
            final main = await api.getMyMainWallet();
            if (!main.success || main.data == null || (main.data!['id'] ?? '').toString().isEmpty) {
              final prof = await api.getProfileMe();
              if (prof.success && prof.data != null) {
                final profileId = (prof.data!['id'] ?? '').toString();
                if (profileId.isNotEmpty) {
                  await api.createWallet(data: {
                    'wallet_name': 'WATO Wallet',
                    'profile_id': profileId,
                    'wallet_provider': 'Paystack',
                    'wallet_type': 'mobile_money',
                    'wallet_account_number': '',
                    'wallet_bank_name': '',
                    'wallet_recipient_code': '',
                  });
                }
              }
            }
          } catch (_) {}
          final result = await api.createPayment(data: {
            'service_request_id': widget.serviceRequestId,
            'amount': widget.amount,
            'currency': 'GHS',
            'method': 'wallet',
            'status': 'completed',
            'reference': widget.reference ?? '',
            'pin': _pin,
          });
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
                child: SizedBox(
                  width: 325,
                  child: Center(child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 14))),
                ),
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

  Widget _keypad() {
    return SizedBox(
      height: 305,
      child: Column(
        children: [
          _keypadRow(['1', '2', '3']),
          _keypadRow(['4', '5', '6']),
          _keypadRow(['7', '8', '9']),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _key('0'),
              const SizedBox(width: 12),
              _backspace(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keypadRow(List<String> labels) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [for (final l in labels) ...[_key(l), const SizedBox(width: 12)]],
      ),
    );
  }

  Widget _key(String label) {
    return InkWell(
      onTap: () {
        if (_pin.length < 4) {
          setState(() => _pin = _pin + label);
        }
      },
      child: Container(
        width: 123,
        height: 48,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [BoxShadow(color: Color(0x7F000000), blurRadius: 1, offset: Offset(0, 1))]),
        child: Center(child: Text(label, style: const TextStyle(fontSize: 26, color: Colors.black))),
      ),
    );
  }

  Widget _backspace() {
    return InkWell(
      onTap: () {
        if (_pin.isNotEmpty) {
          setState(() => _pin = _pin.substring(0, _pin.length - 1));
        }
      },
      child: Container(
        width: 123,
        height: 48,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: const Center(child: Icon(Icons.backspace_outlined)),
      ),
    );
  }
}
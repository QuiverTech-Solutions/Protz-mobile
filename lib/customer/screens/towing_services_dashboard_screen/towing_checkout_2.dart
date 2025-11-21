import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/dashboard_provider.dart';
import '../../../shared/providers/service_providers_provider.dart';
import '../../../shared/providers/api_service_provider.dart';
import '../../../shared/utils/pages.dart';

class TowingCheckout2 extends ConsumerStatefulWidget {
  final Map<String, dynamic>? towingData;
  const TowingCheckout2({super.key, this.towingData});

  @override
  ConsumerState<TowingCheckout2> createState() => _TowingCheckout2State();
}

class _TowingCheckout2State extends ConsumerState<TowingCheckout2> {
  int _selectedPaymentIndex = 0; // 0 wallet, 1 momo, 2 cash
  double _amount = 0;
  String? _requestNumber;
  String? _serviceRequestId;
  int _selectedProviderIndex = -1;

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final user = ref.watch(userInfoProvider);
    final wallet = ref.watch(walletInfoProvider);
    final providersState = ref.watch(serviceProvidersProvider);

    _requestNumber ??= widget.towingData?['requestNumber']?.toString();
    _serviceRequestId ??= widget.towingData?['serviceRequestId']?.toString();
    _selectedProviderIndex = (widget.towingData?['selectedProviderIndex'] as int?) ?? _selectedProviderIndex;
    if (_selectedProviderIndex >= 0 && providersState.providers.isNotEmpty && _selectedProviderIndex < providersState.providers.length) {
      final p = providersState.providers[_selectedProviderIndex];
      _amount = p.basePrice;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _selectedProviderCard(providersState),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0x1A086788)),
                    const SizedBox(height: 16),
                    const Text(
                      'Please select your mode of payment to proceed:',
                      style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                    ),
                    const SizedBox(height: 12),
                    _walletOption(userName: user?.name ?? '—', walletAmount: wallet?.balance ?? 0),
                    const SizedBox(height: 16),
                    _momoOption(),
                    const SizedBox(height: 16),
                    _cashOption(),
                  ],
                ),
              ),
            ),
            _payNowButton(context),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_left, size: 24),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Checkout',
              style: TextStyle(color: Color(0xFF086788), fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ]),
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x1A086788)),
            ),
            child: const Icon(Icons.notifications_none, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _selectedProviderCard(ServiceProvidersState providersState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEBFBFE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A086788), width: 4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            height: 59,
            child: Image.asset('assets/images/towing.png', fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedProviderIndex >= 0 && providersState.providers.isNotEmpty && _selectedProviderIndex < providersState.providers.length
                      ? providersState.providers[_selectedProviderIndex].name
                      : 'Selected Towing Provider',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF30313D)),
                ),
                SizedBox(height: 4),
                Text('Will arrive at pickup in approximately ${_selectedProviderIndex >= 0 && providersState.providers.isNotEmpty && _selectedProviderIndex < providersState.providers.length ? (providersState.providers[_selectedProviderIndex].estimatedArrival ?? '-') : '-'} mins', style: const TextStyle(fontSize: 10, color: Color(0xFF8F8F8F))),
                SizedBox(height: 6),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('GHS ${_amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF009F22))),
              const Opacity(opacity: 0.5, child: Text('GHS 290', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF909090), decoration: TextDecoration.lineThrough))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _walletOption({required String userName, required double walletAmount}) {
    final selected = _selectedPaymentIndex == 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pay with Protz Wallet', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E))),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _selectedPaymentIndex = 0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEBFBFE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBFBFE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: const [Icon(Icons.account_balance_wallet_outlined, size: 24), SizedBox(width: 8)]),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Protz Wallet Account', style: TextStyle(color: Color(0xFF086788), fontSize: 14)),
                      Text('GHS ${walletAmount.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF086788), fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Customer', style: TextStyle(fontSize: 10, color: Color(0xFF086788))),
                    ),
                    Text(userName, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(width: 8),
                _radio(selected),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _momoOption() {
    final selected = _selectedPaymentIndex == 1;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentIndex = 1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFEBFBFE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBFBFE)),
        ),
        child: Row(
          children: [
            const Expanded(child: Text('Pay With Momo', style: TextStyle(color: Color(0xFF086788), fontSize: 14))),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _cashOption() {
    final selected = _selectedPaymentIndex == 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pay with Cash', style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E))),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _selectedPaymentIndex = 2),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEBFBFE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBFBFE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: const [Icon(Icons.home_outlined, size: 24), SizedBox(width: 8)]),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pay with cash upon delivery', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 4),
                      Text('Please make sure you have the exact amount ready.', style: TextStyle(fontSize: 10, color: Color(0xFF1E1E1E))),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _RadioStatic(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _payNowButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: InkWell(
        onTap: () async {
          if (_serviceRequestId == null || _serviceRequestId!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Missing request id')));
            return;
          }
          if (_selectedPaymentIndex == 0) {
            context.go(AppRoutes.walletConfirm, extra: {
              'serviceType': 'towing',
              'serviceRequestId': _serviceRequestId,
              'amount': _amount,
              'providerName': _providerName(),
              'reference': _requestNumber,
            });
            return;
          }
          if (_selectedPaymentIndex == 1) {
            context.go(AppRoutes.momoConfirm, extra: {
              'serviceType': 'towing',
              'serviceRequestId': _serviceRequestId,
              'amount': _amount,
              'providerName': _providerName(),
              'reference': _requestNumber,
            });
            return;
          }
          final api = ref.read(apiServiceProvider);
          final listRes = await api.getPaymentsForServiceRequest(_serviceRequestId!);
          String? paymentId;
          if (listRes.success && listRes.data != null && listRes.data!.isNotEmpty) {
            final items = listRes.data!;
            final pending = items.firstWhere(
              (e) => (e['status']?.toString() ?? '').toLowerCase() == 'pending',
              orElse: () => items.first,
            );
            paymentId = (pending['id'] ?? '').toString();
          }
          bool ok;
          String msg;
          if (paymentId != null && paymentId.isNotEmpty) {
            final upd = await api.updatePayment(paymentId, status: 'pending');
            ok = upd.success;
            msg = upd.message ?? 'Payment updated';
          } else {
            final res = await api.createPayment(data: {
              'service_request_id': _serviceRequestId,
              'amount': _amount,
              'currency': 'GHS',
              'method': 'cash',
              'status': 'pending',
              'reference': _requestNumber ?? '',
            });
            ok = res.success;
            msg = res.message ?? '';
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Payment initiated' : 'Payment failed: $msg')));
          if (ok) {
            context.go(AppRoutes.customerActiveTowingJob, extra: {
              'serviceRequestId': _serviceRequestId,
              'reference': _requestNumber,
              'amount': _amount,
              'providerName': _providerName(),
            });
          }
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF086788),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 325,
                  child: Center(
                    child: Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.arrow_forward, color: Color(0xFF086788)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _providerName() {
    final providersState = ref.read(serviceProvidersProvider);
    if (_selectedProviderIndex >= 0 && providersState.providers.isNotEmpty && _selectedProviderIndex < providersState.providers.length) {
      return providersState.providers[_selectedProviderIndex].name;
    }
    return 'Selected Towing Provider';
  }

  Widget _radio(bool selected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF086788) : Colors.white,
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _RadioStatic extends StatelessWidget {
  const _RadioStatic();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: Colors.white),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_export.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isProtzWalletExpanded = true;
  bool _isMobileMoneyExpanded = false;
  bool _isCardExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        _buildProtzWalletSection(),
                        SizedBox(height: 16.h),
                        _buildMobileMoneySection(),
                        SizedBox(height: 16.h),
                        _buildCardSection(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          SizedBox(width: 8.h),
          Text(
            'Your Wallets',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF322F35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtzWalletSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isProtzWalletExpanded = !_isProtzWalletExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Row(
                children: [
                  Text(
                    'Your Protz Wallet',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF322F35),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isProtzWalletExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF086788),
                  ),
                ],
              ),
            ),
          ),
          if (_isProtzWalletExpanded) _buildProtzWalletCard(),
        ],
      ),
    );
  }

  Widget _buildProtzWalletCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 0, 16.h, 16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FFFE),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: const Color(0xFFE0F2F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Williams',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF322F35),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF086788),
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                        child: Text(
                          'Protz Wallet',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.edit_outlined,
                color: const Color(0xFF086788),
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'GHS 800.50',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF322F35),
            ),
          ),
          Text(
            'Available Balance',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF808080),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Withdraw funds',
                  Colors.white,
                  const Color(0xFF086788),
                  const Color(0xFF086788),
                  () {
                    // Handle withdraw
                  },
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: _buildActionButton(
                  'Add funds',
                  const Color(0xFF086788),
                  Colors.white,
                  const Color(0xFF086788),
                  () {
                    // Handle add funds
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMoneySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isMobileMoneyExpanded = !_isMobileMoneyExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Row(
                children: [
                  Text(
                    'Mobile Money Account(s)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF322F35),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isMobileMoneyExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF086788),
                  ),
                ],
              ),
            ),
          ),
          if (_isMobileMoneyExpanded) _buildMobileMoneyCard(),
        ],
      ),
    );
  }

  Widget _buildMobileMoneyCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 0, 16.h, 16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FFFE),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: const Color(0xFFE0F2F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Account Name',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF808080),
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: const Color(0xFF086788),
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'John Williams',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF322F35),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF086788),
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: Text(
                  'Mobile Money Details',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F8),
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '0244566419',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF322F35),
                  ),
                ),
                Text(
                  'MTN Mobile Money',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(
              'Add Mobile Money Account',
              const Color(0xFF086788),
              Colors.white,
              const Color(0xFF086788),
              () {
                context.push('/customer/add-mobile-money');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isCardExpanded = !_isCardExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Row(
                children: [
                  Text(
                    'Card(s)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF322F35),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isCardExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF086788),
                  ),
                ],
              ),
            ),
          ),
          if (_isCardExpanded) _buildCardDetailsCard(),
        ],
      ),
    );
  }

  Widget _buildCardDetailsCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 0, 16.h, 16.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FFFE),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: const Color(0xFFE0F2F1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card Holder\'s Name',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF808080),
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: const Color(0xFF086788),
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'John Williams',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF322F35),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF086788),
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: Text(
                  'Card Details',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F8),
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '4445 0987 6543 6789',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF322F35),
                  ),
                ),
                Text(
                  'Expiry: 02/29',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: _buildActionButton(
              'Add Credit/Debit Card',
              const Color(0xFF086788),
              Colors.white,
              const Color(0xFF086788),
              () {
                context.push('/customer/add-card');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor,
    Color borderColor,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        side: BorderSide(color: borderColor),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text.contains('Add'))
            Icon(
              Icons.add,
              size: 16,
              color: textColor,
            ),
          if (text.contains('Add')) SizedBox(width: 4.h),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
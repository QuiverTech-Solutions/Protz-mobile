import 'package:flutter/material.dart';
import '../../../customer/core/utils/image_constant.dart';
import '../../../customer/theme/text_style_helper.dart';
import '../../../shared/widgets/live_tracking_map.dart';
import '../../../shared/widgets/custom_sliver_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../core/app_export.dart';
import '../../widgets/order_progress_bar.dart';
import '../../widgets/requester_info_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protz/shared/providers/api_service_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/service_request.dart';

class SPTowingOrderStatus extends StatefulWidget {
  final ServiceRequest? request;
  const SPTowingOrderStatus({super.key, this.request});

  @override
  State<SPTowingOrderStatus> createState() => _SPTowingOrderStatusState();
}

class _SPTowingOrderStatusState extends State<SPTowingOrderStatus> {
  double _progress = 0.3;
  String _statusText = 'Driving to the vehicle pickup point';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Order Request',
            onBackPressed: () => Navigator.of(context).maybePop(),
            pinned: true,
            backgroundColor: Colors.transparent,
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                Positioned.fill(child: _buildMap()),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottomSheet(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveExtension(16).h,
          vertical: ResponsiveExtension(20).h,
        ),
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    _statusText,
                    style: TextStyleHelper.instance.title18MediumPoppins.copyWith(
                      fontSize: ResponsiveExtension(12).fSize,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveExtension(12).h),
                _buildProgressSection(),
                SizedBox(height: ResponsiveExtension(16).h),
                RequesterInfoCard(
                  name: widget.request?.assignedProvider?.name ?? 'Requester',
                  vehicleType: 'Vehicle',
                  vehicleModel: widget.request?.serviceType ?? '—',
                  priceText: 'GHS ${(widget.request?.estimatedCost ?? widget.request?.finalCost ?? 0).toStringAsFixed(0)}',
                  badgeText: widget.request?.urgencyLevel ?? '—',
                  avatarImagePath: ImageConstant.imgAvatar,
                  onCallPressed: () {},
                  onChatPressed: () {},
                ),
                SizedBox(height: ResponsiveExtension(16).h),
                Consumer(builder: (context, ref, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Cancel',
                      backgroundColor: appTheme.white_A700,
                      textColor: const Color(0xFFE30C00),
                      borderColor: const Color(0xFFE30C00),
                      borderRadius: ResponsiveExtension(12).h,
                      height: ResponsiveExtension(50).h,
                      isFullWidth: true,
                      onPressed: () async {
                        final api = ref.read(apiServiceProvider);
                        final id = widget.request?.id;
                        if (id == null) return;
                        final res = await api.cancelServiceRequest(id);
                        if (res.success) {
                          if (mounted) {
                            context.pop();
                          }
                        }
                      },
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget _buildMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
      child: LiveTrackingMap(isProviderContext: true, requestId: widget.request?.id),
    );
  }


  Widget _buildProgressSection() {
    final s = widget.request?.status;
    if (s != null) {
      _progress = _progressFor(s);
      _statusText = _statusLabel(s);
    }
    return OrderProgressBar(
      progress: _progress,
      leftTitle: 'Vehicle pickup',
      leftSubtitle: '(2 mins away from vehicle)',
      rightTitle: 'Delivered',
      trackColor: const Color(0xFFE5E5EA),
      fillColor: appTheme.light_blue_900,
      knobColor: Colors.grey[300],
    );
  }

  double _progressFor(ServiceRequestStatus s) {
    switch (s) {
      case ServiceRequestStatus.pending:
        return 0.1;
      case ServiceRequestStatus.assigned:
        return 0.3;
      case ServiceRequestStatus.inProgress:
        return 0.6;
      case ServiceRequestStatus.completed:
        return 1.0;
      case ServiceRequestStatus.cancelled:
        return 0.0;
      case ServiceRequestStatus.confirmed:
        return 0.8;
      case ServiceRequestStatus.failed:
        return 0.0;
    }
  }

  String _statusLabel(ServiceRequestStatus s) {
    switch (s) {
      case ServiceRequestStatus.pending:
        return 'Awaiting assignment';
      case ServiceRequestStatus.assigned:
        return 'Driving to the vehicle pickup point';
      case ServiceRequestStatus.inProgress:
        return 'In progress';
      case ServiceRequestStatus.completed:
        return 'Delivered';
      case ServiceRequestStatus.cancelled:
        return 'Cancelled';
      case ServiceRequestStatus.confirmed:
        return 'Confirmed';
      case ServiceRequestStatus.failed:
        return 'Failed';
    }
  }

}
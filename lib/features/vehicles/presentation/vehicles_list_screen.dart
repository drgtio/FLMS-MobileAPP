import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/button/outline_button.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/utils/constant_vehicles.dart';
import 'package:v2x/features/vehicles/presentation/components/empty_view.dart';
import 'package:v2x/features/vehicles/presentation/components/vehicle_item.dart';
import 'package:v2x/features/vehicles/presentation/vehicles_list_view_model.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // First fetch after first frame so Provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiclesListViewModel>().init();
    });

    _scrollCtrl.addListener(() {
      final vm = context.read<VehiclesListViewModel>();
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 200) {
        vm.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VehiclesListViewModel>();

    return Scaffold(
      appBar: MainToolbar(title: 'vehicles'.tr()),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: AppFilledButton(
              label: 'add_vehicle'.tr(),
              onClick: () {
                GoRouter.of(context).push(
                  AppRoutes.addVehicle,
                  extra: {ConstantVehicles.onRefresh: viewModel.init},
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Main content switches based on first-page state
                ValueListenableBuilder<ResultState<List<RemoteVehicleModel>?>>(
                  valueListenable: viewModel.requestsState,
                  builder: (context, state, _) {
                    // FIRST LOAD: full-screen loader
                    if ((state is Loading) && viewModel.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // SUCCESS (or we already have items)
                    if (viewModel.items.isEmpty) {
                      // Empty after success
                      return EmptyView(onRefresh: viewModel.init);
                    }

                    // List with pull-to-refresh
                    return RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      child: ListView.builder(
                        controller: _scrollCtrl,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: viewModel.items.length,
                        itemBuilder: (context, index) {
                          final vehicleItem = viewModel.items[index];
                          return VehicleItem(
                            item: vehicleItem,
                            onClickEditVehicle: () {
                              GoRouter.of(context).push(
                                AppRoutes.addVehicle,
                                extra: {
                                  ConstantVehicles.selectedVehicle: vehicleItem,
                                  ConstantVehicles.onRefresh: viewModel.init,
                                },
                              );
                            },
                            onClickDeleteVehicle: () {
                              showDeleteVehicleDialog(
                                context,
                                vehicleName: vehicleItem.name ?? '',
                                onClickConfirmDelete: () {
                                  viewModel.deleteVehicle(vehicleItem.id ?? 0);
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                // BOTTOM linear progress only when loading more
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: viewModel.isLoadingMore,
                    builder: (context, loadingMore, _) {
                      if (!loadingMore) return const SizedBox.shrink();
                      return const _BottomLinearLoader();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showDeleteVehicleDialog(
    BuildContext context, {
    required String vehicleName,
    required VoidCallback onClickConfirmDelete,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_forever_rounded,
                  size: 60,
                  color: Colors.red,
                ),

                const SizedBox(height: 16),

                /// Title
                Text(
                  'Delete Vehicle',
                  style: AppStyles.textSize18.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),

                const SizedBox(height: 8),

                /// Message
                Text(
                  "Are you sure you want to delete",
                  textAlign: TextAlign.center,
                  style: AppStyles.textSize14.copyWith(
                    color: AppColors.neutral60,
                  ),
                ),

                const SizedBox(height: 4),

                /// Vehicle name
                Text(
                  vehicleName,
                  textAlign: TextAlign.center,
                  style: AppStyles.textSize16.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                /// Buttons
                Row(
                  children: [
                    /// Cancel
                    Expanded(
                      child: AppOutlinedButton(
                        containerPadding: const EdgeInsets.only(right: 2),
                        contentPadding: const EdgeInsets.all(8),
                        label: 'cancel'.tr(),
                        onClick: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Delete
                    Expanded(
                      child: AppFilledButton(
                        containerPadding: const EdgeInsets.only(left: 2),
                        contentPadding: const EdgeInsets.all(8),
                        backgroundColor: AppColors.red,
                        label: 'delete_vehicle'.tr(),
                        onClick: () {
                          onClickConfirmDelete();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BottomLinearLoader extends StatelessWidget {
  const _BottomLinearLoader();

  @override
  Widget build(BuildContext context) {
    // Overlay with a subtle background to separate from content
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(200),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor.withAlpha(125)),
        ),
      ),
      child: const LinearProgressIndicator(minHeight: 3),
    );
  }
}

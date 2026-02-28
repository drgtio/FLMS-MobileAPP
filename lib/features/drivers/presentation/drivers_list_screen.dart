import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/button/outline_button.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';
import 'package:v2x/features/drivers/presentation/components/driver_item.dart';
import 'package:v2x/features/drivers/presentation/components/empty_view.dart';
import 'package:v2x/features/drivers/presentation/drivers_list_view_model.dart';

class DriversListScreen extends StatefulWidget {
  const DriversListScreen({super.key});

  @override
  State<DriversListScreen> createState() => _DriversListScreenState();
}

class _DriversListScreenState extends State<DriversListScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriversListViewModel>().init();
    });

    _scrollCtrl.addListener(() {
      final vm = context.read<DriversListViewModel>();
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
    final viewModel = context.watch<DriversListViewModel>();

    return Scaffold(
      appBar: MainToolbar(title: 'drivers'.tr()),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: AppFilledButton(
              label: 'add_driver'.tr(),
              onClick: () => _showNotImplemented(context),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ValueListenableBuilder<ResultState<List<RemoteDriverModel>?>>(
                  valueListenable: viewModel.requestsState,
                  builder: (context, state, _) {
                    if ((state is Loading) && viewModel.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.items.isEmpty) {
                      return EmptyView(onRefresh: viewModel.init);
                    }

                    return RefreshIndicator(
                      onRefresh: viewModel.refresh,
                      child: ListView.builder(
                        controller: _scrollCtrl,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: viewModel.items.length,
                        itemBuilder: (context, index) {
                          final driver = viewModel.items[index];
                          return DriverItem(
                            item: driver,
                            onClickEditDriver: () => _showNotImplemented(context),
                            onClickDeleteDriver:
                                () => _showDeleteDriverDialog(
                                  context,
                                  driverName: driver.fullName ?? driver.username ?? '',
                                ),
                          );
                        },
                      ),
                    );
                  },
                ),
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

  void _showDeleteDriverDialog(
    BuildContext context, {
    required String driverName,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                Text(
                  'delete_driver_title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'delete_driver_message'.tr(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  driverName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        containerPadding: const EdgeInsets.only(right: 2),
                        contentPadding: const EdgeInsets.all(8),
                        label: 'cancel'.tr(),
                        onClick: () => Navigator.pop(dialogContext),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppFilledButton(
                        backgroundColor: AppColors.red,
                        label: 'delete_driver'.tr(),
                        onClick: () {
                          Navigator.pop(dialogContext);
                          _showNotImplemented(context);
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

  void _showNotImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('driver_actions_not_implemented'.tr())),
    );
  }
}

class _BottomLinearLoader extends StatelessWidget {
  const _BottomLinearLoader();

  @override
  Widget build(BuildContext context) {
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/presentation/lookup/lookup_list_viewmodel.dart';

class LookupListScreen extends StatefulWidget {
  final String title;
  final int? selectedValue;
  final Function(Maker) onItemSelected;

  const LookupListScreen({
    super.key,
    required this.title,
    this.selectedValue,
    required this.onItemSelected,
  });

  @override
  State<LookupListScreen> createState() => _LookupListScreenState();
}

class _LookupListScreenState extends State<LookupListScreen> {
  final viewModel = getIt<LookupListViewModel>();

  final _searchCtl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    viewModel.init(selectedValue: widget.selectedValue);
    _searchCtl.addListener(() {
      if (_query != _searchCtl.text) {
        setState(() => _query = _searchCtl.text);
      }
    });
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder:
          (context, _) => Scaffold(
            backgroundColor: AppColors.white,
            appBar: MainToolbar(title: widget.title, backIcon: Icons.close),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: ValueListenableBuilder<ResultState<List<Maker>?>>(
                valueListenable: viewModel.lookupState,
                builder: (context, state, _) {
                  if (state is Loading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final allItems = viewModel.items;
                  final showSearch = allItems.length > 9;
                  final filtered =
                      (_query.isEmpty || !showSearch)
                          ? allItems
                          : allItems
                              .where(
                                (e) => (e.name).toLowerCase().contains(
                                  _query.toLowerCase(),
                                ),
                              )
                              .toList();

                  if (filtered.isEmpty) {
                    return Column(
                      children: [
                        if (showSearch)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: _SearchField(controller: _searchCtl),
                          ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'no_items_found'.tr(),
                                style: AppStyles.textSize14.copyWith(
                                  color: AppColors.neutral40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      if (showSearch)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: _SearchField(controller: _searchCtl),
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            final isSelected =
                                item.id == viewModel.selectedValue;
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              title: Text(
                                item.name,
                                style: AppStyles.textSize14.copyWith(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : AppColors.neutral40,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              trailing:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: AppColors.primary,
                                      )
                                      : null,
                              onTap: () {
                                widget.onItemSelected(item);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppStyles.textSize14,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'search'.tr(),
        hintStyle: AppStyles.textSize14,
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            controller.text.isEmpty
                ? null
                : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
        filled: true,
        fillColor: AppColors.neutral5,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

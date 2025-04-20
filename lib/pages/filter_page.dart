import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filter_model.dart';
import '../provider/providers.dart';

class FilterPage extends ConsumerWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            // final filterNotifier = ref.read(filterProvider.notifier);
            // filterNotifier.resetFilters();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text( "str_filters".tr()
        ,style: TextStyle(fontSize: 25),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top:40),
        child: _buildFilterSwitches(filterState, filterNotifier),
      ),
    );
  }
  Widget _buildFilterSwitches(FilterState state, FilterNotifier notifier) {
    return Column(
      children: [
        _buildSwitch(
          title: 'str_vegetarian'.tr(),
          value: state.isVegetarian,
          onChanged: (_) => notifier.toggleVegetarian(),
        ),
        _buildSwitch(
          title: 'str_diabetes'.tr(),
          value: state.isDiabetes,
          onChanged: (_) => notifier.toggleDiabetes(),
        ),
        _buildSwitch(
          title: 'str_calorie'.tr(),
          value: state.isCalorie,
          onChanged: (_) => notifier.toggleCalorie(),
        ),
        _buildSwitch(
          title: 'str_kids'.tr(),
          value: state.isKids,
          onChanged: (_) => notifier.toggleKids(),
        ),
        _buildSwitch(
          title: 'str_protein'.tr(),
          value: state.isProtein,
          onChanged: (_) => notifier.toggleProtein(),
        ),
      ],
    );
  }
  Widget _buildSwitch({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title.tr(),
        style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 3),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

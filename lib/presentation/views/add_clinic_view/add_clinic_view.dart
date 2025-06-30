import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_map/di/app_providers.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddClinicView extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const AddClinicView({super.key, this.onSuccess});

  @override
  ConsumerState<AddClinicView> createState() => _AddClinicViewState();
}

class _AddClinicViewState extends ConsumerState<AddClinicView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final Map<String, bool> _specs = {
    'кошки/собаки': true,
    'грызуны': false,
    'рептилии': false,
    'птицы': false,
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addrCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_specs.values.any((v) => v)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы одну специализацию')),
      );
      return;
    }

    final rnd = Random();
    final clinic = VetClinic(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      point: Point(
        latitude: rnd.nextDouble(), // TODO: заменить выбором на карте?
        longitude: rnd.nextDouble(),
      ),
      address: _addrCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      isCustom: true,
      specializations:
          _specs.entries.where((e) => e.value).map((e) => e.key).toList(),
    );

    await ref.read(addClinicUCProvider).call(clinic);
    if (mounted) {
      widget.onSuccess?.call();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    Label('название'),
                    TextFormField(
                      controller: _nameCtrl,
                      maxLines: null,
                      validator:
                          (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Введите название'
                                  : null,
                    ),
                    SizedBox(height: 16.h),
                    Label('адрес'),
                    TextFormField(
                      controller: _addrCtrl,
                      validator:
                          (v) =>
                              v == null || v.trim().isEmpty
                                  ? 'Введите адрес'
                                  : null,
                    ),
                    SizedBox(height: 16.h),
                    Label('телефон'),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 24.h),
                    Label('специализация'),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _specs.entries
                              .map(
                                (e) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: _CheckLine(
                                    label: e.key,
                                    value: e.value,
                                    onChanged:
                                        (v) =>
                                            setState(() => _specs[e.key] = v),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('отмена'),
                  ),
                  SizedBox(
                    width: 160.w,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('сохранить'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => onChanged(!value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp)),
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          onChanged: (v) => onChanged(v!),
        ),
      ],
    ),
  );
}

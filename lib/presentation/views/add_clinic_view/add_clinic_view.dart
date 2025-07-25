import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_map/di/app_providers.dart';
import 'package:pet_map/domain/entities/vet_clinic.dart';
import 'package:pet_map/presentation/providers/map_position_providers.dart';
import 'package:pet_map/presentation/providers/nav_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/resources/app_dimansions.dart';
import 'package:pet_map/presentation/views/confirm_location_view/confirm_location_view.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';

class AddClinicView extends ConsumerStatefulWidget {
  final VetClinic? initial;
  const AddClinicView({super.key, this.initial});

  @override
  ConsumerState<AddClinicView> createState() => _AddClinicViewState();
}

class _AddClinicViewState extends ConsumerState<AddClinicView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _addr = TextEditingController();
  final _phone = TextEditingController();
  late final Map<String, bool> _specs;
  LatLng? _point;

  bool get _isEdit => widget.initial != null;

  void _showShadow() => ref.read(navBarShadowProvider.notifier).state = true;
  void _hideShadow() => ref.read(navBarShadowProvider.notifier).state = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hideShadow());
    _specs = {for (final s in VetClinic.allSpecializations) s: false};
    if (_isEdit) {
      final c = widget.initial!;
      _name.text = c.name;
      _addr.text = c.address ?? '';
      _phone.text = c.phone ?? '';
      _point = c.point;
      for (final s in c.specializations) {
        _specs[s] = true;
      }
    } else {
      _specs[VetClinic.allSpecializations.first] = true;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _addr.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final cam = ref.read(lastCameraPositionProvider);
    LatLng init;
    if (cam != null) {
      init = cam.target;
    } else {
      final pos = await Geolocator.getCurrentPosition();
      init = LatLng(pos.latitude, pos.longitude);
    }
    final res = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (_) => ConfirmLocationView(initial: init)),
    );
    if (res != null) {
      setState(() => _point = res);
      try {
        final placemarks = await placemarkFromCoordinates(
          res.latitude,
          res.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final formatted = [
            p.street,
            p.subLocality,
            p.locality,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          setState(() => _addr.text = formatted);
        }
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_specs.values.contains(true)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите специализацию')));
      return;
    }
    if (_point == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите местоположение на карте')),
      );
      return;
    }
    final clinic = VetClinic(
      id:
          _isEdit
              ? widget.initial!.id
              : DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      point: _point!,
      address: _addr.text.trim(),
      phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      isCustom: true,
      specializations:
          _specs.entries.where((e) => e.value).map((e) => e.key).toList(),
    );
    await ref.read(addClinicUCProvider).call(clinic);
    _showShadow();
    if (mounted) Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    _showShadow();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                      Label('название', fontSize: 12),
                      TextFormField(
                        controller: _name,
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Введите название'
                                    : null,
                      ),
                      SizedBox(height: 16.h),
                      Label('адрес', fontSize: 12),
                      TextFormField(
                        controller: _addr,
                        validator:
                            (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Введите адрес'
                                    : null,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.location_on_outlined),
                            onPressed: _pickLocation,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Label('телефон', fontSize: 12),
                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 24.h),
                      Label('специализация', fontSize: 12),
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
                      onPressed: () {
                        _showShadow();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'отменить',
                        style: TextStyle(
                          fontSize: FontSizes.buttons,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 16.w,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        'сохранить',
                        style: TextStyle(
                          fontSize: FontSizes.buttons,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

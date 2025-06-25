import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/providers/pets_ui_providers.dart';
import 'package:pet_map/presentation/resources/app_colors.dart';
import 'package:pet_map/presentation/views/widgets/label.dart';

class AddPetView extends ConsumerStatefulWidget {
  final Pet? initialPet;
  const AddPetView({super.key, this.initialPet});

  @override
  ConsumerState<AddPetView> createState() => _AddPetViewState();
}

class _AddPetViewState extends ConsumerState<AddPetView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();

  DateTime? _birthDate;
  bool? _sterilized;

  @override
  void initState() {
    super.initState();
    final p = widget.initialPet;
    if (p != null) {
      _nameCtrl.text = p.name;
      _breedCtrl.text = p.breed ?? '';
      _birthDate = p.birthDate;
      _sterilized = p.isSterilized;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final pet = Pet(
      id: widget.initialPet?.id,
      name: _nameCtrl.text.trim(),
      breed: _breedCtrl.text.trim().isEmpty ? null : _breedCtrl.text.trim(),
      birthDate: _birthDate,
      photoPath: null, // TODO: добавить фото
      isSterilized: _sterilized!,
    );

    final ctrl = ref.read(petControllerProvider);
    widget.initialPet == null
        ? await ctrl.addPet(pet)
        : await ctrl.updatePet(pet);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _PhotoBlock(
                onPick: () {
                  /* TODO: фото */
                },
              ),
              SizedBox(height: 24.h),
              Label('кличка'),
              TextFormField(
                controller: _nameCtrl,
                maxLines: null,
                validator:
                    (v) =>
                        v == null || v.trim().isEmpty ? 'Введите кличку' : null,
              ),
              SizedBox(height: 16.h),
              Label('дата  рождения'),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _birthDate == null ? '' : _fmt(_birthDate!),
                ),
                onTap: _pickBirthDate,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickBirthDate,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Label('порода'),
              TextFormField(controller: _breedCtrl),
              SizedBox(height: 24.h),
              Label('стерилизован'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RadioLine(
                    label: 'нет',
                    value: false,
                    group: _sterilized,
                    onChanged: (v) => setState(() => _sterilized = v),
                  ),
                  SizedBox(height: 8.h),
                  _RadioLine(
                    label: 'да',
                    value: true,
                    group: _sterilized,
                    onChanged: (v) => setState(() => _sterilized = v),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _PhotoBlock extends StatelessWidget {
  const _PhotoBlock({required this.onPick});
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.secondary,
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/no_image.png'),
            ),
          ),
        ),
        Positioned(
          right: 8,
          bottom: 8,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onPick,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.edit, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioLine extends StatelessWidget {
  const _RadioLine({
    required this.label,
    required this.value,
    required this.group,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool? group;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => onChanged(value),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 16.sp)),
        Radio<bool>(
          value: value,
          groupValue: group,
          onChanged: (v) => onChanged(v!),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_map/domain/entities/pet.dart';
import 'package:pet_map/presentation/providers/pets_ui_providers.dart';

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
  bool _sterilized = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPet != null) {
      final p = widget.initialPet!;
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

    final newPet = Pet(
      id: widget.initialPet?.id,
      name: _nameCtrl.text.trim(),
      breed: _breedCtrl.text.trim().isEmpty ? null : _breedCtrl.text.trim(),
      birthDate: _birthDate,
      photoPath: null, // TODO: добавить фото
      isSterilized: _sterilized,
    );

    final controller = ref.read(petControllerProvider);

    if (widget.initialPet == null) {
      await controller.addPet(newPet);
    } else {
      await controller.updatePet(newPet);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // TODO: кнопка фото
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Имя *'),
              validator:
                  (v) => (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
            ),
            TextFormField(
              controller: _breedCtrl,
              decoration: const InputDecoration(labelText: 'Порода'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Дата рождения'),
              subtitle: Text(
                _birthDate != null
                    ? '${_birthDate!.day}.${_birthDate!.month}.${_birthDate!.year}'
                    : 'не выбрана',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: _pickBirthDate,
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Стерилизован'),
              value: _sterilized,
              onChanged: (v) => setState(() => _sterilized = v ?? false),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}

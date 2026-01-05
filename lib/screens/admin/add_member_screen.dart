import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/family_member_model.dart';
import '../../providers/family_provider.dart';
import '../../providers/auth_provider.dart';

/// Screen for adding a new family member
class AddMemberScreen extends StatefulWidget {
  final FamilyMember? parentMember; // Optional parent to link to
  final FamilyMember? memberToEdit; // Optional member to edit
  final String treeId; // Required tree ID to add member to

  const AddMemberScreen({
    super.key,
    this.parentMember,
    this.memberToEdit,
    required this.treeId,
  });

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _grandfatherNameController = TextEditingController();
  final _birthPlaceController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _birthDate = DateTime.now();
  Gender _gender = Gender.male;
  VitalStatus _status = VitalStatus.alive;
  DateTime? _deathDate;
  int _siblingRank = 1;
  String? _selectedFatherId;
  String? _selectedMotherId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.memberToEdit != null) {
      final m = widget.memberToEdit!;
      _firstNameController.text = m.firstName;
      _fatherNameController.text = m.fatherName;
      _grandfatherNameController.text = m.grandfatherName;
      _birthPlaceController.text = m.birthPlace;
      _notesController.text = m.notes ?? '';
      _birthDate = m.birthDate;
      _gender = m.gender;
      _siblingRank = m.siblingRank;
      _status = m.status;
      _deathDate = m.deathDate;
      _selectedFatherId = m.fatherId;
      _selectedMotherId = m.motherId;
    } else if (widget.parentMember != null) {
      if (widget.parentMember!.gender == Gender.male) {
        _selectedFatherId = widget.parentMember!.id;
        _fatherNameController.text = widget.parentMember!.firstName;
      } else {
        _selectedMotherId = widget.parentMember!.id;
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _grandfatherNameController.dispose();
    _birthPlaceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isBirthDate ? _birthDate : (_deathDate ?? DateTime.now()),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _birthDate = picked;
        } else {
          _deathDate = picked;
        }
      });
    }
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();

    final member = FamilyMember(
      id: widget.memberToEdit?.id ?? '', // Use existing ID if editing
      firstName: _firstNameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      grandfatherName: _grandfatherNameController.text.trim(),
      birthDate: _birthDate,
      birthPlace: _birthPlaceController.text.trim(),
      gender: _gender,
      siblingRank: _siblingRank,
      status: _status,
      deathDate: _status == VitalStatus.deceased ? _deathDate : null,
      fatherId: _selectedFatherId,
      motherId: _selectedMotherId,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      createdAt: widget.memberToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      createdBy:
          widget.memberToEdit?.createdBy ?? authProvider.currentUser?.uid ?? '',
      treeId: widget.treeId,
    );

    final result = widget.memberToEdit != null
        ? await familyProvider.updateMember(member)
        : await familyProvider.addMember(member);

    setState(() => _isLoading = false);

    if (mounted) {
      if (result != null && result != false) {
        // Handle both String? (add) and bool (update)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.memberToEdit != null
                  ? '${member.firstName} a été modifié'
                  : '${member.firstName} a été ajouté à l\'arbre',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              familyProvider.error ?? 'Erreur lors de l\'enregistrement',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.memberToEdit != null
              ? 'Modifier le membre'
              : 'Ajouter un membre',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Names Section
              Text(
                'Identité',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Prénom *',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le prénom est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _fatherNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du père *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom du père est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _grandfatherNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du grand-père *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom du grand-père est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Gender Selection
              Text('Sexe', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderOption(Gender.male, 'Homme', Icons.male),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGenderOption(
                      Gender.female,
                      'Femme',
                      Icons.female,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Birth Info
              Text(
                'Naissance',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => _selectDate(context, true),
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance *',
                    prefixIcon: Icon(Icons.cake),
                  ),
                  child: Text(dateFormat.format(_birthDate)),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _birthPlaceController,
                decoration: const InputDecoration(
                  labelText: 'Lieu de naissance *',
                  prefixIcon: Icon(Icons.location_on),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le lieu de naissance est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Sibling Rank
              Text(
                'Rang dans la fratrie',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: _siblingRank > 1
                        ? () => setState(() => _siblingRank--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppTheme.primaryColor,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$_siblingRank${_siblingRank == 1 ? "er" : "ème"}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _siblingRank++),
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Vital Status
              Text(
                'Statut',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusOption(VitalStatus.alive, 'Vivant'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatusOption(VitalStatus.deceased, 'Décédé'),
                  ),
                ],
              ),

              if (_status == VitalStatus.deceased) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context, false),
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de décès',
                      prefixIcon: Icon(Icons.event),
                    ),
                    child: Text(
                      _deathDate != null
                          ? dateFormat.format(_deathDate!)
                          : 'Sélectionner une date',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Parents Selection
              Text(
                'Parents (optionnel)',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedFatherId,
                decoration: const InputDecoration(
                  labelText: 'Père dans l\'arbre',
                  prefixIcon: Icon(Icons.person, color: AppTheme.maleColor),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Aucun')),
                  ...familyProvider.members
                      .where((m) => m.gender == Gender.male)
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(m.fullName),
                        ),
                      ),
                ],
                onChanged: (value) {
                  setState(() => _selectedFatherId = value);
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedMotherId,
                decoration: const InputDecoration(
                  labelText: 'Mère dans l\'arbre',
                  prefixIcon: Icon(Icons.person_2, color: AppTheme.femaleColor),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Aucune')),
                  ...familyProvider.members
                      .where((m) => m.gender == Gender.female)
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(m.fullName),
                        ),
                      ),
                ],
                onChanged: (value) {
                  setState(() => _selectedMotherId = value);
                },
              ),
              const SizedBox(height: 24),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optionnel)',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMember,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.memberToEdit != null
                              ? 'Enregistrer les modifications'
                              : 'Ajouter à l\'arbre',
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(Gender gender, String label, IconData icon) {
    final isSelected = _gender == gender;
    final color = gender == Gender.male
        ? AppTheme.maleColor
        : AppTheme.femaleColor;

    return InkWell(
      onTap: () => setState(() => _gender = gender),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(VitalStatus status, String label) {
    final isSelected = _status == status;
    final color = status == VitalStatus.alive
        ? AppTheme.successColor
        : AppTheme.deceasedColor;

    return InkWell(
      onTap: () => setState(() => _status = status),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

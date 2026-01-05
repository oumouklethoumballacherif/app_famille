import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/event_model.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';

/// Screen for creating a new family event
class CreateEventScreen extends StatefulWidget {
  final FamilyEvent? eventToEdit;

  const CreateEventScreen({super.key, this.eventToEdit});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _locationUrlController;
  late TextEditingController _descriptionController;

  late EventType _eventType;
  late DateTime _date;
  TimeOfDay? _time;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final event = widget.eventToEdit;
    _titleController = TextEditingController(text: event?.title ?? '');
    _locationController = TextEditingController(text: event?.location ?? '');
    _locationUrlController = TextEditingController(
      text: event?.locationUrl ?? '',
    );
    _descriptionController = TextEditingController(
      text: event?.description ?? '',
    );
    _eventType = event?.type ?? EventType.reunion;
    _date = event?.date ?? DateTime.now();
    _time = event?.time;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _locationUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      locale: Localizations.localeOf(context),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final eventProvider = context.read<EventProvider>();

    final event = FamilyEvent(
      id: widget.eventToEdit?.id ?? '',
      title: _titleController.text.trim(),
      type: _eventType,
      date: _date,
      time: _time,
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : null,
      locationUrl: _locationUrlController.text.trim().isNotEmpty
          ? _locationUrlController.text.trim()
          : null,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      relatedMemberIds: widget.eventToEdit?.relatedMemberIds ?? [],
      imageUrl: widget.eventToEdit?.imageUrl,
      createdBy:
          widget.eventToEdit?.createdBy ?? authProvider.currentUser?.uid ?? '',
      createdAt: widget.eventToEdit?.createdAt ?? DateTime.now(),
      isNotificationSent: widget.eventToEdit?.isNotificationSent ?? false,
    );

    final String? result;
    if (widget.eventToEdit != null) {
      final success = await eventProvider.updateEvent(event);
      result = success ? event.id : null;
    } else {
      result = await eventProvider.addEvent(event);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.eventCreatedSuccess),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              eventProvider.error ??
                  AppLocalizations.of(context)!.eventCreationErrorDefault,
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  String _getEventTypeDisplayName(BuildContext context, EventType type) {
    switch (type) {
      case EventType.wedding:
        return AppLocalizations.of(context)!.eventTypeWedding;
      case EventType.birth:
        return AppLocalizations.of(context)!.eventTypeBirth;
      case EventType.death:
        return AppLocalizations.of(context)!.eventTypeDeath;
      case EventType.reunion:
        return AppLocalizations.of(context)!.eventTypeReunion;
      case EventType.religious:
        return AppLocalizations.of(context)!.eventTypeReligious;
      case EventType.other:
        return AppLocalizations.of(context)!.eventTypeOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(
      'EEEE d MMMM yyyy',
      Localizations.localeOf(context).toString(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvel événement')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Type Selection
              Text(
                AppLocalizations.of(context)!.eventTypeLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: EventType.values.map((type) {
                  final isSelected = _eventType == type;
                  return InkWell(
                    onTap: () => setState(() => _eventType = type),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? type.color.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? type.color : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            size: 18,
                            color: isSelected
                                ? type.color
                                : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getEventTypeDisplayName(context, type),
                            style: TextStyle(
                              color: isSelected
                                  ? type.color
                                  : AppTheme.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                AppLocalizations.of(context)!.detailsSection,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.eventTitleLabel,
                  prefixIcon: Icon(_eventType.icon, color: _eventType.color),
                  hintText: AppLocalizations.of(context)!.eventTitleHint,
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.eventTitleError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.eventDateLabel,
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(dateFormat.format(_date)),
                ),
              ),
              const SizedBox(height: 16),

              // Time (optional)
              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.eventTimeLabel,
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  child: Text(
                    _time != null
                        ? '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}'
                        : '--:--',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Location Section
              Text(
                AppLocalizations.of(context)!.locationSection,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.eventLocationLabel,
                  prefixIcon: const Icon(Icons.location_on),
                  hintText: AppLocalizations.of(context)!.eventLocationHint,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationUrlController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.eventMapsUrlLabel,
                  prefixIcon: const Icon(Icons.map),
                  hintText: 'https://goo.gl/maps/...',
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                AppLocalizations.of(context)!.descriptionLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.descriptionLabel,
                  prefixIcon: const Icon(Icons.notes),
                  hintText: AppLocalizations.of(context)!.eventDescriptionHint,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveEvent,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(AppLocalizations.of(context)!.createEventAction),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _eventType.color,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.eventNotificationInfo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

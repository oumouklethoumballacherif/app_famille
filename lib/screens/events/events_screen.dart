import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme.dart';
import '../../models/event_model.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../admin/create_event_screen.dart';
import '../../l10n/app_localizations.dart';

/// Events Screen showing family events calendar
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final authProvider = context.watch<AuthProvider>();
    final canCreateEvents = authProvider.canCreateEvents;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.eventsTitle)),
      body: eventProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventProvider.events.isEmpty
          ? _buildEmptyState(context)
          : _buildEventsList(context, eventProvider),
      floatingActionButton: canCreateEvents
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateEventScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.newEventButton),
              backgroundColor: AppTheme.primaryColor,
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 100,
              color: AppTheme.primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.noEvents,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noEventsSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, EventProvider eventProvider) {
    final upcomingEvents = eventProvider.upcomingEvents;
    final pastEvents = eventProvider.events
        .where((e) => !e.isUpcoming && !e.isToday)
        .toList();
    final todayEvents = eventProvider.todayEvents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Today's Events
          if (todayEvents.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.todaySection,
              Icons.today,
            ),
            const SizedBox(height: 8),
            ...todayEvents.map((event) => _buildEventCard(context, event)),
            const SizedBox(height: 24),
          ],

          // Upcoming Events
          if (upcomingEvents.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.upcomingSection,
              Icons.upcoming,
            ),
            const SizedBox(height: 8),
            ...upcomingEvents.map((event) => _buildEventCard(context, event)),
            const SizedBox(height: 24),
          ],

          // Past Events
          if (pastEvents.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              AppLocalizations.of(context)!.pastSection,
              Icons.history,
            ),
            const SizedBox(height: 8),
            ...pastEvents
                .take(10)
                .map((event) => _buildEventCard(context, event, isPast: true)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    FamilyEvent event, {
    bool isPast = false,
  }) {
    final dateFormat = DateFormat(
      'EEEE d MMMM yyyy',
      Localizations.localeOf(context).toString(),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showEventDetail(context, event),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Event Type Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: event.type.color.withValues(alpha: isPast ? 0.1 : 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  event.type.icon,
                  color: isPast ? AppTheme.textSecondary : event.type.color,
                ),
              ),
              const SizedBox(width: 16),

              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPast
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(event.date),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    if (event.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Event Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: event.type.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getEventTypeDisplayName(context, event.type),
                  style: TextStyle(
                    color: event.type.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetail(BuildContext context, FamilyEvent event) {
    final dateFormat = DateFormat(
      'EEEE d MMMM yyyy',
      Localizations.localeOf(context).toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Event Type Icon and Title
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: event.type.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      event.type.icon,
                      color: event.type.color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: event.type.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getEventTypeDisplayName(context, event.type),
                            style: TextStyle(
                              color: event.type.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // Date
              _buildDetailRow(
                context,
                Icons.calendar_today,
                AppLocalizations.of(context)!.eventDateLabel,
                dateFormat.format(event.date),
              ),

              // Time
              if (event.time != null)
                _buildDetailRow(
                  context,
                  Icons.access_time,
                  AppLocalizations.of(context)!.timeLabel,
                  '${event.time!.hour.toString().padLeft(2, '0')}:${event.time!.minute.toString().padLeft(2, '0')}',
                ),

              // Location
              if (event.location != null)
                _buildDetailRow(
                  context,
                  Icons.location_on,
                  AppLocalizations.of(context)!.locationLabel,
                  event.location!,
                ),

              // Description
              if (event.description != null &&
                  event.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.descriptionLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],

              // Google Maps button
              if (event.locationUrl != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(event.locationUrl!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: Text(AppLocalizations.of(context)!.openMapButton),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
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
}

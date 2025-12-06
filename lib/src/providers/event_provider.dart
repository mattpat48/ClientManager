import 'event.dart';
import '../json_storage_provider.dart';

class EventProvider extends JsonStorageProvider<Event> {
  static const String _eventsKey = 'events_data';

  EventProvider()
      : super(
          storageKey: _eventsKey,
          fromJson: (json) => Event.fromJson(json),
        );

  List<Event> get events => items;

  void addEvent(Event event) {
    items.add(event);
    saveItems();
  }

  void updateEvent(Event event) {
    final index = items.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      items[index] = event;
      saveItems();
    }
  }

  void removeEvent(String id) {
    items.removeWhere((event) => event.id == id);
    saveItems();
  }
}
import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../widgets/event_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../event_form_page.dart';
import '../../services/event_type_manager.dart';
class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  String _selectedEventType = 'All';
   List<String> _eventTypes = ['All', 'Conference', 'Workshop', 'Webinar'];

    @override
    void initState() {
      super.initState();
      initEventTypes();
    }

void initEventTypes() async {
    await EventTypeManager.init();
    setState(() {
      if (EventTypeManager.eventTypes.contains(_selectedEventType)) {
        _selectedEventType = EventTypeManager.eventTypes.first;
      }
    });
  }

  Stream<QuerySnapshot> getEventsStream() {
    return _selectedEventType == 'All'
        ? FirebaseFirestore.instance.collection('events').snapshots()
        : FirebaseFirestore.instance
            .collection('events')
            .where('eventType', isEqualTo: _selectedEventType)
            .snapshots();
  }

  void _showAddEventTypeDialog() {
    TextEditingController typeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Event Type'),
          content: TextField(
            controller: typeController,
            decoration: InputDecoration(hintText: "Enter event type"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                var newType = typeController.text.trim();
                if (newType.isNotEmpty) {
                  EventTypeManager.addEventType(newType).then((_) {
                    setState(() {
                      _eventTypes = EventTypeManager.eventTypes;
                      _selectedEventType = newType;
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addEventType(String newType) async {
    if (!_eventTypes.contains(newType)) {
      await EventTypeManager.addEventType(newType);
      setState(() {
        _eventTypes = EventTypeManager.eventTypes;
        _selectedEventType = newType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event List"),
        actions: <Widget>[
          DropdownButton<String>(
            value: _selectedEventType,
            onChanged: (String? newValue) {
              if (newValue == 'Add New...') {
                _showAddEventTypeDialog();
              } else {
                setState(() {
                  _selectedEventType = newValue!;
                });
              }
            },
            items: _eventTypes.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()..add(DropdownMenuItem(
                value: 'Add New...',
                child: Text('Add New...')
              )),
            underline: Container(height: 0),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getEventsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No events found for '$_selectedEventType'"));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var event = Event.fromMap(doc.data() as Map<String, dynamic>);
              return EventCard(
                event: event,
                docId: doc.id,
                onDelete: () => deleteEvent(doc.id, context),
                onUpdate: () => updateEvent(doc.id, event, context),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventFormPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Event',
      ),
    );
  }

  void updateEvent(String docId, Event event, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventFormPage(event: event, docId: docId)),
    );
  }

  void deleteEvent(String docId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event successfully deleted'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e'))
      );
    }
  }
}
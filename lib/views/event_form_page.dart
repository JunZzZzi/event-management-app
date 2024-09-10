import 'package:flutter/material.dart';
import '../../models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../services/event_type_manager.dart';

class EventFormPage extends StatefulWidget {
  final Event? event;
  final String? docId;

  EventFormPage({this.event, this.docId});

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String title = 'Loading...';
  late String description;
  late DateTime date;
  late String location;
  late String organizer;
  late String eventType;
  late TextEditingController _dateController;
  late String _selectedEventType;
  late List<String> _eventTypes;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    _eventTypes = await EventTypeManager.eventTypes;
    _selectedEventType = widget.event?.eventType ?? _eventTypes.first;
    title = widget.event?.title ?? 'Default Title';
    description = widget.event?.description ?? '';
    date = widget.event?.date ?? DateTime.now();
    location = widget.event?.location ?? '';
    organizer = widget.event?.organizer ?? '';
    eventType = _selectedEventType;
    _dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(date));
    if (!_eventTypes.contains(_selectedEventType) && _selectedEventType != null) {
      _eventTypes.add(_selectedEventType);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.docId == null ? "Add New Event" : "Update Event"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue: title,
              onSaved: (value) => title = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              initialValue: description,
              onSaved: (value) => description = value ?? '',
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date & Time'),
              onTap: _pickDate,
              readOnly: true,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              initialValue: location,
              onSaved: (value) => location = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Organizer'),
              initialValue: organizer,
              onSaved: (value) => organizer = value ?? '',
            ),
            DropdownButtonFormField<String>(
              value: _selectedEventType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedEventType = newValue ?? _selectedEventType;
                  eventType = newValue ?? eventType;
                });
              },
              items: _eventTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: createOrUpdateEvent,
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[500],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  if (widget.docId != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: deleteEvent,
                        child: Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                        ),
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

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
      );
      if (pickedTime != null) {
        setState(() {
          date = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
          _dateController.text = DateFormat('yyyy-MM-dd – HH:mm').format(date);
        });
      }
    }
  }

  void createOrUpdateEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DocumentReference? ref;
      try {
        if (widget.docId == null) {
          ref = await FirebaseFirestore.instance.collection('events').add({
            'title': title,
            'description': description,
            'date': date,
            'location': location,
            'organizer': organizer,
            'eventType': eventType,
            'updatedAt': DateTime.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event created with ID: ${ref.id}'))
          );
        } else {
          await FirebaseFirestore.instance.collection('events').doc(widget.docId).update({
            'title': title,
            'description': description,
            'date': date,
            'location': location,
            'organizer': organizer,
            'eventType': eventType,
            'updatedAt': DateTime.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event updated'))
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save event: $e'))
        );
      }
      Navigator.pop(context);
    }
  }

  void deleteEvent() async {
    if (widget.docId != null) {
      try {
        await FirebaseFirestore.instance.collection('events').doc(widget.docId).delete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event successfully deleted')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete event: $e')));
      }
      Navigator.pop(context);
    }
  }
}

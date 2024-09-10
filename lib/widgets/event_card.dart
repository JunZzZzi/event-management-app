import 'package:flutter/material.dart';
import '../models/event.dart';


class EventCard extends StatelessWidget {
  final Event event;
  final String docId;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  EventCard({
    required this.event,
    required this.docId,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(event.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(event.description),
            SizedBox(height: 8),
            Text('Date: ${event.date.toString()}'),
            Text('Location: ${event.location}'),
            Text('Organizer: ${event.organizer}'),
            Text('Type: ${event.eventType}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onUpdate,
                  child: Text('Update'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                  ),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
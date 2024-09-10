Event Management Application
Overview
This application is designed to manage events efficiently, allowing users to create, view, update, and delete events. It utilizes a Node.js backend with Firebase, including Firestore for the database and Firebase Cloud Functions for handling serverless operations. The frontend is built with Flutter, providing a dynamic and responsive interface for interacting with the event data.

Features
Create Event: Add new events to the Firestore database.
View Events: Display a list of all events, updated in real-time.
Update Event: Modify details of existing events.
Delete Event: Remove events from the database.
Filter Events: Users can filter events by type (Conference, Workshop, Webinar)
Firebase Setup
Firestore Database: Stores all event data.
Cloud Functions: Manages CRUD operations and real-time updates.

Getting Started:

Prerequisites
Ensure you have the following installed:
Flutter
Dart
Node.js

Installation
Clone the repository:
bash
Copy code
git clone https://github.com/yourgithubusername/event-management-app.git
Navigate to the project directory:
bash
Copy code
cd event-management-app
Install dependencies:
bash
Copy code
flutter pub get
Run the application:
bash
Copy code
flutter run
Usage
The application's main screen displays a list of events. Each event can be tapped to view more details.
Events can be filtered by type using the dropdown at the top of the main screen.
You can add a new event by navigating to the "Create Event" screen from the floating action button.
Update or delete an event from the detail screen.
Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Contact
Jun Zhang - jun.zhang19970502@gmail.com
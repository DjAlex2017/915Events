# el_paso_events(915Events)

915Events is a cross-platform mobile application built with Flutter that helps users discover upcoming events, concerts, restaurants, bars, and local happenings in El Paso, TX. The app combines real-time event data with curated local spots to promote community engagement and simplify local discovery.

## Features 
User Authentication
- Secure email and password authentication using Firebase Authentication
Event Discovery
- Browse upcoming concerts and events powered by the Ticketmaster Discovery API
- View event details including date, venue and external ticket links
Home Feed
- Displays event cards retrueved from Firebase Firestore
- Includes curated local places such as restaurants, bars, and venues in El Paso
Explore Map
- Interactive Map built with Google Maps API
- Shows events and local places using map markers
- Allows users to get directions to selected locations
Create and Manage Events
- Authenticated users can create their own events
- Users can update or delete events they have created
- Events are stored and synchronized using Firestore
User Profile
- Profile screen with access to Your Events, Settings, and Logout

## Tech Stack
Frontend
- Flutter
- Dart
Backend/Services
- Firebase Authentication
- Firebase Firestore
APIs
- Ticketmaster Discovery API
- Google Maps API

## Installation
Prerequisites 
- Flutter SDK installed
- Andriod Studio or Xcode
- Firebase project setup
- Google Maps and Ticketmaster API keys

## Setup 
git clone https://github.com/DjAlex2017/el_paso_events.git
cd el_paso_events
flutter pub get
flutter run

## Configurations Notes 
API keys and Firebase configuration files are not included in this repository for security reasons. 
You will need to provide your own Google Maps and Ticketmaster API keys.

## Author 
Alejandro "Alex" Pedregon
B.S. Computer Science, University of Texas at El Paso
Github: https://github.com/DjAlex2017



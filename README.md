# Note GPS

Note GPS is a location-based notes application built with Flutter. The application allows users to create, edit, and delete notes, with each note being tagged with the user's current location. The notes can be viewed in a list format sorted by creation date or on a map as pins. The application supports authentication via Firebase and allows users to attach images to their notes.

## Features

- User authentication (login and signup) using Firebase.
- Main screen with a welcome message, logout option, and navigation between list and map views.
- Notes view:
  - Note List: Displays all notes sorted by date of creation.
  - Note Map: Displays all notes as pins on a map.
- Note screen:
  - Create new notes or edit existing notes.
  - Attach images to notes from the gallery or camera.
  - Save and delete notes.
  - Automatically attach the user's current location to new notes.
- Persistent login state.
- Real-time data updates with Firestore.

## Screenshots

![signup](https://github.com/user-attachments/assets/26873be3-bec2-4b60-942a-eae3ba3382de)
![main](https://github.com/user-attachments/assets/eec5f01b-2d07-4cb7-bc36-80c4a68b66a0)
![note](https://github.com/user-attachments/assets/ae9287c5-1fe2-467f-aad8-dc8dab5b19ea)
![map](https://github.com/user-attachments/assets/e72faea0-32a0-46c9-9879-eb864784977b)

## Known Issues

- Screen overflow occurs in some places.
- When changing a photo in a note, the old photo does not get deleted in Firebase Storage.
- Location is not always fetched correctly on the first note save.

## Tech Stack

- Flutter
- Firebase Authentication
- Firestore
- Firebase Storage
- Google Maps

## Implementation Details

- Authentication: Firebase Authentication is used for user login and signup.
- Data Storage: Firestore is used to store notes data. Each user has a collection of notes identified by their user ID.
- Images: Firebase Storage is used to store images attached to notes.
- Location: The Geolocator package is used to fetch the user's current location.

### link for an installable application
https://drive.google.com/file/d/1s9pqmnUhoNrz8fq4K-CannPoAqpnufzy/view?usp=sharing

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
![4f815ce4-6d2f-4230-a3ae-124e39a33290](https://github.com/user-attachments/assets/7a60217c-4d0a-476e-b8a8-3fc198053d56)
![5671f14b-a215-4933-95e2-c630fd2bf4d8](https://github.com/user-attachments/assets/601819ae-f021-41b7-a321-dfb727ffef3a)
![2b038d28-97be-4dae-86e9-0d5bbb205916](https://github.com/user-attachments/assets/c2e5ef64-a820-4c72-83e2-e2f7df5cb308)
![image](https://github.com/user-attachments/assets/63580b3a-950e-43e4-bc51-37d1668722b8)
![image](https://github.com/user-attachments/assets/6becd611-a86b-4d5c-adfc-aa9ab8c89907)
![image](https://github.com/user-attachments/assets/e74bf421-db76-4909-aa66-150d1516d8a4)



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

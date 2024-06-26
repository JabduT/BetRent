# BetRent System

## Overview

BetRent is a comprehensive platform designed to facilitate the rental process for both house owners and renters. The system includes a backend server and a Flutter-based mobile application for both owners and renters, with role-based navigation for specific functionalities.

## Repository Structure

The repository is organized into separate directories for the backend server and the Flutter mobile app:

- **backend/**: Contains the source code and configuration files for the backend server.
- **mobileApp/**: Includes the Flutter-based mobile application for owners and renters.

## Backend

The backend server is built using Node.js, Express.js, MongoDB, and Socket.IO, providing the following functionalities:

- API endpoints for user authentication, property listing management, messaging, and notifications.
- Database integration to store user data, property details, messages, and notifications.
- Secure authentication mechanisms using tokens.
- Scalable architecture to handle concurrent user requests.

## Mobile App

The mobile app includes the following key features and screens:

- **Authentication:** Login and registration screens for owners and renters.
- **Dashboard:** Overview of user activities, property listings, and communication channels.
- **Listing Management:** Add, edit, and delete property listings with detailed descriptions and amenities.
- **Property Details:** View photos, amenities, and contact options for each property.
- **Messaging:** In-app messaging system for direct communication between owners and renters.
- **Notifications:** Real-time notifications for new messages, inquiries, and updates.
- **Settings:** Account settings, notification preferences, and support options.

## Getting Started

To run the BetRent system locally, follow these steps:

1. Clone the repository to your local machine.
2. Navigate to the backend directory and install backend dependencies using `npm install`.
3. Set up the database and configure the environment variables for database connection.
4. Start the backend server using `npm start`.
5. Navigate to the mobileApp directory.
6. Set up the Flutter development environment.
7. Connect your mobile device or emulator.
8. Run the Flutter app using `flutter run`.
9. Access the application on your mobile device or emulator.

## Technologies Used

- Backend: Node.js, Express.js, MongoDB, Socket.IO
- Mobile App: Flutter, Dart
- Database: MongoDB
- API Framework: Express.js framework

## Contributors

- lalisabl
- tokuma
- firaol

## License

This project is licensed under the Startup Ethiopian Hackathon License. All rights reserved.

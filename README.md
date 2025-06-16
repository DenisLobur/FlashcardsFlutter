# flutter_flashcards

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## ⚠️ Backend API Configuration:
You need to update the API URL in these files:
- lib/services/auth_service.dart (line 7)
- lib/services/api_service.dart (line 7)
Replace 'http://your-api-url.com/api' with your actual backend API URL.

## 📡 Expected API Endpoints:
The app expects these backend endpoints:

### Authentication:
- `POST /register` - Register new user
  - Request body: `{ "username": "string", "email": "string", "password": "string" }`
  - Response: `{ "token": "string", "user": { "id": "string", "username": "string", "email": "string", "created_at": "string" } }`
- `POST /login` - Login user
  - Request body: `{ "email": "string", "password": "string" }`
  - Response: `{ "token": "string", "user": { "id": "string", "username": "string", "email": "string", "created_at": "string" } }`

### Categories:
- `GET /categories` - Get user's categories
- `POST /categories` - Create category
- `PUT /categories/:id` - Update category
- `DELETE /categories/:id` - Delete category

### Flashcards:
- `GET /categories/:categoryId/flashcards` - Get flashcards
- `POST /categories/:categoryId/flashcards` - Create flashcard
- `PUT /flashcards/:id` - Update flashcard
- `DELETE /flashcards/:id` - Delete flashcard

## 🎨 Key Features
- **Smooth Animations**: The flashcard widget includes a beautiful 3D flip animation
- **Modern UI**: Material Design 3 with custom theming and gradients
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Loading States**: Proper loading indicators during API calls
- **Form Validation**: Client-side validation for all forms including username validation
- **Secure Storage**: Token storage using secure preferences
- **User Registration**: Complete registration with username, email, and password

## 🚀 To Run the App:
1. Update the API URLs in the service files
2. Ensure you have a backend API running
3. Run: `flutter run`

The app is now fully functional and ready for use! All the requirements you specified have been implemented with a modern, user-friendly interface.
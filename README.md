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

️ Backend API Configuration:
You need to update the API URL in these files:
lib/services/auth_service.dart (line 7)
lib/services/api_service.dart (line 7)
Replace 'http://your-api-url.com/api' with your actual backend API URL.
📡 Expected API Endpoints:
The app expects these backend endpoints:
Authentication:
POST /auth/register - Register new user
POST /auth/login - Login user
Categories:
GET /categories - Get user's categories
POST /categories - Create category
PUT /categories/:id - Update category
DELETE /categories/:id - Delete category
Flashcards:
GET /categories/:categoryId/flashcards - Get flashcards
POST /categories/:categoryId/flashcards - Create flashcard
PUT /flashcards/:id - Update flashcard
DELETE /flashcards/:id - Delete flashcard
🎨 Key Features
Smooth Animations: The flashcard widget includes a beautiful 3D flip animation
Modern UI: Material Design 3 with custom theming and gradients
Error Handling: Comprehensive error handling with user-friendly messages
Loading States: Proper loading indicators during API calls
Form Validation: Client-side validation for all forms
Secure Storage: Token storage using secure preferences
🚀 To Run the App:
Update the API URLs in the service files
Ensure you have a backend API running
Run: flutter run
The app is now fully functional and ready for use! All the requirements you specified have been implemented with a modern, user-friendly interface.
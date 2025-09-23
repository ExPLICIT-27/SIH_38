# Blue Carbon MRV Flutter App

A mobile application for the Blue Carbon MRV (Monitoring, Reporting, and Verification) platform that enables users to manage blue carbon projects, upload field data, and track verification status.

## Features

- **Authentication**: Email/OTP-based login and signup
- **Project Management**: Create and view blue carbon projects
- **Data Upload**: Upload field data with GPS metadata
- **Verification Tracking**: Monitor verification status of uploaded data
- **User Profile**: Manage account settings and preferences

## Color Palette

The app uses a carefully selected color palette that represents marine ecosystems:

- **Deep Ocean Blue** (`#1B4B73`): Main brand color, represents deep marine waters
- **Coastal Teal** (`#2E8B8B`): Secondary accent color, evokes coastal waters
- **Seagrass Green** (`#4A7C59`): Represents marine vegetation and carbon sequestration
- **Mangrove Dark** (`#2F4F2F`): Deep green for text and strong contrast elements
- **Coral Accent** (`#FF7F7F`): Warm accent for alerts and call-to-action elements
- **Sandy Beige** (`#F5E6D3`): Light background color for cards and surfaces
- **Ocean Foam** (`#E8F4F8`): Very light blue for subtle backgrounds
- **Pure White** (`#FFFFFF`): Clean backgrounds, text on dark colors
- **Charcoal** (`#2C3E50`): Dark text, strong contrast elements

## Getting Started

### Prerequisites

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- Android Studio / Xcode for mobile deployment

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/blue_carbon_app.git
cd blue_carbon_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── config/           # App configuration
│   ├── constants/        # Constants used throughout the app
│   ├── theme/            # Theme data and color palette
│   └── utils/            # Utility functions
├── data/                 # Data layer
│   ├── models/           # Data models
│   ├── repositories/     # Repositories
│   ├── services/         # API services
│   └── providers/        # Data providers
├── domain/               # Domain layer
│   ├── entities/         # Business entities
│   └── usecases/         # Use cases
└── presentation/         # Presentation layer
    ├── blocs/            # BLoC state management
    ├── screens/          # App screens
    └── widgets/          # Reusable widgets
```

## Backend Integration

The app integrates with the Blue Carbon MRV backend API. Configure the API endpoint in `lib/core/constants/api_constants.dart`.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

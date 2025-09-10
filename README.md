# Flutterby.app

A comprehensive Flutter widget reference application that provides developers with an organized catalog of Flutter widgets, complete with interactive examples, documentation, and code snippets.

## Features

### 📚 Widget Taxonomy
- **8 Main Categories**: Layout, Input, Display, Navigation, Material, Cupertino, Animation, and Styling
- **Subcategories**: Further organization within each category for easy navigation
- **20+ Documented Widgets**: Comprehensive collection with more being added

### 🔍 Search & Discovery
- **Real-time Search**: Instantly find widgets by name, description, or category
- **Popular Suggestions**: Quick access to commonly searched widgets
- **Related Widgets**: Discover similar widgets for better alternatives

### 📖 Detailed Documentation
- **Overview Tab**: Widget description and comprehensive documentation
- **Example Tab**: Syntax-highlighted code examples with copy-to-clipboard
- **Properties Tab**: Complete list of widget properties with types and descriptions

### 🎨 Modern UI/UX
- **Material Design 3**: Clean, modern interface following latest design guidelines
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Navigation**: Intuitive navigation with drawer menu and routing

## Screenshots

<details>
<summary>View Screenshots</summary>

### Home Screen
The main dashboard showing widget categories in a grid layout.

### Widget List
Browse all widgets within a selected category.

### Widget Details
Comprehensive documentation with code examples and properties.

### Search
Real-time search functionality with instant results.

</details>

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/flutterby-app/Flutterby.git
cd Flutterby
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
# For web
flutter run -d chrome

# For macOS
flutter run -d macos

# For other platforms
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── flutter_widget.dart   # Widget model
│   └── widget_category.dart  # Category model
├── screens/                  # UI screens
│   ├── home_screen.dart      # Main dashboard
│   ├── widget_list_screen.dart
│   ├── widget_detail_screen.dart
│   ├── search_screen.dart
│   └── favorites_screen.dart
├── services/                 # Business logic
│   └── widget_data_service.dart
├── data/                     # Sample data
│   └── widget_samples.dart
└── widgets/                  # Reusable components

```

## Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **go_router** - Navigation and routing
- **provider** - State management
- **flutter_highlight** - Syntax highlighting
- **google_fonts** - Typography
- **shared_preferences** - Local storage

## Sample Widgets Included

### Layout Widgets
- Container, Row, Column, Stack, Expanded, Wrap

### Input Widgets
- TextField, ElevatedButton, Checkbox, Switch, Slider

### Display Widgets
- Text, Image, Icon, Card

### Navigation Widgets
- AppBar, BottomNavigationBar

### Animation Widgets
- AnimatedContainer

## Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Adding New Widgets

To add a new widget to the catalog:

1. Open `lib/data/widget_samples.dart`
2. Add a new `FlutterWidget` instance to the `additionalWidgets` list
3. Include all required fields: id, name, categoryId, description, documentation, and exampleCode
4. Add relevant properties and related widgets

## Roadmap

- [ ] Add more widget examples (Goal: 100+ widgets)
- [ ] Implement favorites functionality with local storage
- [ ] Add widget preview/playground feature
- [ ] Include animation previews
- [ ] Add export functionality for code snippets
- [ ] Implement widget comparison feature
- [ ] Add tutorial mode for beginners
- [ ] Support for custom widget collections
- [ ] Offline documentation support
- [ ] Integration with DartPad for live code editing

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design team for design guidelines
- The Flutter community for continuous support and inspiration

## Contact

- Website: [flutterby.app](https://flutterby.app)
- Issues: [GitHub Issues](https://github.com/flutterby-app/Flutterby/issues)

---

Built with 💙 using Flutter
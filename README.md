<div align="center">

# 📚 Attensia - The Attendance Almanac

### *Your Smart Companion for Academic Success*

[![Flutter](https://img.shields.io/badge/Flutter-3.41.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

*Never miss a class. Never lose track. Never fall behind.*

[Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Getting Started](#-getting-started) • [Architecture](#-architecture)

</div>

---

## 🎯 What is Attensia?

**Attensia** is a modern, neo-brutal styled Flutter application designed to help students manage their attendance with style and efficiency. Built with a focus on user experience and data-driven insights, Attensia transforms the mundane task of attendance tracking into an engaging, visual experience.

> **"Because every class counts, and every percentage matters."**

---

## ✨ Features

### 📊 **Smart Attendance Tracking**
- **Real-time Percentage Calculation** - Instantly see your attendance percentage
- **Visual Status Indicators** - Color-coded cards (Green/Yellow/Red) based on attendance health
- **Quick Actions** - Mark present/absent with a single tap
- **Subject Management** - Add, edit, and delete subjects effortlessly

### 📅 **Intelligent Timetable**
- **Weekly Schedule View** - See your entire week at a glance
- **Today's Classes** - Highlighted view of current day's schedule
- **Drag & Drop Editing** - Intuitive timetable creation
- **Quick Attendance Marking** - Mark attendance for all today's classes instantly

### 📈 **Insightful Analytics**
- **Attendance Trends** - Visualize your attendance patterns over time
- **Subject-wise Breakdown** - Detailed analytics for each subject
- **Predictive Insights** - Know how many classes you can skip or need to attend
- **Goal Tracking** - Set and monitor attendance targets

### 👤 **User Management**
- **Secure Authentication** - Email/password login with Supabase
- **Profile Customization** - Personalize your experience
- **Cloud Sync** - Access your data from any device
- **Data Privacy** - Your data is encrypted and secure

### 🎨 **Neo-Brutal Design**
- **Bold & Expressive** - Thick borders, vibrant colors, and strong shadows
- **Intuitive UI** - Easy navigation with bottom tab bar
- **Responsive Layout** - Works seamlessly on all screen sizes
- **Smooth Animations** - Delightful micro-interactions

---

## 📱 Screenshots

<div align="center">

### Attendance Dashboard
*Track all your subjects with real-time percentage updates*

### Timetable View
*Manage your weekly schedule with ease*

### Analytics & Insights
*Visualize your attendance patterns*

### Profile & Settings
*Customize your experience*

</div>

---

## 🛠 Tech Stack

### **Frontend**
```
Flutter 3.41.2          - Cross-platform UI framework
Dart 3.11.0            - Programming language
Material Design 3      - Design system
```

### **Backend & Services**
```
Supabase               - Backend as a Service (BaaS)
PostgreSQL             - Database
Row Level Security     - Data protection
Real-time Subscriptions - Live data updates
```

### **State Management**
```
ChangeNotifier         - Reactive state management
Provider Pattern       - Dependency injection
```

### **Architecture**
```
MVC Pattern            - Model-View-Controller
Service Layer          - Business logic separation
Repository Pattern     - Data access abstraction
```

---

## 🏗 Project Structure

```
attensia/
├── lib/
│   ├── core/
│   │   └── supabase_config.dart.example    # Supabase configuration template
│   │
│   ├── screens/
│   │   ├── attendance/
│   │   │   ├── controllers/                # Attendance business logic
│   │   │   ├── models/                     # Subject data models
│   │   │   └── views/                      # Attendance UI screens
│   │   │
│   │   ├── timetable/
│   │   │   ├── controllers/                # Timetable state management
│   │   │   ├── models/                     # Timetable data models
│   │   │   ├── views/                      # Timetable UI screens
│   │   │   └── widgets/                    # Reusable timetable components
│   │   │
│   │   ├── summary/
│   │   │   ├── controllers/                # Analytics logic
│   │   │   └── views/                      # Summary & analytics UI
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart           # User authentication
│   │   │   ├── register_screen.dart        # New user registration
│   │   │   └── auth_wrapper.dart           # Auth state handler
│   │   │
│   │   ├── profile/
│   │   │   └── profile_screen.dart         # User profile management
│   │   │
│   │   └── main_navigation.dart            # Bottom navigation controller
│   │
│   ├── services/
│   │   ├── attendance_service.dart         # Attendance CRUD operations
│   │   ├── timetable_service.dart          # Timetable CRUD operations
│   │   ├── summary_service.dart            # Analytics data fetching
│   │   ├── profile_service.dart            # User profile operations
│   │   └── auth_service.dart               # Authentication service
│   │
│   ├── widgets/
│   │   ├── neo_brutal_curved_nav_bar.dart  # Custom navigation bar
│   │   └── ...                             # Other reusable widgets
│   │
│   ├── theme.dart                          # App-wide theme configuration
│   └── main.dart                           # Application entry point
│
├── assets/                                 # Images, fonts, icons
├── test/                                   # Unit and widget tests
└── pubspec.yaml                            # Dependencies and metadata
```

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.41.2 or higher)
- **Dart SDK** (3.11.0 or higher)
- **Android Studio** / **VS Code** with Flutter extensions
- **Git**
- **Supabase Account** (free tier works great!)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AtharvaLotankar11/Attensia---The-Attendance-Almanac.git
   cd Attensia---The-Attendance-Almanac/attensia
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   
   a. Create a new project at [supabase.com](https://supabase.com)
   
   b. Copy `lib/core/supabase_config.dart.example` to `lib/core/supabase_config.dart`
   
   c. Add your Supabase credentials:
   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

4. **Set up the database**
   
   Run the following SQL in your Supabase SQL Editor:
   
   ```sql
   -- Create subjects table
   CREATE TABLE subjects (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
     name TEXT NOT NULL,
     attended INTEGER DEFAULT 0,
     total INTEGER DEFAULT 0,
     created_at TIMESTAMPTZ DEFAULT NOW(),
     updated_at TIMESTAMPTZ DEFAULT NOW()
   );

   -- Create timetable table
   CREATE TABLE timetable (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
     day_of_week TEXT NOT NULL,
     subjects TEXT[] NOT NULL DEFAULT '{}',
     created_at TIMESTAMPTZ DEFAULT NOW(),
     updated_at TIMESTAMPTZ DEFAULT NOW(),
     UNIQUE(user_id, day_of_week)
   );

   -- Create user_settings table
   CREATE TABLE user_settings (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
     min_attendance_threshold DECIMAL DEFAULT 75.0,
     created_at TIMESTAMPTZ DEFAULT NOW(),
     updated_at TIMESTAMPTZ DEFAULT NOW(),
     UNIQUE(user_id)
   );

   -- Enable Row Level Security
   ALTER TABLE subjects ENABLE ROW LEVEL SECURITY;
   ALTER TABLE timetable ENABLE ROW LEVEL SECURITY;
   ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

   -- Create RLS Policies
   CREATE POLICY "Users can manage their own subjects"
     ON subjects FOR ALL USING (auth.uid() = user_id);

   CREATE POLICY "Users can manage their own timetable"
     ON timetable FOR ALL USING (auth.uid() = user_id);

   CREATE POLICY "Users can manage their own settings"
     ON user_settings FOR ALL USING (auth.uid() = user_id);
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎨 Design Philosophy

### Neo-Brutalism Aesthetic

Attensia embraces the **neo-brutal design** movement, characterized by:

- **Bold Typography** - Strong, readable fonts that command attention
- **Thick Borders** - 3-4px borders that define clear boundaries
- **Vibrant Colors** - Cyan, yellow, and contrasting palettes
- **Hard Shadows** - Offset shadows (6-8px) for depth without blur
- **Flat Design** - No gradients, no rounded corners (or minimal)
- **High Contrast** - Black text on white backgrounds for maximum readability

This design choice makes Attensia:
- ✅ **Highly Accessible** - Easy to read and navigate
- ✅ **Memorable** - Stands out from generic Material Design apps
- ✅ **Functional** - Form follows function, no unnecessary decoration
- ✅ **Modern** - Aligns with current design trends

---

## 🏛 Architecture

### MVC + Service Layer Pattern

```
┌─────────────────────────────────────────────────────────┐
│                         VIEW                            │
│  (UI Screens, Widgets, User Interactions)               │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                      CONTROLLER                         │
│  (State Management, Business Logic, ChangeNotifier)     │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                       SERVICE                           │
│  (API Calls, Data Transformation, Supabase Client)      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                        MODEL                            │
│  (Data Classes, Serialization, Business Entities)       │
└─────────────────────────────────────────────────────────┘
```

### Key Benefits

- **Separation of Concerns** - Each layer has a single responsibility
- **Testability** - Easy to unit test controllers and services
- **Maintainability** - Changes in one layer don't affect others
- **Scalability** - Easy to add new features without breaking existing code

---

## 🔐 Security

- **Row Level Security (RLS)** - Users can only access their own data
- **Secure Authentication** - Supabase handles password hashing and JWT tokens
- **Environment Variables** - Sensitive keys are gitignored
- **HTTPS Only** - All API calls are encrypted in transit

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style
- Write meaningful commit messages
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation if needed

---

## 🐛 Known Issues & Roadmap

### Current Issues
- [ ] Offline mode not yet implemented
- [ ] Export data feature pending

### Upcoming Features
- [ ] Dark mode support
- [ ] Attendance reminders/notifications
- [ ] Multi-semester support
- [ ] Data export (CSV/PDF)
- [ ] Attendance prediction using ML
- [ ] Widget for home screen
- [ ] Biometric authentication

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Atharva Lotankar**

- GitHub: [@AtharvaLotankar11](https://github.com/AtharvaLotankar11)
- Project Link: [Attensia - The Attendance Almanac](https://github.com/AtharvaLotankar11/Attensia---The-Attendance-Almanac)

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Supabase** - For the powerful backend platform
- **Neo-Brutalism Community** - For design inspiration
- **Open Source Community** - For countless helpful packages

---

<div align="center">

### ⭐ Star this repo if you find it helpful!

**Made with ❤️ and Flutter**

</div>

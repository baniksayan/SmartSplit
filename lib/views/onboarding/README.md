# User Onboarding Flow

Complete onboarding system for SmartSplit app with 4 screens following MVVM architecture.

## 📋 Overview

The onboarding flow guides new users through initial setup with a smooth, intuitive experience:

1. **Welcome Slides** - Introduction to app features (3 slides)
2. **Profile Setup** - User profile creation with validation
3. **Theme Selection** - Visual customization and font preferences
4. **Permissions** - Request necessary app permissions

## 🏗️ Architecture

### MVVM Pattern

- **Models**: `UserModel` (lib/models/user/user_model.dart)
- **Views**: All screens in `lib/views/onboarding/`
- **ViewModels**: `UserViewModel` (lib/view_models/user/user_view_model.dart)
- **Services**: `UserService` (lib/services/database/user_service.dart)

### Data Persistence

- **Database**: Hive (local NoSQL database)
- **Type Adapter**: Auto-generated via `build_runner`
- **Storage Box**: `user_data` with key `current_user`

## 📱 Screens

### 1. Welcome Slides Screen (`welcome_slides_screen.dart`)

**Features:**
- 3 tutorial slides introducing app features
- Smooth page indicators (WormEffect)
- Skip button to jump ahead
- Next/Get Started button with state-aware text

**Slides:**
1. Split Bills Fairly - Easy bill splitting with friends
2. Track Shared Expenses - Monitor shared living costs
3. Smart Settlements - Optimized debt settlement

**Navigation:**
- Skip → `/profile-setup`
- Get Started → `/profile-setup`

**Dependencies:**
- `smooth_page_indicator: ^1.2.0+3`

### 2. Profile Setup Screen (`profile_setup_screen.dart`)

**Features:**
- Profile image picker (camera/gallery)
- Name validation (required, 2-50 chars)
- Email validation (optional, regex pattern)
- Currency selection (140+ currencies, searchable)
- Language selection (40+ languages, searchable)
- Split mode preference (Equal Split vs Item-Level Split)
- Progress indicator (3-step onboarding)

**Validation Rules:**
- Name: Required, 2-50 characters, trim whitespace
- Email: Optional, valid email format (RFC 5322)
- Currency: Required, must select from list
- Language: Required, must select from list

**Navigation:**
- Save → `/theme-selection` (creates UserModel with UUID)
- Data persisted via `UserService.saveUser()`

**Dependencies:**
- `image_picker: ^1.1.2`
- `image_cropper: ^8.0.2`
- `uuid: ^4.5.1`

### 3. Theme Selection Screen (`theme_selection_screen.dart`)

**Features:**
- 5 predefined themes + custom option
- Live theme preview with sample UI
- Custom color picker for RGB selection
- Font size selector (Small, Medium, Large, Extra Large)
- Skip option to proceed with defaults
- Progress indicator showing completed steps

**Predefined Themes:**
1. Light - Default teal/blue gradient (#00B4D8, #0077B6)
2. Dark - Dark mode variant (#90E0EF, #00B4D8)
3. Blue Ocean - Deep blue tones (#006494, #0582CA)
4. Forest - Green nature theme (#2D6A4F, #40916C)
5. Sunset Orange - Warm orange tones (#E63946, #F77F00)
6. Custom - User-defined RGB colors

**Font Sizes:**
- Small: 0.85x scale
- Medium: 1.0x scale (default)
- Large: 1.15x scale
- Extra Large: 1.3x scale

**Navigation:**
- Skip → `/permissions` (no theme changes saved)
- Continue → `/permissions` (updates UserModel theme fields)

**Dependencies:**
- `flutter_colorpicker: ^1.1.0`

### 4. Permissions Screen (`permissions_screen.dart`)

**Features:**
- 3 permission cards with clear explanations
- Individual Allow buttons per permission
- Allow All button for convenience
- Skip option to complete onboarding without granting
- Visual feedback with green checkmarks
- Continue to App button (appears when all granted)

**Permissions:**
1. **Camera Access** - Take photos of bills/receipts
2. **Storage Access** - Save and export expense reports
3. **Notifications** - Settlement reminders and updates

**Navigation:**
- Skip → `/home` (completes onboarding)
- Continue → `/home` (all permissions granted)

**Dependencies:**
- `permission_handler: ^11.3.1`

## 🔄 Navigation Flow

```
SplashScreen (3s animation)
    ↓ (first launch)
WelcomeSlidesScreen
    ↓ (Skip or Get Started)
ProfileSetupScreen
    ↓ (Save profile)
ThemeSelectionScreen
    ↓ (Save theme or Skip)
PermissionsScreen
    ↓ (Allow/Skip)
HomeScreen
```

**First Launch Detection:**
- Hive box: `app_settings`
- Key: `isFirstLaunch`
- Value: `true` (first), `false` (returning)

**Returning Users:**
- SplashScreen → HomeScreen (direct navigation)

## 🎨 Design System

### Color Palette
- Primary: `#00B4D8` (Teal)
- Secondary: `#0077B6` (Blue)
- Accent: `#90E0EF` (Light Blue)
- Background: `#FFFFFF` (White)
- Text: Google Fonts Poppins

### Typography
- Font Family: Poppins (Google Fonts)
- App Bar Title: 16pt, Weight 600
- Body Text: 14pt
- Labels: 12pt
- Scalable via font size preference

### Spacing
- Screen Padding: 24px
- Component Spacing: 16px/32px
- Border Radius: 12px (buttons), 16px (cards)

### Transitions
- Fade: 400ms (splash → welcome)
- Slide: 300ms (onboarding flow)
- Curve: `easeInOut` / `easeOutCubic`

## 📦 Reusable Components

### lib/views/common/

1. **ProfileImagePicker** (`profile_image_picker.dart`)
   - Circular profile image display
   - Camera badge overlay
   - Bottom sheet selector (camera/gallery)
   - Remove image option
   - Customizable size parameter

2. **CurrencyDropdown** (`currency_dropdown.dart`)
   - Searchable modal bottom sheet
   - 140+ currencies organized
   - Popular currencies shown first
   - CircleAvatar with currency symbol
   - Search TextField with real-time filtering

3. **LanguageDropdown** (`language_dropdown.dart`)
   - Searchable modal bottom sheet
   - 40+ languages with native names
   - Language code badges
   - Search functionality
   - Selected state with check icon

## 💾 Data Models

### UserModel (lib/models/user/user_model.dart)

```dart
class UserModel {
  final String userId;              // UUID v4
  final String userName;            // 2-50 chars
  final String? email;              // Optional
  final String? profilePicture;     // File path
  final String preferredCurrency;   // Currency code (USD, EUR, etc.)
  final String preferredLanguage;   // Language code (en, hi, etc.)
  final String defaultSplitMode;    // equal_split | item_level
  final DateTime createdAt;         // Creation timestamp
  final String? themeMode;          // light | dark | custom
  final String? customPrimaryColor; // Hex color
  final String? customSecondaryColor;
  final String? customAccentColor;
  final String? fontSize;           // small | medium | large | xl
}
```

**Hive Configuration:**
- TypeAdapter: `UserModelAdapter` (auto-generated)
- Type ID: 0
- Fields: 13 total with @HiveField annotations

### SplitMode Constants

```dart
class SplitMode {
  static const String equalSplit = 'equal_split';
  static const String itemLevel = 'item_level';
}
```

### FontSizeOption Constants

```dart
class FontSizeOption {
  static const String small = 'small';
  static const String medium = 'medium';
  static const String large = 'large';
  static const String extraLarge = 'xl';
}
```

### AppThemeMode Constants

```dart
class AppThemeMode {
  static const String light = 'light';
  static const String dark = 'dark';
  static const String blueOcean = 'blue_ocean';
  static const String forest = 'forest';
  static const String sunsetOrange = 'sunset_orange';
  static const String custom = 'custom';
}
```

## 🛠️ Services

### UserService (lib/services/database/user_service.dart)

**CRUD Operations:**

```dart
// Create/Update
await userService.saveUser(user);

// Read
UserModel? user = await userService.getCurrentUser();

// Update
await userService.updateUser(updatedUser);

// Delete
await userService.deleteUser();

// Check existence
bool hasUser = await userService.hasUser();

// Update single field
await userService.updateUserField('themeMode', 'dark');

// Export/Import
Map<String, dynamic> data = await userService.exportUserData();
await userService.importUserData(data);

// Clear all data
await userService.clearAll();
```

**Box Configuration:**
- Box Name: `user_data`
- Storage Key: `current_user`
- Type: Hive Box

## 📚 Constants

### Currency Data (lib/core/constants/currency_data.dart)

**Popular Currencies (20):**
USD, EUR, GBP, JPY, CAD, AUD, CHF, CNY, INR, SGD, HKD, NZD, SEK, NOK, KRW, MXN, BRL, ZAR, RUB, TRY

**All Currencies (140+):**
Complete list with currency codes, names, and symbols

**Methods:**
```dart
List<Currency> filtered = CurrencyData.search('dollar');
Currency? usd = CurrencyData.findByCode('USD');
```

### Language Data (lib/core/constants/language_data.dart)

**Supported Languages (40+):**
English, Spanish, French, German, Chinese, Japanese, Korean, Hindi, Arabic, Russian, Portuguese, Italian, Dutch, Swedish, Norwegian, Danish, Finnish, Greek, Turkish, Polish, Thai, Vietnamese, Indonesian, Malay, Filipino, Hebrew, Czech, Romanian, Hungarian, Ukrainian, Bengali, Tamil, Telugu, Gujarati, Kannada, Malayalam, Marathi, Urdu, Persian, Swahili

**Methods:**
```dart
List<Language> filtered = LanguageData.search('eng');
Language? english = LanguageData.findByCode('en');
```

## 🔨 Code Generation

### Generate Hive Adapters

```bash
# Run build_runner to generate user_model.g.dart
flutter pub run build_runner build --delete-conflicting-outputs

# For continuous generation during development
flutter pub run build_runner watch
```

### Register Adapters (main.dart)

```dart
import 'models/user/user_model.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  runApp(MyApp());
}
```

## ✅ Testing Checklist

### Unit Tests
- [ ] UserModel serialization/deserialization
- [ ] UserService CRUD operations
- [ ] Currency/Language search functionality
- [ ] Validation logic (name, email)
- [ ] Theme color conversion (hex ↔ Color)

### Widget Tests
- [ ] ProfileImagePicker tap interactions
- [ ] CurrencyDropdown search filtering
- [ ] LanguageDropdown search filtering
- [ ] Form validation in ProfileSetupScreen
- [ ] PageView navigation in WelcomeSlidesScreen
- [ ] Theme preview updates in ThemeSelectionScreen
- [ ] Permission cards state in PermissionsScreen

### Integration Tests
- [ ] Complete onboarding flow (4 screens)
- [ ] Data persistence across app restarts
- [ ] First launch vs returning user navigation
- [ ] Skip functionality in all screens
- [ ] Theme application to HomeScreen
- [ ] Permission request flows

## 📝 Usage Examples

### Complete Onboarding Journey

```dart
// 1. First Launch Detection (SplashScreen)
final box = await Hive.openBox('app_settings');
final isFirstLaunch = box.get('isFirstLaunch', defaultValue: true);

if (isFirstLaunch) {
  await box.put('isFirstLaunch', false);
  Navigator.pushReplacementNamed(context, '/welcome-slides');
}

// 2. Profile Creation (ProfileSetupScreen)
final user = UserModel(
  userId: Uuid().v4(),
  userName: 'John Doe',
  email: 'john@example.com',
  preferredCurrency: 'USD',
  preferredLanguage: 'en',
  defaultSplitMode: SplitMode.equalSplit,
  createdAt: DateTime.now(),
);
await UserService().saveUser(user);

// 3. Theme Customization (ThemeSelectionScreen)
final updatedUser = user.copyWith(
  themeMode: AppThemeMode.dark,
  fontSize: FontSizeOption.large,
);
await UserService().updateUser(updatedUser);

// 4. Permission Requests (PermissionsScreen)
final cameraStatus = await Permission.camera.request();
final storageStatus = await Permission.storage.request();
final notificationStatus = await Permission.notification.request();
```

### Retrieve User Data

```dart
// Get current user
final userService = UserService();
final user = await userService.getCurrentUser();

if (user != null) {
  print('Welcome back, ${user.userName}!');
  print('Your currency: ${user.preferredCurrency}');
  print('Your theme: ${user.themeMode}');
}
```

## 🐛 Known Issues

1. **Image Cropper Android**: May require additional AndroidManifest.xml permissions
2. **Permission Handler iOS**: Requires Info.plist entries for camera/storage/notifications
3. **Hive Box**: Must close boxes properly to avoid data corruption

## 🔮 Future Enhancements

1. **Social Login**: Google, Facebook, Apple Sign-In integration
2. **Profile Picture Sync**: Cloud storage for profile images
3. **Advanced Themes**: Gradient themes, animated themes
4. **Multi-Language**: Full i18n support for all languages
5. **Tutorial Videos**: Embedded video tutorials in welcome slides
6. **Dark Mode Auto**: System-based theme switching
7. **Accessibility**: VoiceOver, TalkBack, high contrast modes

## 📄 License

Part of SmartSplit app - Intelligent Expense Splitting & Tracking

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Maintainer**: SmartSplit Development Team

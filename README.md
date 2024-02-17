# Services app



## A Flutter project is mainly used for 
* **Service Selection:** Users can choose from various `service categories` like plumbing, electrical work, painting, etc.

* **Location-Based Search:** Users can view artisans' `locations on a map` and select the closest one for their needs.

* **Order Management:** Users can place orders by uploading images and providing descriptions of their issues.

* **Real-Time Chat:** The app offers a `WhatsApp-like chat` feature supporting text, images, audio recordings, locations, and emojis for communication with artisans.

* **Live Tracking:** Users can track artisans `in real-time on a map`, monitor their movements, speed, and activity status.

* **Comprehensive Tracking Analysis:** Users have access to detailed tracking data, including `speed analysis` divided into five different speed ranges. Additionally, users can view total distance covered and time spent during the tracking process. This feature provides valuable insights into the artisan's `movements` and performance throughout the service.

* **Order Management:** Users can cancel current orders and view past orders along with chat and tracking information.



# The main Technologies & Packages/Plugins used in the App
  * The **Backend** is `Firbease`:
    * `Cloud Firestore` to save available services, the service givers info, the user info, Orders, Chat, and Tracking info.
    * `Firebase Storage` to save the images of the Orders and Chat.
    * `Firebase Auth` to handle the **Authentication**.
  * Using [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) plugin to provide a Google Maps widget.
  * Using **Google Maps APIs:** `Roads API`, `Maps Static API`, `Geocoding API`.
  * Using [location](https://pub.dev/packages/location) plugin to get current user location.
  * Using [map_launcher](https://pub.dev/packages/map_launcher) plugin for launching any `location` from Chat.
  * Using [url_launcher](https://pub.dev/packages/url_launcher) plugin for `Linkify Text`: any text containing URLs, email addresses, or phone numbers. Users can seamlessly open or launch these links, emails, or phone calls directly from within the app.
  * The app supports `Localizations`.
  * The app supports `Theming` for `Light` and `Dark`.
  * Using [flutter_sound](https://pub.dev/packages/flutter_sound) package for `recording` and `sound player`.
  * Using [path_provider](https://pub.dev/packages/path_provider) plugin to cach The files `images` in `ApplicationDocumentsDirectory` and save the images to `Gallery`.



# The App Architecture, Directory structure, And State Management
  * Using `Provider` State Management.
  * Using `get_it` for Dependency injection.
  * Using the `Clean Architecture` of `Uncle Bob`.

    ![image](https://github.com/salahalshafey/services_app/assets/64344500/20bcf926-812b-4c53-a2ec-9730fbd0343f)

## Directory Structure
```
lib
│
│───main.dart
│───firebase_options.dart
│───l10n/
│  
└───src
    │
    │───core
    |    |
    |    |──error/
    |    │──location/
    |    │──network/
    |    │──theme
    |    |   │──map_styles.dart
    |    |   └──my_theme.dart   
    |    |
    |    └──util
    |        |──builders/
    |        │──classes/
    |        │──extensions/
    |        │──functions/
    |        └──widgets/   
    |    
    │───features
    |    |
    |    |──account/
    |    │──chat/
    |    │──orders/
    |    │──services/
    |    │──services_givers/
    |    │──tracking/
    |    └──main_screen.dart
    |
    │───app.dart      
    └───injection_container.dart
```

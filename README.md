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
  * Using [hive](https://pub.dev/packages/hive) as a local Database.
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
    |    │──settings/   
    |    └──main_and_drawer_screens/
    |
    │───app.dart      
    └───injection_container.dart
```



# App pages

## Services & making Order's Screens
  Services Screen              | See the nearest artisans       | See all artisans on the map  
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/f8ee206d-9394-4e0b-8b9a-1a67a7160f65)|![](https://github.com/salahalshafey/services_app/assets/64344500/0184ab62-5cf8-4244-af9d-59a6e3dd8194)|![](https://github.com/salahalshafey/services_app/assets/64344500/a97af2be-d19d-4351-b5b3-1b46851979a0)

  Choose one               |     Make Order    
:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/7e262116-4dad-48e6-86da-193611c9e41d)|![](https://github.com/salahalshafey/services_app/assets/64344500/0fe1c118-385d-44d8-8045-c94a02c9a6a5)

## Current Orders' Screens
  Current Orders              | Current Orders       | Order details
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/9c596abd-363a-4b6e-9a5c-7fb547f2b5d7)|![](https://github.com/salahalshafey/services_app/assets/64344500/3335c933-f96b-4ddf-aaae-ada24d983ef6)|![](https://github.com/salahalshafey/services_app/assets/64344500/f6880cb9-b55d-40b3-bd33-e14702cbae07)

  Artisan Image              | Order Image       | Order Image
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/a4917afd-1b62-41de-a8af-a178fdcd2ff4)|![](https://github.com/salahalshafey/services_app/assets/64344500/52d735fe-f72d-46e1-8623-d275b1e2305f)|![](https://github.com/salahalshafey/services_app/assets/64344500/8c81a72f-0e07-458b-8d04-2b072e2c8331)

  The user can Chat With the artisan         | The user can Track the artisan       | The user can Cancel the order
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/eab3bfb8-d202-4f96-94c1-47d71b499a69)|![](https://github.com/salahalshafey/services_app/assets/64344500/ba45c821-500c-4b09-9a0d-e13a40ee0eb8)|![](https://github.com/salahalshafey/services_app/assets/64344500/ab67f7ac-011e-4986-8415-844a7902701a)

## Chat Screens
  If No messages              | Chat can be with `Text`, `Audio`       | it can be with `Location`  
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/7b1f74ae-b305-42a8-a3cd-f422799b1b91)|![](https://github.com/salahalshafey/services_app/assets/64344500/2f89622b-9fab-480d-8ec7-93b63e8f5ee3)|![](https://github.com/salahalshafey/services_app/assets/64344500/7b3acf3b-3d16-43a8-ac3d-25f5681aa71e)

  `current location` can be sent directly              |     Or can be `selected from the map`
:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/d4d446cc-bd04-4f98-ad21-a55f138f665f)|![](https://github.com/salahalshafey/services_app/assets/64344500/e0b051fd-7ec0-45cd-a005-4d91dd8f4de4)

  Chat can be with `Image`      | also `caption` can be added     | the image `full screen` can be viewed
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/82b9968b-1e26-4f62-9814-e85636b9451c)|![](https://github.com/salahalshafey/services_app/assets/64344500/3e1cb0d7-fe26-49c4-b329-d52ce50a4534)|![](https://github.com/salahalshafey/services_app/assets/64344500/20437582-9878-4456-9d0c-2244666584b3)

  the chat support `emoji` | `emoji` can be toggled with `keyboard` | the text in the chat is `linkify`
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/3c79142d-d736-40b2-a43a-de5bed048ac9)|![](https://github.com/salahalshafey/services_app/assets/64344500/7fcc1946-7c8f-4bc6-b92a-47242474be91)|![](https://github.com/salahalshafey/services_app/assets/64344500/6427287e-8373-4cc5-8666-a47d265ef9fe)

## Tracking screens
  user can see artisan `location`, `speed`, and `last seen time`             |     The map type can be toggled
:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/a5f84de9-efb9-40e9-aaa7-65826ff9f5af)|![](https://github.com/salahalshafey/services_app/assets/64344500/69b3fa7f-6c51-4b73-a233-03a056584684)

**Users can see detailes of tracking data, including `speed analysis` divided into five different `speed ranges`. Additionally, users can view `total distance` covered and` time spent` during the tracking process**
  1 | 2 | 3
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/f1ddd2c8-0df4-4217-934f-d0bedd81f1ad)|![](https://github.com/salahalshafey/services_app/assets/64344500/51aaaf3e-eaaf-4c00-9190-eb8346e9735b)|![](https://github.com/salahalshafey/services_app/assets/64344500/8477af8e-b50f-4ba0-9389-0d91024ecb1d)

## Previous orders' screens
  Previous orders        |     Previous orders details
:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/8e3aa0d9-2a43-4a25-8aae-417dfbad8a28)|![](https://github.com/salahalshafey/services_app/assets/64344500/45a2702f-7a1e-427c-b72a-69181d368eb7)

  Previous Chat is `read only`        |     Previous tracking details
:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/097d7c2f-de95-4f74-9f88-a67b4eda0378)|![](https://github.com/salahalshafey/services_app/assets/64344500/2499a1f5-f42c-47a9-b318-8862d8d89ce8)

## Menue & settings screens
  Menue | settings | Language | Apearance
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/cc7a5d80-e506-4d4f-8c24-a417bffbbaf2)|![](https://github.com/salahalshafey/services_app/assets/64344500/ea0f089a-e332-4167-80a8-7c36ca311227)|![](https://github.com/salahalshafey/services_app/assets/64344500/494865cf-5009-4877-af2f-4775e92b3f6e)|![](https://github.com/salahalshafey/services_app/assets/64344500/29900b35-05c8-45ba-ae16-467655914259)

**Some screens with a `dark theme`**
  1 | 2 | 3 | 4
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/salahalshafey/services_app/assets/64344500/54e8a9be-3f1f-4e64-a15f-928612454fcb)|![](https://github.com/salahalshafey/services_app/assets/64344500/a174c80d-043f-443e-9030-e2358daa5ec5)|![](https://github.com/salahalshafey/services_app/assets/64344500/37de3ba0-7b2d-4473-b345-530fbcdfae3a)|![](https://github.com/salahalshafey/services_app/assets/64344500/ea377a6e-f8fc-4986-adc3-dcefd3afba16)

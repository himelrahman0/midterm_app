# midterm_app

# Bangladesh Landmark Manager

# App Summary

The *Bangladesh Landmark Manager* is a native Android application developed for the CSE 489 Midterm project. Its objective is to demonstrate proficiency in modern Android development by implementing a full-stack solution that interacts with a remote RESTful API.

This application allows users to register, visualize, manage (update and delete), and explore landmark records across Bangladesh. The data—including a descriptive title, geographic coordinates (latitude and longitude), and an associated image—is persisted on a remote server. The UI is built around a compact, tabbed navigation design for seamless user experience.

# Feature List

The application implements the following core features as required by the midterm specifications:

 1. Robust API Communication (CRUD)
    Create (POST):Allows registration of new landmark entries via an interactive form.
    Read (GET): Fetches and displays all available landmark records from the remote API.
    Update (PUT):Enables modification of existing landmark details (title, coordinates, and optional image).
    Delete (DELETE): Provides functionality to permanently remove a landmark record.

 2. Multi-Format Landmark Visualization
    Interactive Map View (Overview Tab):
     Utilizes the *Google Maps SDK* to display landmarks as custom, tappable markers.
     Map is automatically centered on Bangladesh ($23.6850^{\circ}\text{N}, 90.3563^{\circ}\text{E}$).
     Tapping a marker opens a *Bottom Sheet Panel* for a quick view of the title, image preview, and quick access to Edit/Delete actions.
  Scrollable List View (Records Tab):
     Presents all fetched landmarks in a modern *RecyclerView* using *CardView* items.
     Supports *Swipe-to-Action* gestures (Left/Right) on cards to quickly initiate Edit or Delete operations.

# 3. Navigation and User Interface
 Employs a *Bottom Navigation Bar* for efficient access to the three main screens: *Overview*, *Records*, and *New Entry*.
 The overall design prioritizes clarity and adheres to modern Material Design standards.

# 4. Landmark Entry/Edit Form (New Entry Tab)
   A dedicated screen for managing landmark data.
   Automatic GPS Detection:** Automatically detects and pre-fills the user's current latitude and longitude when adding a new entry.
   Image Handling: Allows users to select an image, which is then *resized to $800 \times 600$* before submission to the API to optimize data transfer.

# 5. Feedback and Error Handling
   Successful operations are confirmed using *Snackbars* for non-intrusive feedback.
   API or network failures are communicated using persistent *Dialog Popups* with specific error messages.

# Setup Instructions

To build and run the *Bangladesh Landmark Manager* app, follow these steps:

# Prerequisites

  Android Studio: Arctic Fox (2020.3.1) or newer.
  Android SDK: Target API Level 34 (Android 14) or higher.
  Google Maps API Key: You must obtain a Google Maps API key and place it in the `local.properties` file or directly in the `AndroidManifest.xml`.

# Steps to Run

1.  *Clone the Repository:*
    ```bash
    git clone [YOUR_REPOSITORY_URL]
    cd Bangladesh-Landmark-Manager
    ```

2.  * configure API Key (If using Google Maps):*
    * Open the project in Android Studio.
    * Add your Google Maps API key to the appropriate location (e.g., in `app/src/main/res/values/google_maps_api.xml` or referenced from `local.properties`).

4.  *Build the Project:*
      Open the terminal in Android Studio and run a clean build, or use the 'Build' menu:
        ```bash
        ./gradlew clean build
        ```

5.  *Run on Device/Emulator:*
    * Select an Android Emulator or a physical device running a supported API level.
    * Click the **Run** button (▶) in Android Studio.

# Known Limitations

* Network Dependency: The application is entirely dependent on network connectivity for fetching and managing landmark data. API calls will fail without an active internet connection.
    * (Note: The optional *Offline Caching* bonus feature addresses this limitation if implemented.)
* GPS Accuracy: The automatic GPS coordinate detection relies on the device's location services. Accuracy may vary depending on the device and environment.
* Image File Size Limit: Image submission relies on proper handling of multipart form data. Very large source images may cause submission failures before the $800 \times 600$ resizing, depending on the network speed and server limits.

---

I've ensured the content is professional, uses correct technical terms (Retrofit, CardView, Bottom Sheet Panel, etc.), and directly references the requirements (like the resizing specification and center coordinates).

Do you need any modifications to this draft, or would you like to move on to the next task, such as outlining the *project architecture* or drafting the *Retrofit interface*?

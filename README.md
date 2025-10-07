#  Weather App 🌦️

A responsive and feature-rich weather forecast application built with Flutter. It provides real-time weather data for any city, an hourly forecast, and a dynamic UI that adapts for both mobile and web.

**Live Demo:** [**https://awaneetdecoder.github.io/WeatherApp/**](https://awaneetdecoder.github.io/WeatherApp/)

---

## 📸 Showcase

The most important part is showing your app in action. The best way to do this is with a GIF. You can use a free tool like [ScreenToGif](https://www.screentogif.com/) (for Windows) or Giphy Capture (for Mac) to record your app.

*Record a short clip of you searching for a city and toggling the theme.*

![Weather App Demo](link_to_your_gif.gif) 

*After creating the GIF, upload it to your repository and replace `link_to_your_gif.gif` with the actual link to the file.*

### Screenshots
| Light Mode | Dark Mode |
| :---: | :---: |
| ![Light Mode Screenshot](https://github.com/awaneetdecoder/WeatherApp/raw/main/assets/light_mode.png) | ![Dark Mode Screenshot](https://github.com/awaneetdecoder/WeatherApp/raw/main/assets/dark_mode.png) |

---

## ✨ Features

- **Real-time Weather Data:** Fetches current temperature, sky condition, humidity, wind speed, and pressure.
- **Dynamic City Search:** Allows users to find weather information for any city worldwide.
- **Responsive UI:** The layout automatically adjusts for both mobile and desktop web views.
- **Dark & Light Mode:** Includes a theme toggle for user preference.
- **Hourly Forecast:** Displays an hourly forecast with corresponding temperatures and icons.

---

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **API:** OpenWeatherMap REST API for weather data.
- **Packages:**
  - `http`: For making API requests.
  - `intl`: For date and time formatting.

---

## 🚀 Setup and Installation

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/awaneetdecoder/WeatherApp.git](https://github.com/awaneetdecoder/WeatherApp.git)
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd WeatherApp
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Create `secrets.dart`:**
    Create a file named `secrets.dart` inside the `lib` folder and add your OpenWeatherMap API key:
    ```dart
    // lib/secrets.dart
    const openWeatherAPIKey = 'YOUR_API_KEY_HERE';
    ```
5.  **Run the app:**
    ```bash
    flutter run
    ```

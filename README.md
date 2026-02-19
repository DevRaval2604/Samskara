# Samskara
### *Ancient Wisdom Meets Modern Intelligence*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Gemini](https://img.shields.io/badge/Gemini%203%20Flash-8E75B2?style=for-the-badge&logo=googlegemini&logoColor=white)](https://deepmind.google/technologies/gemini/)

**Samskara** is a premium spiritual companion app built in 2026, designed to preserve and present the rich heritage of India. Built with Flutter and powered by Google’s **Gemini 3 Flash**, it provides a bridge between sacred scriptures and modern life, ensuring that timeless wisdom is always just a tap away.

---

## 🌟 Core Feature Pillars

### 📖 Ask the Gita
An AI-driven interface that allows users to seek spiritual guidance directly from the **Bhagavad Gita**.
* **Intelligent Interpretation:** Powered by `gemini-3-flash` to provide contextually accurate shlokas for real-world problems.
* **Modern Relevance:** Every response bridges the gap between ancient Sanskrit wisdom and actionable advice for today’s challenges.

### 📜 Stories of India
An immersive digital library documenting the true **Itihasa** (History) and heritage of Bharat. This section is strictly dedicated to factual narratives and historical legacies.
* **Historical Grit:** Deep dives into the lives of **Great Rulers**, **Freedom Fighters**, and the strategic brilliance of **Legendary Battles**.
* **Unsung Legacies:** Bringing to light **Forgotten Heroes** and the groundbreaking contributions of **Ancient Science and Scholars**.
* **Focused Experience:** A clean, high-performance UI designed for deep historical learning and reflection.

### 🗓️ Indian Festivals
A comprehensive, real-time guide to the diverse festivals of the Indian subcontinent.
* **Cultural & Modern Context:** Deep dives into the astronomical and spiritual significance of each festival, including its **Modern Relevance** in today's society.
* **Ritual Guides:** Clear explanations of traditional practices and the historical events behind the celebrations.

### 🧘 Daily Wisdom
A personalized daily routine featuring a handpicked Shloka to center your mind.
* **Quad-Layer Analysis:** Each entry includes the original **Sanskrit Shloka**, a clear **Translation**, a deep **Philosophical Explanation**, and a dedicated **Modern Relevance** section for practical application.

---

## 🛠️ Technical Specifications

### 📱 Performance-Optimized Responsiveness
The app is built with a sophisticated **Dimension-Driven UI** philosophy. 

* **`MediaQuery.sizeOf(context)` Integration:** To maximize performance, the app utilizes `MediaQuery.sizeOf(context)` to fetch device dimensions. This ensures that widgets only rebuild when the specific size properties change, avoiding unnecessary rebuilds.
* **Dynamic Scaling:** Every element—from the "Ask the Gita" guidance interface to the "Festival" and "Story" cards—calculates its scale dynamically using the device's **Width** and **Height**. 
* **Flexible Grids:** Content containers are mathematically scaled to ensure text readability remains perfectly consistent across all screen sizes and densities without the use of static assets.

---

## 🏗️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Framework** | Flutter 3.41+ (Stable) |
| **Language** | Dart 3.11+ |
| **Backend** | Firebase (Auth & Firestore) |
| **AI Integration** | Google Gemini 3 Flash API |
| **Architecture** | Service-Oriented Architecture (Future/StreamBuilders) |
| **Styling** | Custom Material 3 Theming |

---

## 🚀 Installation & Setup

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/DevRaval2604/Samskara.git
    ```
2.  **Firebase Configuration:**
    * Add `google-services.json` to `android/app/`.
    * Add `GoogleService-Info.plist` to `ios/Runner/`.
    
3.  **Environment Variables:**
    * Create a `.env` file in the root directory.
    * Add your **Gemini API Key** using the following key name:
    ```bash
    GEMINI_API_KEY=your_api_key_here
    ```
4.  **Build and Launch:**
    ```bash
    flutter pub get
    flutter run
    ```
---

## 📐 Design Philosophy
The UI is inspired by traditional Indian aesthetics blended with clean, modern design principles. We use a **"Cream and Slate"** palette (`#F8F4E9` and `#5C6B7D`) to create a calm, meditative environment that encourages long-form reading and spiritual inquiry.

---

### Developed with ❤️ by Dev Raval
*Project Finalized: February 19, 2026*
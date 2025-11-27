# Edge-Swarm-Nano 🧠⚡️

**An Intelligent, Offline AI Router & Task Processor for iOS.**

Edge-Swarm-Nano is a native iOS application that demonstrates the power of **On-Device AI**. Instead of relying on cloud APIs or heavy external models, it uses Apple's `NaturalLanguage` framework to intelligently "route" user text to the correct processing task (Summarization, Sentiment Analysis, or Entity Extraction) in real-time.

## 📸 Demo

| **Intent Routing** | **Sentiment Analysis** | **Entity Extraction** |
|:---:|:---:|:---:|
| <img width="250" height="1000" alt="simulator_screenshot_FD0D6AD4-5B8F-4F38-917B-9B97C4E4FF09" src="https://github.com/user-attachments/assets/987f128f-e8df-4af0-ae81-1a6e9df89bf2" /> | <img width="250" height="1000" alt="simulator_screenshot_8B8E3437-22B9-48AA-95C7-064A907105C2" src="https://github.com/user-attachments/assets/777f46a7-6dd7-4486-818a-8ff4a9f7e0ee" /> | <img width="250" height="1000" alt="simulator_screenshot_3AE3DC7A-F7C2-4716-9EAA-61995E8E3998" src="https://github.com/user-attachments/assets/51a13bea-5ccf-4650-9cf4-862f7b6bae2f" /> |

> *The app automatically detects that the first text is a news article (Summarize), the second is a review (Sentiment), and the third contains personal data (Extract).*

## 🚀 Key Features

- **Zero-Shot Intent Routing**: Uses `NLEmbedding` (Sentence Embeddings) to semantically map user input to abstract concepts like "summary", "opinion", or "data" without requiring a custom-trained model.
- **Voice Input 🎤**: Integrated `SFSpeechRecognizer` for real-time, on-device speech-to-text dictation.
- **Language Detection 🌍**: Automatically identifies the language of the input text using `NLLanguageRecognizer`.
- **Request History 📜**: Persists past requests and results locally so you can revisit them later.
- **100% Offline**: All processing happens on-device using Apple's neural engine. No internet connection required.
- **Privacy First**: Data never leaves the device.
- **Native Performance**: Written in Swift with no heavy external dependencies (e.g., no PyTorch/TensorFlow libraries).

## 🛠 Tech Stack

- **Language**: Swift 5.5+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **AI & Core Frameworks**:
  - `NaturalLanguage`
  - `NLEmbedding` (for Semantic Search/Routing)
  - `NLTagger` (for NER and Sentiment)
  - `Speech` (for SFSpeechRecognizer)
  - `Combine` (for reactive UI updates)
- **Concurrency**: Swift Async/Await

## 🏗 Architecture

The app follows a strict **Router-Processor** pattern:

1. **Input**: User types text or uses **Voice Dictation**.
2. **Router Layer (`RouterService`)**:
    - Converts text to a high-dimensional vector using `NLEmbedding`.
    - Calculates **Cosine Similarity** against target intent vectors.
    - Routes to the highest confidence task (e.g., "Sentiment" if confidence > 35%).
3. **Processor Layer (`NLPService`)**:
    - Executes the specific task (e.g., runs TextRank algorithm for summarization).
    - Detects language metadata.
4. **UI Layer**:
    - Updates via `ContentViewModel` to show results instantly.
    - Saves result to **History** (`UserDefaults`).

## 🏃‍♂️ How to Run

1. Clone the repository.
2. Open `Edgeswarm.xcodeproj` in Xcode 13+.
3. Build and Run on any iOS Simulator or Device (iOS 15.0+ required).
4. **Note**: For Voice Input to work, you must grant Microphone and Speech Recognition permissions when prompted.

## 👨‍💻 Author

**Chase Metoyer**

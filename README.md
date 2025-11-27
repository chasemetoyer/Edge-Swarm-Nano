# Edge-Swarm-Nano 🧠⚡️

**An Intelligent, Offline AI Router & Task Processor for iOS.**

Edge-Swarm-Nano is a native iOS application that demonstrates the power of **On-Device AI**. Instead of relying on cloud APIs or heavy external models, it uses Apple's `NaturalLanguage` framework to intelligently "route" user text to the correct processing task (Summarization, Sentiment Analysis, or Entity Extraction) in real-time.

## 📸 Demo

| **Intent Routing** | **Sentiment Analysis** | **Entity Extraction** |
<img width="1080" height="1980" alt="simulator_screenshot_FD0D6AD4-5B8F-4F38-917B-9B97C4E4FF09" src="https://github.com/user-attachments/assets/987f128f-e8df-4af0-ae81-1a6e9df89bf2" />
<img width="1080" height="1980" alt="simulator_screenshot_8B8E3437-22B9-48AA-95C7-064A907105C2" src="https://github.com/user-attachments/assets/777f46a7-6dd7-4486-818a-8ff4a9f7e0ee" />
<img width="1080" height="1980" alt="simulator_screenshot_3AE3DC7A-F7C2-4716-9EAA-61995E8E3998" src="https://github.com/user-attachments/assets/51a13bea-5ccf-4650-9cf4-862f7b6bae2f" />


> *The app automatically detects that the first text is a news article (Summarize), the second is a review (Sentiment), and the third contains personal data (Extract).*

## 🚀 Key Features

- **Zero-Shot Intent Routing**: Uses `NLEmbedding` (Sentence Embeddings) to semantically map user input to abstract concepts like "summary", "opinion", or "data" without requiring a custom-trained model.
- **100% Offline**: All processing happens on-device using Apple's neural engine. No internet connection required.
- **Privacy First**: Data never leaves the device.
- **Native Performance**: Written in Swift with no heavy external dependencies (e.g., no PyTorch/TensorFlow libraries).

## 🛠 Tech Stack

- **Language**: Swift 5.5+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM (Model-View-ViewModel)
- **AI Frameworks**:
  - `NaturalLanguage`
  - `NLEmbedding` (for Semantic Search/Routing)
  - `NLTagger` (for NER and Sentiment)
- **Concurrency**: Swift Async/Await

## 🏗 Architecture

The app follows a strict **Router-Processor** pattern:

1. **Input**: User types text.
2. **Router Layer (`RouterService`)**:
    - Converts text to a high-dimensional vector using `NLEmbedding`.
    - Calculates **Cosine Similarity** against target intent vectors.
    - Routes to the highest confidence task (e.g., "Sentiment" if confidence > 35%).
3. **Processor Layer (`NLPService`)**:
    - Executes the specific task (e.g., runs TextRank algorithm for summarization).
4. **UI Layer**:
    - Updates via `ContentViewModel` to show results instantly.

## 🏃‍♂️ How to Run

1. Clone the repository.
2. Open `Edgeswarm.xcodeproj` in Xcode 13+.
3. Build and Run on any iOS Simulator or Device (iOS 15.0+ required).

## 👨‍💻 Author

**Chase Metoyer**
*AI Engineer & iOS Developer*

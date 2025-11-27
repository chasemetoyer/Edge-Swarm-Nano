# Edge-Swarm-Nano 🧠⚡️

**An Intelligent, Offline AI Router & Task Processor for iOS.**

Edge-Swarm-Nano is a native iOS application that demonstrates the power of **On-Device AI**. Instead of relying on cloud APIs or heavy external models, it uses Apple's `NaturalLanguage` framework to intelligently "route" user text to the correct processing task (Summarization, Sentiment Analysis, or Entity Extraction) in real-time.

## 📸 Demo

| **Intent Routing** | **Sentiment Analysis** | **Entity Extraction** |
|:---:|:---:|:---:|
| <img src=<img width="1320" height="2868" alt="simulator_screenshot_48749D82-1F6E-461F-9A4B-41FD67D18FCD" src="https://github.com/user-attachments/assets/31031b18-ee45-4735-9d8d-a19bde9983cb" />
> | <img src="path/to/sentiment_screenshot.png"<img width="1320" height="2868" alt="simulator_screenshot_1EA46260-9450-4CE6-AC6A-DA6AAF6EC883" src="https://github.com/user-attachments/assets/543578ee-4293-4490-9632-94b5eb13acf5" />
 width="250"> | <<img width="1320" height="2868" alt="simulator_screenshot_9848F2F1-E7EA-49BB-BB2F-2CFA8DCAF57D" src="https://github.com/user-attachments/assets/c9a511e8-d5a8-4ae5-9ac0-6212ed3c2ae5" />
> |

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

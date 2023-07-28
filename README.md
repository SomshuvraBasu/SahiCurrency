# SahiCurrency

# Indian Currency Recognition App for Visually Impaired

<!--![App Demo](demo.gif)-->

SahiCurrency is a mobile application designed to assist visually impaired individuals in recognizing Indian currency notes using voice-over. The app utilizes TensorFlow Lite to create a currency recognition model and FlutterTTS to convert the recognized currency labels to speech, providing an audible output for the user.

## Key Features

- Real-time recognition of Indian currency notes.
- Voice-over functionality to announce the recognized currency label.
- Improved recognition performance by 30% through dataset modifications.
- Streamlined voice-over by implementing checks to ensure accuracy.

## Installation

1. Clone the repository to your local machine.
2. Ensure you have Flutter installed and set up on your system.
3. Connect your Android/iOS device or use an emulator.
4. Run `flutter pub get` to fetch the required dependencies.
5. Build and install the app on your device using `flutter run`.

## Technology Stack

- Flutter: Front-end framework for building cross-platform mobile applications.
- TensorFlow Lite: Deep learning framework for deploying machine learning models on mobile devices.
- FlutterTTS: A Flutter plugin to provide text-to-speech functionality.

## Usage

1. Launch the app on your Android/iOS device.
2. Hold the currency note in front of the camera.
3. Ensure good lighting conditions for better recognition.
4. The app will automatically recognize the currency note.
5. The recognized currency value will be announced using voice-over.

## Model Training and Dataset Modification

The currency recognition model was trained using TensorFlow Lite. To improve the model's performance, we made modifications to the dataset, including:

- Data augmentation techniques to increase the dataset size.
- Improved preprocessing to enhance feature extraction.
- Fine-tuning hyperparameters for the model architecture.

## Contributing

I welcome contributions to SahiCurrency that can improve its accuracy, performance, and usability for visually impaired users. If you would like to contribute, follow these steps:

1. Fork the repository.
2. Create a new branch with a descriptive name (`feature/new-feature` or `bugfix/issue-fix`).
3. Make your changes and commit them with clear and concise messages.
4. Push your changes to your forked repository.
5. Submit a pull request to the main repository.

## Issues and Feedback

If you encounter any issues while using SahiCurrency or have suggestions for improvement, please report them on the [Issues](https://github.com/SomshuvraBasu/SahiCurrency/issues) page. We appreciate your feedback and will work towards resolving any problems promptly.

## License

SahiCurrency is open-source and licensed under the [GNU GPLv3 License](https://github.com/SomshuvraBasu/SahiCurrency/blob/main/LICENSE). Feel free to use, modify, and distribute the app as per the terms of the license.

## Acknowledgments

I would like to express our gratitude to the open-source community for their valuable contributions to the libraries and frameworks used in this project as well as the dataset.

---

Developed with ❤️ by Somshuvra Basu

<!--[![GitHub](github-logo.png)](link-to-github) [![Twitter](twitter-logo.png)](link-to-twitter) [![LinkedIn](linkedin-logo.png)](link-to-linkedin) [![Website](website-logo.png)](link-to-website)-->

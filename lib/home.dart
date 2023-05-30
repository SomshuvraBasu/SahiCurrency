import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription> cameras = [];
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';
  bool isSpeaking = false;
  String lastOutput = ''; // Declare lastOutput variable here

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    await loadModel();
    loadCamera();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      CameraDescription backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras[0],
      );
      cameraController = CameraController(backCamera, ResolutionPreset.high);
      await cameraController!.initialize();
      if (mounted) { // Add a null check for mounted before updating the state
        setState(() {
          cameraController!.startImageStream((imageFromStream) {
            if (!cameraController!.value.isTakingPicture) {
              setState(() {
                cameraImage = imageFromStream;
              });
              classifyImage(); // Classify the image in each frame
            }
          });
        });
      }
    } else {
      // Handle the case where no cameras are available
      print('No cameras found.');
    }
  }

  classifyImage() async {
    if (cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage!.height,
        imageWidth: cameraImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      if (predictions != null && predictions.isNotEmpty) {
        setState(() {
          output = getLabelFromIndex(predictions[0]['index']);
        });
        if (output != lastOutput && !isSpeaking) {
          lastOutput = output;
          isSpeaking = true;
          await speakOutput(output);
          isSpeaking = false;
        }
      }
    }
  }

  Future<void> speakOutput(String text) async {
    await flutterTts.setLanguage('en-US'); // Set the desired language
    await flutterTts.setPitch(1.0); // Set the pitch of the voice
    await flutterTts.setSpeechRate(0.8); // Set the speech rate
    await flutterTts.speak(text); // Speak the provided text
  }

  String getLabelFromIndex(int index) {
    List<String> labels = [
      'Rs 10',
      'Rs 20',
      'Rs 50',
      'Rs 100',
      'Rs 200',
      'Rs 500',
      'Rs 2000',
    ];
    if (index >= 0 && index < labels.length) {
      return labels[index];
    } else {
      return 'Unknown';
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_v2.tflite',
      labels: 'assets/labels_v2.txt',
    );
  }

  @override
  void dispose() {
    cameraController?.dispose(); // Use the null-aware operator to dispose the cameraController if it's not null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sahi Currency'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              child: cameraController?.value.isInitialized == true // Add a null check before accessing cameraController.value
                  ? AspectRatio(
                aspectRatio: cameraController!.value.aspectRatio,
                child: CameraPreview(cameraController!),
              )
                  : Container(),
            ),
          ),
          Text(
            output,
            style: const TextStyle(
              backgroundColor: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

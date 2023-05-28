import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CameraDescription> cameras = [];
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

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
      await cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          cameraController!.startImageStream((imageFromStream) {
            if (!cameraController!.value.isTakingPicture) {
              cameraController!.stopImageStream();
              setState(() {
                cameraImage = imageFromStream;
              });
              classifyImage();
            }
          });
        });
      }).catchError((error) {
        print('Error initializing camera: $error');
      });
    } else {
      print('No cameras found.');
    }
  }

  classifyImage() async {
    if (cameraImage != null) {
      var prediction = await Tflite.runModelOnFrame(
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
      prediction!.forEach((element) {
        int labelIndex = element['index'];
        double confidence = element['confidence'];
        String label = getLabelFromIndex(labelIndex);
        print('Label: $label, Confidence: $confidence');
        setState(() {
          output = label;
        });
      });
    }
  }

  String getLabelFromIndex(int index) {
    List<String> labels = [
      '0 10',
      '1 20',
      '2 50',
      '3 100',
      '4 200',
      '5 500',
      '6 2000',
    ];

    if (index >= 0 && index < labels.length) {
      return labels[index];
    } else {
      return 'Unknown';
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    cameraController?.dispose();
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
              child: cameraController != null && cameraController!.value.isInitialized
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

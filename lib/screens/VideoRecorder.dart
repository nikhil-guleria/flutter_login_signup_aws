import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_aws_login/app_constants/AppColors.dart';
import 'package:flutter_aws_login/app_constants/SizeConfig.dart';
import 'package:flutter_aws_login/screens/Dummy.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as IMG;


class VideoRecorderExample extends StatefulWidget {
  @override
  _VideoRecorderExampleState createState() {
    return _VideoRecorderExampleState();
  }
}

class _VideoRecorderExampleState extends State<VideoRecorderExample>
{
  CameraController controller;
  String videoPath,imagepath;
  List<File> files = new List();
  List<CameraDescription> cameras;
  int selectedCameraIdx;
  String _localpath="";
  ScreenshotController screenshotController = ScreenshotController();
  static GlobalKey previewContainer = new GlobalKey();
  ui.Image image;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras()
        .then((availableCameras)
    {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    })
        .catchError((err)
    {
      print('Error: $err.code\nError Message: $err.message');
    });
   init();

  }
  init()
  async {
    _localpath = (await _findLocalPath()) + "/AWS";
  final savedDir = Directory(_localpath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
  await savedDir.create();
  }
  }
  AppBar appBar;
  @override
  Widget build(BuildContext context)
  {
    SizeConfig().init(context);
    appBar = AppBar(
      backgroundColor: AppColors.syncColor,
      title: const Text('Video Record'),
      centerTitle: true,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded( child:
      Screenshot(controller:screenshotController,child:
          Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child:
                  _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            )),
          ),
          Container(
            height: SizeConfig.blockSizeVertical*8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _captureControlRowWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction)
  {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized)
    {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return


      AspectRatio(
      aspectRatio: controller.value.aspectRatio,
        child:
        CameraPreview(controller),
      );


  }
  void _getScreenShotImage() async {
   // _capturePng();
    image = await _capturePng();
    debugPrint("im height: ${image.height}, im width: ${image.width}");
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    setState(() {
     /* Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dummy(name: pngBytes,))
      );*/
    });
  }

  Future<ui.Image> _capturePng() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    return image;
  }
  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget()
  {
    if (cameras == null) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(
                _getCameraLensIcon(lensDirection)
            ),
            label: Text("${lensDirection.toString()
                .substring(lensDirection.toString().indexOf('.')+1)}")
        ),
      ),
    );
  }

  /// Display the control bar with buttons to record videos.
  Widget _captureControlRowWidget()
  {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.videocam),
              color: AppColors.syncColor,
              onPressed: controller != null &&
                  controller.value.isInitialized &&
                  !controller.value.isRecordingVideo
                  ? _onRecordButtonPressed
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              color: AppColors.syncColor,
              onPressed: controller != null &&
                  controller.value.isInitialized &&
                  controller.value.isRecordingVideo
                  ? _onStopButtonPressed
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              color: AppColors.syncColor,
              onPressed: ()
                async {
                  String path = await NativeScreenshot.takeScreenshot();
                  print(path);
                  files.add(new File(path));
                /*  final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
                  imagepath = '$_localpath/${currentTime}.jpg';
                  var bytes = await File(path).readAsBytes();
                  IMG.Image src = IMG.decodeImage(bytes);
                   IMG.Image destImage = IMG.copyCrop(src, 7, appBar.preferredSize.height.toInt(),
                      (SizeConfig.blockSizeHorizontal*98).toInt(),
                     (SizeConfig.blockSizeVertical*100 -(appBar.preferredSize.height+SizeConfig.blockSizeVertical*8)).toInt());
                   var jpg = IMG.encodeJpg(destImage);
                   print(jpg);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Dummy(name: jpg,))
                  );*/
                    /*  await imagecontroller.takePicture(imagepath).then((value)
                    {
                        Fluttertoast.showToast(
                            msg:"sf",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white
                        );
                      });*/

                 /* screenshotController.capture(path: imagepath,pixelRatio: 1.5).then((File image)
                  {
                    //Capture Done
                    setState(() {
                      Fluttertoast.showToast(
                          msg: image.path,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white
                      );
                      Navigator.pop(context,imagepath);
                    });
                  }).catchError((onError) {
                    print(onError);
                  });*/
                }
            ),
          ],
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async
  {
    if (controller != null)
    {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.black,
            textColor: Colors.white
        );
      }
    });


    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        /*Fluttertoast.showToast(
            msg: 'Recording video started',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white
        );*/
      }
    });
  }
  Future<void> _ontakePicture() async {

    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    imagepath = '$_localpath/${currentTime}.jpg';
   await controller.takePicture(imagepath).then((value) {
     /*Fluttertoast.showToast(
         msg: 'Recording video started',
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         backgroundColor: Colors.grey,
         textColor: Colors.white
     );*/
   });
  }

  void _onStopButtonPressed() {
    _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
     // HomeScreen screen = new HomeScreen(data :videoPath);
      Navigator.pop(context,files);
     /* Fluttertoast.showToast(
          msg: 'Video recorded to $videoPath',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white
      );*/
  });
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white
      );

      return null;
    }

    // Do nothing if a recording is on progress
    if (controller.value.isRecordingVideo)
    {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$_localpath/${currentTime}.mp4';

    try {
      await controller.startVideoRecording(filePath);
      videoPath = filePath;
      files.add(new File(videoPath));
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async
  {
    if (!controller.value.isRecordingVideo)
    {
      return null;
    }
    try
    {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e)
  {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white
    );
  }
  Future<String> _findLocalPath() async
  {
    if(Platform.isAndroid)
    {
      return "/storage/emulated/0";
    }
    else
    {
      final directory =  await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }
}

/*class VideoRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoRecorderExample(),
    );
  }
}*/

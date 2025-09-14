import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '/models/model_result.dart';
import '/services/image_classifier.dart';
import '/services/image_utility.dart';

class DemoPage extends ConsumerStatefulWidget {
  const DemoPage({super.key});

  @override
  ConsumerState<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends ConsumerState<DemoPage> {
  File? file;
  ModelResult? result;

  @override
  void initState() {
    ImageUtil.requestImagePermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cassava Disease Detection"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(),
            if (file != null)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  image: DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (result != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10,
                margin: EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Image Results",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _itemRow("Mosaic", result!.mosaic),
                      _itemRow("Blight", result!.blight),
                      _itemRow("Brown Streak", result!.brownStreak),
                      _itemRow("Green Mite", result!.greenMite),
                    ],
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: startDetection,
              child: Text("Start Detection"),
            ),
          ],
        ),
      ),
    );
  }

  double get solution => result?.solution ?? double.infinity;

  Widget _itemRow(String name, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(name),
          Spacer(),
          Text(
            "${value.toStringAsFixed(2)} %",
            style: TextStyle(
              color: value >= solution ? Colors.green[800] : Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  Future startDetection() async {
    file = await ImageUtil.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    ); // show Loader
    final image = await ImageUtil.convertFileToImageData(file!);
    if (image == null) return;
    result = await ref.read(imageClassifier).processImage(file!);
    Navigator.of(context).pop(); // pop Loader
    log(result?.toJson().toString() ?? '');
    setState(() {});
  }
}

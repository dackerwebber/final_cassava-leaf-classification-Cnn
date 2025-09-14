import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/services/image_classifier_http.dart';
import '/ui/providers/model_threshold.dart';
import '/ui/providers/model_type_provider.dart';
import '/ui/widgets/credits_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final modelType = ref.watch(modelTypeProvider);
    final notifier = ref.read(modelTypeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text("Classifier Settings")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Select Model",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Your selection will determine which AI model processes the image",
                      ),
                    ],
                  ),
                ),
                ModelTypeTile(
                  title: "Server model (HTTP)",
                  subtitle: "This option allows your request to be processed "
                      "on a django server running the AI model. This option is slow "
                      "and has a max file size of ${ImageClassifierHttp.maxSizeInMb}MB",
                  isSelected: modelType == ModelType.http,
                  onTap: () => notifier.changeType(ModelType.http),
                ),
                ModelTypeTile(
                  title: "Tensorflow Lite Model V2",
                  subtitle: "This option allows process your image using "
                      "plant_disease_detection_v2.tflite. This model has lower accuracy.",
                  isSelected: modelType == ModelType.version2,
                  onTap: () => notifier.changeType(ModelType.version2),
                ),
                ModelTypeTile(
                  title: "Tensorflow Lite Model V3",
                  subtitle: "This option allows process your image using "
                      "plant_disease_detection_v3.tflite. This model has lower accuracy.",
                  isSelected: modelType == ModelType.version3,
                  onTap: () => notifier.changeType(ModelType.version3),
                ),
                Divider(color: Colors.grey[300]),
                Consumer(
                  builder: (_, ref, __) {
                    final value = ref.watch(modelThresholdProvider);
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Invalid Result Threshold",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Any result below the set threshold is regarded as an invalid result. "
                            "Hence, if all results are below the set threshold, the input is regarded as invalid.",
                          ),
                          const SizedBox(height: 10),
                          Text("Threshold: $value%", style: TextStyle(fontSize: 18),),
                          const SizedBox(height: 16),
                          Slider(
                            value: value.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 10,
                            onChanged: ref
                                .read(modelThresholdProvider.notifier)
                                .changeThreshold,
                            label: "$value%",
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          CreditsWidget(textColor: Colors.black),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ModelTypeTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isSelected;
  const ModelTypeTile({
    super.key,
    this.title,
    this.subtitle,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? "NA"),
      subtitle: subtitle == null ? null : Text(subtitle!),
      onTap: onTap,
      leading: Checkbox(value: isSelected, onChanged: (_) => onTap?.call()),
    );
  }
}

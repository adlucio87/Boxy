import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/models/box_model.dart';

class BoxQrWidget extends StatelessWidget {
  final BoxModel box;

  const BoxQrWidget({super.key, required this.box});

  @override
  Widget build(BuildContext context) {
    // The data encoded in the QR. Could be a deeplink or just the ID.
    // For now, we encode a JSON string or just the ID for simplicity.
    final qrData = 'smartbox://${box.id}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          box.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Location: ${box.location}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
        const SizedBox(height: 16),
        Text(
          'ID: ${box.id}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

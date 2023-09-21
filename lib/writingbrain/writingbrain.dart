import 'dart:convert';
import 'package:google_vision/google_vision.dart';
import 'package:http/http.dart' as http;

class WritingBrain {
  Future<void> extractTextFromImage(String imagepath) async {
    final googleVision = await GoogleVision.withJwt(
        "assets/client_secret_707723557463-oveiv9r8dqtn31046ncppobph8r16e1v.apps.googleusercontent.com.json");

    final painter = Painter.fromFilePath(imagepath);

    final requests = AnnotationRequests(requests: [
      AnnotationRequest(
          image: Image(painter: painter),
          features: [Feature(maxResults: 10, type: 'TEXT_DETECTION')])
    ]);

    print('checking...');

    AnnotatedResponses annotatedResponses =
        await googleVision.annotate(requests: requests);

    print('done.\n');

    for (var annotatedResponse in annotatedResponses.responses) {
      for (var textAnnotation in annotatedResponse.textAnnotations) {
        GoogleVision.drawText(
            painter,
            textAnnotation.boundingPoly!.vertices.first.x + 2,
            textAnnotation.boundingPoly!.vertices.first.y + 2,
            textAnnotation.description);

        GoogleVision.drawAnnotations(
            painter, textAnnotation.boundingPoly!.vertices);
      }
    }

    // await painter.writeAsJpeg('example/debugImage.jpg');
  }
}

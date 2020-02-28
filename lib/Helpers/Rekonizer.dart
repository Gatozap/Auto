import 'package:googleapis/vision/v1.dart';

import 'Credentials.dart';

class RekognizeProvider {
  var _client = CredentialsProvider().client;

  Future search(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
                                                                              "requests": [
                                                                                {
                                                                                  "image": {"content": image},
                                                                                  "features": [
                                                                                    {'type': 'TEXT_DETECTION'}
                                                                                  ]
                                                                                }
                                                                              ]
                                                                            }));
    return _response;
  }
}
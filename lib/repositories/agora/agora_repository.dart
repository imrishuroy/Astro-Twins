import 'package:dio/dio.dart';

import '/repositories/agora/base_agora_repo.dart';

class AgoraRepository extends BaseAgoraRepository {
  @override
  Future<String?> getToken({required String channelName}) async {
    try {
      final dio = Dio();

      final response = await dio.get(
          'https://us-central1-astrotwins-fc3a0.cloudfunctions.net/generateAccessToken',
          queryParameters: {'channelName': channelName});

      if (response.statusCode == 200) {
        return response.data['token'];
      }
    } catch (error) {
      rethrow;
    }
    return null;
  }
}

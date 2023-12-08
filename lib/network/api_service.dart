import 'dart:io';

import 'package:chopper/chopper.dart';

import 'package:on_space/utils/constants.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  // Mining
  @Get(path: '365356d4-53d1-4a33-b144-5f4a5c62a85e')
  Future<Response> getItemLocations();

  static _$ApiService create() {
    final chopperClient = ChopperClient(
      baseUrl: Uri.parse(Constants.apiUrl),
      converter: const JsonConverter(),
      services: [_$ApiService()],
      interceptors: [
        HttpLoggingInterceptor(),
        const HeadersInterceptor({
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.contentTypeHeader: 'application/json',
        }),
      ],
    );

    return _$ApiService(chopperClient);
  }
}

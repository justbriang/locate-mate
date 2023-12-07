import 'dart:io';

import 'package:chopper/chopper.dart';

import 'package:on_space/utils/constants.dart';

part 'api_service.chopper.dart';

@ChopperApi()
abstract class ApiService extends ChopperService {
  // Mining
  @Get(path: 'UCR3')
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

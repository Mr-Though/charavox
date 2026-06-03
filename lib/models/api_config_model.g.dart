// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiConfigImpl _$$ApiConfigImplFromJson(Map<String, dynamic> json) =>
    _$ApiConfigImpl(
      llmBaseUrl: json['llmBaseUrl'] as String,
      llmApiKey: json['llmApiKey'] as String,
      llmModel: json['llmModel'] as String,
      ttsBaseUrl: json['ttsBaseUrl'] as String,
      ttsApiKey: json['ttsApiKey'] as String,
      ttsModel: json['ttsModel'] as String,
    );

Map<String, dynamic> _$$ApiConfigImplToJson(_$ApiConfigImpl instance) =>
    <String, dynamic>{
      'llmBaseUrl': instance.llmBaseUrl,
      'llmApiKey': instance.llmApiKey,
      'llmModel': instance.llmModel,
      'ttsBaseUrl': instance.ttsBaseUrl,
      'ttsApiKey': instance.ttsApiKey,
      'ttsModel': instance.ttsModel,
    };

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter.dart';
import 'package:one_loyalty_data_flutter_example/model/api_response.dart';

part 'mission_state.dart';

class MissionCubit extends Cubit<MissionState> {
  static final _oneLoyaltyDataFlutterPlugin = OneLoyaltyDataFlutter();

  MissionCubit() : super(MissionInitial());

  Future<void> fetchMissions() async {
    emit(MissionLoading());
    try {
      final String jsonString = await _oneLoyaltyDataFlutterPlugin.getListMission() ?? "";
      final List<dynamic> json = jsonDecode(jsonString);
      emit(MissionLoaded(json));
    } on PlatformException catch (e) {
      emit(MissionError('Failed to load missions: $e'));
    }
  }
}

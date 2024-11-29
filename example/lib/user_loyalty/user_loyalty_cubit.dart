import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:one_loyalty_data_flutter/one_loyalty_data_flutter.dart';

part 'user_loyalty_state.dart';

class UserLoyaltyCubit extends Cubit<UserLoyaltyState> {
  static final _oneLoyaltyDataFlutterPlugin = OneLoyaltyDataFlutter();

  UserLoyaltyCubit() : super(UserLoyaltyInitial());

  Future<void> fetchUserLoyalty() async {
    emit(UserLoyaltyLoading());
    try {
      final String jsonString = await _oneLoyaltyDataFlutterPlugin.getUser() ?? "";
      final Map<String, dynamic> json = jsonDecode(jsonString);
      emit(UserLoyaltyLoaded(json));
    } on PlatformException catch (e) {
      emit(UserLoyaltyError('Failed to load missions: $e'));
    }
  }
}

part of 'user_loyalty_cubit.dart';

@immutable
abstract class UserLoyaltyState {}

class UserLoyaltyInitial extends UserLoyaltyState {}
class UserLoyaltyLoading extends UserLoyaltyState {}
class UserLoyaltyLoaded extends UserLoyaltyState {
  final dynamic user;

  UserLoyaltyLoaded(this.user);
}

class UserLoyaltyError extends UserLoyaltyState {
  final String message;

  UserLoyaltyError(this.message);
}

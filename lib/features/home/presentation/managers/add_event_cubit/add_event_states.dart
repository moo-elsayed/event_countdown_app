abstract class AddEventStates {}

class AddEventInitial extends AddEventStates {}

class AddEventLoading extends AddEventStates {}

class AddEventSuccess extends AddEventStates {}

class AddEventFailure extends AddEventStates {
  final String errorMessage;

  AddEventFailure({required this.errorMessage});
}

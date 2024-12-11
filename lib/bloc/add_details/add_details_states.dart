part of 'add_details_bloc.dart';

abstract class AddDetailsStates {}

class AddDetailsInitialState extends AddDetailsStates {}

class AddDetailsLoadingState extends AddDetailsStates {}

class FetchDetailsLoadingState extends AddDetailsStates {}

class FetchDetailsLoadedState extends AddDetailsStates {}

class AddDetailsLoadedState extends AddDetailsStates {}

class AddDetailsErrorState extends AddDetailsStates {
  ErrorModel error;

  AddDetailsErrorState({required this.error});
}

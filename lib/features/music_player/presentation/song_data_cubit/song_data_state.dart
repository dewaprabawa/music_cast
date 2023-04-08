part of 'song_data_cubit.dart';

enum StateStatus { initial, loading, success, failure, empty }
// Private constructor used to create SongDataState instances with default values
class SongDataState extends Equatable {
  const SongDataState._({
    this.stateStatus = StateStatus.initial,
    this.data = const ItuneEntities(results: []),
    this.errorMessage = "",
  });
  
   // Fields for the state of the app
  final StateStatus stateStatus;
  final ItuneEntities data;
  final String errorMessage;
  
 // Named constructor used to create an initial state of the app
  const SongDataState.initial()
      : this._(
          stateStatus: StateStatus.initial,
        );
 // Named constructor used to create a loading state of the app
  const SongDataState.loading()
      : this._(
          stateStatus: StateStatus.loading,
        );

  // Named constructor used to create a success state of the app
  const SongDataState.success(ItuneEntities data)
      : this._(stateStatus: StateStatus.success, data: data);

  // Named constructor used to create an empty state of the app
  const SongDataState.empty()
      : this._(
          errorMessage: "Sorry we could not find your favorite song!",
          data: const ItuneEntities(results: []),
          stateStatus: StateStatus.empty,
        );
 // Named constructor used to create a failure state of the app
  const SongDataState.failure(String message)
      : this._(stateStatus: StateStatus.failure, errorMessage: message);


  @override
  List<Object> get props => [stateStatus, data, errorMessage];
}

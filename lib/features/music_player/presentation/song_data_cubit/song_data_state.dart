part of 'song_data_cubit.dart';

enum StateStatus { initial, loading, success, failure, empty }

class SongDataState extends Equatable {
  const SongDataState._({
    this.stateStatus = StateStatus.initial,
    this.data = const ItuneEntities(results: []),
    this.errorMessage = "",
  });
  
  final StateStatus stateStatus;
  final ItuneEntities data;
  final String errorMessage;
  

  /// data song state
  const SongDataState.initial()
      : this._(
          stateStatus: StateStatus.initial,
        );

  const SongDataState.loading()
      : this._(
          stateStatus: StateStatus.loading,
        );

  const SongDataState.success(ItuneEntities data)
      : this._(stateStatus: StateStatus.success, data: data);

  const SongDataState.empty()
      : this._(
          errorMessage: "Sorry we could not find your favorite song!",
          data: const ItuneEntities(results: []),
          stateStatus: StateStatus.empty,
        );

  const SongDataState.failure(String message)
      : this._(stateStatus: StateStatus.failure, errorMessage: message);


  @override
  List<Object> get props => [stateStatus, data, errorMessage];
}

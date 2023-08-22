enum ErrorType {
  username,
  password,
  creditCard,
}

sealed class ResgitserState {
  const ResgitserState();
  const factory ResgitserState.init() = _RegisterInitState;
  const factory ResgitserState.loading() = _RegisterLoadingState;
  const factory ResgitserState.success() = _RegisterSuccessState;
  const factory ResgitserState.error(ErrorType type, String message) =
      _RegisterErrorState;

  T maybeWhen<T>({
    required T Function() orElse,
    T Function()? init,
    T Function()? success,
    T Function()? loading,
    T Function(ErrorType type, String message)? error,
  }) {
    return switch (this) {
      _RegisterInitState() => init?.call() ?? orElse(),
      _RegisterLoadingState() => loading?.call() ?? orElse(),
      _RegisterSuccessState() => success?.call() ?? orElse(),
      _RegisterErrorState() => error?.call(
            (this as _RegisterErrorState).type,
            (this as _RegisterErrorState).message,
          ) ??
          orElse(),
    };
  }
}

class _RegisterSuccessState extends ResgitserState {
  const _RegisterSuccessState();
}

class _RegisterInitState extends ResgitserState {
  const _RegisterInitState();
}

class _RegisterLoadingState extends ResgitserState {
  const _RegisterLoadingState();
}

class _RegisterErrorState extends ResgitserState {
  final ErrorType type;
  final String message;
  const _RegisterErrorState(this.type, this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _RegisterErrorState &&
        other.type == type &&
        other.message == message;
  }

  @override
  int get hashCode => type.hashCode ^ message.hashCode;
}

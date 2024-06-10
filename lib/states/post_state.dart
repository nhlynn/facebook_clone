class PostState {
  final bool loading;
  final bool isPosted;
  final String? message;

  PostState({
    required this.loading,
    required this.isPosted,
    required this.message,
  });

  PostState.initial({
    this.loading = false,
    this.isPosted = false,
    this.message,
  });

  PostState copyWith({
    bool? loading,
    bool? isPosted,
    String? message,
  }) {
    return PostState(
      loading: loading ?? this.loading,
      isPosted: isPosted ?? this.isPosted,
      message: message ?? this.message,
    );
  }
}

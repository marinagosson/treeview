class DownloadViewModel {
  final bool isLoading;
  final String messageError;
  final bool completed;

  DownloadViewModel(
      {this.isLoading = false, this.messageError = '', this.completed = false});

  factory DownloadViewModel.loading() => DownloadViewModel(isLoading: true);

  factory DownloadViewModel.failure(String message) =>
      DownloadViewModel(isLoading: false, messageError: message);

  factory DownloadViewModel.finish() => DownloadViewModel(completed: true);
}

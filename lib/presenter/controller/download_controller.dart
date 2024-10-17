import 'package:flutter/material.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_all_data_use_case.dart';
import 'package:treeview_tractian/presenter/pages/home_page.dart';
import 'package:treeview_tractian/presenter/view_model/download_view_model.dart';

class DownloadController {
  final FetchAndSaveAllDataUseCase _fetchAllDataUseCase;

  DownloadController({required FetchAndSaveAllDataUseCase fetchAllDataUseCase})
      : _fetchAllDataUseCase = fetchAllDataUseCase;

  ValueNotifier<DownloadViewModel> viewModel =
      ValueNotifier(DownloadViewModel.loading());

  Future<void> startDownload() async {
    viewModel.value = DownloadViewModel.loading();
    final resource = await _fetchAllDataUseCase.call();
    resource.fold((error) {
      viewModel.value = DownloadViewModel.failure(error.message);
    }, (_) {
      viewModel.value = DownloadViewModel.finish();
    });
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}

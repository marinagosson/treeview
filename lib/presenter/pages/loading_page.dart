import 'package:flutter/material.dart';
import 'package:treeview_tractian/infra/di/injection.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_all_data_use_case.dart';
import 'package:treeview_tractian/presenter/controller/download_controller.dart';
import 'package:treeview_tractian/presenter/utils/colors.dart';
import 'package:treeview_tractian/presenter/view_model/download_view_model.dart';
import 'package:treeview_tractian/presenter/widgets/text.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late DownloadController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DownloadController(
        fetchAllDataUseCase: Injection.instance<FetchAndSaveAllDataUseCase>());
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tractian,
      body: ValueListenableBuilder<DownloadViewModel>(
        valueListenable: _controller.viewModel,
        builder: (context, value, child) {
          return value.isLoading
              ? _buildLoading
              : value.messageError.isNotEmpty
                  ? _buildErrorMessage
                  : const SizedBox();
        },
      ),
    );
  }

  Future<void> _loadData() async {
    _controller.startDownload().then((_) {
      if (_controller.viewModel.value.completed) {
        _controller.navigateToHomePage(context);
      }
    });
  }

  get _buildLoading => Center(
        child: CircularProgressIndicator(
          color: AppColors.white,
        ),
      );

  get _buildErrorMessage => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                textAlign: TextAlign.center,
                value: _controller.viewModel.value.messageError
              ).body,
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _loadData();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/infra/di/injection.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_companies_use_case.dart';
import 'package:treeview_tractian/presenter/const/assets.dart';
import 'package:treeview_tractian/presenter/controller/home_controller.dart';
import 'package:treeview_tractian/presenter/view_model/item_company_list_view_model.dart';
import 'package:treeview_tractian/presenter/widgets/image.dart';
import 'package:treeview_tractian/presenter/widgets/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController(
        fetchCompaniesUseCase: Injection.instance<FetchCompaniesUseCase>());
    _loadData();
  }

  void _loadData() {
    _controller.fetchAllCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(asset: Assets.logo).fromAsset(
              width: 127,
              height: 18,
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<
              Resource<List<ItemCompanyListViewModel>>>(
          valueListenable: _controller.itemsList,
          builder: (context, resource, child) {
            if (resource.isSuccess()) {
              return _buildList(resource.data!);
            }
            if (resource.isFailure()) {
              return _buildErrorMessage(resource.error!.message);
            }
            return const SizedBox();
          }),
    );
  }

  Widget _buildErrorMessage(String message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
              ),
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

  _buildList(List<ItemCompanyListViewModel<dynamic>> data) =>
      ListView.separated(
        padding: const EdgeInsets.all(24),
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          final borderRadius = BorderRadius.circular(5);
          return Container(
            height: 76,
            decoration:
                BoxDecoration(color: Colors.blue, borderRadius: borderRadius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _controller.navigateToAssetsPage(context, item.data.id);
                },
                borderRadius: borderRadius,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomImage(asset: Assets.parent).fromAsset(),
                        const SizedBox(
                          width: 16,
                        ),
                        CustomText(value: '${item.text} Unit').tile,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 24,
        ),
        itemCount: data.length,
      );

  get buildLoadingPage => const Center(
        child: CircularProgressIndicator(),
      );
}

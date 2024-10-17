import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_companies_use_case.dart';
import 'package:treeview_tractian/presenter/navigation/navigation.dart';
import 'package:treeview_tractian/presenter/view_model/item_company_list_view_model.dart';

class HomeController {
  String? _errorMessage;
  bool _isLoading = true;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  ValueNotifier<Resource<List<ItemCompanyListViewModel>>> itemsList =
      ValueNotifier(Resource.success(data: []));

  final FetchCompaniesUseCase _fetchCompaniesUseCase;

  HomeController({required FetchCompaniesUseCase fetchCompaniesUseCase})
      : _fetchCompaniesUseCase = fetchCompaniesUseCase;

  void setLoading(bool value) {
    _isLoading = true;
  }

  void navigateToAssetsPage(BuildContext context, String companyId) {
    Navigation.navigateToAssets(context, companyId);
  }

  Future<void> fetchAllCompanies() async {
    _fetchCompaniesUseCase.call().then((result) {
      result.fold((appError) {
        itemsList.value = Resource.failure(appError);
      }, (companies) {
        itemsList.value = Resource.success(
            data: List.from(result.data!)
                .map((element) =>
                    ItemCompanyListViewModel(text: element.name, data: element))
                .toList());
      });
    });
  }

  void _setErrorPage(String? message) {
    if (message != null) setLoadingPage(false);
    _errorMessage = message;
  }

  void setLoadingPage(bool value) {
    if (value) _setErrorPage(null);
    _isLoading = value;
  }
}

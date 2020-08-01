import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SearchProvider extends ChangeNotifier {
  static SearchProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<SearchProvider>(context, listen: listen);

  String _prevSearchTerm = "";
  String _searchTerm = "";

  String get prevSearchTerm => _prevSearchTerm;
  String get searchTerm => _searchTerm;

  set searchTerm(String newValue) {
    _searchTerm = newValue;
    notifyListeners();
  }

  set prevSearchTerm(String newValue) {
    _prevSearchTerm = newValue;
  }
}

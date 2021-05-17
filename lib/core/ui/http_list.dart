import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/core/services/toast_service.dart';
import 'package:meowoof/core/ui/alerts/button_alert.dart';
import 'package:meowoof/core/ui/checkbox.dart';
import 'package:meowoof/core/ui/load_more.dart';
import 'package:meowoof/core/ui/progress_indicator.dart';
import 'package:meowoof/core/ui/search_bar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/theme/button.dart';
import 'package:meowoof/theme/icon.dart';

class OBHttpList<T> extends StatefulWidget {
  final OBHttpListItemBuilder<T> listItemBuilder;
  final OBHttpListItemBuilder<T>? selectedListItemBuilder;
  final OBHttpListItemBuilder<T> searchResultListItemBuilder;
  final OBHttpListSearcher<T> listSearcher;
  final OBHttpListRefresher<T> listRefresher;
  final OBHttpListOnScrollLoader<T> listOnScrollLoader;
  final OBHttpListController? controller;
  final String resourceSingularName;
  final String resourcePluralName;
  final EdgeInsets padding;
  final IndexedWidgetBuilder? separatorBuilder;
  final ScrollPhysics physics;
  final List<Widget>? prependedItems;
  final OBHttpListSecondaryRefresher? secondaryRefresher;
  final OBHttpListSelectionChangedListener<T>? onSelectionChanged;
  final OBHttpListSelectionChangedListener<T>? onSelectionSubmitted;
  final OBHttpListSelectionSubmitter<T>? selectionSubmitter;
  final bool hasSearchBar;
  final bool isSelectable;
  final Widget? filter;
  final bool shrinkWrap;
  final bool searchWidget;
  final EdgeInsets? searchbarPadding;

  const OBHttpList(
      {Key? key,
      required this.listItemBuilder,
      required this.listRefresher,
      required this.listOnScrollLoader,
      required this.resourceSingularName,
      required this.resourcePluralName,
      required this.searchResultListItemBuilder,
      required this.listSearcher,
      this.physics = const ClampingScrollPhysics(),
      this.padding = const EdgeInsets.all(0),
      this.controller,
      this.separatorBuilder,
      this.prependedItems,
      this.hasSearchBar = true,
      this.secondaryRefresher,
      this.isSelectable = false,
      this.onSelectionChanged,
      this.onSelectionSubmitted,
      this.selectionSubmitter,
      this.selectedListItemBuilder,
      this.filter,
      this.shrinkWrap = false,
      this.searchWidget = false,
      this.searchbarPadding})
      : super(key: key);

  @override
  OBHttpListState createState() {
    return OBHttpListState<T>();
  }
}

class OBHttpListState<T> extends State<OBHttpList<T>> {
  late ToastService _toastService;

  final GlobalKey<RefreshIndicatorState> _listRefreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late ScrollController _listScrollController;
  List<T> _list = [];
  List<T> _listSearchResults = [];
  List<T> _listSelection = [];
  late List<Widget> _prependedItems;

  late bool _hasSearch;
  late String _searchQuery;
  late bool _needsBootstrap;
  late bool _refreshInProgress;
  late bool _searchRequestInProgress;
  late bool _selectionSubmissionInProgress;
  late bool _loadingFinished;
  late bool _wasBootstrapped;

  CancelableOperation? _searchOperation;
  CancelableOperation? _refreshOperation;
  CancelableOperation? _loadMoreOperation;
  CancelableOperation? _submitSelectionOperation;

  ScrollPhysics noItemsPhysics = const AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    _listScrollController = ScrollController();
    _loadingFinished = false;
    _needsBootstrap = true;
    _refreshInProgress = false;
    _wasBootstrapped = false;
    _searchRequestInProgress = false;
    _selectionSubmissionInProgress = false;
    _hasSearch = false;
    _list = [];
    _searchQuery = '';
    _prependedItems = widget.prependedItems?.toList() ?? [];
  }

  void insertListItem(T listItem, {bool shouldScrollToTop = true, bool shouldRefresh = false}) {
    _list.insert(0, listItem);
    _setList(_list.toList());
    if (shouldScrollToTop) scrollToTop(shouldRefresh: shouldRefresh);
  }

  void removeListItem(T listItem) {
    setState(() {
      _list.remove(listItem);
      _listSearchResults.remove(listItem);
    });
  }

  void scrollToTop({bool shouldRefresh = true}) {
    if (_listScrollController.hasClients) {
      if (_listScrollController.offset == 0 && shouldRefresh) {
        _refreshWithRefreshIndicator();
      }

      _listScrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchOperation?.cancel();
    _loadMoreOperation?.cancel();
    _refreshOperation?.cancel();
    _submitSelectionOperation?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      _toastService = injector<ToastService>();
      _bootstrap();
      _needsBootstrap = false;
    }

    List<Widget> columnItems = [];

    if (widget.listSearcher != null && widget.hasSearchBar) {
      columnItems.add(
        Padding(
          padding: widget.searchbarPadding ?? EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            child: MWSearchBar(
              searchWidget: widget.searchWidget,
              onSearch: _onSearch,
              hintText: 'Search...',
              action: widget.filter ?? const SizedBox(height: 0, width: 0),
            ),
          ),
        ),
      );
    }

    Widget listItems = _hasSearch ? _buildSearchResultsList() : _buildList();

    if (widget.isSelectable) {
      listItems = IgnorePointer(
        ignoring: _selectionSubmissionInProgress,
        child: listItems,
      );
    }
    if (widget.searchWidget) {
      columnItems.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Unkown',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    }

    columnItems.add(Expanded(
      child: listItems,
    ));

    if (widget.isSelectable) {
      columnItems.add(_buildSelectionActionButtons());
    }

    return Column(
      children: columnItems,
    );
  }

  Widget _buildSelectionActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: MWButton(
                size: MWButtonSize.large,
                onPressed: _onClearSelection,
                isDisabled: _listSelection.isEmpty,
                child: const Text('Clean all'),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: MWButton(
                size: MWButtonSize.large,
                isLoading: _selectionSubmissionInProgress,
                isDisabled: _selectionSubmissionInProgress,
                onPressed: _onSubmitSelection,
                child: const Text('Unknow'),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget _buildSearchResultsList() {
    int listItemCount = _listSearchResults.length + 1;

    ScrollPhysics physics = listItemCount > 0 ? widget.physics : noItemsPhysics;

    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        // Hide keyboard
        FocusScope.of(context).requestFocus(FocusNode());
        return true;
      },
      child: widget.separatorBuilder != null
          ? ListView.separated(
              separatorBuilder: widget.separatorBuilder!,
              padding: widget.padding,
              physics: physics,
              itemCount: listItemCount,
              itemBuilder: _buildSearchResultsListItem)
          : ListView.builder(padding: widget.padding, physics: physics, itemCount: listItemCount, itemBuilder: _buildSearchResultsListItem),
    );
  }

  Widget _buildSearchResultsListItem(BuildContext context, int index) {
    if (index == _listSearchResults.length) {
      final String searchQuery = _searchQuery;

      if (_searchRequestInProgress) {
        // Search in progress
        return ListTile(leading: const MWProgressIndicator(), title: Text(searchQuery));
      } else if (_listSearchResults.isEmpty) {
        // Results were empty
        return ListTile(leading: const MWIcon(MWIcons.sad), title: Text('No result for: $searchQuery'));
      } else {
        return const SizedBox();
      }
    }

    final T listItem = _listSearchResults[index];

    final Widget listItemWidget = widget.searchResultListItemBuilder(context, listItem);

    if (!widget.isSelectable) return listItemWidget;

    return _wrapSelectableListItemWidget(listItem, listItemWidget);
  }

  Widget _buildList() {
    return RefreshIndicator(
      key: _listRefreshIndicatorKey,
      onRefresh: _refreshList,
      child: (!_refreshInProgress && _wasBootstrapped && _list.isEmpty)
          ? _buildNoList()
          : LoadMore(
              whenEmptyLoad: false,
              isFinish: _loadingFinished,
              delegate: const OBHttpListLoadMoreDelegate(),
              onLoadMore: _loadMoreListItems,
              child: widget.separatorBuilder != null
                  ? ListView.separated(
                      separatorBuilder: widget.separatorBuilder!,
                      controller: _listScrollController,
                      physics: widget.physics,
                      padding: widget.padding,
                      itemCount: _list.length + _prependedItems.length,
                      itemBuilder: _buildListItem)
                  : ListView.builder(
                      controller: _listScrollController,
                      physics: widget.physics,
                      padding: widget.padding,
                      itemCount: _list.length + _prependedItems.length,
                      itemBuilder: _buildListItem),
            ),
    );
  }

  Widget _buildNoList() {
    List<Widget> items = [];

    if (widget.prependedItems != null && widget.prependedItems!.isNotEmpty) {
      items.addAll(widget.prependedItems!);
    }

    items.add(Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MWButtonAlert(
          text: 'No result found for: ${widget.resourcePluralName.toLowerCase()}',
          onPressed: _refreshList,
          buttonText: 'Refresh',
          buttonIcon: MWIcons.refresh,
        )
      ],
    ));

    return ListView(
      controller: _listScrollController,
      physics: widget.physics,
      padding: widget.padding,
      children: items,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    int itemsIndex = index;

    if (_prependedItems.isNotEmpty && index < _prependedItems.length) {
      return _prependedItems[index];
    }

    itemsIndex = index - _prependedItems.length;

    final T listItem = _list[itemsIndex];

    Widget listItemWidget = widget.listItemBuilder(context, listItem);

    if (widget.isSelectable) {
      listItemWidget = _wrapSelectableListItemWidget(listItem, listItemWidget);
    }

    return listItemWidget;
  }

  String _makeSelectedItemsCount() {
    if (_listSelection.isEmpty) return '';

    return ' (${_listSelection.length})';
  }

  Widget _wrapSelectableListItemWidget(T listItem, Widget listItemWidget) {
    return SizedBox(
        child: GestureDetector(
      onTap: () => _onWantsToToggleSelection(listItem),
      child: Row(
        children: <Widget>[
          Expanded(
            child: listItemWidget,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: MWCheckbox(
              value: _listSelection.contains(listItem),
            ),
          )
        ],
      ),
    ));
  }

  Future _bootstrap() async {
    await _refreshWithRefreshIndicator();
    setState(() {
      _wasBootstrapped = true;
    });
  }

  Future<void> _refreshList() async {
    await _refreshOperation?.cancel();
    _setLoadingFinished(false);
    _setRefreshInProgress(true);
    try {
      final List<Future<dynamic>> refreshFutures = [widget.listRefresher()];

      if (widget.secondaryRefresher != null) {
        refreshFutures.add(widget.secondaryRefresher!());
      }

      _refreshOperation = CancelableOperation.fromFuture(Future.wait(refreshFutures));
      final results = await _refreshOperation!.value;
      final List<T> list = results[0] as List<T>;
      _setList(list);
    } catch (error) {
      await _onError(error);
    } finally {
      _setRefreshInProgress(false);
      _refreshOperation = null;
    }
  }

  Future refreshList({bool shouldScrollToTop = false, bool shouldUseRefreshIndicator = false}) async {
    await (shouldUseRefreshIndicator ? _refreshWithRefreshIndicator() : _refreshList());
    if (shouldScrollToTop && _listScrollController.hasClients && _listScrollController.offset != 0) {
      scrollToTop();
    }
  }

  Future _refreshWithRefreshIndicator() async {
    // Deactivate if active
    _listRefreshIndicatorKey.currentState?.deactivate();

    // Activate
    await _listRefreshIndicatorKey.currentState?.show();
  }

  Future<bool> _loadMoreListItems() async {
    if (_refreshOperation != null) return true;
    if (_loadMoreOperation != null) return true;
    if (_list.isEmpty) return true;
    debugPrint('Loading more list items');

    try {
      _loadMoreOperation = CancelableOperation.fromFuture(widget.listOnScrollLoader(_list));
      final loadMoreOperation = _loadMoreOperation;
      final List<T> moreListItems = await loadMoreOperation!.value as List<T>;

      if (moreListItems.isEmpty) {
        _setLoadingFinished(true);
      } else {
        _addListItems(moreListItems);
      }
      return true;
    } catch (error) {
      await _onError(error);
    } finally {
      _loadMoreOperation = null;
    }

    return false;
  }

  Future _onSearch(String query) {
    _setSearchQuery(query);
    if (query.isEmpty) {
      _setHasSearch(false);
      return Future.value();
    } else {
      _setHasSearch(true);
      return _searchWithQuery(query);
    }
  }

  Future _searchWithQuery(String query) async {
    await _searchOperation?.cancel();
    _setSearchRequestInProgress(true);

    try {
      _searchOperation = CancelableOperation.fromFuture(widget.listSearcher(_searchQuery));

      final List<T> listSearchResults = await _searchOperation!.value as List<T>;
      _setListSearchResults(listSearchResults);
    } catch (error) {
      await _onError(error);
    } finally {
      _setSearchRequestInProgress(false);
      _searchOperation = null;
    }
  }

  void _onClearSelection() {
    _clearSelection();
  }

  Future _onSubmitSelection() async {
    await _submitSelectionOperation?.cancel();

    _setSelectionSubmissionInProgress(true);

    try {
      _submitSelectionOperation = CancelableOperation.fromFuture(widget.selectionSubmitter!(_listSelection));
      widget.onSelectionSubmitted!(_listSelection);
    } catch (error) {
      await _onError(error);
    } finally {
      _setSelectionSubmissionInProgress(false);
      _submitSelectionOperation = null;
    }
  }

  void _onWantsToToggleSelection(T listItem) {
    if (_listSelection.contains(listItem)) {
      _unselectItem(listItem);
    } else {
      _selectItem(listItem);
    }

    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(_listSelection.toList());
    }
  }

  void _resetListSearchResults() {
    _setListSearchResults(_list.toList());
  }

  void _setListSearchResults(List<T> listSearchResults) {
    setState(() {
      _listSearchResults = listSearchResults;
    });
  }

  void _setLoadingFinished(bool loadingFinished) {
    setState(() {
      _loadingFinished = loadingFinished;
    });
  }

  void _setList(List<T> list) {
    setState(() {
      _list = list;
      _resetListSearchResults();
    });
  }

  void _addListItems(List<T> items) {
    setState(() {
      _list.addAll(items);
    });
  }

  void _setSearchQuery(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }

  void _setHasSearch(bool hasSearch) {
    setState(() {
      _hasSearch = hasSearch;
    });
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  void _setSearchRequestInProgress(bool searchRequestInProgress) {
    setState(() {
      _searchRequestInProgress = searchRequestInProgress;
    });
  }

  void _selectItem(T item) {
    setState(() {
      _listSelection.add(item);
    });
  }

  void _unselectItem(T item) {
    setState(() {
      _listSelection.remove(item);
    });
  }

  void _clearSelection() {
    setState(() {
      _listSelection = [];
    });
  }

  void _setSelectionSubmissionInProgress(bool selectionSubmissionInProgress) {
    setState(() {
      _selectionSubmissionInProgress = selectionSubmissionInProgress;
    });
  }

  Future _onError(error) async {}
}

class OBHttpListController<T> {
  OBHttpListState? _state;

  Future<void> attach(OBHttpListState state) async {
    _state = state;
  }

  void insertListItem(T listItem, {bool shouldScrollToTop = true, bool shouldRefresh = false}) {
    if (!_isMounted()) {
      debugPrint('Tried to insertListItem in unattached OBHttpList');
      return;
    }
    _state!.insertListItem(listItem, shouldScrollToTop: shouldScrollToTop, shouldRefresh: shouldRefresh);
  }

  void removeListItem(T listItem) {
    if (!_isMounted()) return;
    _state!.removeListItem(listItem);
  }

  void scrollToTop() {
    if (!_isMounted()) return;
    _state!.scrollToTop();
  }

  Future refresh({bool shouldScrollToTop = false, bool shouldUseRefreshIndicator = false}) async {
    if (!_isMounted()) return;
    await _state!.refreshList(shouldScrollToTop: shouldScrollToTop, shouldUseRefreshIndicator: shouldUseRefreshIndicator);
  }

  Future search(String query) {
    return _state!._onSearch(query);
  }

  Future clearSearch() {
    return _state!._onSearch('');
  }

  bool hasItems() {
    return _state!._list.isNotEmpty;
  }

  T firstItem() {
    return _state!._list.first as T;
  }

  bool _isMounted() {
    return _state != null && _state!.mounted;
  }
}

typedef OBHttpListItemBuilder<T> = Widget Function(BuildContext context, T listItem);
typedef OBHttpListSearcher<T> = Future<List<T>> Function(String searchQuery);
typedef OBHttpListRefresher<T> = Future<List<T>> Function();
typedef OBHttpListSecondaryRefresher<T> = Future Function();
typedef OBHttpListOnScrollLoader<T> = Future<List<T>> Function(List<T> currentList);
typedef OBHttpListSelectionChangedListener<T> = void Function(List<T> selectionItems);
typedef OBHttpListSelectionSubmittedListener<T> = void Function(List<T> selectionItems);
typedef OBHttpListSelectionSubmitter<T> = Future Function(List<T> selectionItems);

class OBHttpListLoadMoreDelegate extends LoadMoreDelegate {
  const OBHttpListLoadMoreDelegate();

  @override
  Widget buildChild(LoadMoreStatus status, {LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.chinese}) {
    if (status == LoadMoreStatus.fail) {
      return SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const MWIcon(MWIcons.refresh),
            SizedBox(
              width: 10.w,
            ),
            const Text('Retry')
          ],
        ),
      );
    }
    if (status == LoadMoreStatus.loading) {
      return const SizedBox(
        child: Center(
          child: MWProgressIndicator(),
        ),
      );
    }
    return const SizedBox();
  }
}

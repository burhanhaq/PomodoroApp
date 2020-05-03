import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_app/shared_pref.dart';

import 'models/card_model.dart';
import 'widgets/card_tile.dart';
import 'screens/second_screen.dart';
import 'screen_navigation/second_screen_navigation.dart';

class CardState with ChangeNotifier {
  resetNewVariables() {
    _newTitle = '';
    _newGoal = '10';
    _newMinutes = '30';
    _newSeconds = '03';
    notifyListeners();
  }

//  SharedPref sharedPrefCS = SharedPref(); // todo implement this maybe to speed things up

  List<CardModel> get cardModels => CardModel.cardModelsX;

  // HOME PAGE 88888888888888888888888888
  int _pageScore;
  int _pageGoal;
  int _selectedIndex;
  bool _addNewScreen = false;
  int _confirmDeleteIndex = -1;
  String _newTitle;
  String _newGoal;
  String _newMinutes;
  String _newSeconds;
  bool _tappedEmptyAreaUnderListView = false;

//  bool _isClearTitleTextEditingController = false;

  int get firstPageScore => _pageScore;

  int get firstPageGoal => _pageGoal;

  int get selectedIndex => _selectedIndex;

  bool get onAddNewScreen => _addNewScreen;

  int get confirmDeleteIndex => _confirmDeleteIndex;

  String get newTitle => _newTitle;

  String get newGoal => _newGoal;

  String get newMinutes => _newMinutes;

  String get newSeconds => _newSeconds;

//  bool get isClearTitleTextEditingController =>
//      _isClearTitleTextEditingController;

  bool get tappedEmptyAreaUnderListView => _tappedEmptyAreaUnderListView;

  set selectTile(CardModel model) {
    int i = cardModels.indexOf(model);
    _confirmDeleteIndex = -1;

    if (model == null) {
      _pageGoal = null;
      _pageScore = null;
      _selectedIndex = null;
      for (int j = 0; j < cardModels.length; j++) {
        cardModels[j].selected = false;
      }
    } else {
      _selectedIndex = i;
      _pageGoal = cardModels[i].goal;
      _pageScore = cardModels[i].score;
      for (int j = 0; j < cardModels.length; j++) {
        cardModels[j].selected = false;
      }
      cardModels[i].selected = true;
    }
    notifyListeners();
  }

  set onAddNewScreen(bool val) {
    _addNewScreen = val;
    notifyListeners();
  }

  set confirmDeleteIndex(int val) {
    _confirmDeleteIndex = val;
    notifyListeners();
  }

  set newTitle(String val) {
    _newTitle = val;
    notifyListeners();
  }

  set newGoal(String val) {
    _newGoal = val;
    notifyListeners();
  }

  set newMinutes(String val) {
    _newMinutes = val;
    notifyListeners();
  }

  set newSeconds(String val) {
    _newSeconds = val;
    notifyListeners();
  }

  set tappedEmptyAreaUnderListView(bool val) {
    _tappedEmptyAreaUnderListView = val;
    // don't add notifyListeners()
  }

  void onTapEmptyAreaUnderListView() {
    selectTile = null;
    closeHomeRightBar();
    tappedEmptyAreaUnderListView = true;
  }

  void onTapCardTile(var widget, var context) {
    closeHomeRightBar();
    if (widget.cardModel.selected) {
      // tapped second time
      Navigator.push(
        context,
        SecondScreenNavigation(
          widget: SecondScreen(cardTile: widget),
        ),
      );
    }
    selectTile = widget.cardModel;
  }

  void onHorizontalDragUpdateCardTile(var details, var widget, var context, var cardScreenController) {
    if (details.primaryDelta < 0) {
      selectTile = widget.cardModel;
      closeHomeRightBar();
      cardScreenController.forward(from: 0.0);
      Navigator.push(
        context,
        SecondScreenNavigation(
          widget: SecondScreen(cardTile: widget),
        ),
      );
    }
  }

//  set isClearTitleTextEditingController(bool val) { // todo implement this
//    _isClearTitleTextEditingController = val;
//    notifyListeners();
//  }

  // RIGHT BAR 8888888888888888888888888888888888888888888888888888888888888
  bool _homeRightBarOpen = false;

  bool get homeRightBarOpen => _homeRightBarOpen;

  openHomeRightBar() {
    _homeRightBarOpen = true;
    notifyListeners();
  }

  closeHomeRightBar() {
    _homeRightBarOpen = false;
    notifyListeners();
  }

  onTapAddRightBar(var addNewIconController, var cancelIconScaleController) {
    if (!onAddNewScreen) {
      cancelIconScaleController.forward();
      onAddNewScreen = true;
      closeHomeRightBar();
      selectTile = null;
      addNewIconController.forward();
    }
  }

  onTapCancelRightBar(var addNewIconController, var cancelIconScaleController) {
    addNewIconController.reverse();
    cancelIconScaleController.reverse();
    if (onAddNewScreen) {
      resetNewVariables();
      onAddNewScreen = !onAddNewScreen;
    }
  }

  onTapDeleteRightBar() async {
    if (confirmDeleteIndex == selectedIndex) {
      // second tap
      String titleToDelete = cardModels[selectedIndex].title;
      sharedPref.remove(titleToDelete);
//      await DatabaseHelper.instance.deleteRecord(titleToDelete, date);
      CardModel.cardModelsX.removeAt(selectedIndex);
      selectTile = null;
    } else {
      // first tap for confirmation
      confirmDeleteIndex = selectedIndex;
    }
  }

  onTapDeleteAllRightBar() {
    sharedPref.removeAll();
    clearCardModelsList();
  }

  bool canAddItem() {
    var keys = [];
    CardModel.cardModelsX.forEach((element) {
      keys.add(element.title.toLowerCase());
    });
    return onAddNewScreen &&
        newTitle.isNotEmpty &&
        !keys.contains(newTitle.toLowerCase());
  }

  onTapCheckBoxRightBar(var cardTileList, var addNewIconController,
      var cancelIconScaleController) {
    bool canAddNewItem = canAddItem();
    if (canAddNewItem) {
      addNewIconController.reverse();
      cancelIconScaleController.reverse();
      addToCardModelsList(
        CardModel(
          title: newTitle,
          score: 0,
          goal: int.tryParse(newGoal) == null ? '777' : int.tryParse(newGoal),
          minutes: int.parse(newMinutes),
          seconds: int.parse(newSeconds),
        ),
      );
      cardTileList.add(CardTile(cardModel: cardModels[cardModels.length - 1]));
      onAddNewScreen = false;
      sharedPref.save(newTitle, cardModels[cardModels.length - 1].toJson());
      resetNewVariables();
    } else {
      // todo play cant add animation maybe
      print('can not add');
    }
  }

  void onTapRightBar() {
    if (homeRightBarOpen) {
      closeHomeRightBar();
    } else {
      openHomeRightBar();
    }
  }

  void onHorizontalDragUpdateRightBar(var details) {
    if (details.delta.dx < 0) {
      openHomeRightBar();
    } else {
      closeHomeRightBar();
    }
  }

  // CARD TILE 8888888888888888888888888888888888888888888888888888888888888888

  void onTapAddScore(CardModel cardModel) {
    addScore(cardModel);
    sharedPref.save(cardModel.title, cardModel.toJson());
    _pageScore = cardModel.score;
    notifyListeners();
  }

  void onTapSubtractScore(CardModel cardModel) {
    subtractScore(cardModel);
    sharedPref.save(cardModel.title, cardModel.toJson());
    _pageScore = cardModel.score;
    notifyListeners();
  }

  // SECOND SCREEN 8888888888888888888888888888888888888888888888888888888888888
  void onTapReplaySecond(var timerDurationController,
      var playPauseIconController, var replayIconRotationController) {
    timerDurationController.value = 0.0;
    playPauseIconController.reverse();
    replayIconRotationController.reverse(from: 1.0);
  }

  void onTapPlaySecond(
      var playPauseIconController, var timerDurationController) {
    if (playPauseIconController.status == AnimationStatus.dismissed) {
      // play pressed
      timerDurationController.forward();
      playPauseIconController.forward();
    } else {
      // pause pressed
      timerDurationController.stop();
      playPauseIconController.reverse();
    }
  }

  // RANDOM

  clearCardModelsList() {
    cardModels.clear();
    notifyListeners();
  }

  void subtractScore(CardModel model) {
    int i = cardModels.indexOf(model);
    if (cardModels[i].score > 0) --cardModels[i].score;
  }

  void addScore(CardModel model) async {
    int i = cardModels.indexOf(model);
    ++cardModels[i].score;
  }

  addToCardModelsList(CardModel model) {
    cardModels.add(model);
    notifyListeners();
  }
}

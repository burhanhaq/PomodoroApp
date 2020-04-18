import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/clock.dart';
import '../card_state.dart';
import '../widgets/card_tile.dart';
import '../shared_pref.dart';
import '../models/card_model.dart';
import '../widgets/boxes_digital_clock.dart';

class SecondScreen extends StatefulWidget {
  static final id = 'SecondScreen';
  final CardTile cardTile;

  SecondScreen({@required this.cardTile});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
  SharedPref sharedPref = SharedPref();
  var timerController;

  var playPauseIconController;
  var playPauseIconAnimation;

  String prefTitle;
  int prefScore;
  int prefGoal;

  loadSharedPrefs() async {
    try {
      CardModel model = CardModel.fromJson(
          await sharedPref.read(widget.cardTile.cardModel.title));
      setState(() {
        prefTitle = model.title;
        prefScore = model.score;
        prefGoal = model.goal;
      });
    } catch (Exception) {
      print('Exception in SecondScreen');
    }
  }

  @override
  void initState() {
    super.initState();
    timerController = AnimationController(
      vsync: this,
      duration: Duration(
        minutes: widget.cardTile.cardModel.minutes,
        seconds: widget.cardTile.cardModel.seconds,
      ),
    );

    playPauseIconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    playPauseIconAnimation = CurvedAnimation(
      curve: Curves.bounceIn,
      parent: playPauseIconController,
    );
  }

  @override
  Widget build(BuildContext context) {
    loadSharedPrefs();
    int index = widget.cardTile.cardModel.index;
    bool timerRunning = timerController.isAnimating;
    var safeAreaPadding = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => CardState(),
        child: Consumer<CardState>(
          builder: (context, cardState, _) => Container(
            color: grey,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: MediaQuery.of(context).size.height *
                            (timerRunning ? 0.2 : 0.5) ,
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: timerRunning ? Color(0xff6A5920) : Color(0xffF7CE47),
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                prefScore == null ? '-3' : prefScore.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Container(height: 5, width: 65, color: white),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                prefGoal == null ? '-3' : prefGoal.toString(),
                                style: TextStyle(
                                  color: white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          height: MediaQuery.of(context).size.height *
                              (timerRunning ? 0.2 : 0.5) *
                              widget.cardTile.cardModel.score.toDouble() / widget.cardTile.cardModel.goal.toDouble(),
                          width: MediaQuery.of(context).size.width * 0.2,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    color: timerRunning ? Color(0xff6E2929) : red1,
                    width: MediaQuery.of(context).size.width *
                        (timerRunning ? 0.7 : 0.8),
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Alex',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'IndieFlower',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width *
                        (timerRunning ? 0.7 : 0.8),
                    color: timerRunning ? Color(0xff6E2929) : red1,
                    child: Center(
                      child: Text(
                        prefTitle == null ? 'null' : prefTitle.toUpperCase(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
//                      textAlign: TextAlign.end,
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    color: timerRunning ? Color(0xff6A5920) : Color(0xffF7CE47),
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height *
                        (timerRunning ? 0.5 : 0.7658),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                cardState.subtract(index);
                                sharedPref.save(widget.cardTile.cardModel.title,
                                    cardState.at(index).toJson());
                              },
                              child: Icon(
                                Icons.remove,
                                size: 40,
                                color: grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                cardState.add(index);
                                sharedPref.save(widget.cardTile.cardModel.title,
                                    cardState.at(index).toJson());
                              },
                              child: Icon(
                                Icons.add,
                                size: 40,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                        Material(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                              color: timerRunning ? Color(0xff6A5920) : Color(0xffF7CE47),
                              border: Border.all(width: 0,
                              color: timerRunning ? Color(0xff6A5920) : Color(0xffF7CE47),),
                            ),
                            child: Column(
                              children: [
                                IconButton(
                                  // todo: program it to be disabled if at 0 I guess
                                  icon: Icon(Icons.replay),
                                  iconSize: 60,
                                  color: timerRunning ? red2 : grey,
                                  onPressed: () {
                                    print('Stop pressed');
                                    timerController.value = 0.0;
                                    playPauseIconController.reverse();
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (playPauseIconController.status ==
                                        AnimationStatus.dismissed) {
                                      print('Play pressed');
                                      timerController.forward();
                                      playPauseIconController.forward();
                                    } else {
                                      print('Pause pressed');
                                      timerController.stop();
                                      playPauseIconController.reverse();
                                    }
                                  },
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: playPauseIconAnimation,
                                    size: 60,
                                    color: timerRunning ? red2 : grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Icon(
                          Icons.settings,
                          size: 40,
                          color: grey,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.222,
                  child: Transform.scale(
                    scale: timerRunning ? 1 : 0.5,
                    child: BoxesDigitalClock(
                      // todo show it increase when page opens
                      min: widget.cardTile.cardModel.minutes,
                      sec: widget.cardTile.cardModel.seconds,
                      timerController: timerController,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timerController.dispose();
    super.dispose();
  }
}

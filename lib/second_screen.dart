import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'clock.dart';
import 'card_state.dart';

class SecondScreen extends StatefulWidget {
  static final id = 'SecondScreen';
  int index;
  String title;
  int score;
  int goal;
  Duration duration;
  bool selected;

  SecondScreen({
    @required this.index,
    @required this.title,
    @required this.score,
    @required this.goal,
    @required this.duration,
    @required this.selected,
  });

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    print('inside build: ${widget.score}');
    return ChangeNotifierProvider(
      create: (context) => CardState(),
      child: Consumer<CardState>(
        builder: (context, cardState, _) => Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(color: grey),
                    Container(
                      decoration: BoxDecoration(
                        color: red1,
                        borderRadius: BorderRadius.only(
//                    topRight: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              widget.title.toUpperCase(),
                              textAlign: TextAlign.end,
                              maxLines: 2,
                              style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 35,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Expanded(child: Container()),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                color: red3,
                                shape: BoxShape.circle,
                              ),
                              child: Clock(duration: widget.duration),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 40,
                                  color: yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: grey,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            cardState.at(widget.index).score.toString() ?? 'x',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Container(height: 10, width: 80, color: white),
                          Text(
                            cardState.at(widget.index).goal.toString() ?? 'y',
                            style: TextStyle(
                              color: white,
                              fontSize: 50,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
//                Expanded(child: Container()),
                      Material(
                        child: Container(
                          decoration: BoxDecoration(
                            color: grey,
                            border: Border.all(
                              color: yellow,
                              width: 4,
                            ),
                          ),
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.stop),
                                iconSize: 60,
                                color: red1,
                                onPressed: () {
                                  print('Stop pressed');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.pause),
                                iconSize: 60,
                                color: red1,
                                onPressed: () {
                                  print('Pause pressed');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                iconSize: 60,
                                color: red1,
                                onPressed: () {
                                  print('Play pressed');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
//                SizedBox(height: 30),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (widget.score > 0) --widget.score;
                                });
                              },
                              child: GestureDetector(
                                onTap: () {
                                  cardState.subtract(widget.index);
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 40,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  cardState.add(widget.index);
                                  ++widget.score;
                                  print('under add icon: ${cardState.at(widget.index).score}');
                                });
                              },
                              child: Icon(
                                Icons.add,
                                size: 40,
                                color: white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

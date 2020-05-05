import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../card_state.dart';
import '../../../models/card_model.dart';

class DisplayChartItem extends StatefulWidget {
  final CardModel cardModel;
  final DisplayChartItemType chartItemType;

  DisplayChartItem({@required this.cardModel, @required this.chartItemType});

  @override
  _DisplayChartItemState createState() => _DisplayChartItemState();
}

class _DisplayChartItemState extends State<DisplayChartItem>
    with TickerProviderStateMixin {
  var sizeTransitionController;

  @override
  void initState() {
    super.initState();
    sizeTransitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    sizeTransitionController.forward();
  }

  @override
  Widget build(BuildContext context) {
    CardState cardState = Provider.of<CardState>(context);
    var sectionWidth =
        MediaQuery.of(context).size.width * (kGreyAreaMul - 0.02);
    var sectionHeight = MediaQuery.of(context).size.height;
    var barLength = sectionWidth * 0.4;
    var coloredBarLength = sectionWidth * 0.4;
    double barEndCircleSize = 5;
    Color barEndCircleColor = grey;
    switch (widget.chartItemType) {
      case DisplayChartItemType.MaxScore:
        var maxScore = 0;
        cardState.cardModels.forEach((element) {
          if (element.score > maxScore) maxScore = element.score;
        });
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else {
          coloredBarLength *= widget.cardModel.score / maxScore;
        }
        if (maxScore == widget.cardModel.score) {
          barEndCircleSize = 10;
          barEndCircleColor = yellow;
        }
        break;
      case DisplayChartItemType.ScoreOverGoal:
        if (widget.cardModel.score == 0) {
          coloredBarLength = 0.0;
        } else if (widget.cardModel.score > widget.cardModel.goal) {
          // do nothing
        } else {
          coloredBarLength *= widget.cardModel.score / widget.cardModel.goal;
        }
        if (widget.cardModel.score / widget.cardModel.goal >= 1) {
          barEndCircleSize = 10;
          barEndCircleColor = yellow;
        }
        break;
    }
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: sectionWidth * 0.3,
            height: sectionHeight * 0.05,
            child: Text(widget.cardModel.title,
                textAlign: TextAlign.end,
                maxLines: 1,
                style: kMonthsTextStyle.copyWith(fontSize: 20)),
          ),
          SizedBox(width: 20),
          Container(
            width: sectionWidth * 0.5,
            child: Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: widget.cardModel.score > 0 ? yellow2 : grey,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    Container(
                      width: barLength,
                      height: 1,
                      color: grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                    ),
                    SizeTransition(
                      sizeFactor: sizeTransitionController,
                      axis: Axis.horizontal,
                      axisAlignment: 0,
                      child: Container(
                        width: coloredBarLength,
                        height: 1,
                        color: yellow,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                      ),
                    ),
                  ],
                ),
                Container(
//                  width: cardState.maxScore == widget.cardModel.score ? 10 : 5,
//                  height: cardState.maxScore == widget.cardModel.score ? 10 : 5,
                  width: barEndCircleSize,
                  height: barEndCircleSize,
                  decoration: BoxDecoration(
                    color: barEndCircleColor,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    sizeTransitionController.dispose();
    super.dispose();
  }
}

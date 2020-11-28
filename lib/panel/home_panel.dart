import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/HomeData.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class HomePanel extends StatefulWidget {
  final HomeData homeData;

  const HomePanel({Key key, this.homeData}) : super(key: key);

  @override
  _HomePanelState createState() => _HomePanelState();
}

class _HomePanelState extends State<HomePanel> {
  CarouselController _carouselController = CarouselController();
  AutoScrollController _controller = AutoScrollController();
  int _currentItem = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget.homeData.title}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${widget.homeData.subPaths.length} Sub Paths",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    child: Text(
                      "Open Path",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.lightBlue[700],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              reverse: false,
              onPageChanged: (index, data) {
                if (data == CarouselPageChangedReason.manual) {
                  _controller.scrollToIndex(index,
                      preferPosition: AutoScrollPosition.middle);
                  setState(() {
                    _currentItem = index;
                  });
                }
              },
            ),
            items: widget.homeData.subPaths.map((f) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      f.image,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.black),
            child: ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: widget.homeData.subPaths.length,
                itemBuilder: (context, index) {
                  return AutoScrollTag(
                    index: index,
                    controller: _controller,
                    key: ValueKey(index),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: GestureDetector(
                        onTap: () {
                          _carouselController.animateToPage(
                            index,
                          );
                          _controller.scrollToIndex(index,
                              preferPosition: AutoScrollPosition.middle);
                          setState(() {
                            _currentItem = index;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.homeData.subPaths[index].title,
                              style: TextStyle(
                                fontSize: 16,
                                color: _currentItem == index
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                            ),
                            (widget.homeData.subPaths.length - 1) != index
                                ? Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hotels/src/stars.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'detail.dart';
import 'favourites.dart';
import 'model.dart';

class Home extends StatefulWidget {
  Home(this.hotels);
  final List<Hotel> hotels;
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  String _sortingOrder = "";
  Set<Hotel> _saved = new Set<Hotel>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotels'),
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (ctxt) => new Favourites(_saved)),
                );
              }),
        ],
      ),
      body: ListView.separated(
          itemCount: widget.hotels.length,
          separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
          padding: const EdgeInsets.all(16.0),
          itemBuilder: /*1*/ (context, i) {
            return _buildRow(widget.hotels[i],
                _saved.contains(widget.hotels[i]) ? true : false);
          }),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {
            setState(() {
              _sortingOrder = "";
              if (widget.hotels[0].stars <
                  widget.hotels[widget.hotels.length - 1].stars) {
                _sortingOrder = "down";
                widget.hotels.sort((a, b) => b.stars - a.stars);
              } else {
                _sortingOrder = "up";
                widget.hotels.sort((a, b) => a.stars - b.stars);
              }
            });
          },
          icon: Icon(Icons.star, color: Colors.pinkAccent),
          label: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Order by stars '),
                WidgetSpan(child: getLabel()),
              ],
            ),
          )),
    );
  }

  Widget getLabel() {
    if (_sortingOrder == "down")
      return Icon(Icons.arrow_downward, size: 16);
    else if (_sortingOrder == "up")
      return Icon(Icons.arrow_upward, size: 16);
    else
      return SizedBox(height: 10);
  }

  ListTile _buildRow(Hotel hotel, bool saved) {
    final _biggerFont = const TextStyle(fontSize: 18.0);

    return ListTile(
      title: Text(
        hotel.name,
        style: _biggerFont,
      ),
      subtitle: new Table(
        children: [
          new TableRow(children: [
            Text(hotel.location.city + " , " + hotel.location.address)
          ]),
          new TableRow(children: [new HotelStars(stars: hotel.stars)]),
        ],
      ),
      leading: new IconButton(
        icon: new Icon(
          saved ? Icons.favorite : Icons.favorite_border,
          color: saved ? Colors.pinkAccent : null,
        ),
        onPressed: () {
          setState(() {
            if (this._saved.contains(hotel)) {
              _saved.remove(hotel);
            } else {
              _saved.add(hotel);
            }
          });
        },
      ),
      trailing: new CircularPercentIndicator(
        radius: 45.0,
        lineWidth: 4.0,
        percent: hotel.userRating / 10,
        center: new Text(hotel.userRating.toString()),
        progressColor: Colors.pinkAccent,
      ),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (ctxt) => new Detail(hotel)),
        );
      },
    );
  }
}

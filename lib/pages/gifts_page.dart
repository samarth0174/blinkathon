import 'package:blinkathon/pages/gifts_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'nm_box.dart';

class GiftsPage extends StatefulWidget {
  @override
  createState() {
    return new GiftsPageState();
  }
}

class GiftsPageState extends State<GiftsPage> {
  List<RadioModel> sampleData = new List<RadioModel>();
  var logger = Logger();
  List<D> data;

  Future<void> getApi() async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      'https://api.blinksky.com/api/v1/catalog',
      data: {
        "service": {"apikey": "b142d0e644f64946b11ec8a2109e7488"}
      },
    );
    final userdata = new Gifts.fromJson(response.data);
    setState(() {
       data = userdata.d;
    });
   
  }

  @override
  void initState() {
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      body: data != null
          ? ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 18),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    decoration: nMbox,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(data[index].caption,
                                style: TextStyle(
                                    color: fCD,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            Icon(
                              Icons.more_horiz,
                              color: fCD,
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  child: Text(data[index].desc,
                                      style: TextStyle(
                                          color: fCD,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                data[index].logo,
                                fit: BoxFit.cover,
                                height: 140,
                                width: 140,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Value',
                                    style: TextStyle(
                                        color: fCL,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                Text(data[index].value,
                                    style: TextStyle(
                                        color: fCD,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Expires',
                                    style: TextStyle(
                                        color: fCL,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                                Text('08 / 21',
                                    style: TextStyle(
                                        color: fCD,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : Text('Nothing'),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            height: 50.0,
            width: 50.0,
            child: new Center(
              child: new Text(_item.buttonText,
                  style: new TextStyle(
                      color: _item.isSelected ? Colors.white : Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
            ),
            decoration: new BoxDecoration(
              color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
              border: new Border.all(
                  width: 1.0,
                  color: _item.isSelected ? Colors.blueAccent : Colors.grey),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 10.0),
            child: new Text(_item.text),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}

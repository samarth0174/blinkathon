import 'package:blinkathon/pages/gifts_model.dart';
import 'package:blinkathon/pages/nm_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:blinkathon/constant/data_json.dart';
import 'package:blinkathon/theme/colors.dart';
import 'package:blinkathon/widgets/header_home_page.dart';
import 'package:blinkathon/widgets/column_social_icon.dart';
import 'package:blinkathon/widgets/left_panel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';

List<D> data;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  var logger = Logger();

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
    _tabController = TabController(length: items.length, vsync: this);
    getApi();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return VideoPlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            songName: items[index]['songName'],
            profileImg: items[index]['profileImg'],
            likes: items[index]['likes'],
            comments: items[index]['comments'],
            shares: items[index]['shares'],
            albumImg: items[index]['albumImg'],
          );
        }),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;
  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.caption,
      this.songName,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.albumImg,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((value) {
        _videoController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: black),
                  child: Stack(
                    children: <Widget>[
                      VideoPlayer(_videoController),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(),
                          child: isPlaying(),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          HeaderHomePage(),
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              LeftPanel(
                                size: widget.size,
                                name: "${widget.name}",
                                caption: "${widget.caption}",
                                songName: "${widget.songName}",
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(24.0)),
                                      ),
                                      builder: (context) {
                                        return data != null
                                            ? Column(
                                                children: [
                                                  Container(
                                                    height: 200,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8.0),
                                                            child: Container(
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                      data[0]
                                                                          .caption,
                                                                      style: TextStyle(
                                                                          color:
                                                                              fCD,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w700)),
                                                                  TextFormField(
                                                                    cursorColor:
                                                                        Theme.of(context)
                                                                            .cursorColor,
                                                                    initialValue:
                                                                        'Input text',
                                                                    maxLength:
                                                                        20,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .favorite),
                                                                      labelText:
                                                                          'Enter text',
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF6200EE),
                                                                      ),
                                                                      helperText:
                                                                          'Helper text',
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Color(0xFF6200EE)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DropdownButton<
                                                                      String>(
                                                                    items: <
                                                                        String>[
                                                                      '\$5',
                                                                      '\$10',
                                                                      '\$15',
                                                                      '\$20'
                                                                    ].map((String
                                                                        value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child: new Text(
                                                                            value),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged:
                                                                        (_) {},
                                                                    hint: Text(
                                                                        'Enter amount'),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          child: Image.network(
                                                            data[0].logo,
                                                            fit: BoxFit.cover,
                                                            height: 140,
                                                            width: 140,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: data.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            print(data[index]
                                                                .caption);
                                                          },
                                                          child: Container(
                                                            width: 200,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      18.0),
                                                              child: Container(
                                                                decoration:
                                                                    nMbox,
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                        data[index]
                                                                            .caption,
                                                                        style: TextStyle(
                                                                            color:
                                                                                fCD,
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.w700)),
                                                                    SizedBox(
                                                                        height:
                                                                            25),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: <
                                                                          Widget>[
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0),
                                                                          child:
                                                                              Image.network(
                                                                            data[index].logo,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            height:
                                                                                140,
                                                                            width:
                                                                                160,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            25),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Text('Nothing');
                                      });
                                },
                                child: RightPanel(
                                  size: widget.size,
                                  likes: "${widget.likes}",
                                  comments: "${widget.comments}",
                                  shares: "${widget.shares}",
                                  profileImg: "${widget.profileImg}",
                                  albumImg: "${widget.albumImg}",
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key key,
    @required this.size,
    this.likes,
    this.comments,
    this.shares,
    this.profileImg,
    this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.63,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(20.0),
                //     child: Icon(
                //       LineIcons.values['gift'],
                //       color: Colors.white,
                //       size: 30,
                //     )),
                Container(
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      border: new Border.all(width: 3.0, color: Colors.white),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(50.0)),
                    ),
                    width: 50,
                    height: 50,
                    child: Icon(
                      LineIcons.values['gift'],
                      color: Colors.white,
                      size: 30,
                    )),
                getAlbum(albumImg)
              ],
            ))
          ],
        ),
      ),
    );
  }
}

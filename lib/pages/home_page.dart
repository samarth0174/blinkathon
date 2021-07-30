import 'package:blinkathon/pages/gifts_model.dart';
import 'package:blinkathon/pages/nm_box.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:blinkathon/constant/data_json.dart';
import 'package:blinkathon/theme/colors.dart';
import 'package:blinkathon/widgets/header_home_page.dart';
import 'package:blinkathon/widgets/column_social_icon.dart';
import 'package:blinkathon/widgets/left_panel.dart';
import 'package:google_fonts/google_fonts.dart';
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
                                  opensheet(context);
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

void opensheet(BuildContext context) async {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      context: (context),
      enableDrag: true,
      isDismissible: true,
      builder: (context) {
        return Page1();
      });
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int currentview = 0;
  List<Widget> pages;
  int index = 0;

  @override
  void initState() {
    pages = [
      page1(),
      page2(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return pages[currentview];
  }

  Widget page1() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.red, width: 5.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              hintText: "Search your gift card",
              fillColor: Colors.white70,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60), topLeft: Radius.circular(60))),
          height: 350,
          width: double.maxFinite,
          child: data != null
              ? GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  padding: const EdgeInsets.all(8.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 4.0,
                  children: data?.map((D) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentview = 1;
                            });
                          },
                          child: GridTile(
                              child: Image.network(D.logo, fit: BoxFit.cover)),
                        );
                      })?.toList() ??
                      Text(''))
              : Center(child: Text('Loading')),
        ),
      ],
    );
  }

  Widget page2() {
    String amount = '\$5';
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(60), topLeft: Radius.circular(60))),
      height: 400,
      width: double.maxFinite,
      child: Center(
        child: InkWell(
          onTap: () {
            setState(() {
              currentview = 0;
            });
          },
          child: data != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      data[0]?.caption ?? '',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Image.network(data[0]?.logo ?? ''),
                                width: 100,
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 100,
                                child: Text(
                                  data[0]?.desc ?? '',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                width: 200,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Send a message',
                                    hintText: 'Send a message',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 35,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'OR',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Send a Gift Card',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<String>(
                            items: <String>['\$5', '\$10', '\$15', '\$20']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (data) {
                              setState(() {
                                amount = data;
                              });
                            },
                            hint: Row(
                              children: [
                                Text(
                                  'Select Amount: ',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  amount,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )),
                        Row(
                          children: [
                            Icon(
                              LineIcons.values['gift'],
                              color: Colors.black,
                              size: 30,
                            ),
                            Text(
                              'Send Gift',
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              : Container(),
        ),
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
                      border: new Border.all(width: 1.0, color: Colors.black),
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

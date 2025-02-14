import 'package:battle_me/models/user.dart';
import 'package:battle_me/widgets/utilities/meme_card.dart';
import 'package:flutter/material.dart';
import 'package:battle_me/helpers/dimensions.dart';
import 'package:intl/intl.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_scoped_model.dart';

class OtherProfileScreen extends StatefulWidget {
  final MainModel model;
  final User user;

  OtherProfileScreen(this.model, this.user);

  @override
  State<StatefulWidget> createState() {
    return _OtherProfileScreenState();
  }
}

class _OtherProfileScreenState extends State<OtherProfileScreen>
    with TickerProviderStateMixin {
  User currentUser;
  TabController _tabController;
  List<Tab> tabList = List();

  @override
  void initState() {
    currentUser = widget.user;
    tabList.add(new Tab(
      text: 'Feed',
    ));
    tabList.add(new Tab(
      text: 'Media',
    ));
    tabList.add(new Tab(
      text: 'Newest',
    ));
    _tabController =
        new TabController(vsync: this, length: tabList.length, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return Stack(
            children: <Widget>[
              Container(
                height: getViewportHeight(context),
                width: getDeviceWidth(context),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: getViewportHeight(context) * 0.35,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.asset(
                          'assets/images/wallpaper.jpg',
                          height: getViewportHeight(context) * 0.3,
                          width: getDeviceWidth(context),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getViewportHeight(context) * 0.05,
                    ),
                    Container(
                      height: getViewportHeight(context) * 0.1,
                      // color: Colors.lightBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                currentUser.memes.length.toString(),
                                style: TextStyle(
                                    fontSize:
                                        getViewportHeight(context) * 0.035),
                              ),
                              subtitle: Text(
                                'Posts',
                                style: TextStyle(
                                    fontSize:
                                        getViewportHeight(context) * 0.018),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: RichText(
                                text: new TextSpan(
                                  text: currentUser.followers.length < 1000
                                      ? currentUser.followers.length.toString()
                                      : (currentUser.followers.length < 1000000
                                          ? (currentUser.followers.length /
                                                  1000)
                                              .toStringAsFixed(1)
                                          : (currentUser.followers.length /
                                                  1000000)
                                              .toStringAsFixed(1)),
                                  style: TextStyle(
                                    fontSize:
                                        getViewportHeight(context) * 0.035,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: currentUser.followers.length < 1000
                                          ? ''
                                          : (currentUser.followers.length <
                                                  1000000
                                              ? 'K'
                                              : 'M'),
                                      style: new TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                'Followers',
                                style: TextStyle(
                                    fontSize:
                                        getViewportHeight(context) * 0.018),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: RichText(
                                text: new TextSpan(
                                  text: currentUser.followings.length < 1000
                                      ? currentUser.followings.length.toString()
                                      : (currentUser.followings.length < 1000000
                                          ? (currentUser.followings.length /
                                                  1000)
                                              .toStringAsFixed(1)
                                          : (currentUser.followings.length /
                                                  1000000)
                                              .toStringAsFixed(1)),
                                  style: TextStyle(
                                    fontSize:
                                        getViewportHeight(context) * 0.035,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: currentUser.followings.length < 1000
                                          ? ''
                                          : (currentUser.followings.length <
                                                  1000000
                                              ? 'K'
                                              : 'M'),
                                      style: new TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Text(
                                'Following',
                                style: TextStyle(
                                    fontSize:
                                        getViewportHeight(context) * 0.018),
                              ),
                            ),
                          ),
                          widget.model.getAuthenticatedUser.followings.any(
                                  (obj) =>
                                      obj["following"] == currentUser.userId)
                              ? FlatButton(
                                  color: Colors.blue,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                  child: Text('UnFollow'),
                                  onPressed: () async {
                                    await widget.model.toggleFollow(
                                        currentUser.userId,
                                        widget
                                            .model.getAuthenticatedUser.token);
                                    await widget.model.setAuthenticatedUser(
                                        widget
                                            .model.getAuthenticatedUser.userId,
                                        widget
                                            .model.getAuthenticatedUser.token);
                                    setState(() {
                                      currentUser.followers.length =
                                          currentUser.followers.length - 1;
                                      print('Unfollow done');
                                    });
                                  },
                                )
                              : FlatButton(
                                  color: Colors.blue,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  textColor: Colors.white,
                                  child: Text('Follow'),
                                  onPressed: () async {
                                    await widget.model.toggleFollow(
                                        currentUser.userId,
                                        widget
                                            .model.getAuthenticatedUser.token);
                                    await widget.model
                                        .setAuthenticatedUser(
                                            widget.model.getAuthenticatedUser
                                                .userId,
                                            widget.model.getAuthenticatedUser
                                                .token)
                                        .then((onValue) {
                                      setState(() {
                                        currentUser.followers.length =
                                            currentUser.followers.length + 1;
                                        print('Follow done');
                                      });
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                    new Container(
                      child: new TabBar(
                        controller: _tabController,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Theme.of(context).accentColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelPadding: EdgeInsets.symmetric(horizontal: 0.1),
                        tabs: <Widget>[
                          Tab(
                            text: 'Feed',
                          ),
                          Tab(
                            text: 'Media',
                          ),
                          Tab(
                            text: 'Activity',
                          ),
                        ],
                      ),
                    ),
                    widget.model.isLoading
                        ? Container(
                            height: getViewportHeight(context) * 0.42,
                            child: Center(child: CircularProgressIndicator()))
                        : (widget.model.getAuthenticatedUser.followings.any(
                                (obj) => obj["following"] == currentUser.userId)
                            ? Container(
                                height: getViewportHeight(context) * 0.42,
                                child: new TabBarView(
                                  controller: _tabController,
                                  children: <Widget>[
                                    ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return MemeCard(
                                          index: index,
                                          model: widget.model,
                                          feedList: widget.model.getFeedList,
                                          onMemeIndexSelect: (int index) {
                                            print(index);
                                          },
                                        );
                                      },
                                      itemCount:
                                          widget.model.getFeedList.length,
                                    ),
                                    Container(
                                      color: Colors.blueGrey[100],
                                      child: Center(
                                        child: Text(
                                          'You haven\'t posted any meme yet',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  getDeviceWidth(context) *
                                                      0.08,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return MemeCard(
                                            index: index, model: widget.model);
                                      },
                                      itemCount:
                                          widget.model.getFeedList.length,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: getViewportHeight(context) * 0.42,
                                child: Center(
                                  child: Text('Not Following'),
                                ),
                              )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            // will create a chatroom
                            _chatRoomCreate(model);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getViewportHeight(context) * 0.09,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: getViewportHeight(context) * 0.19,
                      // color: Colors.yellow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: getViewportHeight(context) * 0.22,
                              // color: Colors.yellow,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      width: getViewportWidth(context) * 0.55,
                                      child: ListTile(
                                        title: Text(
                                          currentUser.name,
                                          style: TextStyle(
                                              fontSize:
                                                  getViewportHeight(context) *
                                                      0.036),
                                        ),
                                        subtitle: Text(
                                          currentUser.username,
                                          style: TextStyle(
                                              fontSize:
                                                  getViewportHeight(context) *
                                                      0.02),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Less Perfection, More Authencity.',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize:
                                            getViewportHeight(context) * 0.02,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      getViewportHeight(context) * 018),
                                  child: ProgressiveImage.assetNetwork(
                                    placeholder:
                                        'assets/images/wallpaper.jpg', // gifs can be used
                                    thumbnail: currentUser.avatar,
                                    image: currentUser.avatar,
                                    height: getViewportHeight(context) * 0.18,
                                    width: getViewportHeight(context) * 0.18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _chatRoomCreate(MainModel model) {
    var user = model.getAuthenticatedUser;
    var memberList = [
      {
        'userId': currentUser.userId,
        'username': currentUser.username,
        'avatar': currentUser.avatar,
        'lastMessage': 'Start conversation!',
        'lastMessageTime': DateFormat.Hm().format(DateTime.now()),
      },
      {
        'userId': user.userId,
        'username': user.username,
        'avatar': user.avatar,
        'lastMessage': 'Start conversation!',
        'lastMessageTime': DateFormat.Hm().format(DateTime.now()),
      }
    ];
    model.mainSocket.emit('createChatRoom', {'members': memberList});
  }
}

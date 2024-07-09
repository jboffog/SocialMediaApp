import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:social_media_app/chats/recent_chats.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/utils/constants.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/widgets/indicators.dart';
import 'package:social_media_app/widgets/story_widget.dart';
import 'package:social_media_app/widgets/userpost.dart';

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int page = 5;
  bool loadingMore = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !loadingMore) {
        setState(() {
          page = page + 5;
          loadingMore = true;
        });
      }
    });
    super.initState();
  }

  Future<QuerySnapshot<Object?>> _refreshFeeds() async {
    setState(() {
      page = 5;
    });
    return await postRef.orderBy('timestamp', descending: true).limit(page).get();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(Constants.appName, style: TextStyle(fontWeight: FontWeight.w900)),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Ionicons.chatbubble_ellipses, size: 30.0),
                  onPressed: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (_) => Chats()));
                  }),
              SizedBox(width: 20.0)
            ]),
        body: RefreshIndicator(
            color: Theme.of(context).colorScheme.secondary,
            onRefresh: _refreshFeeds,
            child: FutureBuilder(
                future: postRef.orderBy('timestamp', descending: true).limit(page).get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    var snap = snapshot.data;
                    List docs = snap!.docs;

                    return ListView.builder(
                        controller: scrollController,
                        itemCount: docs.length + 1, // Adding 1 for the StoryWidget
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(padding: const EdgeInsets.only(left: 8.0), child: StoryWidget());
                          }
                          PostModel posts = PostModel.fromJson(docs[index - 1].data());
                          return Padding(padding: const EdgeInsets.all(10.0), child: UserPost(post: posts));
                        });
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return circularProgress(context);
                  } else {
                    return Center(
                        child: Text('No Feeds', style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)));
                  }
                })));
  }

  @override
  bool get wantKeepAlive => true;
}

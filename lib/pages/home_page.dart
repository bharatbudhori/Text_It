import 'package:chati_fy/pages/recent_conversations_pages.dart';
import 'package:flutter/material.dart';

import './profile_page.dart';
import './search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double _height;
  double _width;

  TabController _tabController;

  _HomePageState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('ChatiFy'),
        textTheme: TextTheme(
          headline5: TextStyle(fontSize: 16),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(
                Icons.people_outline_outlined,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.chat_bubble,
                size: 25,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.person_outline,
                size: 25,
              ),
            ),
          ],
        ),
      ),
      body: tabBarPages(),
    );
  }

  Widget tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: [
        SearchPage(_height, _width),
        RecentConversations(_height, _width),
        ProfilePage(_height, _width),
      ],
    );
  }
}

import 'package:chati_fy/models/conversation.dart';
import 'package:chati_fy/pages/conversation_page.dart';
import 'package:chati_fy/services/db_service.dart';
import 'package:chati_fy/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/auth_provider.dart';

class RecentConversations extends StatelessWidget {
  final double _height;
  final double _width;

  RecentConversations(
    this._height,
    this._width,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,
      child: ChangeNotifierProvider<AuthProvider>.value(
        value: AuthProvider.instance,
        child: _conversationsListViewWidget(),
      ),
    );
  }

  Widget _conversationsListViewWidget() {
    return Builder(
      builder: (BuildContext _context) {
        var _auth = Provider.of<AuthProvider>(_context);
        return Container(
          height: _height,
          width: _width,
          child: StreamBuilder<List<ConversationSnippet>>(
            stream: DBService.instance.getUSerConversations(_auth.user.uid),
            builder: (_context, _snapshot) {
              var _data = _snapshot.data;
              return !_snapshot.hasData
                  ? Center(
                      child: SpinKitPouringHourglass(
                        color: Colors.blue,
                      ),
                    )
                  : _data.length == 0
                      ? Center(
                          child: Text(
                            'No Conversations yet...Start chatting!',
                          ),
                        )
                      : ListView.builder(
                          itemCount: _data.length,
                          itemBuilder: (_context, _index) {
                            return ListTile(
                              onTap: () {
                                NavigationServices.instance.navigateToRoute(
                                  MaterialPageRoute(
                                    builder: (BuildContext _context) {
                                      return ConversationPage(
                                        _data[_index].conversationID,
                                        _data[_index].id,
                                        _data[_index].name,
                                        _data[_index].image,
                                      );
                                    },
                                  ),
                                );
                              },
                              title: Text(_data[_index].name),
                              subtitle: Text(_data[_index].lastMessage),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  _data[_index].image,
                                ),
                              ),
                              trailing: _listTileTrailingWidget(
                                  _data[_index].timestamp),
                            );
                          },
                        );
            },
          ),
        );
      },
    );
  }

  Widget _listTileTrailingWidget(Timestamp _lastMessageTimestamp) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _lastMessageTimestamp == null
              ? ''
              : timeago.format(_lastMessageTimestamp.toDate()),
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        CircleAvatar(
          radius: 6,
          backgroundColor: Colors.green,
        ),
      ],
    );
  }
}

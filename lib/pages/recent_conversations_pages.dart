import 'package:flutter/material.dart';

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
      child: _conversationsListViewWidget(),
    );
  }

  Widget _conversationsListViewWidget() {
    return Container(
      height: _height,
      width: _width,
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (_context, _index) {
          return ListTile(
            onTap: () {},
            title: Text('Will Smith'),
            subtitle: Text('Sorry, for late response buddy!!'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3Ktc8CXLt7lJ9mezatk_JhV3nvuxcSCCrAg&usqp=CAU',
              ),
            ),
            trailing: _listTileTrailingWidget(),
          );
        },
      ),
    );
  }

  Widget _listTileTrailingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Last seen',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        CircleAvatar(
          radius: 6,
          backgroundColor: Colors.blue,
        ),
      ],
    );
  }
}

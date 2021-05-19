import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final _height;
  final _width;

  SearchPage(this._height, this._width);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _searchPageUI(),
    );
  }

  Widget _searchPageUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _userSearchField(),
        _userListView(),
      ],
    );
  }

  Widget _userSearchField() {
    return Container(
      height: this.widget._height * 0.08,
      width: this.widget._width,
      padding: EdgeInsets.symmetric(vertical: this.widget._height * 0.02),
      child: TextField(
        autocorrect: false,
        style: TextStyle(color: Colors.white),
        onSubmitted: (_input) {},
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          labelText: 'Search',
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _userListView() {
    return Container(
      height: this.widget._height * 0.75,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (_context, _integer) {
          return ListTile(
            title: Text('Bharat Budhori'),
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5NAQzseXiAQoYrETzEElTOuqUX6QncKaoxw&usqp=CAU',
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Last seen',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  'About an hour ago',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchComponent extends StatelessWidget {
  SearchComponent({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoSearchTextField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop<String>(_searchController.text);
            },
            child: Text(
              'Search',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

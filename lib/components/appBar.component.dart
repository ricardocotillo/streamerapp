import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:streamerapp/components/search.component.dart';
import 'package:streamerapp/providers/home.provider.dart';

class AppBarComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return ClipRect(
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 50,
          width: _size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(CupertinoIcons.search),
                onPressed: () async {
                  final String queryTerm = await _onSearchTap(context);
                  if (queryTerm.isNotEmpty) {
                    Provider.of<SearchPreferencesProvider>(context,
                            listen: false)
                        .setQueryTerm(queryTerm);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _onSearchTap(BuildContext context) async {
    return (await showModalBottomSheet<String>(
          isScrollControlled: true,
          backgroundColor: Colors.black38,
          context: context,
          builder: (BuildContext context) => SearchComponent(),
        )) ??
        '';
  }
}

import 'package:app_contabilidad/constants.dart';
import 'package:app_contabilidad/models/options.dart';
import 'package:flutter/material.dart';

class OverView extends StatelessWidget {
  const OverView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BranchID',
          style: appBarTextStyle,
        ),
        backgroundColor: appBarBackground,
      ),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            Divider(
              height: 8,
            ),
            ListTile(
              onTap: () => {},
              leading: IconTheme(
                data: IconThemeData(
                  color: secundarioDark,
                  size: 30,
                ),
                child: options[index].icono,
              ),
              title: Text(
                options[index].title,
                style: optionStyle,
                textAlign: TextAlign.start,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: secundarioDark,
              ),
              hoverColor: secundarioLight,
            ),
          ],
        ),
      ),
    );
  }
}

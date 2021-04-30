import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/widgets/chip_list.dart';
import 'package:workmannow/widgets/hire_button.dart';
import 'package:workmannow/widgets/job_card.dart';
import 'package:workmannow/widgets/user_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class ProfileScreen extends StatelessWidget {
  final workMan;
  ProfileScreen({@required this.workMan});
  @override
  Widget build(BuildContext context) {
    Widget similarWorkmenGridList = new Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 200.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            UserCard(),
            UserCard(),
            UserCard(),
            UserCard(),
            UserCard(),
          ],
        ));

    Widget finishedJobsGridList = new Container(
        height: 80.0,
        child: new ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            JobCard(),
            JobCard(),
            JobCard(),
            JobCard(),
          ],
        ));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: MyColors.blue),
        title: Text(
          'Workman Profile',
          style: TextStyle(color: MyColors.blue),
        ),
        bottom: PreferredSize(
          child: Container(
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey[300], width: 0.5)),
            ),
          ),
          preferredSize: null,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.grey[200], width: 2.0)),
                          child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: workMan['dpImage'] != null
                                  ? NetworkImage(
                                      workMan['dpImage'],
                                    )
                                  : AssetImage('assets/dp.png')),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${workMan['lastName']} ${workMan['firstName']}'
                                  .titleCase,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              '${workMan['profession']}'.sentenceCase,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //=========================================================================================== ratings card
                Card(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${workMan['rating']}/5',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            Text(
                              'Rating',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 80.0,
                        ),
                        Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12.0),
                            ),
                            Text(
                              'Jobs completed',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //============================================================================== hire and price card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Staring fee',
                              style:
                                  TextStyle(fontSize: 10.0, color: Colors.grey),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "Shs : ",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'QuickSand',
                                      fontSize: 12),
                                  children: [
                                    TextSpan(
                                        text: workMan['startingFee'],
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0))
                                  ]),
                            ),
                          ],
                        ),
                        HireButton(
                          workMan: workMan,
                        ),
                      ],
                    ),
                  ),
                ),
                //============================================================================== specialities card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Specialities',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        ChipList(
                          list: [...workMan['specialities']],
                        ),
                      ],
                    ),
                  ),
                ),
                //============================================================================== about card
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey),
                        ),
                        Text(
                          workMan['aboutSelf'],
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('Finished Jobs',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
                SizedBox(
                  height: 10.0,
                ),
                finishedJobsGridList,
                SizedBox(
                  height: 10.0,
                ),
                Text('Other similar workmen',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
                similarWorkmenGridList,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

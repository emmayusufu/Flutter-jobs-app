import 'package:provider/provider.dart';
import 'package:workmannow/helpers/colors.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/utils/chip_list.dart';
import 'package:workmannow/widgets/buttons/hire_button.dart';
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
        child: FutureBuilder(
            future: Provider.of<UserProvider>(context,listen:false).fetchUsers(limit: 5, role: "workman"),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Widget container;
              if(snapshot.connectionState == ConnectionState.waiting){
                container = Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                container = Center(child: Text('Something went wrong'),);
              } else if(snapshot.hasData){
                if(snapshot.data.length>0){
                  container = ListView.builder(itemCount: snapshot.data.length,itemBuilder: (context, index){
                    return ;
                  });
                } else if(snapshot.data.length==0){
                  container = Center(child: Text('No similar workmen'),);
                }
              }
          return container;
        }),
    );
    //
    Widget finishedJobsGridList = new Container(
        height: 80.0,
      child: FutureBuilder(
          future: Provider.of<UserProvider>(context,listen:false).fetchUsers(limit: 5, role: "workman"),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            Widget container;
            if(snapshot.connectionState == ConnectionState.waiting){
              container = Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              container = Center(child: Text('Something went wrong'),);
            } else if(snapshot.hasData){
              if(snapshot.data.length>0){
                container = ListView.builder(itemCount: snapshot.data.length,itemBuilder: (context, index){
                  return ;
                });
              } else if(snapshot.data.length==0){
                container = Center(child: Text('No similar workmen'),);
              }
            }
            return container;
          }),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: MyColors.blue),
        title: Text(
          'Workman Profile',
          style: TextStyle(color: MyColors.blue),
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
                              backgroundImage: workMan['profileImage'] != null
                                  ? NetworkImage('http://192.168.43.77:3001/'+
                                      workMan['profileImage']['small'],
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
                              '${workMan['firstName']} ${workMan['lastName']}'
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
                                  fontSize:10.0,
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
                          list: workMan['specialities'],
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
                Text('Finished hirings',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
                SizedBox(
                  height: 10.0,
                ),
                // finishedJobsGridList,
                SizedBox(
                  height: 10.0,
                ),
                Text('Other similar workmen',
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
                // similarWorkmenGridList,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

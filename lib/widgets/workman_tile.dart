import 'package:workmannow/pages/profile/workman_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmannow/widgets/hire_button.dart';
import 'package:workmannow/widgets/rating.dart';
import 'package:recase/recase.dart';

class WorkManTile extends StatelessWidget {
  final String image;
  final String name;
  final String about;
  final int rating;
  final String startFee;
  final String profession;
  final workMan;

  WorkManTile(
      {@required this.name,
      @required this.image,
      @required this.about,
      @required this.profession,
      @required this.rating,
      @required this.startFee,
      @required this.workMan});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 0.0,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        workMan: workMan,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                            border: Border.all(
                                color: Colors.grey[200], width: 0.5)),
                        child: image != null
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/dp.png',
                                image: 'http://192.168.0.108:3001/$image',
                                fit: BoxFit.cover,
                              )
                            : Image.asset('assets/dp.png'),
                      )),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.titleCase,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          profession.titleCase,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10.0,),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          about.length > 100
                              ? "${about.substring(0, 100)}....".sentenceCase
                              : about.sentenceCase,
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [Rating(count: rating)],
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Starting fee',
                        style: TextStyle(fontSize: 10.0, color: Colors.grey),
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
                                  text: startFee,
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0))
                            ]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Completed jobs',
                        style: TextStyle(fontSize: 10.0, color: Colors.grey),
                      ),
                      Text('0',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0)),
                    ],
                  ),
                  HireButton(
                    workMan: workMan,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

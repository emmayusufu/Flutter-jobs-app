// import 'package:workmannow/pages/finished_job/index.dart';
import 'package:workmannow/widgets/rating.dart';
import 'package:flutter/material.dart';

class JobCard extends StatefulWidget {
  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_)=>FinishedJob()));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '18/12/2020',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Senior software engineer',
                style: TextStyle(),
              ),
              Row(
                children: [
                  Rating(count: 5)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

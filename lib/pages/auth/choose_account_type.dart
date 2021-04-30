import 'package:flutter/material.dart';
import 'package:workmannow/pages/auth/setup_client_profile.dart';
import 'package:workmannow/pages/auth/setup_workman_profile.dart';
import 'package:workmannow/widgets/round_button.dart';

class ChooseAccountType extends StatefulWidget {
  @override
  _ChooseAccountTypeState createState() => _ChooseAccountTypeState();
}

class _ChooseAccountTypeState extends State<ChooseAccountType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('What are you registering as ?',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
              ),
              RoundButton(cb: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SetUpClientProfile()));
              }, name: 'Client'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(decoration: BoxDecoration(
                      border: Border.all(color: Colors.black,width: 0.1,)
                    ),),
                  ),
                  Text(' OR '),
                  Expanded(
                    child: Container(decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 0.1,)
                    ),),
                  ),
                ],
              ),
              RoundButton(cb: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SetupWorkManProfile()));
              }, name: 'Workman'),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:workmannow/providers/user.dart';
import 'package:workmannow/widgets/round_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class HireFinished extends StatefulWidget {
  final String docRef;
  HireFinished({@required this.docRef});
  @override
  _HireFinishedState createState() => _HireFinishedState();
}

class _HireFinishedState extends State<HireFinished> {
  double rating = 0.0;
  String review;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Complete hire'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Please rate our workman and leave us a review according to how the work was done by the workman',
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (double rating) {
                        setState(() {
                          rating = rating;
                        });
                      },
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    TextFormField(
                      maxLines: 5,
                      maxLength: 200,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      decoration: InputDecoration(
                          labelText: 'Your review',
                          prefixIcon: Icon(CupertinoIcons.pen),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          )),
                      onChanged: (value) {
                        setState(() {
                          review = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    RoundButton(
                      cb: () {
                        if (_formKey.currentState.validate()) {
                          _submit(docRef: widget.docRef);
                        }
                      },
                      name: 'Submit',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit({String docRef}) {
    Provider.of<UserProvider>(context, listen: false).completeHire(
        documentRef: docRef, review: review, workManRating: rating);
  }
}

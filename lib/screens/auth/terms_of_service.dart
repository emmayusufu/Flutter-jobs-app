import 'package:flutter/material.dart';

class TermsOfService extends StatefulWidget {
  @override
  _TermsOfServiceState createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms of service and privacy'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  'In the course of engaging with our services, you provide personal information about you.'),
              SizedBox(
                height: 20.0,
              ),
              Text(
                  ''' Ensuring your privacy is important to us. We don’t share your personal information with anyone expect as described in the privacy policy. we may share your personal information with;'''),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [Text('A . '), Text('Third party service providers')],
              ),
              Row(
                children: [
                  Text('B . '),
                  Text('Business partners'),
                ],
              ),
              Row(
                children: [
                  Text('C . '),
                  Expanded(
                      child: Text(
                          'Affiliated companies within our corporate structure'))
                ],
              ),
              Row(
                children: [
                  Text('D . '),
                  Text('As needed for legal purposes'),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                  ''' All the categories mentioned above have access to personal information only as needed to perform their functions and must process the personal information in accordance with the privacy policy'''),
              SizedBox(
                height: 20.0,
              ),
              Text(
                  '''When you visit our website and use our services, we may send small text file(cookie) to your web browser, this uniquely identifies your computer and lets you use Canva for faster browsing, login and navigation through the site. if you would like to edit your cookie settings, please consult your browser use instructions. '''),
              SizedBox(
                height: 20.0,
              ),
              Text(
                  '''We reserve the right, to modify or replace the privacy policy at any time. If a revision is to be done, we will make reasonable efforts to provide at least a 24-hour notice through email our website prior and after the new terms and conditions take effect. By continuing to access or use Our Service after those revisions become effective, you agree to be bound by the revised terms. If You do not agree to the new terms, in whole or in part, please stop using the website and the Service. '''),
            ],
          ),
        ),
      )),
    );
  }
}

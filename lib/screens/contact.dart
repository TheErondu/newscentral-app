import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

void main() => runApp(Contact());

class Contact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: ContactUsBottomAppBar(
          companyName: 'Abhishek Doshi',
          textColor: Colors.white,
          backgroundColor: Theme.of(context).backgroundColor,
          email: 'adoshi26.ad@gmail.com',
          // textFont: 'Sail',
        ),
        backgroundColor: Colors.white,
        body: ContactUs(
            cardColor: Colors.white,
            textColor: Colors.teal.shade900,
            logo: const AssetImage('assets/images/logo.gif'),
            email: 'itsupport@gmail.com',
            companyName: 'Abhishek Doshi',
            companyColor: Colors.black,
            phoneNumber: '+917818044311',
            website: 'https://abhishekdoshi.godaddysites.com',
            githubUserName: 'AbhishekDoshi26',
            linkedinURL:
                'https://www.linkedin.com/in/abhishek-doshi-520983199/',
            tagLine: 'Flutter Developer',
            taglineColor: Colors.black,
            twitterHandle: 'AbhishekDoshi26',
            instagram: '_abhishek_doshi',
            facebookHandle: '_abhishek_doshi'),
      ),
    );
  }
}

import 'package:heart_safe/components/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
///Author: Matthew Bertello, Pachia Lee, Grace Kiesau
///Date: 5/14/24
///Description: 
///Bugs: None Known
class OtherInfo extends StatelessWidget {
  const OtherInfo({super.key});

///This is a page displayed in the menu that allows the user to get more info on CHD from reputable sources
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(context: context, title: const Text('More Info')),
      body: Padding(
        padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Resource Links",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            const SizedBox(height: 10.0),
            uwHealthBox(), // info and link to website UWHealth website
            const SizedBox(height: 20.0),
            hermaHeartBox(), // info and link to Herma Heart website
            const SizedBox(height: 20.0),
            cardiacCenterBox(), // info and link to Cardiac Center website
          ]
        )
      )
    );
  } // end of build


 // info and link to website UWHealth website
Container uwHealthBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text ("UW Health Kids heart program provides the most advanced care for congenital and acquired heart conditions. Learn more."),
            TextButton(
              onPressed: () {launchUrl(Uri.parse('https://www.uwhealth.org/services/pediatric-heart-program'));},
              child: const Text('UW Health Services')
            )
          ],
        ),
      )
    );
  }

   // info and link to website Herma Heart website
  Container hermaHeartBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text ("The Herma Heart Institute at Children's Wisconsin is one of the top-rated pediatric heart centers in the nation. Our cutting-edge pediatric cardiac care results in some of the best surgical outcomes for even the most complex types of heart disease."),
            TextButton(
              onPressed: () {launchUrl(Uri.parse('https://childrenswi.org/medical-care/herma-heart'));},
              child: const Text('Herma Heart Institute Wisconsin'))
          ],
        ),
      )
    );
  }

   // info and link to website Cardiac Center website
  Container cardiacCenterBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text ("The Cardiac Center at Children's Hospital of Philadelphia is one of the world's leading pediatric heart centers, offering care for children with acquired and congenital heart conditions."),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse('https://www.chop.edu/centers-programs/cardiac-center'));
              },
              child: const Text('Cardiac Center Philiadelphia'))
          ],
        ),
      )
    );
  }

}

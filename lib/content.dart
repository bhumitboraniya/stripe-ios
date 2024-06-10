import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stripe_payment_flutter/home.dart';

class Content extends StatefulWidget {
  const Content({super.key});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IHM CORP',
          // style: TextStyle(),
        ),
        centerTitle: true,
        // backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildIntroductionCard(),
            SizedBox(height: 24.0),
            _buildFeatureCard(
              title: 'Credit Mastery E-Courses',
              description:
                  'Immerse yourself in comprehensive courses meticulously crafted by industry experts. From the fundamentals of personal credit to navigating the complexities of business credit, we cover it all.',
            ),
            _buildFeatureCard(
              title: 'Holistic Financial Education',
              description:
                  'Gain insights into how personal and business credit intertwine with your overall financial health. Our primary treatment feature ensures personalized guidance, empowering you to make informed decisions for lasting financial success.',
            ),
            _buildFeatureCard(
              title: 'Subscription with Credit Reporting',
              description:
                  'Elevate your credit journey with our monthly subscription that actively reports to major credit agencies, establishing a robust primary trade line. Watch your credit profile grow while you expand your financial knowledge.',
            ),
            _buildFeatureCard(
              title: 'Flexible Learning Paths',
              description:
                  'Tailor your learning experience to suit your lifestyle. Whether you\'re delving into personal credit enhancement or seeking to leverage credit for business growth, our flexible courses adapt to your unique needs.',
            ),
            SizedBox(height: 24.0),
            _buildEmpowermentCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroductionCard() {
    return Card(
      color: Colors.orange.shade400,
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Image(
                image: AssetImage(
                  "assets/tlogo.png",
                ),
                height: 170,
                width: 170,
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Welcome to International Holdings Management Corp',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: Text(
                'Your gateway to mastering personal and business credit with a revolutionary monthly subscription that not only educates but actively contributes to your credit profile as a primary trade line.',
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      {required String title, required String description}) {
    return Card(
      elevation: 4.0,
      // color: Colors.orange.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade500,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpowermentCard() {
    return Card(
      color: Colors.green.shade100,
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'At International Holdings Management Corp, we empower individuals and entrepreneurs to unlock the full potential of their finances. Join us in mastering personal and business credit, with the added benefit of building a positive credit history through our subscription that reports to credit agencies.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              child: Text(
                'Join Now',
                // style: TextStyle(color: Colors.orange.shade500),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

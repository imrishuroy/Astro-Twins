import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchingTwinsIndicator extends StatelessWidget {
  const SearchingTwinsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svgs/twins.svg',
              color: Colors.white,
              height: 50.0,
              width: 50.0,
            ),
            const SizedBox(height: 40.0),
            const Text(
              'LOADING (45%)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: 300,
              height: 7,
              child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  //  value: 0.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Astro twins are two people born on same day,month,year,time and place.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

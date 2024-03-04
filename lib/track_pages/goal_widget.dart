import 'package:bearthly/reduce_pages/reduce.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarbonReductionGoalWidget extends StatefulWidget {
  @override
  _CarbonReductionGoalWidgetState createState() =>
      _CarbonReductionGoalWidgetState();
}

class _CarbonReductionGoalWidgetState extends State<CarbonReductionGoalWidget> {
  @override
  void initState() {
    super.initState();

    _loadCalculatedPercent();
  }

  double calculatedPercent = 0.0;
  List<double> percents = [];

  Future<void> _loadCalculatedPercent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? storedPercent = prefs.getDouble('calculatedPercent');
    if (storedPercent != null) {
      percents = prefs
              .getStringList('allPercents')
              ?.map((e) => double.parse(e))
              .toList() ??
          [];
      percents.add(storedPercent);
      _saveAllPercents(percents);
      setState(() {
        _updateProgress();
      });

      print(percents);
    }
  }

  Future<void> _saveAllPercents(List<double> percents) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'allPercents', percents.map((e) => e.toString()).toList());
  }

  void _updateProgress() {
    calculatedPercent = 0.0; // Reset progress
    if (percents.length >= 2) {
      for (int i = 1; i < percents.length; i++) {
        if (percents[i] < percents[i - 1]) {
          calculatedPercent +=
              0.05; // Increase progress by 10% for each improvement
        }
      }
      calculatedPercent =
          calculatedPercent.clamp(0.0, 1.0); // Clamp between 0 and 1
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 121, 191, 184),
            ),
            child: const Icon(
              Icons.area_chart,
              size: 30,
              color: Color.fromARGB(255, 200, 235, 232),
            ),
          ),
          const Text(
            'Carbon Reduction Progress',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'You are on track to decrease your emissions by',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: Colors.grey[300],
            barRadius: const Radius.circular(10),
            width: 280,
            lineHeight: 15,
            leading: Text('${((calculatedPercent) * 100).toInt()}%'),
            percent: calculatedPercent,
            animation: true,
            animationDuration: 1500,
            progressColor: const Color.fromARGB(255, 34, 121, 108),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            width: 300,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 254, 254, 254)),
            child: Row(
              children: [
                Container(
                    child: const Stack(
                  children: [
                    // Icon(
                    //   Icons.circle,
                    //   size: 70,
                    //   color: Color.fromARGB(255, 121, 191, 184),
                    // ),
                    // Padding(
                    //   padding:
                    //       EdgeInsets.only(top: 2.0, left: 15.0, right: 4.0),
                    //   child: Icon(
                    //     Icons.co2,
                    //     size: 45,
                    //     color: Color.fromARGB(255, 50, 154, 138),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 25.0, left: 15.0),
                    //   child: Icon(
                    //     Icons.scatter_plot_sharp,
                    //     size: 35,
                    //     color: Color.fromARGB(255, 34, 121, 108),
                    //   ),
                    // ),
                  ],
                )),
                GestureDetector(
                  child: Row(children: [
                    Text(
                      "  Lets reduce our emissions ",
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 34, 121, 108),
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color.fromARGB(255, 34, 121, 108),
                    )
                  ]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Reduce())));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:covid_19_tracker/View/world_stats.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DetailScreen extends StatefulWidget {
  String name, image;
  int totalCases, totalDeaths, totalRecovered, active, critical, todayRecovered, test;

  DetailScreen({Key? key, required this.name,
  required this.image,
  required this.totalCases,
  required this.totalDeaths,
  required this.todayRecovered,
  required this.active,
  required this.critical,
  required this.totalRecovered,
  required this.test,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds:  3))..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color> [
    Colors.indigo,
    Colors.cyan,
    Colors.blueGrey,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.name),  // country name
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PieChart(dataMap: {
            'Total Cases': double.parse(widget.totalCases.toString()),
            'Total Deaths':double.parse(widget.totalDeaths.toString()),
            'Total Recovered' : double.parse(widget.totalRecovered.toString())
          },
            animationDuration: Duration(milliseconds: 1200),
            colorList: colorList,
            chartType: ChartType.ring,
            chartRadius: MediaQuery.of(context).size.height / 6.5,
            legendOptions: LegendOptions(
              legendPosition: LegendPosition.left
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true
            ),

          ),
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .067),
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * .06,),
                        ReusableRow(title: 'Name', value: widget.name.toString()),
                        ReusableRow(title: 'Cases', value: widget.totalCases.toString()),
                        ReusableRow(title: 'Total Deaths', value: widget.totalDeaths.toString()),
                        ReusableRow(title: 'Recovered', value: widget.totalRecovered.toString()),
                        ReusableRow(title: 'Critical', value: widget.critical.toString()),
                        ReusableRow(title: 'Today Recovered', value: widget.todayRecovered.toString()),
                      ],
                    ),
                  ),
                ),

                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.image),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


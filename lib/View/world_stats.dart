import 'package:covid_19_tracker/View/countries_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import '../Model/world_stats_model.dart';
import '../Services/stats_services.dart';

class WorldStatsScreen extends StatefulWidget {
  const WorldStatsScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatsScreen> createState() => _WorldStatsScreenState();
}

class _WorldStatsScreenState extends State<WorldStatsScreen> with TickerProviderStateMixin{
  // for showing pie chart with animation
  late final AnimationController _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color> [
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {

    StatsServices statsServices = StatsServices();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .01,),
                FutureBuilder(
                    future: statsServices.fetchWorldStatsRecord(),
                    builder: (context, AsyncSnapshot<WorldStatsModel> snapshot){
                  if(!snapshot.hasData){
                    return Expanded(
                      flex: 1,
                        child: SpinKitFadingCircle(
                         color: Colors.white,
                          size: 50,
                          controller: _controller,
                        )
                    );
                  }
                  else{
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            'Total' : double.parse(snapshot.data!.cases.toString()),
                            'Recovered' : double.parse(snapshot.data!.recovered.toString()),
                            'Death' : double.parse(snapshot.data!.deaths.toString()),
                          },
                          animationDuration: Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorList,
                          chartRadius: MediaQuery.of(context).size.height / 4.5,
                          legendOptions: LegendOptions(
                              legendPosition: LegendPosition.left
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .04),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(title: "Total", value: snapshot.data!.cases.toString()),
                                ReusableRow(title: "Recovered", value: snapshot.data!.recovered.toString()),
                                ReusableRow(title: "Deaths", value: snapshot.data!.deaths.toString()),
                                ReusableRow(title: "Active", value: snapshot.data!.active.toString()),
                                ReusableRow(title: "Critical", value: snapshot.data!.critical.toString()),
                                ReusableRow(title: "Today Deaths", value: snapshot.data!.todayDeaths.toString()),
                              ],
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesListScreen()));

                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xff1aa260),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Track Countries"),
                            ),
                          ),
                        ),

                      ],
                    );
                  }
                }),

              ],
            ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value)
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
        ],
      ),
    );
  }
}


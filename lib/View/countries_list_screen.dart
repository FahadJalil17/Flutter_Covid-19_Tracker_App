import 'package:covid_19_tracker/Services/stats_services.dart';
import 'package:covid_19_tracker/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search with country name",
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
                onChanged: (value){
                  setState(() {

                  });
                },
              ),
            ),

            Expanded(
                child: FutureBuilder(
                    future: statsServices.countriesListApi(),
                    builder: (context, AsyncSnapshot<List<dynamic>> snapshot){
                      // using shimmer effect if there is no data
                      if(!snapshot.hasData){
                        return ListView.builder(
                            itemCount: 8,
                            itemBuilder: (context, index){
                          return Shimmer.fromColors(
                              baseColor: Colors.grey.shade700,
                              highlightColor: Colors.grey.shade100,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Container(height: 10, width: 80, color: Colors.white,),
                                    subtitle: Container(height: 10, width: 80, color: Colors.white,),
                                    leading: Container(height: 50, width: 50, color: Colors.white,),
                                  )
                                ],
                              ),
                          );
                        });
                      }

                      else{
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index){
                              // for filtering out list
                              String name = snapshot.data![index]['country']; // assigning country name
                              if(searchController.text.isEmpty){
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                            DetailScreen(
                                              name: snapshot.data![index]['country'],
                                              image: snapshot.data![index]['countryInfo']['flag'],
                                              totalCases: snapshot.data![index]['cases'],
                                              totalRecovered: snapshot.data![index]['recovered'],
                                              totalDeaths: snapshot.data![index]['deaths'],
                                              active: snapshot.data![index]['active'],
                                              test: snapshot.data![index]['tests'],
                                              todayRecovered: snapshot.data![index]['todayRecovered'],
                                              critical: snapshot.data![index]['critical'],
                                            )));
                                      },
                                      child: ListTile(
                                        title: Text(snapshot.data![index]['country']),
                                        subtitle: Text(snapshot.data![index]['cases'].toString()),
                                        leading: Image(
                                          height: 50,
                                          width: 50,
                                          image: NetworkImage(snapshot.data![index]['countryInfo']['flag']),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              else if(name.toLowerCase().contains(searchController.text.toLowerCase())
                                  && name.toUpperCase().contains(searchController.text.toUpperCase())
                              ){
                                return Column(
                                  children: [
                                    InkWell(
                                      // when search and click on any country name to get it's record
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                            DetailScreen(
                                              name: snapshot.data![index]['country'],
                                              image: snapshot.data![index]['countryInfo']['flag'],
                                              totalCases: snapshot.data![index]['cases'],
                                              totalRecovered: snapshot.data![index]['recovered'],
                                              totalDeaths: snapshot.data![index]['deaths'],
                                              active: snapshot.data![index]['active'],
                                              test: snapshot.data![index]['tests'],
                                              todayRecovered: snapshot.data![index]['todayRecovered'],
                                              critical: snapshot.data![index]['critical'],
                                            )));
                                      },

                                      child: ListTile(
                                        title: Text(snapshot.data![index]['country']),
                                        subtitle: Text(snapshot.data![index]['cases'].toString()),
                                        leading: Image(
                                          height: 50,
                                          width: 50,
                                          image: NetworkImage(snapshot.data![index]['countryInfo']['flag']),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }

                              // if search is not valid then show empty container
                              else{
                                return Container();
                              }


                        });
                      }

                }),
            )

          ],
        ),
      ),
    );
  }
}



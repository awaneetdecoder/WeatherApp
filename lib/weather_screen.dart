import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';


import 'package:intl/intl.dart';

import 'package:weather_app/additonal_information.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;



class WeatherScreen extends StatefulWidget {
  final VoidCallback onThemeChange;
  const WeatherScreen({super.key, required this.onThemeChange});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Future<Map<String,dynamic>> weatherFuture;
  String cityName='London';
  @override
  void initState() {  
    super.initState();
    weatherFuture=getWeatherForecast(cityName);
  }

   
   
  Future<Map<String,dynamic>> getWeatherForecast(String cityName) async{
    //uri=uniform resourse identifier and url= uniform resourse locator
    try{
      
          
      final res = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
    );
    final data =jsonDecode(res.body);
    if (data['cod'] != '200') { 
      throw data['message'];
    }
    return data;
   
    
    
    }catch(e){
      throw e.toString();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          cityName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: widget.onThemeChange, icon: Icon(
            Theme.of(context).brightness== Brightness.dark?
            Icons.light_mode:
            Icons.dark_mode,
          )),
          IconButton(
            onPressed: () async {
              final typedCityName = await showDialog<String>(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                 
                  
                  return AlertDialog(
                    title: const Text('Enter City Name'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(hintText: 'City Name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog without returning a value
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                      Navigator.of(context).pop(controller.text);
                    } // Return the entered city name
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  );
                },
              );

              if (typedCityName != null && typedCityName.isNotEmpty) {
                setState(() {
                  cityName = typedCityName;
                  weatherFuture = getWeatherForecast(cityName);
                });
              }
            
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(onPressed: (){
            setState(() {
              
              weatherFuture=getWeatherForecast(cityName);
            });
          }, 
          icon: Icon(Icons.refresh)),
        ],
      ),
      
      body:  FutureBuilder(
        future: weatherFuture,
        builder:(context, snapshot) {
         
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Center(child: Text('An error occured ${snapshot.error}'));
          } 
          if(!snapshot.hasData || snapshot.data==null){
            return Center(child: Text('No data found') );
          }
          final data = snapshot.data!;
          final forecastList = data['list'] as List?;

          if (forecastList == null || forecastList.isEmpty) {
            return Center(child: Text('No forecast data found'));
          }

          // Get the first forecast from the list
          // Get the first forecast from the list
          final currentWeatherData = data['list'][0];

// Now, access the details from that first forecast
          final currentTemp = currentWeatherData['main']['temp'];
          final celsiusTemp = currentTemp - 273.15; 
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWind = currentWeatherData['wind']['speed'];
          // some changes are here due to the data in incorrect above currentWeatherData is used instead of data


        //   return Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
             
                
        //           SizedBox(height: 5),
        //           SizedBox(
        //             width: double.infinity,
        //             child: Card(
        //               elevation: 10,
        //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        //              // clipRRect is use to set the boarder radius and use to cliping the unwanted elevation
        //               child: ClipRRect(
        //                 borderRadius:BorderRadius.circular(16) ,
        //                 child: BackdropFilter(
        //                   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), // it is an abstract class
        //                   child: Padding(
        //                     padding: const EdgeInsets.all(16.0),
        //                     child: Column(
        //                       children: [
        //                       Text(
        //                        '${celsiusTemp.toStringAsFixed(1)}°C',
        //                       style: TextStyle(
        //                         fontSize: 32,
        //                         fontWeight: FontWeight.bold
        //                               ),
        //                       ),
        //                       const SizedBox(height: 16),
        //                       Icon(
        //                         currentSky=='Clouds'|| currentSky =='Sunny'?
        //                         Icons.cloud:Icons.sunny,size: 65),
        //                       SizedBox(height: 7),
        //                       Text(currentSky,
        //                       style: TextStyle(fontSize: 20),
        //                       ),
                              
        //                       ],                           
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(height: 20),

        //           Text('Hourly Forecast', 
        //             style: TextStyle(
        //               fontSize: 24, 
        //               fontWeight: FontWeight.bold
        //               )
        //              ),
        //           const SizedBox(height: 8),
        //           // SingleChildScrollView(
        //           //   scrollDirection: Axis.horizontal,
        //           //   child: Row(
        //           //       children: [
        //           //         for(int i=0;i<6;i++)
        //           //          HourlyForecastItem(
        //           //           time:data['dt'].toString(),
        //           //           temp:data['main']['temp'].toString(),
        //           //           icon:data['weather'][0]['main'] == '  Clouds' || data['weather'][0]['main'] == 'Sunny'? Icons.cloud : Icons.sunny,
        //           //          ),                 
                                  
                           
        //           //       ],
        //           //   ),
        //           // ),
                  

        //           SizedBox(

        //             height: 130,
        //             child: ListView.builder(
        //               itemCount: 8,
        //               scrollDirection: Axis.horizontal,
        //               itemBuilder: (context, index) {
        //                 final hourlyForecast = data['list'][index + 1];
        //                 final hourlySky = hourlyForecast['weather'][0]['main'];
        //                 // final hourlyTemp = hourlyForecast['main']['temp'].toString();
        //                 final dateTime = DateTime.parse(hourlyForecast['dt_txt']);
        //                 final kelvinTemp = hourlyForecast['main']['temp'];
        //                 final hourlyTemp = (kelvinTemp - 273.15).toStringAsFixed(1);
                        

        //                 return HourlyForecastItem(
        //                   time: DateFormat.j().format(dateTime),
        //                   temp:'${hourlyTemp}°C ',
        //                   icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
        //                       ? Icons.cloud
        //                       : Icons.sunny,
        //                 );
        //               },
        //             ),
        //           ),
                  
        //           const SizedBox(height: 20),
        //           Text('Additional Information', 
        //             style: TextStyle(
        //               fontSize: 24, 
        //               fontWeight: FontWeight.bold
        //               ) 
        //              ),
        //           const SizedBox(height: 1),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: [
        //               AdditionalInformation(
        //                 icon: Icons.water_drop,
        //                 label: 'Humidity',
        //                 value:  currentHumidity.toString(),
        //               ),
        //               AdditionalInformation(
        //                 icon: Icons.air,
        //                 label: 'Wind Speed',
        //                 value: currentWind.toString(),
        //               ),
        //               AdditionalInformation(
        //                 icon: Icons.compress,
        //                 label: 'Pressure',
        //                 value: currentPressure.toString(),
        //               ),
        //             ],
        //           )
                
        //         ],
        //       ),
        // );
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 800) {
              return buildMobileLayout(currentWeatherData, data['list']);
            } else {
              return buildDesktopLayout(currentWeatherData, data['list']);
            }
          },
        );
        },
        
      ),
    );
  }
}

Widget buildMobileLayout(Map<String,dynamic> currentWeatherData, List<dynamic> fullForecastList){
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainWeatherCard(currentWeatherData),
        const SizedBox(height: 20),
        _buildHourlyForecastSection(fullForecastList),
        const SizedBox(height: 20), 
        _buildAdditionalInfoSection(currentWeatherData),
      ],
    ),
    );
}

Widget buildDesktopLayout(Map<String, dynamic> currentWeatherData, List<dynamic> fullForecastList) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildMainWeatherCard(currentWeatherData),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHourlyForecastSection(fullForecastList),
                  const SizedBox(height: 24),
                  _buildAdditionalInfoSection(currentWeatherData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeatherCard(Map<String, dynamic> data) {
    final currentTemp = data['main']['temp'] as num;
    final currentSky = data['weather'][0]['main'];
    final celsiusTemp = currentTemp - 273.15;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '${celsiusTemp.toStringAsFixed(1)}°C',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Icon(
                    currentSky == 'Clouds' || currentSky == 'Rain'
                        ? Icons.cloud
                        : Icons.sunny,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentSky,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecastSection(List<dynamic> fullForecastList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Hourly Forecast',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fullForecastList.length,
            itemBuilder: (context, index) {
              final hourlyForecast = fullForecastList[index];
              final hourlySky = hourlyForecast['weather'][0]['main'];
              final dateTime = DateTime.parse(hourlyForecast['dt_txt']);
              final kelvinTemp = hourlyForecast['main']['temp'] as num;
              final celsiusTemp = kelvinTemp - 273.15;

              return HourlyForecastItem(
                time: DateFormat.j().format(dateTime),
                temp: '${celsiusTemp.toStringAsFixed(1)}°C',
                icon: hourlySky == 'Clouds'
                    ? Icons.cloud
                    : hourlySky == 'Rain'
                        ? Icons.water_drop
                        : (dateTime.hour > 18 || dateTime.hour < 6)
                            ? Icons.nightlight
                            : Icons.sunny,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfoSection(Map<String, dynamic> data) {
    final currentPressure = data['main']['pressure'];
    final currentHumidity = data['main']['humidity'];
    final currentWind = data['wind']['speed'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Additional Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AdditionalInformation(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: currentHumidity.toString(),
            ),
            AdditionalInformation(
              icon: Icons.air,
              label: 'Wind Speed',
              value: currentWind.toString(),
            ),
            AdditionalInformation(
              icon: Icons.compress,
              label: 'Pressure',
              value: currentPressure.toString(),
            ),
          ],
        )
      ],
    );
  }



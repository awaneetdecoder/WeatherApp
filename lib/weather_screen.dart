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
        title: const Text(
          'Weather App',
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
            onPressed: () {
            
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(onPressed: (){}, 
          icon: Icon(Icons.refresh))
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


          return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
                
                  SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                     // clipRRect is use to set the boarder radius and use to cliping the unwanted elevation
                      child: ClipRRect(
                        borderRadius:BorderRadius.circular(16) ,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6), // it is an abstract class
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                              Text(
                               '${celsiusTemp.toStringAsFixed(1)}°C',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                                      ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky=='Clouds'|| currentSky =='Sunny'?
                                Icons.cloud:Icons.sunny,size: 65),
                              SizedBox(height: 7),
                              Text(currentSky,
                              style: TextStyle(fontSize: 20),
                              ),
                              
                              ],                           
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text('Hourly Forecast', 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                      )
                     ),
                  const SizedBox(height: 8),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //       children: [
                  //         for(int i=0;i<6;i++)
                  //          HourlyForecastItem(
                  //           time:data['dt'].toString(),
                  //           temp:data['main']['temp'].toString(),
                  //           icon:data['weather'][0]['main'] == '  Clouds' || data['weather'][0]['main'] == 'Sunny'? Icons.cloud : Icons.sunny,
                  //          ),                 
                                  
                           
                  //       ],
                  //   ),
                  // ),
                  

                  SizedBox(

                    height: 130,
                    child: ListView.builder(
                      itemCount: 8,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = hourlyForecast['weather'][0]['main'];
                        // final hourlyTemp = hourlyForecast['main']['temp'].toString();
                        final dateTime = DateTime.parse(hourlyForecast['dt_txt']);
                        final kelvinTemp = hourlyForecast['main']['temp'];
                        final hourlyTemp = (kelvinTemp - 273.15).toStringAsFixed(1);
                        

                        return HourlyForecastItem(
                          time: DateFormat.j().format(dateTime),
                          temp:'${hourlyTemp}°C ',
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Text('Additional Information', 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold
                      ) 
                     ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInformation(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value:  currentHumidity.toString(),
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
              ),
        );
        },
      ),
    );
  }
}





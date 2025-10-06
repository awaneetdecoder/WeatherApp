import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final IconData icon;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
     });

  @override
  Widget build(BuildContext context) {
    return Card(
                            elevation: 6,                          
                            child:Container(
                              width: 80,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(time,
                                     style: TextStyle(
                                     fontSize: 20,
                                     fontWeight: FontWeight.bold
                                     
                                   ),
                                   maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                   ),
                                  
                                  Icon(icon,
                                   size: 30),
                                  SizedBox(height: 7),
                                  Text(temp, style: TextStyle(fontSize: 10),),
                                  
                                ],
                              ),
                            )
                          );
  }
}
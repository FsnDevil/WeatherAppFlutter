import 'dart:ui';

import 'package:flutter/material.dart';

class MainCard extends StatefulWidget {
  const MainCard({super.key, required this.tempData, required this.skyData});

  final String tempData;
  final String skyData;

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    widget.tempData,
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Icon(widget.skyData=="Clouds"||widget.skyData=="Rain"?Icons.cloud:Icons.sunny, size: 48),
                  const SizedBox(
                    height: 16,
                  ),
                   Text(
                    widget.skyData,
                    style:
                        const TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForecastHourlyItem extends StatelessWidget {
  final IconData icon;
  final String timeValue;
  final String kelvinValue;

  const ForecastHourlyItem(
      {super.key,
      required this.icon,
      required this.timeValue,
      required this.kelvinValue});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                timeValue,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(icon, size: 24),
              const SizedBox(
                height: 10,
              ),
              Text(
                kelvinValue,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String weatherValueString;
  final String intValue;

  const AdditionalInfoItem(
      {super.key,
      required this.icon,
      required this.weatherValueString,
      required this.intValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: 120,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Icon(icon, size: 36),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  weatherValueString,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  intValue,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


          // return ListView(
          //   children: [
          //     ListTile(
          //       title: Text(
          //         weather.name ?? "CityName",
          //       ),
          //       subtitle: Text.rich(
          //         TextSpan(
          //           children: [
          //             TextSpan(
          //               text: (weather.sys?.country ?? "Country") + " (",
          //             ),
          //             TextSpan(
          //               text:
          //                   (weather.coord?.lat.toString() ?? "Lat") + " Lat, ",
          //             ),
          //             TextSpan(
          //               text:
          //                   (weather.coord?.lon.toString() ?? "Lon") + " Lon)",
          //             ),
          //           ],
          //         ),
          //       ),
          //       leading: CircleAvatar(
          //         child: Icon(Icons.location_city_rounded),
          //       ),
          //     )
          //   ],
          // );
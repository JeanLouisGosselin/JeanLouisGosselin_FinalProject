import 'NetworkEnsurer.dart';
import 'constants/constants.dart';


class StockDataGetter {

  Future<dynamic> getStockData(String companyName) async {

    var url = '$openWeatherMapURL?q=$companyName&appid=$apiKey&units=metric';

    NetworkEnsurer networkEnsurer = NetworkEnsurer(url);

    var allWeatherData = await networkEnsurer.getData();

    return allWeatherData;
  }

  /////////////////////////////////////////////////
  // below: copied from the Flutter course; to be changed and done at a later date (if needed)

  String getStockIcon(int condition) {

    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getStockMessage(int temp) {

    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
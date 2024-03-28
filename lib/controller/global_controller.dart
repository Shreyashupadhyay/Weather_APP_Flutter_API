import "package:geolocator/geolocator.dart";
import "package:get/get.dart";

class GlobalController extends GetxController {
  // create various variables that will be used globally

  final _isLoading = true.obs;
  final _latutude = 0.0.obs;
  final _longitude = 0.0.obs;

  // Instance for them to be called

  RxBool get getIsLoading => _isLoading;
  RxDouble get getLatitude => _latutude;
  RxDouble get getLongitude => _longitude;

  @override
  void onInit() {
    // TODO: implement onInit
    if (_isLoading.isTrue) {
      GetLocation();
    }
    super.onInit();
  }

  void GetLocation() async {
    // get the current location of the user
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    // return if service is not enabled

    if (!isServiceEnabled) {
      return Future.error('Location services are disabled');
    }

    // check for permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location services are disabled forever');
    } else if (locationPermission == LocationPermission.denied) {
      // request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location services are disabled');
      }
    }

    //getting the current possition
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      _latutude.value = value.latitude;
      _longitude.value = value.longitude;
    });
  }
}

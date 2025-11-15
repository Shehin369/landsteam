import 'package:flutter/material.dart';
import 'package:landsteam/models/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationController extends ChangeNotifier {
  List<Location>? locations;
  getAllLocations() async {
    final supabase = Supabase.instance.client;
    final data = await supabase.from('Location').select();
    print(data);
    Map<String, dynamic> newdata = {'location': data};
    Locationbase base = Locationbase.fromJson(newdata);
    locations = base.location;
    // properties = base.properties;
    print(newdata);
    notifyListeners();
    return base.location!;
  }
}

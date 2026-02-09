import 'package:flutter/material.dart';
import 'package:landsteam/models/property.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PropertyController extends ChangeNotifier {
  List<Properties>? properties;
  List<Properties>? queries;
  Future<List<Properties>> getMyProperties() async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('Properties')
        .select()
        .eq('query', false)
        .eq('status', 1)
        .eq('userid', 1)
        .order('created_at', ascending: false);
    // print(json.encode(data));
    Map<String, dynamic> newdata = {'properties': data};
    Propertybase base = Propertybase.fromJson(newdata);
    properties = base.properties;
    print(newdata);
    notifyListeners();
    return base.properties!;
  }

  Future<List<Properties>> getMyQueries() async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('Properties')
        .select()
        .eq('query', true)
        .eq('status', 1)
        .eq('userid', 1);
    // print(json.encode(data));
    Map<String, dynamic> newdata = {'properties': data};
    Propertybase base = Propertybase.fromJson(newdata);
    queries = base.properties;
    print(newdata);
    notifyListeners();
    return base.properties!;
  }

  Future<List<Properties>> getPropertySearch({
    required int locationid,
    required int from,
    required int to,
    required bool res,
  }) async {
    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('Properties')
        .select()
        .gte('price', from)
        .lte('price', to)
        .eq('residential', res)
        .eq('locationid', locationid)
        .eq('query', false)
        .eq('rent', false)
        .eq('status', 1)
        .order('created_at', ascending: false);
    // print(json.encode(data));
    Map<String, dynamic> newdata = {'properties': data};
    Propertybase base = Propertybase.fromJson(newdata);
    properties = base.properties;
    print(newdata);
    return base.properties!;
  }

  Future<List<Properties>> getRentSearch(Properties prop) async {
    //  residential: propertyType == 'Residential',
    // sharing: occupancyType == 'Sharing',
    // // peoples: int.parse(numberOfPeople!),
    // price: budgetFrom,
    // toPrice: budgetTo,
    // locationid: Provider.of<AuthenticationController>(
    //   context,
    //   listen: false,
    // ).locations!.firstWhere((loc) => loc.name == selectedLocation).id!,
    // rent: true,

    final supabase = Supabase.instance.client;
    final data = await supabase
        .from('Properties')
        .select()
        .gte('price', prop.price!)
        .lte('price', prop.toPrice!)
        .eq('residential', prop.residential!)
        .eq('sharing', prop.sharing!)
        .eq('locationid', prop.locationid!)
        .eq('query', false)
        .eq('rent', true)
        .eq('status', 1)
        .order('created_at', ascending: false);
    // print(json.encode(data));
    Map<String, dynamic> newdata = {'properties': data};
    Propertybase base = Propertybase.fromJson(newdata);
    properties = base.properties;
    print(newdata);
    return base.properties!;
  }

  addlocation(String locationName, BuildContext context) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Location').insert({
      'name': locationName,
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    }
  }

  Future<bool> addproperty(BuildContext context, Properties property) async {
    final input = property.toJson();
    print(input);
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Properties').insert(input);
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property added successfully')),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.error!.message}'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
  }

  Future<bool> addquery(BuildContext context, Properties property) async {
    final input = property.toJson();
    print(input);
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Properties').insert(input);
    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your query has been submitted, we will contact you soon !!',
          ),
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${response.error!.message}'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
  }
}

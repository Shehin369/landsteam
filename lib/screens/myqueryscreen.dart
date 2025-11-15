import 'package:flutter/material.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/controllers/property_controller.dart';
import 'package:landsteam/models/property.dart';
import 'package:landsteam/screens/addpropertyscreen.dart';
import 'package:landsteam/screens/propertylist_screem.dart';
import 'package:landsteam/screens/queryscreen.dart';
import 'package:provider/provider.dart';

// Theme colours (use these exactly)

class Myqueryscreen extends StatefulWidget {
  const Myqueryscreen({super.key});

  @override
  State<Myqueryscreen> createState() => _MyqueryscreenState();
}

class _MyqueryscreenState extends State<Myqueryscreen> {
  late List<Properties> _Properties;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final controller = Provider.of<PropertyController>(
        context,
        listen: false,
      );
      final res = await controller.getMyQueries();
    });
  }

  Future<void> _refresh() async {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: kBackgroundColor,
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AddQuerryScreen()),
      //     );
      //   },
      //   tooltip: 'Add',
      //   child: Icon(Icons.add),
      // ),
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSurfaceColor,
        elevation: 0,
        title: const Text(
          'My Queries',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<PropertyController>(
          builder: (context, value, child) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            final items = value.queries ?? [];

            if (items.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 80),
                    Icon(
                      Icons.house_siding,
                      size: 64,
                      color: kSecondaryTextColor.withOpacity(0.25),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'No queries found',
                        style: TextStyle(
                          color: kPrimaryTextColor.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Pull down to refresh',
                        style: TextStyle(
                          color: kPrimaryTextColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final p = items[index];
                  return PropertyCard(
                    property: p,
                    onTap: () {
                      // placeholder: open details
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

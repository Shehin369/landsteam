import 'package:flutter/material.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/controllers/authentication_controller.dart';
import 'package:landsteam/controllers/property_controller.dart';
import 'package:landsteam/models/location.dart';
import 'package:landsteam/models/property.dart';
import 'package:landsteam/screens/propertylist_screem.dart';
import 'package:provider/provider.dart';

class PropertySearchScreen extends StatefulWidget {
  const PropertySearchScreen({super.key, required this.rent});
  final bool rent;

  @override
  State<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends State<PropertySearchScreen> {
  String? selectedLocation;
  int? budgetFrom;
  int? budgetTo;
  String propertyType = 'Residential';
  String occupancyType = 'Single';
  // String? numberOfPeople;
  // DateTime? selectedDate;

  final List<String> peopleCount = ['1', '2', '3', '4', '5+'];

  onSearchApiCall() async {
    if (widget.rent) {
      final res = await PropertyController().getRentSearch(
        Properties(
          residential: propertyType == 'Residential',
          sharing: occupancyType == 'Sharing',
          // peoples: int.parse(numberOfPeople!),
          price: budgetFrom,
          toPrice: budgetTo,
          locationid: Provider.of<AuthenticationController>(
            context,
            listen: false,
          ).locations!.firstWhere((loc) => loc.name == selectedLocation).id!,
        ),
      );
      if (res.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No rentals found matching the criteria.'),
          ),
        );
        return;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PropertylistScreen(properties: res, rent: true),
          ),
        );
      }
    } else {
      final res = await PropertyController().getPropertySearch(
        locationid: Provider.of<AuthenticationController>(
          context,
          listen: false,
        ).locations!.firstWhere((loc) => loc.name == selectedLocation).id!,
        from: budgetFrom!,
        to: budgetTo!,
        res: propertyType == 'Residential',
      );
      if (res.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No properties found matching the criteria.'),
          ),
        );
        return;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PropertylistScreen(properties: res, rent: false),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Location> locations =
        Provider.of<AuthenticationController>(
          context,
          listen: false,
        ).locations ??
        [];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSurfaceColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.rent ? 'Find Rentals' : 'Buy Property',
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 18),

            // Location
            _buildSectionTitle('Location'),
            Container(
              decoration: _buildBoxDecoration(),
              child: DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                hint: Text(
                  'Select Location',
                  style: TextStyle(color: kPrimaryTextColor.withOpacity(0.7)),
                ),
                items: locations.map((Location location) {
                  return DropdownMenuItem(
                    value: location.name,
                    child: Text(
                      location.name!,
                      style: const TextStyle(color: kPrimaryTextColor),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedLocation = value);
                },
              ),
            ),

            const SizedBox(height: 18),
            // Budget
            _buildSectionTitle('Budget Range'),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: _buildBoxDecoration(),
                    child: TextField(
                      style: const TextStyle(color: kPrimaryTextColor),
                      decoration: InputDecoration(
                        hintText: 'From',
                        hintStyle: TextStyle(
                          color: kPrimaryTextColor.withOpacity(0.6),
                        ),
                        prefixText: '\₹ ',
                        prefixStyle: const TextStyle(color: kPrimaryTextColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => budgetFrom = int.tryParse(value));
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: _buildBoxDecoration(),
                    child: TextField(
                      style: const TextStyle(color: kPrimaryTextColor),
                      decoration: InputDecoration(
                        hintText: 'To',
                        hintStyle: TextStyle(
                          color: kPrimaryTextColor.withOpacity(0.6),
                        ),
                        prefixText: '\₹ ',
                        prefixStyle: const TextStyle(color: kPrimaryTextColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() => budgetTo = int.tryParse(value));
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),
            // Property Type
            _buildSectionTitle('Property Type'),
            Row(
              children: [
                Expanded(
                  child: _buildToggle(
                    'Residential',
                    propertyType == 'Residential',
                    () => setState(() => propertyType = 'Residential'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggle(
                    'Commercial',
                    propertyType == 'Commercial',
                    () => setState(() => propertyType = 'Commercial'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Occupancy Type
            Visibility(
              visible: widget.rent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Occupancy Type'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildToggle(
                          'Sharing',
                          occupancyType == 'Sharing',
                          () => setState(() => occupancyType = 'Sharing'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildToggle(
                          'Single',
                          occupancyType == 'Single',
                          () => setState(() => occupancyType = 'Single'),
                        ),
                      ),
                    ],
                  ),

                  // const SizedBox(height: 18),

                  // // Number of People
                  // _buildSectionTitle('Number of People'),
                  // Container(
                  //   decoration: _buildBoxDecoration(),
                  //   child: DropdownButtonFormField<String>(
                  //     value: numberOfPeople,
                  //     decoration: const InputDecoration(
                  //       border: InputBorder.none,
                  //       contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  //     ),
                  //     hint: Text(
                  //       'Select number of people',
                  //       style: TextStyle(
                  //         color: kPrimaryTextColor.withOpacity(0.7),
                  //       ),
                  //     ),
                  //     items: peopleCount.map((String count) {
                  //       return DropdownMenuItem(
                  //         value: count,
                  //         child: Text(
                  //           count,
                  //           style: const TextStyle(color: kPrimaryTextColor),
                  //         ),
                  //       );
                  //     }).toList(),
                  //     onChanged: (value) {
                  //       setState(() => numberOfPeople = value);
                  //     },
                  //   ),
                  // ),
                  const SizedBox(height: 18),
                ],
              ),
            ),

            // Date
            // _buildSectionTitle('Date of Requirement'),
            // GestureDetector(
            //   onTap: () async {
            //     final DateTime? picked = await showDatePicker(
            //       context: context,
            //       initialDate: selectedDate ?? DateTime.now(),
            //       firstDate: DateTime.now(),
            //       lastDate: DateTime.now().add(const Duration(days: 365)),
            //       builder: (context, child) {
            //         return Theme(
            //           data: Theme.of(context).copyWith(
            //             colorScheme: ColorScheme.light(
            //               primary: kSecondaryTextColor,
            //               onPrimary: Colors.white,
            //               onSurface: kPrimaryTextColor,
            //             ),
            //           ),
            //           child: child!,
            //         );
            //       },
            //     );
            //     if (picked != null) setState(() => selectedDate = picked);
            //   },
            //   child: Container(
            //     decoration: _buildBoxDecoration(),
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 14,
            //     ),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.calendar_today,
            //           color: kSecondaryTextColor.withOpacity(0.9),
            //         ),
            //         const SizedBox(width: 12),
            //         Text(
            //           selectedDate != null
            //               ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
            //               : 'Select Date',
            //           style: TextStyle(
            //             color: kPrimaryTextColor.withOpacity(0.9),
            //           ),
            //         ),
            //         const Spacer(),
            //         const Icon(
            //           Icons.arrow_forward_ios,
            //           size: 14,
            //           color: Colors.black26,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Spacer(),
            // const SizedBox(height: 28),

            // Proceed
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => onSearchApiCall(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryTextColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter properties',
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Refine your search with targeted filters',
          style: TextStyle(
            color: kPrimaryTextColor.withOpacity(0.8),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: kSecondaryTextColor,
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: kSurfaceColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildToggle(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryTextColor : kSurfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? kSecondaryTextColor : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : kPrimaryTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

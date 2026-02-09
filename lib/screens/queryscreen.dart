import 'package:flutter/material.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/controllers/authentication_controller.dart';
import 'package:landsteam/controllers/property_controller.dart';
import 'package:landsteam/models/location.dart';
import 'package:landsteam/models/property.dart';
import 'package:landsteam/screens/myqueryscreen.dart';
import 'package:provider/provider.dart';

class AddQuerryScreen extends StatefulWidget {
  const AddQuerryScreen({super.key});

  @override
  State<AddQuerryScreen> createState() => _AddQuerryScreenState();
}

class _AddQuerryScreenState extends State<AddQuerryScreen> {
  String? selectedLocation;
  double? budgetFrom;
  double? budgetTo;
  String propertyType = 'Residential';
  String type = 'Rent';
  String occupancyType = 'Single';
  String? numberOfPeople;
  DateTime? selectedDate;
  String? title;

  final TextEditingController _descriptionController = TextEditingController();

  final List<String> peopleCount = ['1', '2', '3', '4', '5+'];

  onSubmit() {
    // submit action
    final property = Properties(
      rent: type == 'Rent',
      query: true,
      title: title,
      residential: propertyType == 'Residential',
      // sharing: occupancyType == 'Sharing',
      // peoples: numberOfPeople != null ? int.parse(numberOfPeople!) : null,
      price: budgetFrom != null ? budgetFrom!.toInt() : null,
      toPrice: budgetTo != null ? budgetTo!.toInt() : null,
      locationName: selectedLocation,
      locationid: Provider.of<AuthenticationController>(
        context,
        listen: false,
      ).locations!.firstWhere((loc) => loc.name == selectedLocation).id,
      date: selectedDate != null
          ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
          : null,
      // date: selectedDate != null
      //     ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
      //     : null,
      description: _descriptionController.text.trim(),
      userid: 1,
      username: 'Ajmal',
      phoneNumber: 956256951,
      status: 1,
    );
    if (type == 'Rent' && propertyType == 'Residential') {
      property.sharing = occupancyType == 'Sharing';
      property.peoples = (numberOfPeople == '5+'
          ? 5
          : int.parse(numberOfPeople!));
    }
    PropertyController()
        .addquery(context, property)
        .then((value) => Navigator.pop(context));
  }

  validate() {
    if (selectedLocation == null ||
        budgetFrom == null ||
        selectedDate == null ||
        title == null ||
        (type == 'Rent' &&
            propertyType == 'Residential' &&
            numberOfPeople == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
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
          'Tell your requirement',
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Myqueryscreen()),
              );
            },
            icon: Icon(Icons.history, color: kPrimaryTextColor),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildToggle(
                    'Rent',
                    type == 'Rent',
                    () => setState(() => type = 'Rent'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildToggle(
                    'Buy',
                    type == 'Buy',
                    () => setState(() => type = 'Buy'),
                  ),
                ),
              ],
            ),

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
                        setState(() => budgetFrom = double.tryParse(value));
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
                        setState(() => budgetTo = double.tryParse(value));
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
              visible: type == 'Rent',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildSectionTitle('Advance Amount'),
                  // Container(
                  //   width: 250,
                  //   decoration: _buildBoxDecoration(),
                  //   child: TextField(
                  //     style: const TextStyle(color: kPrimaryTextColor),
                  //     decoration: InputDecoration(
                  //       hintText: 'Advance',
                  //       hintStyle: TextStyle(
                  //         color: kPrimaryTextColor.withOpacity(0.6),
                  //       ),
                  //       prefixText: '\$ ',
                  //       prefixStyle: const TextStyle(color: kPrimaryTextColor),
                  //       border: InputBorder.none,
                  //       contentPadding: const EdgeInsets.symmetric(
                  //         horizontal: 16,
                  //       ),
                  //     ),
                  //     keyboardType: TextInputType.number,
                  //     onChanged: (value) {
                  //       setState(() => budgetTo = double.tryParse(value));
                  //     },
                  //   ),
                  // ),

                  // Number of People
                  Visibility(
                    visible: propertyType == 'Residential',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 18),
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

                        const SizedBox(height: 18),
                        _buildSectionTitle('Number of People'),
                        Container(
                          decoration: _buildBoxDecoration(),
                          child: DropdownButtonFormField<String>(
                            value: numberOfPeople,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            hint: Text(
                              'Select number of people',
                              style: TextStyle(
                                color: kPrimaryTextColor.withOpacity(0.7),
                              ),
                            ),
                            items: peopleCount.map((String count) {
                              return DropdownMenuItem(
                                value: count,
                                child: Text(
                                  count,
                                  style: const TextStyle(
                                    color: kPrimaryTextColor,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => numberOfPeople = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
            _buildSectionTitle('Title'),
            Container(
              decoration: _buildBoxDecoration(),
              child: TextField(
                style: const TextStyle(color: kPrimaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: kPrimaryTextColor.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() => title = value);
                },
              ),
            ),
            const SizedBox(height: 18),
            // Description
            _buildSectionTitle('Description'),
            Container(
              decoration: _buildBoxDecoration(),
              child: TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(color: kPrimaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Enter property description...',
                  hintStyle: TextStyle(
                    color: kPrimaryTextColor.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Date
            _buildSectionTitle('Date of Requirement'),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: kSecondaryTextColor,
                          onPrimary: Colors.white,
                          onSurface: kPrimaryTextColor,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Container(
                decoration: _buildBoxDecoration(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: kSecondaryTextColor.withOpacity(0.9),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Select Date',
                      style: TextStyle(
                        color: kPrimaryTextColor.withOpacity(0.9),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Proceed
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  // proceed action
                  if (validate()) {
                    onSubmit();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSecondaryTextColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
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

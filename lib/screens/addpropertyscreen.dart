import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/controllers/authentication_controller.dart';
import 'package:landsteam/controllers/property_controller.dart';
import 'package:landsteam/models/location.dart';
import 'package:landsteam/models/property.dart';
import 'package:landsteam/screens/propertylist_screem.dart';
import 'package:provider/provider.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  String? selectedLocation;
  double? budgetFrom;
  double? budgetTo;
  String propertyType = 'Residential';
  String type = 'Rent';
  String occupancyType = 'Single';
  // String? numberOfPeople = '1';
  String? title;
  DateTime? selectedDate;

  final List<String> peopleCount = ['1', '2', '3', '4', '5+'];

  final TextEditingController _descriptionController = TextEditingController();
  File? _image1;
  File? _image2;
  final ImagePicker _picker = ImagePicker();

  addpropertyApiCall() async {
    Properties property = Properties(
      title: title,
      locationName: selectedLocation,
      price: budgetFrom?.toInt(),
      residential: propertyType == 'Residential',
      rent: type == 'Rent',
      // date: selectedDate != null
      //     ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
      //     : null,
      query: false,
      locationid: Provider.of<AuthenticationController>(
        context,
        listen: false,
      ).locations!.firstWhere((loc) => loc.name == selectedLocation).id,
      description: _descriptionController.text.trim(),
      userid: 1,
      username: 'Ajmal',
      phoneNumber: 956256951,
      status: 1,
    );
    if (type == 'Rent') {
      property.advance = budgetTo?.toInt();
      property.sharing = occupancyType == 'Sharing';
      // property.peoples = (numberOfPeople == '5+'
      //     ? 5
      //     : int.parse(numberOfPeople!));
    }
    final success = await PropertyController().addproperty(context, property);
    if (success) {
      Navigator.pop(context);
    }
  }

  bool validateInputs() {
    if (selectedLocation == null ||
        budgetFrom == null ||
        propertyType.isEmpty ||
        type.isEmpty ||
        title == null ||
        (type == 'Rent' &&
            propertyType == 'Residential' &&
            (budgetTo == null || occupancyType.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _pickImage(int imageNumber) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (imageNumber == 1) {
          _image1 = File(image.path);
        } else {
          _image2 = File(image.path);
        }
      });
    }
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
          'Add your property',
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
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
                    'Sell',
                    type == 'Sell',
                    () => setState(() => type = 'Sell'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Budget
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
            _buildSectionTitle('Price'),
            Container(
              width: 250,
              decoration: _buildBoxDecoration(),
              child: TextField(
                style: const TextStyle(color: kPrimaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(
                    color: kPrimaryTextColor.withOpacity(0.6),
                  ),
                  prefixText: '\₹ ',
                  prefixStyle: const TextStyle(color: kPrimaryTextColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() => budgetFrom = double.tryParse(value));
                },
              ),
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
              visible: type == 'Rent' && propertyType == 'Residential',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Advance Amount'),
                  Container(
                    width: 250,
                    decoration: _buildBoxDecoration(),
                    child: TextField(
                      style: const TextStyle(color: kPrimaryTextColor),
                      decoration: InputDecoration(
                        hintText: 'Advance',
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
                          () {
                            setState(() {
                              occupancyType = 'Single';
                            });
                          },
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
                  //     onChanged: occupancyType == 'Single'
                  //         ? null
                  //         : (value) {
                  //             setState(() => numberOfPeople = value);
                  //           },
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

            // Images
            _buildSectionTitle('Property Images'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(1),
                    child: Container(
                      height: 120,
                      decoration: _buildBoxDecoration(),
                      child: _image1 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_image1!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 32,
                                  color: kSecondaryTextColor.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add Image 1',
                                  style: TextStyle(
                                    color: kPrimaryTextColor.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickImage(2),
                    child: Container(
                      height: 120,
                      decoration: _buildBoxDecoration(),
                      child: _image2 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_image2!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 32,
                                  color: kSecondaryTextColor.withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add Image 2',
                                  style: TextStyle(
                                    color: kPrimaryTextColor.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Proceed
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (validateInputs()) {
                    addpropertyApiCall();
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

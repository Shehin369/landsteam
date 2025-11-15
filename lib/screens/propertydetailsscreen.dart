import 'package:flutter/material.dart';
import 'package:landsteam/models/property.dart';
import 'package:landsteam/constants.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final Properties property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSurfaceColor,
        elevation: 0,
        title: Text(
          property.title ?? 'Property Details',
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images Section
            SizedBox(
              height: 250,
              child: PageView(
                children: [
                  if (property.imageurl != null)
                    Image.network(
                      property.imageurl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                    ),
                  if (property.imageurl2 != null)
                    Image.network(
                      property.imageurl2!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                    ),
                  if (property.imageurl == null && property.imageurl2 == null)
                    _buildImagePlaceholder(),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type Tag and Price
                  Row(
                    children: [
                      _buildTag(
                        property.rent ?? false ? 'FOR RENT' : 'FOR SALE',
                        kSecondaryTextColor,
                      ),
                      const SizedBox(width: 8),
                      _buildTag(
                        property.residential ?? false
                            ? 'RESIDENTIAL'
                            : 'COMMERCIAL',
                        kPrimaryTextColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Title and Price
                  Text(
                    property.title ?? 'Untitled Property',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹ ${property.price ?? 0}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kSecondaryTextColor,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Location
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'Location',
                    property.locationName ?? 'Not specified',
                  ),

                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description ?? 'No description provided',
                    style: TextStyle(
                      color: kPrimaryTextColor.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Rental specific details
                  if (property.rent ?? false) ...[
                    const Text(
                      'Rental Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.money_outlined,
                      'Advance Amount',
                      '₹ ${property.advance ?? 0}',
                    ),
                    if (property.residential ?? false) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.people_outline,
                        'Occupancy',
                        property.sharing ?? false ? 'Sharing' : 'Single',
                      ),
                    ],
                  ],

                  const SizedBox(height: 24),

                  // Contact Details
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.person_outline,
                    'Owner',
                    property.username ?? 'Not available',
                  ),
                  if (property.phoneNumber != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'Phone',
                      property.phoneNumber.toString(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_outlined, size: 64, color: Colors.grey),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kSecondaryTextColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: kPrimaryTextColor.withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}

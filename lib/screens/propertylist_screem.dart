import 'package:flutter/material.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/models/property.dart';
import 'package:landsteam/screens/propertydetailsscreen.dart';

class PropertylistScreen extends StatelessWidget {
  PropertylistScreen({super.key, required this.properties, required this.rent});
  final List<Properties> properties;
  bool rent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSurfaceColor,
        elevation: 0,
        title: Text(
          rent ? 'Rentals' : 'Properties',
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
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: properties.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final p = properties[index];
            return PropertyCard(
              property: p,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsScreen(property: p),
                  ),
                );

                // placeholder: open details
              },
            );
          },
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Properties property;
  final VoidCallback? onTap;
  const PropertyCard({required this.property, this.onTap});

  @override
  Widget build(BuildContext context) {
    final priceText = property.price != null
        ? '₹ ${property.price}'
        : (property.toPrice != null ? '₹ ${property.toPrice}' : 'Price N/A');
    final dateText = property.date ?? property.createdAt ?? '';
    final modeText = (property.rent ?? false) ? 'Rent' : 'Sell';
    String modeText2 = (property.residential ?? false)
        ? 'Residential'
        : 'Commercial';
    if (property.residential! && property.rent!) {
      modeText2 = property.sharing!
          ? (modeText2 + '-' + 'Sharing')
          : (modeText2 + '-' + 'Single');
    }
    final title = property.title ?? (property.username ?? 'Property');
    final description =
        (property.description != null && property.description!.isNotEmpty)
        ? property.description!
        : 'No description provided';

    return Material(
      color: kSurfaceColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(property: property),
            ),
          );
        },
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kSurfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 96,
                  height: double.infinity,
                  color: Colors.grey.shade200,
                  child:
                      property.imageurl != null && property.imageurl!.isNotEmpty
                      ? Image.network(
                          property.imageurl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 36,
                              color: Colors.black26,
                            );
                          },
                        )
                      : const Icon(
                          Icons.home_outlined,
                          size: 44,
                          color: Colors.black26,
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // top row: title and tag
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: kPrimaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kSecondaryTextColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            modeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            description,
                            style: TextStyle(
                              color: kPrimaryTextColor.withOpacity(0.8),
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kSecondaryTextColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            modeText2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // bottom row: price, location, date
                    Row(
                      children: [
                        Text(
                          priceText,
                          style: const TextStyle(
                            color: kSecondaryTextColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: kPrimaryTextColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  property.locationName ?? 'Unknown',
                                  style: TextStyle(
                                    color: kPrimaryTextColor.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dateText,
                          style: TextStyle(
                            color: kPrimaryTextColor.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

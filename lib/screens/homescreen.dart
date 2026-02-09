import 'package:flutter/material.dart';
import 'package:landsteam/controllers/authentication_controller.dart';
import 'package:landsteam/screens/addpropertyscreen.dart';
import 'package:landsteam/screens/myproperty_screen.dart';
import 'package:landsteam/screens/myqueryscreen.dart';
import 'package:landsteam/screens/profile_screen.dart';
import 'package:landsteam/screens/queryscreen.dart';
import 'package:provider/provider.dart';
import 'property_search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Define theme colors
  static final kBackgroundColor = Colors.grey[300]!;
  static final kSurfaceColor = Colors.grey[100]!;
  static final kPrimaryTextColor = Color(0xFF2D2D2D);
  static final kSecondaryTextColor = Color(0xFF1A1A1A);

  // static const kBackgroundColor = Color(0xFF1A1A1A); // Softer black
  // static const kSurfaceColor = Color(0xFF2D2D2D); // Light shade of black
  // static final kPrimaryTextColor = Colors.grey[100]!; // Almost white
  // static final kSecondaryTextColor = Colors.grey[300]!; // Light grey

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).getAllLocations();
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invest\nSell your property\nFind your rentals',
                style: TextStyle(
                  fontSize: 35,
                  letterSpacing: 3,
                  wordSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryTextColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _buildBoxButton(
                      context,
                      title: 'Find Rentals',
                      icon: Icons.home_outlined,
                      isLeft: false,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildBoxButton(
                      context,
                      title: 'Buy Property',
                      icon: Icons.business_outlined,
                      isLeft: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStyledButton(
                context,
                'Tell Your Requirement',
                Icons.description_outlined,
              ),
              const SizedBox(height: 20),
              _buildStyledButton(
                context,
                'List Your Properties',
                Icons.add_business_outlined,
              ),
              // const SizedBox(height: 20),
              // _buildStyledButton(
              //   context,
              //   'My Queries',
              //   Icons.note_alt_outlined,
              // ),
              const SizedBox(height: 20),
              _buildStyledButton(context, 'My Profile', Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBoxButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isLeft,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: isLeft ? Colors.white.withOpacity(0.95) : kSurfaceColor,
        border: Border.all(
          color: isLeft ? Colors.white.withOpacity(0.1) : Colors.grey[800]!,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(25),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2),
        //     blurRadius: 15,
        //     offset: const Offset(0, 5),
        //   ),
        // ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            // if (title == 'Buy Property') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertySearchScreen(
                  rent: title != 'Buy Property',
                  // primaryColor: kPrimaryTextColor,
                  // accentColor: kSecondaryTextColor,
                ),
              ),
            );
            // }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: isLeft ? kBackgroundColor : kPrimaryTextColor,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isLeft ? kBackgroundColor : kPrimaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(BuildContext context, String title, IconData icon) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (title == 'List Your Properties') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPropertyScreen()),
              );
            } else if (title == 'Tell Your Requirement') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuerryScreen()),
              );
              // } else if (title == 'My Queries') {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => Myqueryscreen()),
              //   );
            } else if (title == 'My Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            }
            // else {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => QuerryScreen()),
            //   );
            // }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: kSecondaryTextColor, size: 24),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kSecondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

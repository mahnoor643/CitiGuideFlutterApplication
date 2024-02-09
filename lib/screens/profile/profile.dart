import 'package:citi_guide/Constants/constants.dart';
import 'package:citi_guide/screens/Cities/cities.dart';
import 'package:citi_guide/screens/Dashboard/dashboard.dart';
import 'package:citi_guide/screens/SearchScreen/searchScreen.dart';
import 'package:citi_guide/screens/SignOut/signOut.dart';
import 'package:citi_guide/widgets/blueButton.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    bool _isObscured = true;
      int selectedIndex = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //profile design
          Stack(
            children: [
              Container(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/profileScreenAbove.png',
                    fit: BoxFit.cover,
                  )),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 80),
                  child: ClipOval(
                    child: CircleAvatar(
                      radius: 90,
                      backgroundColor: Colors
                          .transparent, // Set background color to transparent if you want to see the border
                      backgroundImage: const AssetImage('assets/images/profile2.png'),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Constants
                                .whiteColor, // Set your desired border color
                            width: 4.0, // Set the width of the border
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //Name Displaying
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Fatima Hadid",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    //mail
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "fatimahadid32@gmail.com",
                          style: TextStyle(
                            color: Constants.greyTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                            const SizedBox(height: 
                            20,),
                
                             //TextFields
                    Row(
                        children: [
                          Icon(
                            Icons.manage_accounts_outlined,
                            color: Constants.greyTextColor,
                            size: 13,
                          ),
                          Text(
                            " Name",
                            style: TextStyle(
                              fontSize: 13,
                              color: Constants.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                            
                            
                            const SizedBox(height: 5,),
                            
                            
                            
                //Email TextField
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0), // Adjust this value for more circular corners
                    color: Constants.whiteColor,
                    border: Border.all(
                      color: Constants.greyTextColor, // Set your desired border color
                      width: 2.0, // Set the width of the border
                    ),
                  ),
                  child: TextField(
                    cursorColor: Constants.greyTextColor,
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      border: InputBorder.none, // Remove the default border
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Handle visibility toggle
                        },
                      ),
                    ),
                    style: TextStyle(
                      color: Constants.greyTextColor,
                    ),
                  ),
                ),
                            
                            const SizedBox(height: 10,),
                    //TextFields
                    Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: Constants.greyTextColor,
                            size: 13,
                          ),
                          Text(
                            " Email",
                            style: TextStyle(
                              fontSize: 13,
                              color: Constants.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                            
                            
                            const SizedBox(height: 5,),
                            
                            
                            
                //Email TextField
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0), // Adjust this value for more circular corners
                    color: Constants.whiteColor,
                    border: Border.all(
                      color: Constants.greyTextColor, // Set your desired border color
                      width: 2.0, // Set the width of the border
                    ),
                  ),
                  child: TextField(
                    cursorColor: Constants.greyTextColor,
                    decoration: InputDecoration(
                      hintText: 'Your email',
                      border: InputBorder.none, // Remove the default border
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Handle visibility toggle
                        },
                      ),
                    ),
                    style: TextStyle(
                      color: Constants.greyTextColor,
                    ),
                  ),
                ),
                            
                            const SizedBox(height: 10,),
                            
                 //TextFields
                    Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Constants.greyTextColor,
                            size: 13,
                          ),
                          Text(
                            " Password",
                            style: TextStyle(
                              fontSize: 13,
                              color: Constants.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                            
                            
                            const SizedBox(height: 5,),
                
                
                
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0), // Adjust this value for more circular corners
                    color: Constants.whiteColor,
                    border: Border.all(
                      color: Constants.greyTextColor, // Set your desired border color
                      width: 2.0, // Set the width of the border
                    ),
                  ),
                  child: TextField(
                    cursorColor: Constants.greyTextColor,
                    decoration: InputDecoration(
                      hintText: 'Your password',
                      border: InputBorder.none, // Remove the default border
                      suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                    ),
                    style: TextStyle(
                      color: Constants.greyTextColor,
                    ),
                    obscureText: _isObscured,
                  ),
                ),
                            
                BlueButton(
                  topBottomPadding: 10,
                  leftRightPadding: 20,
                  widget_: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Text(
                        "Sign out",
                        style: TextStyle(
                          color: Constants.whiteColor,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Constants.whiteColor,
                      ),
                    ],
                  ),
                  OntapFunction: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SignOutScreen()));
                  },
                  topBottomMargin: 20,
                  leftRightMargin: 90)
                
                
                
                
                
                
                
                            
                            
                  ],
                ),
              ),
            ),
          )
        ],
      ),

       // Navigation Bar
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Constants.whiteColor, // Set your border color
            width: 1.0, // Set your border width
          ),
          color: Constants.whiteColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 25)],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Constants.whiteColor,
            color: Constants.greyTextColor,
            activeColor: Constants.whiteColor,
            onTabChange: (index) {
              // Update the selected index
            setState(() {
              selectedIndex = index;
            });
              // Handle tab change
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Dashboard()));
              } else if (index == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CitiesScreen()));
              } else if (index == 2) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()));
              }
            },
                        tabBackgroundGradient: Constants.orangeGradient,
            gap: 8,
            padding: EdgeInsets.all(11),
            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.language, text: "Cities"),
              GButton(icon: Icons.search, text: "Search"),
              GButton(
                  icon: Icons.supervised_user_circle_sharp, text: "Profile"),
            ],
          ),
        ),
      ),
   
    );
  }
}

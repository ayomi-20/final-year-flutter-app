// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(title: Text('Home')),
// body: Center(
// child: Text(
// 'Welcome to the App!',
// style: TextStyle(fontSize: 22),
// ),
// ),
// );
// }
// }


import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Text Controller for Search
  final TextEditingController _searchController = TextEditingController();

  // 🚩 TODO: Replace these lists with data fetched from Dashboard
  // ---------------- MOCK DATA FOR VISUALIZATION ----------------
  
  // List of Categories
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Wildlife',
      'icon': 'assets/images/wildlife_icon.png',
    },
    {
      'title': 'Stays',
      'icon': 'assets/images/stays_icon.png',
    },
    {
      'title': 'Car Hire',
      'icon': 'assets/images/car_hire_icon.png',
    },
    {
      'title': 'Eat & Drink',
      'icon': 'assets/images/eat_and_drink_icon.png',
    },
    {
      'title': 'Certified Tour Guides',
      'icon': 'assets/images/certified_tour_guides_icon.png', // You will add .png/.svg
    },
  ];

  // List of Featured Destinations (Mock data)
  final List<Map<String, String>> _featuredDestinations = [
    {
      'title': 'Savanna Safari',
      'image': 'assets/images/auth_bg.png', // Using existing asset as placeholder
      'price': '\$200',
    },
    {
      'title': 'Mountain Trek',
      'image': 'assets/images/login_bg.png',
      'price': '\$150',
    },
    {
      'title': 'Lake Victoria View',
      'image': 'assets/images/crested-crane.jpg',
      'price': '\$120',
    },
  ];

  // List of Top Experiences (Mock data)
  final List<Map<String, String>> _topExperiences = [
    {
      'title': 'Boat Cruise',
      'image': 'assets/images/forgotpassword_bg.png',
      'rating': '4.8',
    },
    {
      'title': 'Gorilla Tracking',
      'image': 'assets/images/verify_code_bg.png',
      'rating': '5.0',
    },
  ];

  // Search Logic
  void _performSearch() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      // Reset to default if empty
      setState(() {});
      return;
    }
    
    // 🚩 TODO: Connect this to your Dashboard API search endpoint
    // For now, we just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Searching for: $query...')),
    );
    
    // Logic to filter _featuredDestinations would go here:
    // setState(() {
    //   _filteredResults = _featuredDestinations.where((item) => item['title']!.toLowerCase().contains(query)).toList();
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Theme color from your auth screen
    const Color primaryGreen = Color(0xFF0F3B2E);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 253, 232),
      // ---------------- APP BAR (Hidden, custom header in body) ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // Hides default appbar height so we can use custom layout
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Picture (Placeholder, Editable later)
                  GestureDetector(
                    onTap: () {
                      // 🚩 TODO: Implement Image Picker here (e.g., ImagePicker package)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Update Profile Picture clicked')),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey,
                      backgroundImage: null, // Placeholder
                      child: Icon(Icons.person, color: Colors.white, size: 30),
                    ),
                  ),
                  
                  // Hamburger Menu (Clickable)
                  GestureDetector(
                    onTap: () {
                      // 🚩 TODO: Implement Hamburger Menu Logic / Drawer
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Menu Clicked')),
                      );
                    },
                    child: const Icon(Icons.menu, color: primaryGreen, size: 32),
                  ),
                ],
              ),
            ),

            // ---------------- SEARCH SECTION ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore the beauty of Uganda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3B2E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search destinations, experiences...',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 50, // Match TextField height
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: _performSearch,
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- CATEGORIES SECTION ----------------
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3B2E),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                           // 🚩 TODO: Navigate to "All Categories" page
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('See All Categories')),
                          );
                        },
                        child: const Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return GestureDetector(
                        onTap: () {
                          // 🚩 TODO: Navigate to Category Detail Page
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${category['title']}')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              // Category Icon (Placeholder until you add assets)
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  // Uncomment once you have images:
                                  // image: DecorationImage(
                                  //   image: AssetImage("${category['icon']}.png"),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                                child: const Icon(Icons.image, color: Colors.grey), // Placeholder
                              ),
                              const SizedBox(height: 8),
                              Text(
                                category['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F3B2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ---------------- FEATURED DESTINATIONS ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured Destinations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3B2E),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 🚩 TODO: Replace this ListView.builder with data from Dashboard
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _featuredDestinations.length,
                    itemBuilder: (context, index) {
                      final item = _featuredDestinations[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[300],
                          image: DecorationImage(
                            image: AssetImage(item['image']!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item['price']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- TOP EXPERIENCES ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Experiences',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3B2E),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // 🚩 TODO: Replace this ListView.builder with data from Dashboard
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _topExperiences.length,
                    itemBuilder: (context, index) {
                      final item = _topExperiences[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[100],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.asset(
                                item['image']!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F3B2E),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.orange, size: 16),
                                        const SizedBox(width: 5),
                                        Text(
                                          item['rating']!,
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Padding at bottom for Footer
            const SizedBox(height: 20),
          ],
        ),
      ),

      // ---------------- FOOTER (Fixed Bottom Nav) ----------------
      // Note: Use standard icons now. Swap `Icons.home` etc with 
      // Image.asset('assets/images/your_icon.png') when ready.
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFooterItem(
              icon: Icons.home,
              label: 'Home',
              isSelected: true,
            ),
            _buildFooterItem(
              icon: Icons.explore,
              label: 'Explore',
              isSelected: false,
            ),
            _buildFooterItem(
              icon: Icons.book,
              label: 'Bookings',
              isSelected: false,
            ),
            _buildFooterItem(
              icon: Icons.person,
              label: 'Profile',
              isSelected: false,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Footer Items
  Widget _buildFooterItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        // 🚩 TODO: Implement Navigation logic here
        // If Profile -> Go to profile screen
        // If Bookings -> Go to bookings screen
        // etc.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicked on $label')),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF0F3B2E) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFF0F3B2E) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
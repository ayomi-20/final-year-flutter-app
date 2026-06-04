// // import 'package:flutter/material.dart';

// // class HomeScreen extends StatelessWidget {
// //   const HomeScreen({super.key});

// // @override
// // Widget build(BuildContext context) {
// // return Scaffold(
// // appBar: AppBar(title: Text('Home')),
// // body: Center(
// // child: Text(
// // 'Welcome to the App!',
// // style: TextStyle(fontSize: 22),
// // ),
// // ),
// // );
// // }
// // }


// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // Text Controller for Search
//   final TextEditingController _searchController = TextEditingController();

//   // 🚩 TODO: Replace these lists with data fetched from Dashboard
//   // ---------------- MOCK DATA FOR VISUALIZATION ----------------
  
//   // List of Categories
//   final List<Map<String, dynamic>> _categories = [
//     {
//       'title': 'Wildlife',
//       'icon': 'assets/images/wildlife_icon.png',
//     },
//     {
//       'title': 'Stays',
//       'icon': 'assets/images/stays_icon.png',
//     },
//     {
//       'title': 'Car Hire',
//       'icon': 'assets/images/car_hire_icon.png',
//     },
//     {
//       'title': 'Eat & Drink',
//       'icon': 'assets/images/eat_and_drink_icon.png',
//     },
//     {
//       'title': 'Certified Tour Guides',
//       'icon': 'assets/images/certified_tour_guides_icon.png', // You will add .png/.svg
//     },
//   ];

//   // List of Featured Destinations (Mock data)
//   final List<Map<String, String>> _featuredDestinations = [
//     {
//       'title': 'Savanna Safari',
//       'image': 'assets/images/auth_bg.png', // Using existing asset as placeholder
//       'price': '\$200',
//     },
//     {
//       'title': 'Mountain Trek',
//       'image': 'assets/images/login_bg.png',
//       'price': '\$150',
//     },
//     {
//       'title': 'Lake Victoria View',
//       'image': 'assets/images/crested-crane.jpg',
//       'price': '\$120',
//     },
//   ];

//   // List of Top Experiences (Mock data)
//   final List<Map<String, String>> _topExperiences = [
//     {
//       'title': 'Boat Cruise',
//       'image': 'assets/images/forgotpassword_bg.png',
//       'rating': '4.8',
//     },
//     {
//       'title': 'Gorilla Tracking',
//       'image': 'assets/images/verify_code_bg.png',
//       'rating': '5.0',
//     },
//   ];

//   // Search Logic
//   void _performSearch() {
//     String query = _searchController.text.toLowerCase();
//     if (query.isEmpty) {
//       // Reset to default if empty
//       setState(() {});
//       return;
//     }
    
//     // 🚩 TODO: Connect this to your Dashboard API search endpoint
//     // For now, we just show a snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Searching for: $query...')),
//     );
    
//     // Logic to filter _featuredDestinations would go here:
//     // setState(() {
//     //   _filteredResults = _featuredDestinations.where((item) => item['title']!.toLowerCase().contains(query)).toList();
//     // });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Theme color from your auth screen
//     const Color primaryGreen = Color(0xFF0F3B2E);

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 224, 253, 232),
//       // ---------------- APP BAR (Hidden, custom header in body) ----------------
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         toolbarHeight: 0, // Hides default appbar height so we can use custom layout
//       ),
      
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // ---------------- HEADER ----------------
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Profile Picture (Placeholder, Editable later)
//                   GestureDetector(
//                     onTap: () {
//                       // 🚩 TODO: Implement Image Picker here (e.g., ImagePicker package)
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Update Profile Picture clicked')),
//                       );
//                     },
//                     child: const CircleAvatar(
//                       radius: 24,
//                       backgroundColor: Colors.grey,
//                       backgroundImage: null, // Placeholder
//                       child: Icon(Icons.person, color: Colors.white, size: 30),
//                     ),
//                   ),
                  
//                   // Hamburger Menu (Clickable)
//                   GestureDetector(
//                     onTap: () {
//                       // 🚩 TODO: Implement Hamburger Menu Logic / Drawer
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Menu Clicked')),
//                       );
//                     },
//                     child: const Icon(Icons.menu, color: primaryGreen, size: 32),
//                   ),
//                 ],
//               ),
//             ),

//             // ---------------- SEARCH SECTION ----------------
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Explore the beauty of Uganda',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F3B2E),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _searchController,
//                           decoration: InputDecoration(
//                             hintText: 'Search destinations, experiences...',
//                             prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                             filled: true,
//                             fillColor: Colors.grey[100],
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         height: 50, // Match TextField height
//                         decoration: BoxDecoration(
//                           color: primaryGreen,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: TextButton(
//                           onPressed: _performSearch,
//                           child: const Text(
//                             'Next',
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ---------------- CATEGORIES SECTION ----------------
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Categories',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF0F3B2E),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                            // 🚩 TODO: Navigate to "All Categories" page
//                            ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('See All Categories')),
//                           );
//                         },
//                         child: const Text(
//                           'See all',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: primaryGreen,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 SizedBox(
//                   height: 120,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _categories.length,
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     itemBuilder: (context, index) {
//                       final category = _categories[index];
//                       return GestureDetector(
//                         onTap: () {
//                           // 🚩 TODO: Navigate to Category Detail Page
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Selected: ${category['title']}')),
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10),
//                           child: Column(
//                             children: [
//                               // Category Icon (Placeholder until you add assets)
//                               Container(
//                                 width: 60,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(12),
//                                   // Uncomment once you have images:
//                                   // image: DecorationImage(
//                                   //   image: AssetImage("${category['icon']}.png"),
//                                   //   fit: BoxFit.cover,
//                                   // ),
//                                 ),
//                                 child: const Icon(Icons.image, color: Colors.grey), // Placeholder
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 category['title'],
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xFF0F3B2E),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 30),

//             // ---------------- FEATURED DESTINATIONS ----------------
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Featured Destinations',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F3B2E),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   // 🚩 TODO: Replace this ListView.builder with data from Dashboard
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _featuredDestinations.length,
//                     itemBuilder: (context, index) {
//                       final item = _featuredDestinations[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 20),
//                         height: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Colors.grey[300],
//                           image: DecorationImage(
//                             image: AssetImage(item['image']!),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: Stack(
//                           children: [
//                             Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: Container(
//                                 padding: const EdgeInsets.all(15),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.6),
//                                   borderRadius: const BorderRadius.only(
//                                     bottomLeft: Radius.circular(16),
//                                     bottomRight: Radius.circular(16),
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       item['title']!,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       item['price']!,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // ---------------- TOP EXPERIENCES ----------------
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Top Experiences',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF0F3B2E),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   // 🚩 TODO: Replace this ListView.builder with data from Dashboard
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: _topExperiences.length,
//                     itemBuilder: (context, index) {
//                       final item = _topExperiences[index];
//                       return Container(
//                         margin: const EdgeInsets.only(bottom: 20),
//                         height: 120,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: Colors.grey[100],
//                         ),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(16),
//                                 bottomLeft: Radius.circular(16),
//                               ),
//                               child: Image.asset(
//                                 item['image']!,
//                                 width: 120,
//                                 height: 120,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       item['title']!,
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF0F3B2E),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Row(
//                                       children: [
//                                         const Icon(Icons.star, color: Colors.orange, size: 16),
//                                         const SizedBox(width: 5),
//                                         Text(
//                                           item['rating']!,
//                                           style: const TextStyle(color: Colors.grey),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
            
//             // Padding at bottom for Footer
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),

//       // ---------------- FOOTER (Fixed Bottom Nav) ----------------
//       // Note: Use standard icons now. Swap `Icons.home` etc with 
//       // Image.asset('assets/images/your_icon.png') when ready.
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, -5),
//             ),
//           ],
//         ),
//         height: 70,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildFooterItem(
//               icon: Icons.home,
//               label: 'Home',
//               isSelected: true,
//             ),
//             _buildFooterItem(
//               icon: Icons.explore,
//               label: 'Explore',
//               isSelected: false,
//             ),
//             _buildFooterItem(
//               icon: Icons.book,
//               label: 'Bookings',
//               isSelected: false,
//             ),
//             _buildFooterItem(
//               icon: Icons.person,
//               label: 'Profile',
//               isSelected: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper Widget for Footer Items
//   Widget _buildFooterItem({
//     required IconData icon,
//     required String label,
//     required bool isSelected,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         // 🚩 TODO: Implement Navigation logic here
//         // If Profile -> Go to profile screen
//         // If Bookings -> Go to bookings screen
//         // etc.
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Clicked on $label')),
//         );
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? const Color(0xFF0F3B2E) : Colors.grey,
//             size: 24,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: isSelected ? const Color(0xFF0F3B2E) : Colors.grey,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import 'service_detail_screen.dart';
import 'my_bookings_screen.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DashboardService _dashboard = DashboardService();
  final AuthService _auth = AuthService();
  final TextEditingController _searchController = TextEditingController();

  int _selectedIndex = 0;
  Map<String, dynamic> _homeData = {};
  Map<String, dynamic>? _currentUser;
  bool _loading = true;
  String _searchQuery = '';

  static const Color _green = Color(0xFF0F3B2E);
  static const Color _lightGreen = Color(0xFFE3EFE5);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _dashboard.getHomeData(),
      _auth.getUser(),
    ]);
    
    setState(() {
      _homeData  = results[0] as Map<String, dynamic>;
      _currentUser = results[1] as Map<String, dynamic>?;
      _loading   = false;
    });
  }

  List<dynamic> get _categories => _homeData['categories'] ?? [];
  List<dynamic> get _featured   => _homeData['featured']   ?? [];
  List<dynamic> get _topExp     => _homeData['top_experiences'] ?? [];
  List<dynamic> get _reviews    => _homeData['recent_reviews']  ?? [];

  String _getFirstImage(dynamic service) {
  final imgs = service['images'];
  if (imgs is List && imgs.isNotEmpty) {
    return '$kBaseUrl/images/${imgs[0]}';
  }
  return '';
}

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGreen,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _green))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: _green,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  SliverToBoxAdapter(child: _buildCategories()),
                  SliverToBoxAdapter(child: _buildFeatured()),
                  SliverToBoxAdapter(child: _buildTopExperiences()),
                  SliverToBoxAdapter(child: _buildRecentReviews()),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    final firstName = _currentUser?['first_name'] ?? 'Explorer';

    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello, $firstName 👋',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _green,
                      ),
                    ),
                    const Text(
                      'Where to today?',
                      style: TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Notifications bell
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: _green),
                      onPressed: () {},
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: _lightGreen,
                        child: Text(
                          (_currentUser?['first_name'] ?? 'U')[0].toUpperCase(),
                          style: const TextStyle(
                            color: _green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Search ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              onSubmitted: (_) => _doSearch(),
              style: const TextStyle(color: _green, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search destinations, experiences...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _doSearch,
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _doSearch() {
    if (_searchQuery.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryScreen(
          categorySlug: null,
          categoryName: 'Search: "$_searchQuery"',
          searchQuery: _searchQuery,
        ),
      ),
    );
  }

  // ── Categories ─────────────────────────────────────────────────────────
  Widget _buildCategories() {
    if (_categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Categories', onSeeAll: null),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
const color = Color(0xFF0F3B2E);
              return GestureDetector(
             onTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CategoryScreen(
      categorySlug: cat['slug'] as String?,
      categoryName: (cat['name'] ?? 'Category') as String,
    ),
  ),
),
                child: Container(
                width: 90,
                margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(_categoryIcon((cat['slug'] ?? '') as String), color: color, size: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['name'] ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _green,
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
    );
  }

  // ── Featured Destinations ──────────────────────────────────────────────
  Widget _buildFeatured() {
    if (_featured.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Featured Destinations', onSeeAll: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CategoryScreen(
                categorySlug: null,
                categoryName: 'All Featured',
              ),
            ),
          );
        }),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _featured.length,
            itemBuilder: (_, i) {
              final service = _featured[i];
              return _FeaturedCard(
                service: service,
                imageUrl: _getFirstImage(service),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(
                      serviceSlug: service['slug'],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Top Experiences ────────────────────────────────────────────────────
  Widget _buildTopExperiences() {
    if (_topExp.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Top Experiences'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _topExp.length,
          itemBuilder: (_, i) {
            final service = _topExp[i];
            return _ExperienceCard(
              service: service,
              imageUrl: _getFirstImage(service),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceDetailScreen(serviceSlug: service['slug']),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Recent Reviews ─────────────────────────────────────────────────────
  Widget _buildRecentReviews() {
    if (_reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('What Travelers Say'),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _reviews.length,
            itemBuilder: (_, i) {
              final review = _reviews[i];
              return _ReviewCard(review: review);
            },
          ),
        ),
      ],
    );
  }

  // ── Section header helper ──────────────────────────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'IBMPlexSerif',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontFamily: 'IBMPlexSerif',
                  fontSize: 13,
                  color: _green,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Bottom nav ─────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Explore'),
      BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Bookings'),
      BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
    ];

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) {
        setState(() => _selectedIndex = i);
        switch (i) {
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CategoryScreen(
                  categorySlug: null,
                  categoryName: 'Explore All',
                ),
              ),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            break;
        }
      },
      selectedItemColor: _green,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'IBMPlexSerif',
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'IBMPlexSerif',
        fontSize: 11,
      ),
      items: items,
    );
  }

  // ── Icon mapper ────────────────────────────────────────────────────────
  IconData _categoryIcon(String icon) {
  switch (icon) {
    case 'accommodations':      return Icons.hotel_rounded;
    case 'vehicles-for-hire':   return Icons.directions_car_rounded;
    case 'restaurants':         return Icons.restaurant_rounded;
    case 'tour-guides':         return Icons.badge_rounded;
    case 'tourist-destinations': return Icons.landscape_rounded;
    default:                    return Icons.category_rounded;
  }
}
}

// ── Featured Service Card ──────────────────────────────────────────────────
class _FeaturedCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String imageUrl;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.service,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImage(),
                    )
                  : _placeholderImage(),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),

              // Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['title'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexSerif',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 12),
                          Expanded(
                            child: Text(
                              service['location'] ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'UGX ${service['price'] ?? 0}',
                            style: const TextStyle(
                              fontFamily: 'IBMPlexSerif',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7BEB9C),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 12),
                              Text(
                                '${service['average_rating'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Featured badge
              if (service['is_featured'] == true)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3B2E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '⭐ Featured',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFFE3EFE5),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF0F3B2E), size: 40),
      ),
    );
  }
}

// ── Experience Row Card ────────────────────────────────────────────────────
class _ExperienceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final String imageUrl;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.service,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE3EFE5),
                          child: const Icon(Icons.image_outlined,
                              color: Color(0xFF0F3B2E)),
                        ))
                    : Container(
                        color: const Color(0xFFE3EFE5),
                        child: const Icon(Icons.image_outlined,
                            color: Color(0xFF0F3B2E)),
                      ),
              ),
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service['title'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey, size: 12),
                        Expanded(
                          child: Text(
                            service['location'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'UGX ${service['price'] ?? 0}',
                          style: const TextStyle(
                            fontFamily: 'IBMPlexSerif',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F3B2E),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${service['average_rating'] ?? '0.0'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F3B2E),
                              ),
                            ),
                            Text(
                              ' (${service['total_reviews'] ?? 0})',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Review Card ────────────────────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final tourist = review['tourist'] ?? {};
    final name = '${tourist['first_name'] ?? ''} ${tourist['last_name'] ?? ''}'.trim();
    final service = review['service'] ?? {};

    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFE3EFE5),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Color(0xFF0F3B2E),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'IBMPlexSerif',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F3B2E),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          size: 11,
                          color: i < (review['rating'] ?? 0)
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review['body'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
          ),
          const Spacer(),
          Text(
            service['title'] ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF0F3B2E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
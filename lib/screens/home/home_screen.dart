import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:giftcard_wallet/screens/cards/add_edit_card_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giftcard_wallet/utils/brand_config.dart';
import 'package:giftcard_wallet/widgets/giftcard_widget.dart';
import 'package:giftcard_wallet/screens/cards/card_details_screen.dart';
import 'package:giftcard_wallet/screens/notifications/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? "User";

    return Scaffold(
      backgroundColor: const Color(0xFF090B15),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF5823D3),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEditCardScreen(),
              ),
            );
          },
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Hi, ",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: userName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                              const TextSpan(
                                text: " 👋",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          "Good to see you again!",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF171A27),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,

                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase().trim();
                        });
                      },

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Search gift cards...",
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF171A27),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 0),
                ],
              ),

              const SizedBox(height: 24),

              const Row(
                children: [
                  Text(
                    "My Gift Cards",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("giftcards")
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Gift Cards Found",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      );
                    }

                    final cards = snapshot.data!.docs;
                    final filteredCards = cards.where((doc) {
                      final card = doc.data();

                      final brand = (card["brand"] ?? "")
                          .toString()
                          .toLowerCase();

                      final code = (card["code"] ?? "")
                          .toString()
                          .toLowerCase();

                      return brand.contains(searchQuery) ||
                          code.contains(searchQuery);
                    }).toList();

                    if (filteredCards.isEmpty) {
                      return const Center(
                        child: Text(
                          "No matching gift cards found",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      );
                    }

                    return GridView.builder(
                      itemCount: filteredCards.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            childAspectRatio: 1.7,
                          ),

                      itemBuilder: (context, index) {
                        final doc = filteredCards[index];
                        final card = doc.data();

                        return InkWell(
                          borderRadius: BorderRadius.circular(26),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CardDetailsScreen(
                                  card: card,
                                  heroTag: doc.id,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: doc.id,
                            child: Material(
                              type: MaterialType.transparency,
                              child: GiftCardWidget(card: card),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

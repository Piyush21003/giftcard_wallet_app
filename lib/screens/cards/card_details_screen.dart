import 'package:flutter/material.dart';
import 'package:giftcard_wallet/widgets/giftcard_widget.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:giftcard_wallet/screens/cards/add_edit_card_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> card;
  final String heroTag;

  const CardDetailsScreen({
    super.key,
    required this.card,
    required this.heroTag,
  });

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  late Map<String, dynamic> card;

  @override
  void initState() {
    super.initState();
    card = Map<String, dynamic>.from(widget.card);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B15),

      appBar: AppBar(
        backgroundColor: const Color(0xFF090B15),
        iconTheme: const IconThemeData(
          color: Colors.white, // Back arrow color
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Card Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AddEditCardScreen(card: card, documentId: widget.heroTag),
                ),
              );
              await _loadUpdatedCard();
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: _deleteCard,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CARD PREVIEW
              /// CARD PREVIEW
              Hero(
                tag: widget.heroTag,
                child: Material(
                  type: MaterialType.transparency,
                  child: GiftCardWidget(card: card),
                ),
              ),

              const SizedBox(height: 24),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      context,
                      Icons.copy_rounded,
                      "Copy Code",
                      () async {
                        await Clipboard.setData(
                          ClipboardData(text: card["code"] ?? ""),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Card code copied"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _actionButton(
                      context,
                      Icons.lock_outline,
                      "Copy PIN",
                      () async {
                        await Clipboard.setData(
                          ClipboardData(text: card["pin"] ?? ""),
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("PIN copied"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _actionButton(
                      context,
                      Icons.share_outlined,
                      "Share",
                      () {
                        SharePlus.instance.share(
                          ShareParams(
                            text:
                                '''
${card["brand"]} Gift Card

Code: ${card["code"]}

PIN: ${card["pin"]}

Amount: ₹${card["amount"]}

Expiry: ${card["expiry"]}
''',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// CARD INFORMATION
              _sectionTitle(Icons.credit_card, "Card Information"),

              const SizedBox(height: 12),

              _buildInformationCard(),

              const SizedBox(height: 24),

              /// NOTES

              /// QUICK ACTIONS
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: const Color(0xFF141A22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.deepPurpleAccent, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent, size: 22),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _placeholderCard({double height = 180}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
    );
  }

  Future<void> _loadUpdatedCard() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("giftcards")
        .doc(widget.heroTag)
        .get();

    if (!doc.exists) return;

    setState(() {
      card = doc.data()!;
    });
  }

  Widget _buildInformationCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141A22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Brand",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            trailing: Text(
              card["brand"] ?? "-",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text(
              "Card Code",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              card["code"] ?? "-",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text(
              "PIN",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              card["pin"] ?? "-",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(height: 1),
          ListTile(
            title: Text(
              "Expiry",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              card["expiry"] ?? "-",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCard() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171A27),
        title: const Text("Delete Card", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to delete this gift card?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("giftcards")
        .doc(widget.heroTag)
        .delete();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Gift Card Deleted")));

    Navigator.pop(context, true);
  }
}

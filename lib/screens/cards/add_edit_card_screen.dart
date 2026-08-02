import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giftcard_wallet/utils/brand_config.dart';

class AddEditCardScreen extends StatefulWidget {
  final Map<String, dynamic>? card;
  final String? documentId;

  const AddEditCardScreen({super.key, this.card, this.documentId});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  String? selectedBrand = "Amazon";

  bool isOtherBrand = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otherBrandController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardCodeController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  Color selectedColor = const Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();

    if (widget.card != null) {
      final card = widget.card!;

      selectedBrand = card["isCustomBrand"] == true ? "Other" : card["brand"];

      isOtherBrand = card["isCustomBrand"] == true;

      otherBrandController.text = card["isCustomBrand"] == true
          ? card["brand"] ?? ""
          : "";

      amountController.text = card["amount"].toString();

      cardCodeController.text = card["code"] ?? "";

      pinController.text = card["pin"] ?? "";

      expiryController.text = card["expiry"] ?? "";

      selectedColor = Color(
        card["color"] ?? const Color(0xFF8B5CF6).toARGB32(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090B15),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            widget.card == null ? "Add New Card" : "Edit Card",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 28),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Brand",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF171A27),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: DropdownButtonFormField<String>(
                      value: selectedBrand,
                      menuMaxHeight: 300,
                      borderRadius: BorderRadius.circular(22),

                      dropdownColor: const Color(0xFF171A27),

                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                      ),

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),

                      style: const TextStyle(color: Colors.white, fontSize: 16),

                      items:
                          [
                            "Amazon",
                            "Flipkart",
                            "Google Play",
                            "Netflix",
                            "Steam",
                            "Apple",
                            "Swiggy",
                            "Myntra",
                            "PVR",
                            "Other",
                          ].map((brand) {
                            return DropdownMenuItem<String>(
                              value: brand,
                              child: Row(
                                children: [
                                  brand != "Other"
                                      ? SvgPicture.asset(
                                          BrandConfig.logos[brand]!,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                          colorFilter: null,
                                        )
                                      : const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 22,
                                        ),

                                  const SizedBox(width: 12),

                                  Text(
                                    brand,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedBrand = value;
                          isOtherBrand = value == "Other";
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Visibility(
                    visible: isOtherBrand,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Brand Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: otherBrandController,

                          style: const TextStyle(color: Colors.white),

                          decoration: InputDecoration(
                            hintText: "Enter Brand Name",

                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                            ),

                            filled: true,
                            fillColor: const Color(0xFF171A27),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isOtherBrand,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Card Color",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,

                          children: [
                            _buildColorCircle(const Color(0xFF8B5CF6)),
                            _buildColorCircle(Colors.blue),
                            _buildColorCircle(Colors.green),
                            _buildColorCircle(Colors.orange),
                            _buildColorCircle(Colors.red),
                            _buildColorCircle(Colors.black),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Amount (₹)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,

                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: "Enter Amount",

                      prefixText: "₹ ",
                      prefixStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),

                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),

                      filled: true,
                      fillColor: const Color(0xFF171A27),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Card Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: cardCodeController,

                    style: const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: "Enter Gift Card Code",

                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),

                      filled: true,
                      fillColor: const Color(0xFF171A27),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: pinController,

                    style: const TextStyle(color: Colors.white),

                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                      hintText: "Enter PIN",

                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),

                      filled: true,
                      fillColor: const Color(0xFF171A27),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Expiry Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: expiryController,
                    readOnly: true,

                    style: const TextStyle(color: Colors.white),

                    onTap: _selectExpiryDate,

                    decoration: InputDecoration(
                      hintText: "Select Expiry Date",

                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),

                      suffixIcon: const Icon(
                        Icons.calendar_month,
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

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 56,

                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedBrand == null) {
                          _showMessage("Please select a brand");
                          return;
                        }

                        if (amountController.text.trim().isEmpty) {
                          _showMessage("Please enter amount");
                          return;
                        }

                        if (cardCodeController.text.trim().isEmpty) {
                          _showMessage("Please enter card code");
                          return;
                        }

                        if (pinController.text.trim().isEmpty) {
                          _showMessage("Please enter PIN");
                          return;
                        }

                        if (expiryController.text.trim().isEmpty) {
                          _showMessage("Please select expiry date");
                          return;
                        }

                        if (isOtherBrand &&
                            otherBrandController.text.trim().isEmpty) {
                          _showMessage("Please enter brand name");
                          return;
                        }

                        await _saveCard();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5823D3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      child: Text(
                        widget.card == null ? "Save Card" : "Update Card",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        expiryController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/"
            "${pickedDate.month.toString().padLeft(2, '0')}/"
            "${pickedDate.year}";
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

Future<void> _saveCard() async {
  try {
    final user = auth.currentUser;

    if (user == null) {
      _showMessage("User not logged in");
      return;
    }

    final cardData = {
      "brand": isOtherBrand
          ? otherBrandController.text.trim()
          : selectedBrand,

      "isCustomBrand": isOtherBrand,

      "color": selectedColor.toARGB32(),

      "amount": int.parse(amountController.text.trim()),

      "code": cardCodeController.text.trim(),

      "pin": pinController.text.trim(),

      "expiry": expiryController.text.trim(),
    };

    if (widget.documentId == null) {
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("giftcards")
          .add({
            ...cardData,
            "createdAt": FieldValue.serverTimestamp(),
          });

      _showMessage("Gift Card Saved Successfully");
    } else {
      await firestore
          .collection("users")
          .doc(user.uid)
          .collection("giftcards")
          .doc(widget.documentId)
          .update(cardData);

      _showMessage("Gift Card Updated Successfully");
    }

    Navigator.pop(context);
  } catch (e) {
    _showMessage(e.toString());
  }
}

  @override
  void dispose() {
    otherBrandController.dispose();
    amountController.dispose();
    cardCodeController.dispose();
    pinController.dispose();
    expiryController.dispose();
    super.dispose();
  }
}

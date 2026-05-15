import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const BookingScreen({
    super.key,
    required this.service,
  });

  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();
}

class _BookingScreenState
    extends State<BookingScreen> {

  final BookingService _bookingService =
      BookingService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController personsController =
      TextEditingController(text: "1");

  final TextEditingController notesController =
      TextEditingController();

  bool _loading = false;

  static const Color green =
      Color(0xFF0F3B2E);

  Future<void> submitBooking() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {

      final response =
          await _bookingService.createBooking({

        "service_id":
            widget.service["id"].toString(),

        "persons":
            personsController.text,

        "notes":
            notesController.text,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"] ??
                "Booking created successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        _loading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFE3EFE5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Book Service",
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme:
            const IconThemeData(color: green),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // SERVICE CARD
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      widget.service["title"] ?? "",

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "UGX ${widget.service["price"] ?? 0}",

                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // PERSONS
              TextFormField(
                controller: personsController,

                keyboardType:
                    TextInputType.number,

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {

                    return "Enter number of persons";
                  }

                  return null;
                },

                decoration: InputDecoration(
                  labelText: "Number of Persons",

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // NOTES
              TextFormField(
                controller: notesController,

                maxLines: 4,

                decoration: InputDecoration(
                  labelText: "Additional Notes",

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),

                  onPressed:
                      _loading ? null : submitBooking,

                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Confirm Booking",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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
}
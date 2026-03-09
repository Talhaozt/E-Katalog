import 'package:e_katalog/models/saved_card_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => AddCardScreenState();
}

class AddCardScreenState extends State<AddCardScreen> {
  final formKey = GlobalKey<FormState>();
  final holderController = TextEditingController();
  final numberController = TextEditingController();
  final expiryMonthController = TextEditingController();
  final expiryYearController = TextEditingController();

  @override
  void dispose() {
    holderController.dispose();
    numberController.dispose();
    expiryMonthController.dispose();
    expiryYearController.dispose();
    super.dispose();
  }

  void _saveCard() {
    if (!formKey.currentState!.validate()) return;

    final card = SavedCard(
      id: const Uuid().v4(),
      holderName: holderController.text.trim(),
      cardNumber: numberController.text.replaceAll(' ', ''),
      expiryMonth: expiryMonthController.text.trim(),
      expiryYear: expiryYearController.text.trim(),
    );

    Navigator.pop(context, card);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Kart Ekle",
        style: TextStyle(
          fontWeight: .bold,
          fontSize: 30,
        ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: holderController,
                  decoration: const InputDecoration(
                    labelText: "Kart Üzerindeki İsim",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Lütfen isim girin";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Kart Numarası",
                    hintText: "XXXX XXXX XXXX XXXX",
                  ),
                  validator: (value) {
                    final cleaned = (value ?? "").replaceAll(' ', '');
                    if (cleaned.length < 12) {
                      return "Geçerli bir kart numarası girin";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: expiryMonthController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Ay",
                          hintText: "MM",
                        ),
                        validator: (value) {
                          final v = int.tryParse(value ?? "");
                          if (v == null || v < 1 || v > 12) {
                            return "1-12 arası ay";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: expiryYearController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Yıl",
                          hintText: "YY",
                        ),
                        validator: (value) {
                          if (value == null || value.length < 2) {
                            return "Yıl girin";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveCard,
                    child: const Text("Kartı Kaydet"),
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


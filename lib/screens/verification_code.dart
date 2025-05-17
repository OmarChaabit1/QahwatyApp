import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController _pinController = TextEditingController();
  int _secondsRemaining = 60;
  Timer? _timer;

  final String phoneNumber = '+212628080697';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _verifyCode() {
    final code = _pinController.text.trim();
    if (code.length == 6) {
      _showDialog('Succès', 'Code vérifié avec succès.');
    } else {
      _showDialog('Erreur', 'Veuillez saisir un code de 6 chiffres.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/coffe_project/logo.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Saissez le code de\nconfirmation reçu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Un code de 6 chiffres a été envoyé au',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // logic to change number
                    },
                    child: const Text(
                      'Change',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'coffe_project/whatsapp.png', // Add this WhatsApp icon to your assets
                    height: 20,
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // sssf
              Pinput(
                controller: _pinController,
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _secondsRemaining > 0
                    ? 'Vous pouvez renvoyer le code dans $_secondsRemaining secondes'
                    : 'Renvoyer le code maintenant',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 177, 127, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'CONFIRMÉ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
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

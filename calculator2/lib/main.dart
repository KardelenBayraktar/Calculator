import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // İlk sayı
  String operand = ""; // İşlem operatörü
  String number2 = ""; // İkinci sayı

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'), // AppBar'a başlık eklendi
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Çıkış ekranı
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            // Butonlar
            Wrap(
              children: [
                "7", "8", "9", "/",
                "4", "5", "6", "*",
                "1", "2", "3", "-",
                "C", "0", ".", "+",
                "DEL", "√", "!", "=" // DEL ve = yer değiştirdi
              ].map(
                    (value) => SizedBox(
                  width: screenSize.width / 4,
                  height: screenSize.width / 5,
                  child: buildButton(value),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ######## Buton Fonksiyonları ########
  void onBtnTap(String value) {
    if (value == "C") {
      clearAll();
    } else if (value == "DEL") {
      delete();
    } else if (value == "=") {
      calculate();
    } else if (value == "√") {
      calculateSquareRoot();
    } else if (value == "!") {
      calculateFactorial();
    } else {
      appendValue(value);
    }
  }

  // İşlemi hesaplama
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    double result = 0;

    switch (operand) {
      case "+":
        result = num1 + num2;
        break;
      case "-":
        result = num1 - num2;
        break;
      case "*":
        result = num1 * num2;
        break;
      case "/":
        result = num1 / num2;
        break;
    }

    setState(() {
      number1 = result.toStringAsPrecision(3);
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  // Faktöriyel hesaplama
  void calculateFactorial() {
    if (operand.isNotEmpty || number2.isNotEmpty || number1.isEmpty) return;

    final int num = int.tryParse(number1) ?? 0;
    if (num < 0) return;

    setState(() {
      number1 = factorial(num).toString();
      operand = "";
      number2 = "";
    });
  }

  // Karekök hesaplama
  void calculateSquareRoot() {
    if (operand.isNotEmpty || number2.isNotEmpty || number1.isEmpty) return;

    final double num = double.tryParse(number1) ?? 0.0;
    if (num < 0) return;

    setState(() {
      number1 = sqrt(num).toStringAsPrecision(3);
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  // Temizle
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // Son karakteri sil
  void delete() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = "";
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  // Buton basımlarını ekle
  void appendValue(String value) {
    if (value == "." && ((number1.isEmpty && number2.isEmpty) || operand.isEmpty)) {
      value = "0.";
    }

    if (["+", "-", "*", "/"].contains(value)) {
      if (operand.isEmpty) {
        operand = value;
      }
    } else if (operand.isEmpty) {
      number1 += value;
    } else {
      number2 += value;
    }

    setState(() {});
  }

  // Faktöriyel hesaplama fonksiyonu
  int factorial(int number) {
    if (number <= 1) return 1;
    return number * factorial(number - 1);
  }

  // Button colors
  Color getBtnColor(String value) {
    if (["C", "DEL"].contains(value)) {
      return Colors.pinkAccent;
    } else if (["+", "-", "*", "/", "=", "√", "!"].contains(value)) {
      return Colors.purpleAccent;
    }
    return Colors.black87;
  }
}



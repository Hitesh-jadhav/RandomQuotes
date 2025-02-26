import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(RandomQuotesApp());
}

class RandomQuotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quotes',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String? quote;
  bool isLoading = false;

  Future<void> fetchQuote() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('https://api.adviceslip.com/advice'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => quote = data['slip']['advice']);
      } else {
        setState(() => quote = 'Failed to fetch quote. Try again!');
      }
    } catch (e) {
      setState(() => quote = 'Error fetching quote. Check your connection.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Quotes')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      quote ?? 'Tap the button for a quote!',
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchQuote,
                child: Text('Get Quote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:OOHLIVETV_iptv/services/storage.dart';
import 'package:OOHLIVETV_iptv/services/Formatting.dart';
import 'package:OOHLIVETV_iptv/pages/home pages/channellistpage.dart';
import 'package:OOHLIVETV_iptv/pages/home pages/favoritespage.dart';
import 'package:OOHLIVETV_iptv/pages/home%20pages/contactpage.dart';
import 'package:OOHLIVETV_iptv/GlobalWidgets/RandomImageBanner.dart'; // Update path based on file location

final random = Random(); // Global random object

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.storage,
    required this.formattingProvider,
  });

  final StorageProvider storage;
  final FormattingProvider formattingProvider;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  late StorageProvider storage;
  late FormattingProvider formattingProvider;

  int _selectedIndex = 1;
  bool _isBannerVisible = true; // New state variable

  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _closeBanner() {
    setState(() => _isBannerVisible = false);
  } // New method to hide banner

  @override
  void initState() {
    super.initState();
    storage = widget.storage;
    formattingProvider = formattingProvider;
    _pages = <Widget>[
      const ContactPage(),
      ChannelListPage(
        storage: storage,
        formattingProvider: formattingProvider,
      ),
      FavoritesPage(
        storage: storage,
        formattingProvider: formattingProvider,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digilog TV'),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
      ),
      body: Stack(
        children: [
          // Position the ModalBarrier and Banner together
          if (_isBannerVisible) ... [
            ModalBarrier(
              color: Colors.black.withOpacity(0.7), // adjust opacity as needed
              dismissible: false, // prevents accidental dismissal by tapping behind
            ),
            WillPopScope(
              onWillPop: () async => false, // prevents closing by back button
              child: Center(
                child: RandomImageBanner(
                  onClose: _closeBanner, // Updated to use the defined 'onClose' parameter
                ),
              ),
            ),
          ],
          // Place the selected page below (only visible when banner is hidden)
          if (!_isBannerVisible) ... [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _pages.elementAt(_selectedIndex),
            ),
          ],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.indigo[900],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Contact Me',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reorder),
              label: 'Channel List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Favorites',
            ),
          ]),
    );
  }
}

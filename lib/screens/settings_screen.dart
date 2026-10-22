import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';
import 'package:southsea_cinema/models/user_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  bool _receiveNewsletter = false;
  String _confirmationMessage = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(appTitle, style: cinemaHeaderStyle),
        ),
        drawer: const NavDrawer(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'My Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Address',
                style: TextStyle(
                  color: cinemaFontMuted,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Delivery address',
                  hintText: 'Enter delivery address',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Email Address',
                style: TextStyle(
                  color: cinemaFontMuted,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email address',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Preferences',
                style: TextStyle(
                  color: cinemaFontMuted,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Text('Receive news by email')),
                  Switch(
                    value: _receiveNewsletter,
                    onChanged: (bool value) {
                      setState(() {
                        _receiveNewsletter = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cinemaSurface,
                        foregroundColor: cinemaFontWhite,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('CANCEL')),
                  const SizedBox(width: 12),
                  PrimaryButton(
                      label: 'SAVE SETTINGS', onPressed: _saveSettings)
                ],
              ),
              if (_confirmationMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _confirmationMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 16),
            ])));
  }

  void _saveSettings() {
    final String name = _nameController.text.trim();
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();

    final UserSettings settings = UserSettings(
      name: name,
      address: address,
      email: email,
      receiveNewsletter: _receiveNewsletter,
    );

    setState(() {
      _confirmationMessage = 'Settings saved for ${settings.name}';
    });
  }
}

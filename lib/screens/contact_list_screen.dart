import 'package:flutter/material.dart';
import 'package:contact_app/database/database_helper.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/screens/add_contact_screen.dart';
import 'package:contact_app/screens/contact_details_screen.dart';
import 'package:contact_app/screens/favorites_screen.dart';
import 'package:contact_app/screens/settings_screen.dart';
import 'package:contact_app/screens/about_screen.dart';
import 'package:contact_app/widgets/contact_tile.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final db = DatabaseHelper();
    final contacts = await db.getAllContacts(); // adjust method name if needed
    setState(() {
      _contacts = contacts;
      _filteredContacts = contacts;
    });
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _contacts;
      } else {
        _filteredContacts = _contacts
            .where(
              (contact) =>
                  contact.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _focusSearch() {
    _searchFocusNode.requestFocus();
  }

  void _clearSearch() {
    _searchController.clear();
    _filterContacts('');
    _searchFocusNode.unfocus();
  }

  void _logout() {
    // Show a confirmation dialog or handle logout logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Add your logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contacts'),
        actions: [
          // Search icon – focuses the search field below
          IconButton(icon: const Icon(Icons.search), onPressed: _focusSearch),
          // Settings icon
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      // Drawer exactly like your screenshot
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(color: Colors.teal),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'My Contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage your friends easily',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('My Contacts'),
              onTap: () =>
                  Navigator.pop(context), // close drawer, already on home
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddContactScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar below the AppBar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade50,
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          // Contact list
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.contacts, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No contacts yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add your first contact by tapping the + button below.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                      return ContactTile(
                        contact: contact,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ContactDetailsScreen(contact: contact),
                            ),
                          );
                          _loadContacts();
                        },
                        onFavoriteToggle: () async {
                          final db = DatabaseHelper();
                          final updated = Contact(
                            id: contact.id,
                            name: contact.name,
                            phoneNumber: contact.phoneNumber,
                            email: contact.email,
                            address: contact.address,
                            isFavorite: !contact.isFavorite,
                          );
                          await db.updateContact(updated);
                          _loadContacts();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
          _loadContacts();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

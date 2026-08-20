import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contact.dart';
import '../widgets/contact_tile.dart';
import 'contact_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Contact> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await _db.getFavoriteContacts();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final contact = _favorites[index];
                return ContactTile(
                  contact: contact,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            ContactDetailsScreen(contact: contact),
                      ),
                    ).then((_) => _loadFavorites());
                  },
                  onFavoriteToggle: () => _toggleFavorite(contact),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No favorite contacts',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Mark contacts as favorite to see them here.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(Contact contact) async {
    final updatedContact = Contact(
      id: contact.id,
      name: contact.name,
      phoneNumber: contact.phoneNumber,
      email: contact.email,
      address: contact.address,
      isFavorite: !contact.isFavorite,
    );
    await _db.updateContact(updatedContact);
    await _loadFavorites();
  }
}

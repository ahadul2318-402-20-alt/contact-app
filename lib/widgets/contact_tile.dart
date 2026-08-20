import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ContactTile({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: contact.isFavorite
              ? Colors.red.shade100
              : Colors.teal.shade100,
          child: Text(
            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: contact.isFavorite ? Colors.red.shade700 : Colors.teal.shade700,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                contact.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (contact.isFavorite)
              const Icon(Icons.star, color: Colors.amber, size: 18),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.phoneNumber.isNotEmpty)
              Text(
                contact.phoneNumber,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            if (contact.email.isNotEmpty)
              Text(
                contact.email,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            contact.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: contact.isFavorite ? Colors.red : Colors.grey.shade400,
          ),
          onPressed: onFavoriteToggle,
          tooltip: contact.isFavorite ? 'Remove from favorites' : 'Add to favorites',
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
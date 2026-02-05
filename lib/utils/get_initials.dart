String getInitials(String? name) {
  if (name == null || name.isEmpty) {
    return '??';
  }
  List<String> nameParts = name.trim().split(' ').where((part) => part.isNotEmpty).toList();
  if (nameParts.length > 1) {
    return nameParts[0][0].toUpperCase() + nameParts.last[0].toUpperCase();
  } else if (name.length >= 2) {
    return name.substring(0, 2).toUpperCase();
  } else {
    return name.toUpperCase();
  }
}
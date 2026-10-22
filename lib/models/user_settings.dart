class UserSettings {
  final String name;
  final String address;
  final String email;
  final bool receiveNewsletter;
  final String patreonNumber;

  const UserSettings({
    this.name = '',
    this.address = '',
    this.email = '',
    this.receiveNewsletter = false,
    this.patreonNumber = '',
  });
}

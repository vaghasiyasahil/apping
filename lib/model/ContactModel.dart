import 'dart:typed_data';

class Contact {
  final String id;
  final String displayName;
  final Uint8List? photo;
  final Uint8List? thumbnail;
  final Name name;
  final List<Phone> phones;
  final List<Email> emails;
  final List<Address> addresses;
  final List<Organization> organizations;
  final List<Website> websites;
  final List<SocialMedia> socialMedias;
  final List<Event> events;
  final List<Note> notes;
  final List<Group> groups;

  Contact({
    required this.id,
    required this.displayName,
    this.photo,
    this.thumbnail,
    required this.name,
    required this.phones,
    required this.emails,
    required this.addresses,
    required this.organizations,
    required this.websites,
    required this.socialMedias,
    required this.events,
    required this.notes,
    required this.groups,
  });
}

class Name {
  final String first;
  final String last;

  Name({
    required this.first,
    required this.last,
  });
}

class Phone {
  final String number;
  final PhoneLabel label;

  Phone({
    required this.number,
    required this.label,
  });
}

enum PhoneLabel { mobile, home, work, other }

class Email {
  final String address;
  final EmailLabel label;

  Email({
    required this.address,
    required this.label,
  });
}

enum EmailLabel { personal, work, other }

class Address {
  final String address;
  final AddressLabel label;

  Address({
    required this.address,
    required this.label,
  });
}

enum AddressLabel { home, work, other }

class Organization {
  final String company;
  final String title;

  Organization({
    required this.company,
    required this.title,
  });
}

class Website {
  final String url;
  final WebsiteLabel label;

  Website({
    required this.url,
    required this.label,
  });
}

enum WebsiteLabel { personal, company, portfolio, other }

class SocialMedia {
  final String userName;
  final SocialMediaLabel label;

  SocialMedia({
    required this.userName,
    required this.label,
  });
}

enum SocialMediaLabel { facebook, twitter, instagram, linkedin, other }

class Event {
  final int? year;
  final int month;
  final int day;
  final EventLabel label;

  Event({
    this.year,
    required this.month,
    required this.day,
    required this.label,
  });
}

enum EventLabel { birthday, anniversary, other }

class Note {
  final String note;

  Note({
    required this.note,
  });
}

class Group {
  final String id;
  final String name;

  Group({
    required this.id,
    required this.name,
  });
}

import 'package:apping/controller/allData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  late Stream<List<Contact>> contactStream;
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contactStream = getContactStream();
    searchController.addListener(_filterContacts);
  }

  void _filterContacts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = allContacts.where((contact) {
        String fullName = '${contact.name.first} ${contact.name.last}'.toLowerCase();
        String phoneNumber = contact.phones.isNotEmpty ? contact.phones[0].number.replaceAll(' ', '').toLowerCase() : '';
        return fullName.contains(query) || phoneNumber.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: allData.bgAppColor,
      appBar: AppBar(
        backgroundColor: allData.bgAppColor,
        title: TextField(
          cursorColor: Colors.white,
          controller: searchController,
          style: TextStyle(color: allData.textWhiteColor),
          decoration: InputDecoration(
            hintText: "Search contacts...",
            hintStyle: TextStyle(color: allData.hintTextGreyColor),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: allData.hintTextGreyColor),
          ),
        ),
      ),
      body: StreamBuilder<List<Contact>>(
        stream: contactStream,
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(width: 100, 'assets/lottie/loaddata.json'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Contact Found",
                style: TextStyle(color: allData.hintTextGreyColor),
              ),
            );
          } else {
            allContacts = snapshot.data!;
            if (searchController.text.isEmpty) {
              filteredContacts = allContacts;
            }

            return ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: contact.thumbnail != null
                        ? MemoryImage(contact.thumbnail!)
                        : null,
                    child: contact.thumbnail == null
                        ? Icon(Icons.account_circle,
                        size: 35, color: allData.bgAppColor)
                        : null,
                  ),
                  title: Text(
                    "${contact.name.first} ${contact.name.last}",
                    maxLines: 1,
                  ),
                  titleTextStyle: TextStyle(
                    color: allData.textWhiteColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle: Text(contact.phones.isNotEmpty
                      ? contact.phones[0].number
                      : "No number"),
                  subtitleTextStyle: TextStyle(
                    color: allData.textWhiteColor,
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      try {
                        await launchUrl(
                            Uri.parse('tel:${contact.phones[0].number}'));
                      } catch (e) {
                        Get.snackbar("Error", "Something Went Wrong!!",
                            colorText: Colors.red);
                      }
                    },
                    icon: Icon(Icons.call, color: Colors.white),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Stream<List<Contact>> getContactStream() async* {
    await FlutterContacts.requestPermission();
    final contacts = await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
    yield contacts;
  }
}

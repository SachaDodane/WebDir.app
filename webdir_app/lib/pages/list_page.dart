import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/person.dart';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final List<Person> persons;

  ListPage({required this.persons});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Person> filteredPersons;
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedDepartments = [];
  bool _isSearching = false;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    filteredPersons = widget.persons;
    _searchController.addListener(_filterPersons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPersons() {
    final query = _searchController.text.toLowerCase();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredPersons = widget.persons.where((person) {
          final matchesQuery = query.isEmpty ||
              person.firstName.toLowerCase().contains(query) ||
              person.lastName.toLowerCase().contains(query) ||
              person.email.toLowerCase().contains(query) ||
              person.phoneNumber.toLowerCase().contains(query) ||
              person.department.toLowerCase().contains(query);

          final matchesDepartment = _selectedDepartments.isEmpty ||
              _selectedDepartments.contains(person.department);

          return matchesQuery && matchesDepartment;
        }).toList();
        _sortPersons();
      });
    });
  }

  void _toggleDepartmentFilter(String department) {
    setState(() {
      if (_selectedDepartments.contains(department)) {
        _selectedDepartments.remove(department);
      } else {
        _selectedDepartments.add(department);
      }
      _filterPersons();
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedDepartments.clear();
      _filterPersons();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      filteredPersons = widget.persons;
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortPersons();
    });
  }

  void _sortPersons() {
    filteredPersons.sort((a, b) {
      final comparison = a.firstName.compareTo(b.firstName);
      return _isAscending ? comparison : -comparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            'SAE WebDirectory App',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isAscending ? Icons.sort_by_alpha : Icons.sort_by_alpha,
              color: Colors.white,
            ),
            onPressed: _toggleSortOrder,
          ),
          if (!_isSearching)
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                icon: Icon(Icons.search, size: 30, color: Colors.white),
                onPressed: _startSearch,
              ),
            ),
          if (_isSearching)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          if (_isSearching)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: _stopSearch,
            ),
        ],
        bottom: !_isSearching
            ? PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: SizedBox(height: 20.0),
        )
            : null,
      ),
      body: Column(
        children: [
          if (_selectedDepartments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Expanded(
                    child: Text(
                      'Filters: ${_selectedDepartments.join(', ')}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: _clearFilters,
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPersons.length,
              itemBuilder: (context, index) {
                final person = filteredPersons[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: person.imageUrl != null
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(person.imageUrl!),
                      )
                          : null,
                      title: Text(
                        '${person.firstName} ${person.lastName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.department,
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            person.phoneNumber,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(person: person),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showDepartmentFilterDialog(context);
        },
        child: Icon(Icons.filter_list, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showDepartmentFilterDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              title: Text('Filter by Department', style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: widget.persons
                      .map((person) => person.department)
                      .toSet()
                      .map((department) {
                    return CheckboxListTile(
                      title: Text(department, style: TextStyle(color: Colors.white)),
                      value: _selectedDepartments.contains(department),
                      onChanged: (bool? value) {
                        setState(() {
                          _toggleDepartmentFilter(department);
                        });
                      },
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Done', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

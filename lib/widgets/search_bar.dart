import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const CustomSearchBar({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Buscar ciudad...',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              onSearch(_controller.text);
              _controller.clear();
              FocusScope.of(context).unfocus(); 
            },
          ),
        ),
        onSubmitted: (text) {
          onSearch(text);
          _controller.clear();
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
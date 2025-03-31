import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({required this.onSearch});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.onSearch(_controller.text);
              _controller.clear();
              FocusScope.of(context).unfocus(); // Oculta el teclado
            },
          ),
        ),
        onSubmitted: (text) {
          widget.onSearch(text);
          _controller.clear();
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
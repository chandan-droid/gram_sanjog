import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.onSearch,
    this.hintText = 'Search...',
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _showClearButton = false; //initially don't show clear button

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showClearButton = _controller.text.isNotEmpty; //show clear button only when there is text in search bar
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (widget.onSearch != null) {
      widget.onSearch!(_controller.text);
    }
    FocusScope.of(context).unfocus(); //hiding keyboard
  }

  void _clearSearch() {
    _controller.clear();
    if (widget.onSearch != null) {
      widget.onSearch!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                isDense: true,
              ),
              onSubmitted: (_) => _onSearch(),
            ),
          ),
          if (_showClearButton)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }
}
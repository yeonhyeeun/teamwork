import 'package:flutter/material.dart';
import 'package:teamwork/color/color.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  SearchBarWidget({required this.onSearch});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 55,
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: '이번학기 내 전공 과목 검색하기',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: CustomColor.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: CustomColor.blue),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              widget.onSearch(_textEditingController.text);
              FocusScope.of(context).unfocus(); // Close the keyboard
            },
            icon: Icon(Icons.search, color: CustomColor.blue),
          ),
        ),
      ),
    );
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>>? fetchedData;
  bool isDataFetched = false;

  void _fetchDataAndSetState() async {
    try {
      List<Map<String, dynamic>> data = await fetchPosts();
      setState(() {
        fetchedData = data;
        isDataFetched = true;
      });
    } catch (e) {
      // Handle error
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: fetchedData?.length ?? 0,
      itemBuilder: (context, index) => _buildCard(index),
    );
  }

  Widget _buildCard(int index) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          fetchedData![index]['title'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(fetchedData![index]['body']),
        onTap: () => _onItemTap(index),
      ),
    );
  }

  void _onItemTap(int index) {
    final snackBar = SnackBar(
      content: Text('You clicked: ${fetchedData![index]['title']}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
          child: isDataFetched ? _buildListView() : const Center(child: Text("Click the button to load data"))
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await isConnected()) {
            _fetchDataAndSetState();
          } else {
            showNoInternetDialog(context);
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

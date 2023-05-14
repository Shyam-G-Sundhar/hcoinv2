import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget child;

  ConnectivityWidget({required this.child});

  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.child : _buildNoInternetWidget();
  }

  Widget _buildNoInternetWidget() {
    return Container(
      child: Center(
        child: Text('Internet not available'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'tcpudp.dart';
//import 'websockettest.dart';
//import 'websockettest2.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'socket',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'test socket client(tcp/udp)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _message;
  String debug_str = "debug: []";
  String send_str = "send: []";
  String recv_str = "recv: []";
  //bool kIsWeb = identical(0, 0.0);
  IOWebSocketChannel _channel;

  void _sendHandle() {
    if (_message != null) {
        setState(() {debug_str = "debug: [11 $_channel]";});
      if (_channel == null){
        _channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
        //_channel = WebSocketChannel.connect(Uri.parse("ws://echo.websocket.org"));
        //_channel = WebSocketChannel.connect(Uri.parse("ws://i.aganzai.com:8240"));
        _channel.stream.listen((message) {
          setState(() {recv_str = "recv: [$message]";});
        });
      }
      _channel.sink.add(_message);
      setState(() {send_str = "send: [$_message]";});
    }else{
      setState(() {debug_str = "debug: [22]";});
    }
  }

  void _onChangedHandle(value) {
    setState(() {
      _message = value.toString();
    });
  }
  
  void _tcptest() {
    ClientTest p = new ClientTest();
    p.tcp();
    _incrementCounter();
  }
  
  void _udptest() {
    ClientTest p = new ClientTest();
    p.udp();
    _incrementCounter();
  }
  
  void _wstest() {
    ClientTest p = new ClientTest();
    p.ws();
    _incrementCounter();
  }

  void _incrementCounter() {
    setState(() {
      _counter+=2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(onChanged: _onChangedHandle),
            RaisedButton(child: Text('send'), onPressed: _sendHandle),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text('$debug_str'),
            Text('$send_str'),
            Text('$recv_str'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MaterialButton(color: Colors.blue,
            textColor: Colors.white,
            child: new Text('udp'),
            onPressed: _udptest,
          ),
          SizedBox(
            /* */
            height: 2,
          ),
          MaterialButton(color: Colors.blue,
            textColor: Colors.white,
            child: new Text('tcp'),
            onPressed: _tcptest,
          ),
          SizedBox(
            /* */
            height: 2,
          ),
          MaterialButton(color: Colors.blue,
            textColor: Colors.white,
            child: new Text('ws'),
            onPressed: _wstest,
          ),
       ]
  )
    );
  }
}

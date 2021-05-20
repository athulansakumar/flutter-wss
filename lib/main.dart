import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  var channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));

  channel.stream.listen((message) {
    // channel.sink.add('received!');
    print(message);
  });

  runApp(MyApp(channel: channel));
  // channel.sink.close(3000);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  MyApp({required this.channel}) : super();
  WebSocketChannel channel;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', channel: channel),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.channel})
      : super(key: key);
  WebSocketChannel channel;
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState(channel: channel);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({required this.channel}) : super();
  WebSocketChannel channel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _date = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Date',
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                onDateSelected: (DateTime value) {
                  print(value);
                  setState(() {
                    _date = value.toString();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      channel.sink.add(_date);
                    }
                  },
                  child: const Center(child: Text('Submit')),
                ),
              ),
              Text(_date),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:convert';

class ClientTest {
  String _privateString = "private";
  String publicString = "public";
  String tcpString = "";
  String udpString = "";
  void tcp() async {
    print("tcp demo");
    Socket socket = await Socket.connect('i.aganzai.com', 4041, timeout: Duration(seconds: 5));
    socket.listen((List<int> event) {
      tcpString = utf8.decode(event);
      print(tcpString);
    });
    socket.add(utf8.encode('hello_tcp'));
    //tcpString = await socket.transform(utf8.decoder).join();
    //await socket.close();
    await Future.delayed(Duration(seconds: 5));
    socket.close();
    print(tcpString);
  }

  void udp() async {
    print("udp demo");
    RawDatagramSocket socket = await RawDatagramSocket.bind("0.0.0.0", 0);
    //InternetAddress ad = new InternetAddress('i.aganzai.com');
    InternetAddress ad = await new InternetAddress('180.215.24.69');
    socket.listen((RawSocketEvent e){
      Datagram d = socket.receive();
      if (d == null) return;
      udpString = utf8.decode(d.data);
      print(udpString);
    });
    socket.send(utf8.encode("hello_udp"), ad, 4041);
    await Future.delayed(Duration(seconds: 5));
    socket.close();
    print(udpString);
  }
}

void main(){
  ClientTest p = new ClientTest();
  p.tcp();
  p.udp();
}

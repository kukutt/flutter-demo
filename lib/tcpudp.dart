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
    Timer t = Timer(Duration(seconds: 5), (){print("timeout");socket.close();});
    socket.listen((event) {
      tcpString = utf8.decode(event);
      print(tcpString);
      t.cancel();
      socket.close();
    });
    socket.add(utf8.encode('hello_tcp'));
  }

  void udp() async {
    print("udp demo");
    RawDatagramSocket socket = await RawDatagramSocket.bind("0.0.0.0", 0);
    var ad = await InternetAddress.lookup('i.aganzai.com');
    Timer t = Timer(Duration(seconds: 5), (){print("timeout");socket.close();});
    socket.listen((RawSocketEvent e){
      Datagram d = socket.receive();
      if (d == null) return;
      udpString = utf8.decode(d.data);
      print(udpString);
      t.cancel();
      socket.close();
    });
    socket.send(utf8.encode("hello_udp"), ad[0], 4041);
  }
}

void main(){
  ClientTest p = new ClientTest();
  p.tcp();
  p.udp();
}

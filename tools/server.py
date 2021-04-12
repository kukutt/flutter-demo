from socket import *
from time import ctime
import os 
import sys
import _thread

#websocket and http
#pip3 install flask gevent-websocket flask_sockets
from flask import Flask
from flask_sockets import Sockets

app = Flask(__name__)
sockets = Sockets(app)

def after_request(resp):
    resp.headers['Access-Control-Allow-Origin'] = '*'
    return resp


@sockets.route('/echo')
def echo_socket(ws):
    while not ws.closed:
        message = ws.receive()
        print("监听成功", message)
        if (None != message):
            ws.send(message)

@app.route('/hello')
def index():
    print("hello");
    return 'Hello World!!!'

def udpserver( threadName, port):
    host = ''
    bufsize = 1024
    addr = (host,port) 

    udpServer = socket(AF_INET,SOCK_DGRAM)
    udpServer.bind(addr) #开始监听
    print(threadName, "port=", port);

    while True:
        print(threadName, 'Waiting for connection...')
        data,addr = udpServer.recvfrom(bufsize)  #接收数据和返回地址
        print(threadName, '[+]...connected from:',addr)
        print(threadName, '   [-]', data.hex(), len(data))
        udpServer.sendto(b"ret:"+data, addr)
    udpServer.close()

def tcpserver( threadName, port):
    host = ''
    bufsize = 1024
    addr = (host,port)

    tcpServer = socket(AF_INET,SOCK_STREAM)
    tcpServer.bind(addr)
    tcpServer.listen(5) #这里设置监听数为5(默认值),有点类似多线程。
    print(threadName, "port=", port);

    while True:
        print(threadName, 'Waiting for connection...')
        tcpClient,addr = tcpServer.accept() #拿到5个中一个监听的tcp对象和地址
        print(threadName, '[+]...connected from:',addr)

        while True:
            cmd = tcpClient.recv(bufsize) 
            if 0 == len(cmd):
                break
            print(threadName, '   [-]', cmd.hex(), len(cmd))
            tcpClient.send(b"ret:"+cmd)

        tcpClient.close() #
        print(threadName, addr,'End')
    tcpServer.close() #两次关闭，第一次是tcp对象，第二次是tcp服务器

def httpserver(port):
    from gevent import pywsgi
    from geventwebsocket.handler import WebSocketHandler
    app.after_request(after_request)
    server = pywsgi.WSGIServer(('0.0.0.0', port), app, handler_class=WebSocketHandler)
    server.serve_forever()

try:
    for arg in sys.argv[1:]:
        strlist = arg.split(':')
        if (strlist[0].find("tcp") >= 0):
            print("debug_tcp", strlist[0], strlist[1])
            _thread.start_new_thread( tcpserver, (strlist[0], int(strlist[1]), ) )
        if (strlist[0].find("udp") >= 0):
            print("debug_udp", strlist[0], strlist[1])
            _thread.start_new_thread( udpserver, (strlist[0], int(strlist[1]), ) )
    httpserver(8240);
except:
    print("Error: unable to start thread")
 
while 1:
    pass

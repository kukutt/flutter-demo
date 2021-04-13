# demo

A new Flutter project.

## web
flutter build web
pushd build/web/ ; python3 -m http.server ; popd

# 遇到问题

## http访问不了
ios和android新版本限制使用http来范围，需要添加对应的权限

android增加`android:usesCleartextTraffic="true"` 参考 `b1414b18aa6130feb4e700489a54c10e57577070`

ios增加`NSAppTransportSecurity`设置 参考 `e2e23ba8f39fd2d2a4443e9e76993ec8cf9092d3`

## 跨域问题
flask需要增加`resp.headers['Access-Control-Allow-Origin'] = '*'`解决



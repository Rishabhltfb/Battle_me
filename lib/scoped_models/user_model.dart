import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import './connected_scoped_model.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserModel extends ConnectedModel {
  User get getAuthenticatedUser {
    print('Inside get authenticated User');
    return authenticatedUser;
  }

  Future<bool> userLogin(String email, String password) async {
    isLoading = true;
    notifyListeners();
    bool isAuthenticated = false;
    print('Inside login : ');
    Map<String, dynamic> req = {'email': email, 'password': password};
    try {
      http.Response response = await http.post('${uri}api/users/login',
          body: json.encode(req),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('Inside login success');
        final Map<String, dynamic> res = json.decode(response.body);
        isAuthenticated =
            await setAuthenticatedUser(res['userId'], res['token']);
        isAuthenticated
            ? (isUserAuthenticated = true)
            : (isUserAuthenticated = false);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setString('userId', res['userId']);
      }
      isLoading = false;
      notifyListeners();
      return isAuthenticated;
    } catch (error) {
      print("Error in login:  " + error.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setAuthenticatedUser(String userId, String token) async {
    isLoading = true;
    notifyListeners();
    print('Inside setAuthenticatedUser : ');
    return await http
        .get(
      '${uri}api/users/$userId',
    )
        .then<bool>((http.Response response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body)['user'];
        User user = new User(
          // age: responseData['age'],
          avatar: responseData['avatar'],
          dateOfJoining: responseData['dateOfJoining'],
          email: responseData['email'],
          username: responseData['username'],
          memes: responseData['memes'],
          followers: responseData['followers'],
          followings: responseData['followings'],
          name: responseData['name'],
          userId: responseData['_id'],
          token: token,
        );
        authenticatedUser = user;
        print(user);
        print(user.name);
        isLoading = false;
        notifyListeners();
      }
      return true;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      print("Fetch Authenticated User Error: ${error.toString()}");
      return false;
    });
  }

  Future<Null> userRegister(Map<String, dynamic> registerForm) async {
    isLoading = true;
    notifyListeners();
    print('Inside Register : ');
    Map<String, dynamic> req = registerForm;
    try {
      http.Response response = await http.post('${uri}api/users/register',
          body: json.encode(req),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print('Inside register success');
        final Map<String, dynamic> res = json.decode(response.body);
        print(res);
      }
      isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Error in registration:  " + error.toString());
      isLoading = false;
      notifyListeners();
      return;
    }
  }

  Future<bool> autoAuthenticate() async {
    print('Inside autoAuthenticate');
    isLoading = true;
    bool isAuthenticated = false;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final String userId = prefs.getString('userId');
    if (token != null) {
      isUserAuthenticated = true;
      notifyListeners();
      print('stored token found');
      isAuthenticated = await setAuthenticatedUser(userId, token);
      print('authentication is  $isAuthenticated');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() async {
    print('Inside logout');
    authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  Future<User> findUser(String userId) async {
    isLoading = true;
    notifyListeners();
    print('Inside FindUser : ');
    return await http
        .get(
      '${uri}api/users/$userId',
    )
        .then<User>((http.Response response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body)['user'];
        User user = new User(
          avatar: responseData['avatar'],
          dateOfJoining: responseData['dateOfJoining'],
          email: responseData['email'],
          username: responseData['username'],
          memes: responseData['memes'],
          followers: responseData['followers'],
          followings: responseData['followings'],
          name: responseData['name'],
          userId: responseData['_id'],
        );
        print(user);
        print(user.name);
        isLoading = false;
        notifyListeners();
        return user;
      }
      return null;
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      print("Fetch other User Error: ${error.toString()}");
      return null;
    });
  }

  Future<bool> toggleFollow(String userId, String token) async {
    isLoading = true;
    notifyListeners();
    print('Inside toggle follow : ');
    try {
      http.Response response =
          await http.post('${uri}api/userupdate/follow/${userId}', headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      });
      if (response.statusCode == 200) {
        print('Inside toggle follow success');
        final Map<String, dynamic> res = json.decode(response.body);
        print(res);
      }
      isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      print("Error in toggle follow:  " + error.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Future<Null> socketConnect() async {
  //   // Dart client
  //   print('Inside socketConnect');
  //   IO.Socket socket = await IO.io('http://192.168.43.197:5000');
  //   socket.on('connect', (_) {
  //     print('connect!!!!!!!!!!!!!!!');
  //     //  socket.emit('msg', 'test');
  //   });
  //   // socket.on('event', (data) => print(data));
  //   // socket.on('disconnect', (_) => print('disconnect'));
  //   // socket.on('fromServer', (_) => print(_))
  // }
}

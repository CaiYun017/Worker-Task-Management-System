import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wtms/profilescreen.dart';  // 导入 ProfileScreen 页面
import 'package:wtms/model/worker.dart'; // 假设你有 Worker 类来存储用户数据
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // 加载存储的凭据
  }

  // 加载存储的凭据
  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe && email != null && password != null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  }

  // 登录处理函数
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please fill in all fields");
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorDialog("Please enter a valid email address");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http
          .post(
            Uri.parse("http://192.168.68.109/wtms/login_worker.php"),
            body: {
              "email": email,
              "password": password,
            },
          )
          .timeout(const Duration(seconds: 15));

      debugPrint("Login Response: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);

          if (jsonData['status'] == 'success') {
            if (_rememberMe) {
              await _storeCredentials(email, password);
            } else {
              await _clearCredentials();
            }

            // 获取 worker 数据
            final workerData = jsonData['worker']; // 从 json 中取出 worker 数据
            if (workerData != null) {
              final worker = Worker.fromJson(workerData); // 使用 Worker 类来解析数据
              // 登录成功后跳转到 ProfileScreen，并传递 worker 数据
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(worker: worker),
                ),
              );
            } else {
              _showErrorDialog("Invalid user data received");
            }
          } else {
            _showErrorDialog(jsonData['message'] ?? "Login failed");
          }
        } on FormatException catch (e) {
          debugPrint("JSON Decode Error: $e");
          _showErrorDialog("Invalid server response format");
        } catch (e) {
          debugPrint("Error: $e");
          _showErrorDialog("An error occurred while processing your request");
        }
      } else {
        _showErrorDialog(
            "Server error (HTTP ${response.statusCode})\nPlease try again later");
      }
    } on http.ClientException catch (e) {
      debugPrint("Network Error: $e");
      _showErrorDialog("Network error. Please check your connection");
    } on TimeoutException {
      _showErrorDialog("Connection timeout. Please try again");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      _showErrorDialog("An unexpected error occurred");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 存储凭据
  Future<void> _storeCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('rememberMe', true);
  }

  // 清除凭据
  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('rememberMe', false);
  }

  // 显示错误对话框
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"))
        ],
      ),
    );
  }

  // 忘记密码对话框
  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password"),
        content: const Text(
            "Please contact your administrator to reset your password."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
        backgroundColor: Colors.amber.shade900,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                      obscureText: true,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Login"),
                      ),
                    ),
                    TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: const Text("Forgot Password?"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

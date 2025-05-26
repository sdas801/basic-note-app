import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _textEditingController;
  bool _isPasswordSaved = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child:
              _isPasswordSaved
                  ? const _LoginWidget()
                  : const _CreatePasswordWidget(),
        ),
      ),
    );
  }
}

class _CreatePasswordWidget extends StatefulWidget {
  const _CreatePasswordWidget({super.key});

  @override
  State<_CreatePasswordWidget> createState() => __CreatePasswordWidgetState();
}

class __CreatePasswordWidgetState extends State<_CreatePasswordWidget> {
  late final TextEditingController _createPasswordController;
  late final TextEditingController _retypePasswordController;
  final List<bool> _fulfilmentList = List<bool>.filled(5, false);

  @override
  void initState() {
    super.initState();
    _createPasswordController = TextEditingController();
    _retypePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _createPasswordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final String password = _createPasswordController.text;
  }

  String? _passwordValidator(String? value) {
    // Password must be 8 characters long
    // Must contain a digit, a uppercase character, a lowercase character, a special chracter

    if (value?.trim().isEmpty ?? true) {
      return "You MUST enter a password";
    }

    final bool fulfilsLength = value!.length >= 8;

    if (!fulfilsLength) {
      return "Must have a length of 8";
    }

    final RegExp digitMatcher = RegExp(r"\d");
    final RegExp uppercaseMatcher = RegExp("([A-Z])");
    final RegExp lowercaseMatcher = RegExp("([a-z])");
    final RegExp specialCharacterMatcher = RegExp(r"[^\dA-Za-z]");

    final bool digitMatcherResult = digitMatcher.hasMatch(value);

    if (!digitMatcherResult) {
      return "Must contain a digit";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create a password",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36,
              color: Color.fromARGB(255, 87, 86, 86),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Your password must:"),
          ...[
            "Have a length of 8",
            "Contain a digit",
            "Contain a lowercase character",
            "Contain a lowercase character",
            "Contain a special character",
          ].indexed.map<Widget>(
            (x) => Text("${(_fulfilmentList[x.$1]) ? "✔" : "•"} ${x.$2}"),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _createPasswordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Create password',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            validator: _passwordValidator,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _retypePasswordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Retype Password',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
          Align(
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Enter your password",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 36,
            color: Color.fromARGB(255, 87, 86, 86),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          //controller: _textEditingController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: '••••••••••',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 24),
        Align(
          child: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ],
    );
  }
}

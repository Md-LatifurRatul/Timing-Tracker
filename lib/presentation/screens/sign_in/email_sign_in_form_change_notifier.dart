import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/data/models/email_sign_in_change_model.dart';
import 'package:time_tracker_app/data/services/auth.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier(
      {super.key, required this.emailSignInChangeModel});

  final EmailSignInChangeModel emailSignInChangeModel;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, emailSignInChangeModel, _) =>
            EmailSignInFormChangeNotifier(
                emailSignInChangeModel: emailSignInChangeModel),
      ),
    );
  }

  @override
  State<EmailSignInFormChangeNotifier> createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _passwordVisible = false;

  EmailSignInChangeModel get emailSignInModel => widget.emailSignInChangeModel;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Future<void> _submit() async {
    try {
      await emailSignInModel.emailSignInSubmit();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } on PlatformException catch (e) {
      // print(e.toString());
      if (!mounted) {
        return;
      }
      PlatFormExceptionAlertDialogue(
        exeption: e,
        title: 'Sign in failed',
      ).show(context);
    } finally {
      print("Submitted");
    }
  }

  void _toogleFormType() {
    emailSignInModel.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildTextField() {
    return [
      _buildEmailTextField(),
      const SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(),
      const SizedBox(
        height: 12,
      ),
      ElevatedButton(
        onPressed: emailSignInModel.canSubmit ? _submit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        child: Text(
          emailSignInModel.primaryText,
          style: const TextStyle(
              color: Color.fromARGB(255, 233, 228, 228), fontSize: 16),
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      TextButton(
        onPressed: !emailSignInModel.isLoading ? _toogleFormType : null,
        child: Text(emailSignInModel.secondaryText),
      ),
    ];
  }

  void _emailEditingComplete() {
    final newFocus =
        emailSignInModel.emailValidator.isValid(emailSignInModel.email)
            ? _passwordFocusNode
            : _emailFocusNode;

    FocusScope.of(context).requestFocus(newFocus);
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      obscureText: !_passwordVisible,
      onEditingComplete: _submit,
      onChanged: emailSignInModel.updatePassword,
      decoration: InputDecoration(
          label: const Text("Password"),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          errorText: emailSignInModel.passwordErrorText,
          enabled: emailSignInModel.isLoading == false),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: emailSignInModel.updateEmail,
      decoration: InputDecoration(
          label: const Text("Email"),
          hintText: "test@gmail.com",
          errorText: emailSignInModel.emailErrorText),
      enabled: emailSignInModel.isLoading == false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildTextField(),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}

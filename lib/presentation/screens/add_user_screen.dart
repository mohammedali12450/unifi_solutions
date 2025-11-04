import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unifi_exams/domain/entities/user.dart';
import 'package:unifi_exams/presentation/cubit/user_cubit.dart';
import 'package:unifi_exams/presentation/cubit/user_state.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _gender = 'male';
  String _status = 'active';

  void _submitUser(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: _nameController.text,
        email: _emailController.text,
        gender: _gender,
        status: _status,
      );
      context.read<UserCubit>().createUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add User')),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back to the user list on success
            context.pop();
          } else if (state is UserError) {
            // Show a snackbar with the specific error message from the cubit
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an email' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['male', 'female']
                      .map(
                        (label) =>
                            DropdownMenuItem(child: Text(label), value: label),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _gender = value!),
                ),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: ['active', 'inactive']
                      .map(
                        (label) =>
                            DropdownMenuItem(child: Text(label), value: label),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 20),
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    // Show a loading indicator while submitting
                    if (state is UserSubmitting) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () => _submitUser(context),
                      child: const Text('Add User'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

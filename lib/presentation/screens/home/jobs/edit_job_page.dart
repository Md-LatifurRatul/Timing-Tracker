import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_app/data/models/job.dart';
import 'package:time_tracker_app/data/services/database.dart';
import 'package:time_tracker_app/presentation/widgets/plat_form_exception_alert_dialogue.dart';
import 'package:time_tracker_app/presentation/widgets/platform_alert_dialogue.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({super.key, required this.database, this.job});

  final Database database;

  final Job? job;

  static Future<void> showJobPage(BuildContext context,
      {required Database database, Job? job}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(
                database: database,
                job: job,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job?.name;
      _ratePerHour = widget.job?.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;

    if (form?.validate() ?? false) {
      form?.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;

        final allNames = jobs.map((job) => job.name).toList();

        if (widget.job != null) {
          allNames.remove(widget.job?.name);
        }

        if (allNames.contains(_name)) {
          if (!mounted) {
            return;
          }
          const PlatformAlertDialogue(
            title: "Name already used",
            content: "Please choose a different job name",
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          //print("Form Saved, name: $_name, ratPerHour: $_ratePerHour");
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);

          await widget.database.setJob(job);
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } on PlatformException catch (e) {
        if (mounted) {
          PlatFormExceptionAlertDialogue(title: 'Operation failed', exeption: e)
              .show(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(widget.job == null ? "New Job" : 'Edit Job'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              "Save",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Name can't be empty";
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: "Job name",
        ),
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? "$_ratePerHour" : null,
        decoration: const InputDecoration(
          labelText: "Rate Per Hour",
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value ?? '') ?? 0,
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
      ),
    ];
  }
}

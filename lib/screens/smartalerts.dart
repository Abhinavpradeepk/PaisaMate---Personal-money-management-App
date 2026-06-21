import 'package:flutter/material.dart';
import 'package:paisamate/db/alert.dart';
import 'package:paisamate/model/alert_model.dart';
import 'package:paisamate/services/alert_service.dart';

class ScreenAlerts extends StatefulWidget {
  const ScreenAlerts({super.key});

  @override
  State<ScreenAlerts> createState() => _ScreenAlertsState();
}

class _ScreenAlertsState extends State<ScreenAlerts> {
  String? selectedValue;
  final TextEditingController customController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final List<String> paymentTypes = [
    'EMI',
    'Loan',
    'Current Bill',
    'Water Bill',
    'Wi-Fi Bill',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    AlertService.init();
  }

  @override
  void dispose() {
    customController.dispose();
    amountController.dispose();
    dateController.dispose();
    super.dispose();
  }

  DateTime? _parseSelectedDate() {
    if (dateController.text.isEmpty) return null;
    final parts = dateController.text.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    
    DateTime parsedDate = DateTime(year, month, day, 9, 0);
    
    final now = DateTime.now();
    if (parsedDate.isBefore(now)) {
      if (parsedDate.year == now.year && 
          parsedDate.month == now.month && 
          parsedDate.day == now.day) {
        parsedDate = DateTime(year, month, day, 9, 0);
      } else {
        return null;
      }
    }
    
    return parsedDate;
  }

  Future<void> _saveReminder() async {
    final paymentType = selectedValue == 'Other'
        ? customController.text.trim()
        : selectedValue?.trim();
    final amountText = amountController.text.trim();
    final dueDate = _parseSelectedDate();

    if (paymentType == null || paymentType.isEmpty) {
      _showMessage('Please select a payment type.');
      return;
    }

    if (amountText.isEmpty) {
      _showMessage('Please enter an amount.');
      return;
    }

    if (dueDate == null) {
      _showMessage('Please select a valid due date.');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid amount.');
      return;
    }

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final title = '$paymentType Reminder';
    final body = '₹${amount.toStringAsFixed(2)} is due on ${dateController.text}.';

    try {
      // Schedule the notification
      await AlertService.scheduleAlert(
        id: notificationId,
        title: title,
        body: body,
        dateTime: dueDate,
      );

      // Save to database
      final alert = AlertModel(
        type: paymentType,
        amount: amount,
        dueDate: dateController.text,
      );
      await AlertDB.addAlert(alert);

      _showMessage('Reminder scheduled for ${dateController.text}.');
      _clearForm();
      setState(() {});
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearForm() {
    setState(() {
      selectedValue = null;
      customController.clear();
      amountController.clear();
      dateController.clear();
    });
  }

  Future<void> _deleteReminder(int id) async {
    try {
      await AlertDB.deleteAlert(id);
      _showMessage('Reminder deleted.');
      setState(() {});
    } catch (e) {
      _showMessage('Error deleting reminder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paisa Mate Smart Alerts'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Reminder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: const InputDecoration(
                labelText: 'Payment Type',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Select Payment Type'),
              isExpanded: true,
              items: paymentTypes.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            if (selectedValue == 'Other')
              TextField(
                controller: customController,
                decoration: const InputDecoration(
                  labelText: 'Custom Payment Type',
                  border: OutlineInputBorder(),
                ),
              ),
            if (selectedValue == 'Other') const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Due Date',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );

                if (pickedDate != null) {
                  setState(() {
                    dateController.text =
                        '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveReminder,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Save Reminder'),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Your Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<AlertModel>>(
              future: AlertDB.getAllAlerts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final alerts = snapshot.data ?? [];
                if (alerts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No reminders yet. Add one to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text('${alert.type} - ₹${alert.amount.toStringAsFixed(2)}'),
                        subtitle: Text('Due: ${alert.dueDate}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Reminder?'),
                                content: const Text('Are you sure you want to delete this reminder?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      if (alert.id != null) {
                                        _deleteReminder(alert.id!);
                                      }
                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

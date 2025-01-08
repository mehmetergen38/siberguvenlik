import 'package:flutter/material.dart';
import 'dart:convert';



class SecurityAuditPage extends StatefulWidget {
  @override
  _SecurityAuditPageState createState() => _SecurityAuditPageState();
}

class _SecurityAuditPageState extends State<SecurityAuditPage> {
  List<Task> tasks = [
    Task(name: 'Antivirüs yazılımını güncelle', isCompleted: false, frequency: Frequency.daily),
    Task(name: 'Şifreleri kontrol et ve güçlendir', isCompleted: false, frequency: Frequency.weekly),
    Task(name: 'VPN bağlantısını kontrol et', isCompleted: false, frequency: Frequency.monthly),
    Task(name: 'Güvenlik duvarını gözden geçir', isCompleted: false, frequency: Frequency.daily),
    Task(name: 'Yedeklemeleri güncelle', isCompleted: false, frequency: Frequency.weekly),
  ];

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });

    // Tüm görevler tamamlandığında tebrik mesajı göster ve görevleri sıfırla
    if (_allTasksCompleted()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tebrikler! Görevleri tamamladınız')),
      );
      _resetTasks(); // Görevleri sıfırla
    }
  }

  // Görevlerin tamamlanıp tamamlanmadığını kontrol etme
  bool _allTasksCompleted() {
    return tasks.every((task) => task.isCompleted);
  }

  // Tüm görevleri sıfırlama
  void _resetTasks() {
    setState(() {
      tasks = tasks.map((task) {
        task.isCompleted = false;
        return task;
      }).toList();
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _resetCompletedTasks() {
    setState(() {
      tasks = tasks.map((task) {
        task.isCompleted = false;
        return task;
      }).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tamamlanan görevler sıfırlandı')));
  }

  void _addNewTask(String taskName, Frequency frequency) {
    setState(() {
      tasks.add(Task(name: taskName, isCompleted: false, frequency: frequency));
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yeni görev eklendi')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Güvenlik Denetim Listesi'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddTaskDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _resetCompletedTasks();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return _buildTaskCard(tasks[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return Card(
      color: task.isCompleted ? Colors.green[700] : Colors.orange[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.white : Colors.orange,
          size: 30,
        ),
        title: Text(
          task.name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          'Frekans: ${_getFrequencyString(task.frequency)}',
          style: TextStyle(color: Colors.black54),
        ),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            _toggleTaskCompletion(index);
          },
          activeColor: Colors.orange,
        ),
        onLongPress: () => _deleteTask(index),
      ),
    );
  }

  String _getFrequencyString(Frequency frequency) {
    switch (frequency) {
      case Frequency.daily:
        return 'Günlük';
      case Frequency.weekly:
        return 'Haftalık';
      case Frequency.monthly:
        return 'Aylık';
      default:
        return '';
    }
  }

  void _showAddTaskDialog() {
    String newTaskName = '';
    Frequency selectedFrequency = Frequency.daily;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Görev Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Görev adı'),
                onChanged: (value) {
                  newTaskName = value;
                },
              ),
              SizedBox(height: 10),
              DropdownButton<Frequency>(
                value: selectedFrequency,
                onChanged: (Frequency? newValue) {
                  setState(() {
                    selectedFrequency = newValue!;
                  });
                },
                items: Frequency.values.map((Frequency frequency) {
                  return DropdownMenuItem<Frequency>(
                    value: frequency,
                    child: Text(_getFrequencyString(frequency)),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newTaskName.isNotEmpty) {
                  _addNewTask(newTaskName, selectedFrequency);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ekle'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('İptal'),
            ),
          ],
        );
      },
    );
  }
}

enum Frequency { daily, weekly, monthly }

class Task {
  String name;
  bool isCompleted;
  Frequency frequency;

  Task({required this.name, this.isCompleted = false, required this.frequency});

  // JSON'dan görev oluşturma
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      isCompleted: json['isCompleted'],
      frequency: Frequency.values[json['frequency']],
    );
  }

  // JSON'a görev verisini kaydetme
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCompleted': isCompleted,
      'frequency': frequency.index,
    };
  }
}

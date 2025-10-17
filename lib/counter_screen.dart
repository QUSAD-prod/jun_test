import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  String _fileContent = '';
  static const platform = MethodChannel('com.qusadprod.filewriter');

  @override
  void initState() {
    super.initState();
    _loadFileContent();
  }

  void _loadFileContent() async {
    try {
      final String result = await platform.invokeMethod('readFromFile');

      setState(() {
        _fileContent = result;
        if (result.isNotEmpty && result != "Файл не найден") {
          _counter = result.split('\n').where((line) => line.trim().isNotEmpty).length;
        }
      });
    } on PlatformException catch (e) {
      setState(() {
        _fileContent = 'Ошибка чтения: ${e.message}';
      });
    }
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    try {
      final String result = await platform.invokeMethod('writeToFile', {
        'counter': _counter,
        'message': 'hello world $_counter',
      });

      setState(() {
        _fileContent = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _fileContent = 'Ошибка: ${e.message}';
      });
    }
  }

  void _deleteFile() async {
    try {
      final String result = await platform.invokeMethod('deleteFile');

      setState(() {
        _fileContent = result;
        _counter = 0;
      });
    } on PlatformException catch (e) {
      setState(() {
        _fileContent = 'Ошибка удаления: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Test')),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemBlue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Содержимое файла:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 256,
                      height: 128,
                      child: SingleChildScrollView(
                        child: Text(
                          _fileContent.isEmpty ? 'Файл пуст' : _fileContent,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemBlue,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton.filled(
                    onPressed: _incrementCounter,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: const Text(
                      '+1',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  CupertinoButton(
                    onPressed: _deleteFile,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    color: CupertinoColors.systemRed,
                    child: Icon(CupertinoIcons.trash, color: CupertinoColors.white),
                  ),
                ],
              ),
              Spacer(flex: 3),
              Text(
                'by QUSAD.prod',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

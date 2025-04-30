import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class EditNewsScreen extends StatefulWidget {
  final News news;

  EditNewsScreen({required this.news});

  @override
  _EditNewsScreenState createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late TextEditingController _imageUrlController;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news.title);
    _descriptionController =
        TextEditingController(text: widget.news.description);
    _urlController = TextEditingController(text: widget.news.url);
    _imageUrlController = TextEditingController(text: widget.news.imageUrl);
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final updatedNews = News(
        id: widget.news.id,
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        url: _urlController.text,
      );

      try {
        await apiService.updateNews(widget.news.id, updatedNews);
        Navigator.pop(context); // العودة إلى الشاشة السابقة
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('فشل التعديل'),
            content: Text('حدث خطأ أثناء تعديل الخبر: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('موافق'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل الخبر'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'العنوان'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال العنوان';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'الوصف'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الوصف';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _urlController,
                decoration: InputDecoration(labelText: 'الرابط'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الرابط';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'رابط الصورة'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رابط الصورة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('تحديث الخبر'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

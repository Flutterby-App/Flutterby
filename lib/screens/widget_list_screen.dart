import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/widget_data_service.dart';
import '../models/flutter_widget.dart';

class WidgetListScreen extends StatelessWidget {
  final String categoryId;

  const WidgetListScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final category = WidgetDataService.getCategoryById(categoryId);
    final widgets = WidgetDataService.getWidgetsByCategory(categoryId);

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Category Not Found')),
        body: const Center(
          child: Text('The requested category was not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: widgets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.widgets_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No widgets in this category yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                return _WidgetListTile(widget: widgets[index]);
              },
            ),
    );
  }
}

class _WidgetListTile extends StatelessWidget {
  final FlutterWidget widget;

  const _WidgetListTile({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            if (widget.isMaterial)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Material',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            if (widget.isCupertino)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Cupertino',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            if (widget.subcategory.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                children: [
                  Chip(
                    label: Text(
                      widget.subcategory,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.go('/widget/${widget.id}'),
      ),
    );
  }
}
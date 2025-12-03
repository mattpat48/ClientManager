import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_field_data.dart';

class ListableScreenWithForm<P extends ChangeNotifier, T> extends StatelessWidget {
  final String appBarTitle;
  final String dialogTitle;
  final String noItemsMessage;
  final List<T> Function(P provider) getItems;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final List<FormFieldData> formFields;
  final T Function(Map<String, String> formResults) createItemFromForm;
  final void Function(P provider, T item) addItemToProvider;

  const ListableScreenWithForm({
    super.key,
    required this.appBarTitle,
    required this.dialogTitle,
    required this.noItemsMessage,
    required this.getItems,
    required this.itemBuilder,
    required this.formFields,
    required this.createItemFromForm,
    required this.addItemToProvider,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<P>();
    final items = getItems(provider);
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: items.isEmpty
          ? Center(child: Text(noItemsMessage))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, index) => itemBuilder(ctx, items[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final controllers = {for (var field in formFields) field.label: TextEditingController()};

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: formFields.map((field) {
                  return TextFormField(
                    controller: controllers[field.label],
                    decoration: InputDecoration(labelText: field.label),
                    keyboardType: field.keyboardType,
                    validator: field.validator,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(child: const Icon(Icons.close), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: const Icon(Icons.check),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final formResults = controllers.map((key, value) => MapEntry(key, value.text));
                  final newItem = createItemFromForm(formResults);
                  addItemToProvider(context.read<P>(), newItem);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
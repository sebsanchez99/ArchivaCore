// multi_select_dropdown.dart
import 'package:flutter/material.dart';
import 'package:frontend/presentation/global/constants/schema_colors.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final ValueChanged<Set<String>> onSelectionChanged;
  final String hintText;
  final double width;
  final String tooltip;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    this.hintText = 'Seleccione un item',
    this.tooltip = 'Mostrar opciones',
    this.width = 16
  });

  @override
  MultiSelectDropdownState createState() => MultiSelectDropdownState();
}

class MultiSelectDropdownState extends State<MultiSelectDropdown> {
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Mostrar opciones',
      elevation: 3,
      onSelected: (String item) {},
      // El contenido del menú
       itemBuilder: (BuildContext context) {
      return widget.items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStatePopup) {
              return Theme(
                data: Theme.of(context).copyWith(
                  hoverColor: Colors.transparent,
                ),
                child: CheckboxListTile(
                  dense: true,
                  activeColor: SchemaColors.secondary,
                  title: Text(item),
                  value: _selectedItems.contains(item),
                  onChanged: (bool? isSelected) {
                    setStatePopup(() {
                      if (isSelected == true) {
                        _selectedItems.add(item);
                      } else {
                        _selectedItems.remove(item);
                      }
                    });
                    widget.onSelectionChanged(_selectedItems);
                  },
                ),
              );
            },
          ),
        );
      }).toList();
    },
    // Añade el tamaño máximo del menú
    constraints: BoxConstraints(maxHeight: 200), // Altura fija de 200px
    offset: Offset(0, 40),
      // El botón de filtro
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.width, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: SchemaColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedItems.isEmpty ? widget.hintText : _selectedItems.join(', '),
              style: TextStyle(
                color: _selectedItems.isEmpty ? Colors.grey.shade600 : Colors.black,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ), // Ajusta el offset del menú debajo del botón
  );
  }
}
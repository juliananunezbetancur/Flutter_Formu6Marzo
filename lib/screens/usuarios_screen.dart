import 'package:flutter/material.dart';

class Infraccion {
  final String producto;
  final int stack;

  Infraccion(this.producto, this.stack);
}

class InfraccionesScreen extends StatefulWidget {
  const InfraccionesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InfraccionesScreenState createState() => _InfraccionesScreenState();
}

class _InfraccionesScreenState extends State<InfraccionesScreen> {
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _stackController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<Infraccion> _infraccionesList = [];
  List<Infraccion> _filteredInfraccionesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de productos y su stack',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: 'poppins', fontSize: 30),
        ),
        backgroundColor: const Color.fromARGB(255, 231, 234, 236),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _productoController,
              decoration: const InputDecoration(labelText: 'Producto'),
            ),
            TextField(
              controller: _stackController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stack'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarInfraccion,
              child: const Text('Registrar Stack'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              onChanged: _filterInfracciones,
              decoration: const InputDecoration(labelText: 'Buscar por nombre de producto'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredInfraccionesList.length,
                itemBuilder: (context, index) {
                  final infraccion = _filteredInfraccionesList[index];
                  return ListTile(
                    title: Text('${infraccion.producto} : ${infraccion.stack}'),
                    onTap: () => _editarInfraccion(index),
                    onLongPress: () => _eliminarInfraccion(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registrarInfraccion() {
    final producto = _productoController.text;
    final stack = int.parse(_stackController.text);

    setState(() {
      _infraccionesList.add(Infraccion(producto, stack));
      _productoController.clear();
      _stackController.clear();
      _filteredInfraccionesList = _infraccionesList;
    });
  }

  void _filterInfracciones(String query) {
    setState(() {
      _filteredInfraccionesList = _infraccionesList
          .where((infraccion) => infraccion.producto.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _editarInfraccion(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar stack de producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Producto: ${_infraccionesList[index].producto}'),
              TextField(
                controller: _stackController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stack'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _actualizarInfraccion(index);
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _actualizarInfraccion(int index) {
    final stack = int.parse(_stackController.text);

    setState(() {
      _infraccionesList[index] = Infraccion(_infraccionesList[index].producto, stack);
      _stackController.clear();
    });
  }

  void _eliminarInfraccion(int index) {
    setState(() {
      _infraccionesList.removeAt(index);
      _filteredInfraccionesList = _infraccionesList;
    });
  }
}


import 'package:flutter/material.dart';
import 'package:konekta_app/screens/notificaciones.dart';
import 'proveedor_perfil.dart';
import 'proveedor_servicios.dart';
import 'proveedor_solicitudes.dart';

class ProveedorHome extends StatefulWidget {
  final int idusuario;
  final int idProveedor;
  final String tipoUsuario;
  final String empresa;

  const ProveedorHome({
    super.key,
    required this.idusuario,
    required this.idProveedor,
    required this.tipoUsuario,
    required this.empresa,
  });

  @override
  State<ProveedorHome> createState() => _ProveedorHomeState();
}

class _ProveedorHomeState extends State<ProveedorHome> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProveedorPerfil(
        idUsuario: widget.idusuario,
        idProveedor: widget.idProveedor,
      ),
      ProveedorServicios(
        idProveedor: widget.idProveedor,
        idUsuario: widget.idusuario,
        empresa: widget.empresa,
      ),
      Notificaciones(idusuario: widget.idusuario),
      ProveedorSolicitudes(
        idProveedor: widget.idProveedor,
        idusuario: widget.idusuario,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Solicitudes',
          ),
        ],
      ),
    );
  }
}

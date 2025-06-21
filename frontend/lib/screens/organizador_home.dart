import 'package:flutter/material.dart';
import 'package:konekta_app/screens/organizador_perfil.dart';
import 'package:konekta_app/screens/servicios_ofertados.dart';
import 'eventos.dart';
import 'notificaciones.dart';
import 'organizador_solicitudes.dart';

class OrganizadorHome extends StatefulWidget {
  final int idusuario;
  final int idOrganizador;
  final String tipoUsuario;
  final String nombre;

  const OrganizadorHome({
    super.key,
    required this.idusuario,
    required this.idOrganizador,
    required this.tipoUsuario,
    required this.nombre,
  });

  @override
  State<OrganizadorHome> createState() => _OrganizadorHomeState();
}

class _OrganizadorHomeState extends State<OrganizadorHome> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OrganizadorPerfil(
        idusuario: widget.idusuario,
        idOrganizador: widget.idOrganizador,
      ),
      Eventos(idUsuario: widget.idusuario, idOrganizador: widget.idOrganizador),
      ServiciosOfertados(
        idOrganizador: widget.idOrganizador,
        idUsuario: widget.idusuario,
      ),
      Notificaciones(idusuario: widget.idusuario),
      OrganizadorSolicitudes(
        idOrganizador: widget.idOrganizador,
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
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Eventos'),
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

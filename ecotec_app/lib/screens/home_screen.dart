import 'package:ecotec_app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Ecotec'),
        backgroundColor: Colors.lightBlue,
        elevation: 5,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.widgets),
            title: Text('Texto'),
            trailing: Icon(Icons.arrow_forward),
            subtitle: Text('Este widget crea texto'),
            onTap: () {
              //  debugPrint('Navegando a la siguiente pantalla');
              /*     Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextoScreen()),
              );
 */

              Navigator.pushNamed(context, AppRoutes.texto);
              debugPrint('Navego siguiente pantalla');
            },
          ),

          ListTile(
            leading: Icon(Icons.image),
            title: Text('Widget de Imagenes'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              //  debugPrint('Navegando a la pantalla de imagenes');
              /*   Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImagenesScreen()),
              ); */

              Navigator.pushNamed(context, AppRoutes.imagenes);

              debugPrint('Navego siguiente pantalla');
            },
          ),

          ListTile(
            leading: Icon(Icons.credit_card_sharp),
            title: Text('Cards'),
            trailing: Icon(Icons.arrow_forward),
          ),

          ListTile(
            leading: Icon(Icons.border_outer_outlined),
            title: Text('Botones'),
            trailing: Icon(Icons.arrow_forward),
          ),

          ListTile(
            leading: Icon(Icons.border_outer_outlined),
            title: Text('Formularios'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              /*  debugPrint('Navegando a la pantalla de formularios');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormsScreen()),
              );
 */

              Navigator.pushNamed(context, AppRoutes.formularios);
              debugPrint('Navego siguiente pantalla');
            },
          ),

          Text('Botones'),
        ],
      ),
    );
  }
}

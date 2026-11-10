// import 'package:flutter/material.dart';
// import 'package:novamart/screens/API_DATA_Screen.dart';
// import 'package:provider/provider.dart';
// import 'providers/cart_provider.dart';
// import 'providers/product_provider.dart';
// import 'app/cartify_app.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ProductProvider()),
//       ],
//       child: const ExplorerScreen2(),
//     ),
//   );
// }




import 'package:flutter/material.dart';
import 'package:novamart/app/cartify_app.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
// import 'screens/API_DATA_Screen.dart'; // Aapki screen ka path

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()), // Agar cart provider bhi hai
      ],
      child: MaterialApp( // <-- Yahan MaterialApp hona zaroori hai!
        debugShowCheckedModeBanner: false,
        // title: 'Novamart',
        // theme: ThemeData(
        //   primarySwatch: Colors.purple,
        //   brightness: Brightness.dark, // Agar dark theme hai
        // ),
        home: const CartifyApp(), // <-- Yahan aapki screen aayegi
      ),
    ),
  );
}
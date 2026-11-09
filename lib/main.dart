// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/cart_provider.dart';
// import 'app/cartify_app.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => CartProvider()),
//       ],
//       child: const CartifyApp(),
//     ),
//   );
// }









// ============================================================
//  SHOPZY - Flutter E-Commerce App (single file: main.dart)
//  Sirf ek package chahiye: provider
//  pubspec.yaml me dependencies ke neeche add karo:
//      provider: ^6.1.2
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ------------------------------------------------------------
//  APP KE COLORS AUR CHHOTE HELPERS
// ------------------------------------------------------------

const Color brandColor = Color(0xFF6C5CE7);
const Color brandColorLight = Color(0xFFA29BFE);
const Color successGreen = Color(0xFF00B894);

// Brand ka gradient jo buttons aur banner me use hoga
const LinearGradient brandGradient = LinearGradient(
  colors: [brandColor, brandColorLight],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Color ko halka (transparent) karne ke liye helper
Color soft(Color color, double opacity) {
  return color.withAlpha((opacity * 255).round());
}

// Price ko rupees me dikhane ke liye
String rupee(double value) => '₹${value.toStringAsFixed(0)}';

// Check karta hai ki abhi dark theme on hai ya nahi
bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

// Halka grey text color (theme ke hisaab se)
Color mutedColor(BuildContext context) {
  return isDarkMode(context) ? Colors.white60 : Colors.black54;
}

// Card ke neeche halka shadow
List<BoxShadow> cardShadow(BuildContext context) {
  return [
    BoxShadow(
      color: isDarkMode(context)
          ? Colors.black.withAlpha(90)
          : brandColor.withAlpha(30),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}

// Chhota sa message (snackbar) dikhane ke liye
void showMiniMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
}

// Smooth fade + slide wala page transition
Route<T> fadeSlideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

// ------------------------------------------------------------
//  MODELS (data ke dabbe)
// ------------------------------------------------------------

class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double oldPrice;
  final String emoji; // image ki jagah emoji, taaki koi asset ya internet na lage
  final Color color;
  final double rating;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.emoji,
    required this.color,
    required this.rating,
    required this.description,
  });

  // Kitne percent discount mil raha hai
  int get discountPercent => (((oldPrice - price) / oldPrice) * 100).round();
}

// Cart ke andar ek product aur uski quantity
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

// Place ho chuka order
class PlacedOrder {
  final String orderId;
  final int itemCount;
  final double totalAmount;
  final String itemNames;
  final String paymentMethod;
  final DateTime orderTime;

  PlacedOrder({
    required this.orderId,
    required this.itemCount,
    required this.totalAmount,
    required this.itemNames,
    required this.paymentMethod,
    required this.orderTime,
  });
}

// ------------------------------------------------------------
//  DUMMY PRODUCTS DATA
// ------------------------------------------------------------

const List<String> productCategories = ['All', 'Fashion', 'Gadgets', 'Home', 'Beauty'];

const List<Product> allProducts = [
  Product(
    id: 1,
    name: 'Wireless Earbuds',
    category: 'Gadgets',
    price: 1499,
    oldPrice: 2999,
    emoji: '🎧',
    color: Color(0xFF6C5CE7),
    rating: 4.5,
    description:
        'Deep bass aur 24 ghante ki battery. Noise cancellation ke saath music ka asli maza lo.',
  ),
  Product(
    id: 2,
    name: 'Smart Watch',
    category: 'Gadgets',
    price: 2999,
    oldPrice: 4999,
    emoji: '⌚',
    color: Color(0xFF00B894),
    rating: 4.3,
    description:
        'Heart rate, steps aur sleep track karo. AMOLED display aur 7 din ki battery life.',
  ),
  Product(
    id: 3,
    name: 'Street Sneakers',
    category: 'Fashion',
    price: 1899,
    oldPrice: 2999,
    emoji: '👟',
    color: Color(0xFFFF7675),
    rating: 4.6,
    description:
        'Halke aur super comfortable sneakers. Roz pehenne ke liye perfect, har outfit ke saath match.',
  ),
  Product(
    id: 4,
    name: 'Denim Jacket',
    category: 'Fashion',
    price: 2199,
    oldPrice: 3499,
    emoji: '🧥',
    color: Color(0xFF0984E3),
    rating: 4.2,
    description:
        'Classic denim jacket jo kabhi out of style nahi hoti. Winter aur evening dono ke liye mast.',
  ),
  Product(
    id: 5,
    name: 'Cool Sunglasses',
    category: 'Fashion',
    price: 799,
    oldPrice: 1499,
    emoji: '🕶️',
    color: Color(0xFFFDCB6E),
    rating: 4.1,
    description: 'UV protection wale stylish goggles. Dhoop me bhi swag banaye rakhe.',
  ),
  Product(
    id: 6,
    name: 'Study Table Lamp',
    category: 'Home',
    price: 999,
    oldPrice: 1599,
    emoji: '💡',
    color: Color(0xFFE17055),
    rating: 4.4,
    description: 'Aankhon ko aaram dene wali warm light. Touch control aur 3 brightness modes.',
  ),
  Product(
    id: 7,
    name: 'Coffee Mug Set',
    category: 'Home',
    price: 599,
    oldPrice: 999,
    emoji: '☕',
    color: Color(0xFFA29BFE),
    rating: 4.0,
    description: '2 premium ceramic mugs ka set. Subah ki chai ya coffee ka mood hi alag ho jayega.',
  ),
  Product(
    id: 8,
    name: 'Matte Lipstick',
    category: 'Beauty',
    price: 449,
    oldPrice: 799,
    emoji: '💄',
    color: Color(0xFFE84393),
    rating: 4.5,
    description: 'Long lasting matte finish. Ek baar lagao aur poore din ki tension khatam.',
  ),
  Product(
    id: 9,
    name: 'Luxury Perfume',
    category: 'Beauty',
    price: 1299,
    oldPrice: 2199,
    emoji: '🧴',
    color: Color(0xFF00CEC9),
    rating: 4.7,
    description: 'Fresh aur long lasting khushboo. Party ho ya office, har jagah impression strong.',
  ),
  Product(
    id: 10,
    name: 'Gaming Mouse',
    category: 'Gadgets',
    price: 1199,
    oldPrice: 1999,
    emoji: '🖱️',
    color: Color(0xFF636E72),
    rating: 4.4,
    description: 'RGB lights aur 6 programmable buttons. Fast response, gaming me no lag.',
  ),
  Product(
    id: 11,
    name: 'Travel Backpack',
    category: 'Fashion',
    price: 1099,
    oldPrice: 1799,
    emoji: '🎒',
    color: Color(0xFFF0932B),
    rating: 4.3,
    description: 'Water resistant aur bahut spacious. Laptop ke liye alag pocket bhi hai.',
  ),
  Product(
    id: 12,
    name: 'Indoor Plant',
    category: 'Home',
    price: 399,
    oldPrice: 699,
    emoji: '🌿',
    color: Color(0xFF55EFC4),
    rating: 4.6,
    description: 'Ghar ko fresh banane wala sundar plant. Kam paani me bhi khush rehta hai.',
  ),
];

// ------------------------------------------------------------
//  PROVIDERS (app ki state yahin se manage hogi)
// ------------------------------------------------------------

// Dark / Light theme ka provider
class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

// Cart ka provider
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  // Cart me total kitne pieces hain (badge ke liye)
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // 999 se upar ka order ho to delivery free
  double get deliveryFee => (_items.isEmpty || subtotal >= 999) ? 0 : 49;

  double get grandTotal => subtotal + deliveryFee;

  // Product add karo, pehle se hai to quantity badha do
  void addProduct(Product product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeProduct(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

// Wishlist (dil wale favourites) ka provider
class WishlistProvider extends ChangeNotifier {
  final Set<int> _likedIds = {};

  int get totalLiked => _likedIds.length;

  bool isLiked(int productId) => _likedIds.contains(productId);

  void toggleLike(int productId) {
    if (_likedIds.contains(productId)) {
      _likedIds.remove(productId);
    } else {
      _likedIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> get likedProducts =>
      allProducts.where((product) => _likedIds.contains(product.id)).toList();
}

// Orders ka provider
class OrderProvider extends ChangeNotifier {
  final List<PlacedOrder> _orders = [];

  // Sabse naya order sabse upar dikhega
  List<PlacedOrder> get orders => List.unmodifiable(_orders.reversed);

  int get totalOrders => _orders.length;

  // Order place karta hai aur order id wapas deta hai
  String placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String paymentMethod,
  }) {
    final orderId = 'SHZ${10000 + Random().nextInt(89999)}';
    _orders.add(
      PlacedOrder(
        orderId: orderId,
        itemCount: items.fold(0, (sum, item) => sum + item.quantity),
        totalAmount: totalAmount,
        itemNames: items.map((item) => item.product.name).join(', '),
        paymentMethod: paymentMethod,
        orderTime: DateTime.now(),
      ),
    );
    notifyListeners();
    return orderId;
  }
}

// ------------------------------------------------------------
//  MAIN FUNCTION AUR APP ROOT
// ------------------------------------------------------------

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const ShopzyApp(),
    ),
  );
}

// Light aur Dark dono theme yahan bante hain
ThemeData buildAppTheme(bool dark) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: brandColor,
      brightness: dark ? Brightness.dark : Brightness.light,
    ),
    scaffoldBackgroundColor: dark ? const Color(0xFF12121A) : const Color(0xFFF6F5FB),
    cardColor: dark ? const Color(0xFF1E1E2A) : Colors.white,
  );
}

class ShopzyApp extends StatelessWidget {
  const ShopzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Shopzy',
      debugShowCheckedModeBanner: false,
      themeAnimationDuration: const Duration(milliseconds: 500), // theme smooth badlega
      theme: buildAppTheme(false),
      darkTheme: buildAppTheme(true),
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

// ------------------------------------------------------------
//  REUSABLE CHHOTE WIDGETS
// ------------------------------------------------------------

// Widget ko upar-neeche halka halka tairata hua dikhata hai
class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double distance;

  const FloatingWidget({super.key, required this.child, this.distance = 10});

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final curved = Curves.easeInOut.transform(_controller.value);
        final offsetY = (curved * 2 - 1) * widget.distance;
        return Transform.translate(offset: Offset(0, offsetY), child: child);
      },
    );
  }
}

// Grid ke items ek ek karke neeche se upar aate hain
class StaggerIn extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggerIn({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index % 8) * 90),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
        );
      },
    );
  }
}

// Price badalne par number count hota hua dikhta hai
class AnimatedPriceText extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const AnimatedPriceText({super.key, required this.price, this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: price),
      duration: const Duration(milliseconds: 450),
      builder: (context, value, _) => Text(rupee(value), style: style),
    );
  }
}

// Jab kuch na ho (empty cart, empty wishlist, no search result)
class EmptyStateView extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const EmptyStateView({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) => Transform.scale(scale: value, child: child),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingWidget(child: Text(emoji, style: const TextStyle(fontSize: 80))),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: mutedColor(context), fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gradient wala bada button (press par halka dab jata hai)
class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: brandGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: soft(brandColor, 0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: widget.isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                  )
                : Row(
                    key: ValueKey(widget.text),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: Colors.white),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// Gol chhota button (back, heart, + - ke liye)
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const RoundIconButton({super.key, required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: cardShadow(context),
        ),
        child: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }
}

// Heart (wishlist) button jo animation ke saath badalta hai
class HeartButton extends StatelessWidget {
  final Product product;

  const HeartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isLiked = context.watch<WishlistProvider>().isLiked(product.id);

    return GestureDetector(
      onTap: () {
        context.read<WishlistProvider>().toggleLike(product.id);
        showMiniMessage(
          context,
          isLiked ? 'Wishlist se hata diya' : 'Wishlist me add ho gaya ❤️',
        );
      },
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: cardShadow(context),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: Icon(
            isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isLiked),
            color: isLiked ? Colors.redAccent : mutedColor(context),
            size: 22,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
//  SPLASH SCREEN (app khulte hi animated logo)
// ------------------------------------------------------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2.4 second baad main screen par chale jao
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, fadeSlideRoute(const MainShell()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: brandGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo elastic effect ke saath bada hota hai
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1300),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(scale: value, child: child),
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_bag_rounded, size: 60, color: brandColor),
              ),
            ),
            const SizedBox(height: 26),
            // App ka naam dheere dheere fade in hota hai
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOut,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
              ),
              child: const Column(
                children: [
                  Text(
                    'Shopzy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Shopping ka naya andaaz',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
//  MAIN SHELL (4 tabs + floating bottom navigation bar)
// ------------------------------------------------------------

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentTabIndex = 0;

  Widget _buildCurrentPage() {
    switch (currentTabIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const WishlistPage();
      case 2:
        return const CartPage();
      default:
        return const ProfilePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // page nav bar ke peeche tak failega (floating look ke liye)
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(currentTabIndex),
          child: _buildCurrentPage(),
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: currentTabIndex,
        onTabChange: (index) => setState(() => currentTabIndex = index),
      ),
    );
  }
}

// Nav bar ke ek tab ki info
class NavTabData {
  final IconData icon;
  final String label;

  const NavTabData(this.icon, this.label);
}

// Modern floating pill wali bottom navigation bar
class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const FloatingNavBar({super.key, required this.selectedIndex, required this.onTabChange});

  static const List<NavTabData> tabs = [
    NavTabData(Icons.home_rounded, 'Home'),
    NavTabData(Icons.favorite_rounded, 'Wishlist'),
    NavTabData(Icons.shopping_cart_rounded, 'Cart'),
    NavTabData(Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalItems;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: isDarkMode(context) ? Colors.black.withAlpha(120) : Colors.black.withAlpha(35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            final badgeCount = index == 2 ? cartCount : 0; // badge sirf cart par
            return _buildTab(context, index, isSelected, badgeCount);
          }),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, bool isSelected, int badgeCount) {
    final tab = tabs[index];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 18 : 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? brandColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    tab.icon,
                    size: 24,
                    color: isSelected ? Colors.white : mutedColor(context),
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    // count badalne par badge pop hota hai
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey(badgeCount),
                      tween: Tween<double>(begin: 0.4, end: 1),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) => Transform.scale(scale: value, child: child),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Selected tab ka naam smoothly khulta hai
            AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        tab.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
//  HOME PAGE
// ------------------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  String searchText = '';

  // Category aur search ke hisaab se filter hue products
  List<Product> get filteredProducts {
    return allProducts.where((product) {
      final categoryMatch = selectedCategory == 'All' || product.category == selectedCategory;
      final searchMatch = product.name.toLowerCase().contains(searchText.toLowerCase().trim());
      return categoryMatch && searchMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = filteredProducts;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearchBar()),
          const SliverToBoxAdapter(child: PromoBanner()),
          SliverToBoxAdapter(child: _buildCategoryChips()),
          if (products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateView(
                emoji: '🔍',
                title: 'Kuch nahi mila',
                subtitle: 'Doosra naam search karke dekho ya category badlo.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return StaggerIn(
                      key: ValueKey(product.id),
                      index: index,
                      child: ProductCard(product: product),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Upar ka greeting wala hissa
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Namaste 👋', style: TextStyle(color: mutedColor(context), fontSize: 15)),
                const SizedBox(height: 4),
                const Text(
                  'Aaj kya khareedna hai?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(gradient: brandGradient, shape: BoxShape.circle),
            child: const Icon(Icons.notifications_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: cardShadow(context),
        ),
        child: TextField(
          onChanged: (value) => setState(() => searchText = value),
          decoration: InputDecoration(
            hintText: 'Products search karo...',
            hintStyle: TextStyle(color: mutedColor(context)),
            prefixIcon: const Icon(Icons.search_rounded, color: brandColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  // Category chips jo animate hote hue badalte hain
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        itemCount: productCategories.length,
        itemBuilder: (context, index) {
          final category = productCategories[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? brandColor : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: isSelected
                    ? [BoxShadow(color: soft(brandColor, 0.35), blurRadius: 12, offset: const Offset(0, 5))]
                    : cardShadow(context),
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : mutedColor(context),
                ),
                child: Text(category),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Sale wala promo banner (emoji upar neeche hilta rehta hai)
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFFF7675)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: soft(brandColor, 0.35), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'MEGA SALE',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Flat 50% tak\nki chhoot!',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, height: 1.2),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Abhi lo',
                    style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const FloatingWidget(child: Text('🛍️', style: TextStyle(fontSize: 70))),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
//  PRODUCT CARD (grid me dikhne wala card)
// ------------------------------------------------------------

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, fadeSlideRoute(ProductDetailsPage(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: cardShadow(context),
        ),
        child: Column(
          children: [
            // Upar ka rangeen hissa jisme emoji hai
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [soft(product.color, 0.25), soft(product.color, 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'product-emoji-${product.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(product.emoji, style: const TextStyle(fontSize: 60)),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${product.discountPercent}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(top: 6, right: 6, child: HeartButton(product: product)),
                  ],
                ),
              ),
            ),
            // Neeche ka naam aur price wala hissa
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 15),
                            const SizedBox(width: 2),
                            Text('${product.rating}', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rupee(product.price),
                          style: const TextStyle(
                            color: brandColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<CartProvider>().addProduct(product);
                      showMiniMessage(context, '${product.name} cart me add ho gaya 🛒');
                    },
                    child: Container(
                      height: 38,
                      width: 38,
                      decoration: BoxDecoration(
                        color: brandColor,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
//  PRODUCT DETAILS PAGE
// ------------------------------------------------------------

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedQuantity = 1;
  bool justAdded = false; // button par "Added" dikhane ke liye

  Future<void> _addToCart() async {
    context.read<CartProvider>().addProduct(widget.product, quantity: selectedQuantity);
    setState(() => justAdded = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => justAdded = false);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      body: Column(
        children: [
          // Upar ka bada rangeen hissa
          Container(
            height: 330,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [soft(product.color, 0.3), soft(product.color, 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(44)),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: FloatingWidget(
                      distance: 8,
                      child: Hero(
                        tag: 'product-emoji-${product.id}',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(product.emoji, style: const TextStyle(fontSize: 130)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 8,
                    child: RoundIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(right: 16, top: 8, child: HeartButton(product: product)),
                ],
              ),
            ),
          ),
          // Neeche ki details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const Icon(Icons.star_rounded, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(product.category, style: TextStyle(color: mutedColor(context))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        rupee(product.price),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: brandColor),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        rupee(product.oldPrice),
                        style: TextStyle(
                          color: mutedColor(context),
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${product.discountPercent}% off',
                        style: const TextStyle(color: successGreen, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(color: mutedColor(context), height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Text('Quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      QuantityStepper(
                        quantity: selectedQuantity,
                        onMinus: () {
                          if (selectedQuantity > 1) setState(() => selectedQuantity--);
                        },
                        onPlus: () => setState(() => selectedQuantity++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Neeche ka Add to Cart bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: TextStyle(color: mutedColor(context))),
                  AnimatedPriceText(
                    price: product.price * selectedQuantity,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: GradientButton(
                  text: justAdded ? 'Added ✓' : 'Add to Cart',
                  icon: justAdded ? null : Icons.shopping_cart_rounded,
                  onTap: _addToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// + / - wala quantity selector
class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow(context),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepButton(Icons.remove_rounded, onMinus),
          // Number badalne par halka scale animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: SizedBox(
              key: ValueKey(quantity),
              width: 36,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _stepButton(Icons.add_rounded, onPlus),
        ],
      ),
    );
  }

  Widget _stepButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(color: soft(brandColor, 0.15), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 20, color: brandColor),
      ),
    );
  }
}

// ------------------------------------------------------------
//  WISHLIST PAGE
// ------------------------------------------------------------

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final likedProducts = context.watch<WishlistProvider>().likedProducts;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text('Meri Wishlist ❤️', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: likedProducts.isEmpty
                ? const EmptyStateView(
                    emoji: '💔',
                    title: 'Wishlist khali hai',
                    subtitle: 'Jo products pasand aaye unpe heart dabao,\nwo yahan save ho jayenge.',
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: likedProducts.length,
                    itemBuilder: (context, index) {
                      final product = likedProducts[index];
                      return StaggerIn(
                        key: ValueKey(product.id),
                        index: index,
                        child: ProductCard(product: product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
//  CART PAGE
// ------------------------------------------------------------

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100), // floating nav bar ke liye jagah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Mera Cart (${cart.totalItems})',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              child: cart.isEmpty
                  ? const EmptyStateView(
                      emoji: '🛒',
                      title: 'Cart khali hai',
                      subtitle: 'Kuch mast products add karo\naur shopping shuru karo!',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return StaggerIn(
                          key: ValueKey('cart-${item.product.id}'),
                          index: index,
                          child: CartTile(item: item),
                        );
                      },
                    ),
            ),
            if (!cart.isEmpty) const CartSummaryCard(),
          ],
        ),
      ),
    );
  }
}

// Cart ka ek item (swipe karke delete bhi ho sakta hai)
class CartTile extends StatelessWidget {
  final CartItem item;

  const CartTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final product = item.product;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Dismissible(
        key: ValueKey('dismiss-${product.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          cart.removeProduct(product.id);
          showMiniMessage(context, '${product.name} hata diya');
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(24)),
          child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: cardShadow(context),
          ),
          child: Row(
            children: [
              Container(
                height: 76,
                width: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [soft(product.color, 0.25), soft(product.color, 0.6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(product.emoji, style: const TextStyle(fontSize: 38)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    AnimatedPriceText(
                      price: item.totalPrice,
                      style: const TextStyle(color: brandColor, fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                  ],
                ),
              ),
              QuantityStepper(
                quantity: item.quantity,
                onMinus: () => cart.decreaseQuantity(product.id),
                onPlus: () => cart.increaseQuantity(product.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Cart ke neeche ka bill summary
class CartSummaryCard extends StatelessWidget {
  const CartSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: cardShadow(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow(context, 'Subtotal', AnimatedPriceText(price: cart.subtotal)),
          const SizedBox(height: 8),
          _summaryRow(
            context,
            'Delivery',
            cart.deliveryFee == 0
                ? const Text('FREE', style: TextStyle(color: successGreen, fontWeight: FontWeight.bold))
                : Text(rupee(cart.deliveryFee)),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              AnimatedPriceText(
                price: cart.grandTotal,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: brandColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GradientButton(
            text: 'Checkout karo',
            icon: Icons.lock_rounded,
            onTap: () => Navigator.push(context, fadeSlideRoute(const CheckoutPage())),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: mutedColor(context), fontSize: 15)),
        value,
      ],
    );
  }
}

// ------------------------------------------------------------
//  CHECKOUT PAGE (address + payment + place order)
// ------------------------------------------------------------

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final List<String> paymentMethods = ['UPI', 'Card', 'Cash on Delivery'];
  final List<IconData> paymentIcons = [
    Icons.qr_code_rounded,
    Icons.credit_card_rounded,
    Icons.payments_rounded,
  ];

  int selectedPaymentIndex = 0;
  bool isPlacingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Order place karne ka poora kaam
  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isPlacingOrder = true);
    await Future.delayed(const Duration(milliseconds: 1600)); // fake processing time
    if (!mounted) return;

    final cart = context.read<CartProvider>();
    final orderId = context.read<OrderProvider>().placeOrder(
          items: cart.items,
          totalAmount: cart.grandTotal,
          paymentMethod: paymentMethods[selectedPaymentIndex],
        );
    cart.clearCart();

    // Pichle saare pages hata ke success page kholo
    Navigator.pushAndRemoveUntil(
      context,
      fadeSlideRoute(OrderSuccessPage(orderId: orderId)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 14),
                    const Text('Checkout', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Poora naam',
                  icon: Icons.person_rounded,
                  validator: (value) =>
                      (value == null || value.trim().length < 3) ? 'Sahi naam daalo' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _phoneController,
                  hint: 'Phone number',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      (value == null || value.trim().length != 10) ? '10 digit ka number daalo' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _addressController,
                  hint: 'Ghar ka poora address',
                  icon: Icons.home_rounded,
                  maxLines: 3,
                  validator: (value) =>
                      (value == null || value.trim().length < 8) ? 'Poora address daalo' : null,
                ),
                const SizedBox(height: 26),
                const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...List.generate(paymentMethods.length, _buildPaymentOption),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: cardShadow(context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${cart.totalItems} items ka total',
                          style: TextStyle(color: mutedColor(context), fontSize: 15)),
                      Text(
                        rupee(cart.grandTotal),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: brandColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                GradientButton(
                  text: 'Order Place Karo',
                  icon: Icons.check_circle_rounded,
                  isLoading: isPlacingOrder,
                  onTap: _placeOrder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: cardShadow(context),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: mutedColor(context)),
          prefixIcon: Icon(icon, color: brandColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(int index) {
    final isSelected = index == selectedPaymentIndex;

    return GestureDetector(
      onTap: () => setState(() => selectedPaymentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? soft(brandColor, 0.12) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? brandColor : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Icon(paymentIcons[index], color: isSelected ? brandColor : mutedColor(context)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                paymentMethods[index],
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                key: ValueKey(isSelected),
                color: isSelected ? brandColor : mutedColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
//  ORDER SUCCESS PAGE (tick animation + confetti)
// ------------------------------------------------------------

// Confetti ka ek tukda
class ConfettiPiece {
  final double xPosition; // 0 se 1 ke beech (screen ki width ka hissa)
  final double startDelay;
  final double size;
  final double phase;
  final double rotationSpeed;
  final Color color;

  ConfettiPiece({
    required this.xPosition,
    required this.startDelay,
    required this.size,
    required this.phase,
    required this.rotationSpeed,
    required this.color,
  });
}

class OrderSuccessPage extends StatefulWidget {
  final String orderId;

  const OrderSuccessPage({super.key, required this.orderId});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _circleScale;
  late final Animation<double> _checkProgress;
  late final Animation<double> _textFade;
  late final Animation<double> _buttonFade;
  late final List<ConfettiPiece> _confetti;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200));

    // Ek hi controller se alag alag timing par animations chalenge
    _circleScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
    );
    _checkProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.5, curve: Curves.easeInOut),
    );
    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
    );
    _buttonFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
    );

    // Random confetti pieces banao
    final random = Random();
    const confettiColors = [
      Colors.redAccent,
      Colors.amber,
      successGreen,
      brandColor,
      Colors.pinkAccent,
      Colors.lightBlueAccent,
    ];
    _confetti = List.generate(45, (index) {
      return ConfettiPiece(
        xPosition: random.nextDouble(),
        startDelay: random.nextDouble() * 0.5,
        size: 6 + random.nextDouble() * 8,
        phase: random.nextDouble() * pi * 2,
        rotationSpeed: 2 + random.nextDouble() * 6,
        color: confettiColors[random.nextInt(confettiColors.length)],
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Peeche confetti gir raha hai
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => CustomPaint(
                  painter: ConfettiPainter(pieces: _confetti, progress: _controller.value),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hara gola jo bounce hota hai
                    ScaleTransition(
                      scale: _circleScale,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: successGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: soft(successGreen, 0.45),
                              blurRadius: 40,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        // Tick mark khud draw hota hai
                        child: AnimatedBuilder(
                          animation: _checkProgress,
                          builder: (context, _) => CustomPaint(
                            painter: CheckMarkPainter(progress: _checkProgress.value),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          const Text(
                            'Order Place Ho Gaya! 🎉',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Order ID: ${widget.orderId}',
                            style: const TextStyle(
                              color: brandColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aapka saaman 3-5 din me\naapke ghar pahunch jayega.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: mutedColor(context), fontSize: 15, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _buttonFade,
                      child: GradientButton(
                        text: 'Shopping Jaari Rakho',
                        icon: Icons.storefront_rounded,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            fadeSlideRoute(const MainShell()),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Tick mark ko dheere dheere draw karne wala painter
class CheckMarkPainter extends CustomPainter {
  final double progress;

  CheckMarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.28, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.67)
      ..lineTo(size.width * 0.74, size.height * 0.36);

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final metric = path.computeMetrics().first;
    final partialPath = metric.extractPath(0, metric.length * progress);
    canvas.drawPath(partialPath, paint);
  }

  @override
  bool shouldRepaint(covariant CheckMarkPainter oldDelegate) => oldDelegate.progress != progress;
}

// Confetti gerne wala painter
class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> pieces;
  final double progress;

  ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      // Is piece ki apni progress (delay ke baad shuru hoti hai)
      final pieceProgress = ((progress - piece.startDelay) / (1 - piece.startDelay)).clamp(0.0, 1.0);
      if (pieceProgress <= 0) continue;

      final y = -20 + pieceProgress * (size.height + 40);
      final x = piece.xPosition * size.width + sin(pieceProgress * pi * 4 + piece.phase) * 22;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(pieceProgress * piece.rotationSpeed);
      final paint = Paint()..color = piece.color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: piece.size, height: piece.size * 0.6),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}

// ------------------------------------------------------------
//  PROFILE PAGE (theme switch + orders history)
// ------------------------------------------------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final wishlistCount = context.watch<WishlistProvider>().totalLiked;
    final cartCount = context.watch<CartProvider>().totalItems;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          // Profile header
          Row(
            children: [
              Container(
                height: 72,
                width: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(gradient: brandGradient, shape: BoxShape.circle),
                child: const Text('😎', style: TextStyle(fontSize: 38)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shopzy User', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Happy Shopping!', style: TextStyle(color: mutedColor(context))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // 3 chhote stats cards
          Row(
            children: [
              _buildStatCard(context, '${orderProvider.totalOrders}', 'Orders', Icons.inventory_2_rounded),
              const SizedBox(width: 12),
              _buildStatCard(context, '$wishlistCount', 'Wishlist', Icons.favorite_rounded),
              const SizedBox(width: 12),
              _buildStatCard(context, '$cartCount', 'In Cart', Icons.shopping_cart_rounded),
            ],
          ),
          const SizedBox(height: 24),
          // Dark mode switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: cardShadow(context),
            ),
            child: Row(
              children: [
                // Sun / Moon icon ghoomte hue badalta hai
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Icon(
                    themeProvider.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    key: ValueKey(themeProvider.isDark),
                    color: themeProvider.isDark ? brandColorLight : Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    themeProvider.isDark ? 'Dark Mode' : 'Light Mode',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
                Switch(
                  value: themeProvider.isDark,
                  activeColor: brandColor,
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text('Mere Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (orderProvider.orders.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'Abhi tak koi order nahi 📦',
                  style: TextStyle(color: mutedColor(context)),
                ),
              ),
            )
          else
            ...List.generate(orderProvider.orders.length, (index) {
              return StaggerIn(
                key: ValueKey(orderProvider.orders[index].orderId),
                index: index,
                child: OrderTile(order: orderProvider.orders[index]),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: cardShadow(context),
        ),
        child: Column(
          children: [
            Icon(icon, color: brandColor),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text(label, style: TextStyle(color: mutedColor(context), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// Order history ka ek order
class OrderTile extends StatelessWidget {
  final PlacedOrder order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final date = order.orderTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: cardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: soft(successGreen, 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.local_shipping_rounded, color: successGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(
                  order.itemNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: mutedColor(context), fontSize: 13),
                ),
                const SizedBox(height: 3),
                Text(
                  '${date.day}/${date.month}/${date.year} • ${order.paymentMethod}',
                  style: TextStyle(color: mutedColor(context), fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            rupee(order.totalAmount),
            style: const TextStyle(color: brandColor, fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
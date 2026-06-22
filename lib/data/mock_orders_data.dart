import 'models.dart';

// ═══════════════════════════════════════════════════════
//  MOCK ORDERS DATA — DeliVIP Orders Screen
// ═══════════════════════════════════════════════════════

/// Dummy items for reuse
final _pizzaMargherita = MenuItem(
  id: 'mock_m1',
  name: 'Margherita',
  description: 'Sauce tomate, mozzarella, basilic',
  price: 45.00,
  emoji: '🍕',
);

final _cola = MenuItem(
  id: 'mock_m2',
  name: 'Coca Cola',
  description: 'Canette 33cl',
  price: 8.00,
  emoji: '🥤',
);

final _burger = MenuItem(
  id: 'mock_m3',
  name: 'Big Burger',
  description: 'Deux steaks, salade, fromage',
  price: 35.00,
  emoji: '🍔',
);

final _frites = MenuItem(
  id: 'mock_m4',
  name: 'Frites Maison',
  description: 'Frites dorées et croustillantes',
  price: 15.00,
  emoji: '🍟',
);

final _sushi = MenuItem(
  id: 'mock_m5',
  name: 'California Roll',
  description: 'Crabe, avocat, concombre',
  price: 55.00,
  emoji: '🍣',
);

final _tacos = MenuItem(
  id: 'mock_m6',
  name: 'Tacos DeliVIP',
  description: 'Viande hachée, frites, fromage, sauce blanche',
  price: 42.00,
  emoji: '🌮',
);

final _nuggets = MenuItem(
  id: 'mock_m7',
  name: 'Nuggets 10 Pièces',
  description: 'Nuggets de poulet avec sauce BBQ',
  price: 39.00,
  emoji: '🐔',
);

/// Mock Past Orders (delivered / cancelled)
final List<Order> mockPastOrders = [
  Order(
    id: 'ORD-2026-0618',
    restaurantName: 'Pizza Marrakech',
    restaurantId: 'r1',
    items: [
      CartItem(item: _pizzaMargherita, quantity: 2),
      CartItem(item: _cola, quantity: 1),
    ],
    total: 98.00,
    deliveryAddress: '12 Rue des Orangers, Agadir',
    status: 'delivered',
    date: DateTime(2026, 6, 18, 19, 30),
  ),
  Order(
    id: 'ORD-2026-0615',
    restaurantName: 'Burger House',
    restaurantId: 'r2',
    items: [
      CartItem(item: _burger, quantity: 1),
      CartItem(item: _frites, quantity: 2),
      CartItem(item: _cola, quantity: 2),
    ],
    total: 81.00,
    deliveryAddress: '5 Boulevard Hassan II, Agadir',
    status: 'delivered',
    date: DateTime(2026, 6, 15, 20, 15),
  ),
  Order(
    id: 'ORD-2026-0610',
    restaurantName: 'Sushi Souss',
    restaurantId: 'r3',
    items: [
      CartItem(item: _sushi, quantity: 2),
      CartItem(item: _cola, quantity: 1),
    ],
    total: 118.00,
    deliveryAddress: '8 Avenue Mohammed V, Agadir',
    status: 'cancelled',
    date: DateTime(2026, 6, 10, 18, 45),
  ),
  Order(
    id: 'ORD-2026-0605',
    restaurantName: 'Tacos Factory',
    restaurantId: 'r4',
    items: [
      CartItem(item: _tacos, quantity: 2),
      CartItem(item: _frites, quantity: 1),
      CartItem(item: _nuggets, quantity: 1),
    ],
    total: 138.00,
    deliveryAddress: '3 Rue de la Liberté, Agadir',
    status: 'delivered',
    date: DateTime(2026, 6, 5, 21, 0),
  ),
];

/// Mock Active Order (currently delivering)
final Order mockActiveOrder = Order(
  id: 'ORD-2026-0620',
  restaurantName: 'Pizza Marrakech',
  restaurantId: 'r1',
  items: [
    CartItem(item: _pizzaMargherita, quantity: 1),
    CartItem(item: _tacos, quantity: 1),
    CartItem(item: _cola, quantity: 2),
  ],
  total: 103.00,
  deliveryAddress: '12 Rue des Orangers, Agadir',
  status: 'delivering',
  date: DateTime(2026, 6, 20, 19, 0),
);

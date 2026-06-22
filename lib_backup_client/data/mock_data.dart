import 'package:flutter/material.dart';
import '../models/store_model.dart';
import '../models/product_model.dart';

class MockData {
  // ==================== STORES ====================

  static List<StoreModel> restaurants = [
    StoreModel(
      id: 'r1',
      name: 'Burger House Agadir',
      emoji: '🍔',
      category: 'restaurants',
      tags: ['Burgers', 'Fast Food', 'American'],
      rating: 4.8,
      deliveryTime: '25-35 min',
      deliveryFee: 'Free',
      promoBadge: '-20%',
      bgColor: const Color(0xFFFFF3E0),
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
    ),
    StoreModel(
      id: 'r2',
      name: 'Pizza Marrakech',
      emoji: '🍕',
      category: 'restaurants',
      tags: ['Pizza', 'Italian', 'Pasta'],
      rating: 4.6,
      deliveryTime: '20-30 min',
      deliveryFee: '10 MAD',
      bgColor: const Color(0xFFFFEBEE),
      imageUrl:
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600&q=80',
    ),
    StoreModel(
      id: 'r3',
      name: 'Fresh Salad Bar',
      emoji: '🥗',
      category: 'restaurants',
      tags: ['Salads', 'Healthy', 'Vegan'],
      rating: 4.9,
      deliveryTime: '15-25 min',
      deliveryFee: 'Free',
      promoBadge: '-15%',
      bgColor: const Color(0xFFE8F5E9),
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&q=80',
    ),
    StoreModel(
      id: 'r4',
      name: 'Sushi Souss',
      emoji: '🍣',
      category: 'restaurants',
      tags: ['Sushi', 'Japanese', 'Asian'],
      rating: 4.7,
      deliveryTime: '30-40 min',
      deliveryFee: '15 MAD',
      bgColor: const Color(0xFFE3F2FD),
      imageUrl:
          'https://images.unsplash.com/photo-1553621042-f6e147245754?w=600&q=80',
    ),
  ];

  static List<StoreModel> boutiques = [
    StoreModel(
      id: 'b1',
      name: 'Zara Agadir',
      emoji: '👗',
      category: 'boutiques',
      tags: ['Fashion', 'Women', 'Men'],
      rating: 4.5,
      deliveryTime: '40-55 min',
      deliveryFee: 'Free',
      bgColor: const Color(0xFFFCE4EC),
      imageUrl:
          'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=600&q=80',
    ),
    StoreModel(
      id: 'b2',
      name: 'Adidas Store',
      emoji: '👟',
      category: 'boutiques',
      tags: ['Sports', 'Shoes', 'Fitness'],
      rating: 4.7,
      deliveryTime: '35-50 min',
      deliveryFee: '20 MAD',
      promoBadge: '-10%',
      bgColor: const Color(0xFFE8EAF6),
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&q=80',
    ),
    StoreModel(
      id: 'b3',
      name: 'Accessoires VIP',
      emoji: '👜',
      category: 'boutiques',
      tags: ['Accessories', 'Luxury', 'Bags'],
      rating: 4.4,
      deliveryTime: '30-45 min',
      deliveryFee: 'Free',
      bgColor: const Color(0xFFFFF8E1),
      imageUrl:
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&q=80',
    ),
  ];

  static List<StoreModel> supermarkets = [
    StoreModel(
      id: 's1',
      name: 'Marjane Agadir',
      emoji: '🏪',
      category: 'supermarkets',
      tags: ['Hypermarket', 'Groceries', 'Household'],
      rating: 4.3,
      deliveryTime: '30-45 min',
      deliveryFee: 'Free',
      bgColor: const Color(0xFFE0F2F1),
      imageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
    ),
    StoreModel(
      id: 's2',
      name: 'Carrefour',
      emoji: '🛒',
      category: 'supermarkets',
      tags: ['Supermarket', 'Groceries'],
      rating: 4.5,
      deliveryTime: '25-40 min',
      deliveryFee: '15 MAD',
      promoBadge: '-5%',
      bgColor: const Color(0xFFE3F2FD),
      imageUrl:
          'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=600&q=80',
    ),
    StoreModel(
      id: 's3',
      name: 'BIM Local',
      emoji: '🧺',
      category: 'supermarkets',
      tags: ['Discount', 'Groceries', 'Local'],
      rating: 4.1,
      deliveryTime: '20-30 min',
      deliveryFee: 'Free',
      bgColor: const Color(0xFFFFF8E1),
      imageUrl:
          'https://images.unsplash.com/photo-1608686207856-001b95cf60ca?w=600&q=80',
    ),
  ];

  static List<StoreModel> getStoresByCategory(String category) {
    switch (category) {
      case 'restaurants':
        return restaurants;
      case 'boutiques':
        return boutiques;
      case 'supermarkets':
        return supermarkets;
      default:
        return [...restaurants, ...boutiques, ...supermarkets];
    }
  }

  static List<StoreModel> popularStores = [
    restaurants[0],
    restaurants[1],
    boutiques[1],
    supermarkets[1],
  ];

  // ==================== PRODUCTS ====================

  static ProductModel classicBurger = ProductModel(
    id: 'p1',
    name: 'Classic Burger',
    description:
        'Smashed beef patty with fresh lettuce, tomato, and our special sauce, served in a brioche bun.',
    emoji: '🍔',
    basePrice: 45,
    calories: 650,
    bgColor: const Color(0xFFFFF3E0),
    optionGroups: [
      ProductOptionGroup(
        id: 'size',
        title: 'Choisissez votre taille',
        subtitle: 'Sélectionnez la taille de votre burger',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'size-reg',
            name: 'Regular',
            price: 0,
            isDefault: true,
          ),
          ProductOption(id: 'size-lg', name: 'Large', price: 10),
          ProductOption(id: 'size-xl', name: 'XL Double', price: 20),
        ],
      ),
      ProductOptionGroup(
        id: 'drink',
        title: 'Choisissez votre boisson',
        subtitle: 'Une boisson est incluse',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'drink-cola',
            name: 'Cola',
            emoji: '🥤',
            isDefault: true,
          ),
          ProductOption(id: 'drink-sprite', name: 'Sprite', emoji: '🥤'),
          ProductOption(
            id: 'drink-oj',
            name: 'Orange Juice',
            emoji: '🧃',
            price: 5,
          ),
          ProductOption(id: 'drink-water', name: 'Water', emoji: '💧'),
        ],
      ),
      ProductOptionGroup(
        id: 'extras',
        title: 'Ajoutez des extras',
        subtitle: 'Personnalisez votre burger',
        isRequired: false,
        maxSelections: 4,
        type: OptionType.checkbox,
        options: [
          ProductOption(
            id: 'ex-cheese',
            name: 'Extra Cheese',
            emoji: '🧀',
            price: 5,
          ),
          ProductOption(id: 'ex-bacon', name: 'Bacon', emoji: '🥓', price: 8),
          ProductOption(
            id: 'ex-jala',
            name: 'Jalapeños',
            emoji: '🌶️',
            price: 3,
          ),
          ProductOption(id: 'ex-egg', name: 'Fried Egg', emoji: '🥚', price: 6),
          ProductOption(id: 'ex-avo', name: 'Avocado', emoji: '🥑', price: 7),
        ],
      ),
      ProductOptionGroup(
        id: 'sauce',
        title: 'Choisissez votre sauce',
        subtitle: 'Sauce maison',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'sauce-ketchup',
            name: 'Ketchup',
            emoji: '🍅',
            isDefault: true,
          ),
          ProductOption(id: 'sauce-bbq', name: 'BBQ', emoji: '🫙'),
          ProductOption(id: 'sauce-garlic', name: 'Garlic Mayo', emoji: '🧄'),
          ProductOption(id: 'sauce-sriracha', name: 'Sriracha', emoji: '🌶️'),
        ],
      ),
      ProductOptionGroup(
        id: 'dessert',
        title: 'Choisissez votre dessert',
        subtitle: 'Ajoutez un dessert à votre commande',
        isRequired: false,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'dessert-none',
            name: 'No dessert',
            emoji: '🍦',
            isDefault: true,
          ),
          ProductOption(
            id: 'dessert-cookie',
            name: 'Cookie',
            emoji: '🍪',
            price: 12,
          ),
          ProductOption(
            id: 'dessert-cheese',
            name: 'Cheesecake',
            emoji: '🍰',
            price: 18,
          ),
          ProductOption(
            id: 'dessert-donut',
            name: 'Donut',
            emoji: '🍩',
            price: 10,
          ),
        ],
      ),
    ],
  );

  static ProductModel doubleSmash = ProductModel(
    id: 'p2',
    name: 'Double Smash',
    description:
        'Double smashed beef patties with melted cheese, caramelized onions, and pickles.',
    emoji: '🍔',
    basePrice: 65,
    calories: 850,
    bgColor: const Color(0xFFFFF3E0),
    optionGroups: [
      ProductOptionGroup(
        id: 'size',
        title: 'Choisissez votre taille',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(id: 'dbl-reg', name: 'Regular', isDefault: true),
          ProductOption(id: 'dbl-lg', name: 'Large', price: 10),
        ],
      ),
      ProductOptionGroup(
        id: 'drink',
        title: 'Choisissez votre boisson',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'dd-cola',
            name: 'Cola',
            emoji: '🥤',
            isDefault: true,
          ),
          ProductOption(id: 'dd-sprite', name: 'Sprite', emoji: '🥤'),
          ProductOption(
            id: 'dd-juice',
            name: 'Orange Juice',
            emoji: '🧃',
            price: 5,
          ),
        ],
      ),
      ProductOptionGroup(
        id: 'extras',
        title: 'Ajoutez des extras',
        isRequired: false,
        maxSelections: 3,
        type: OptionType.checkbox,
        options: [
          ProductOption(
            id: 'dd-ex-cheese',
            name: 'Extra Cheese',
            emoji: '🧀',
            price: 5,
          ),
          ProductOption(
            id: 'dd-ex-bacon',
            name: 'Bacon',
            emoji: '🥓',
            price: 8,
          ),
          ProductOption(
            id: 'dd-ex-egg',
            name: 'Fried Egg',
            emoji: '🥚',
            price: 6,
          ),
        ],
      ),
      ProductOptionGroup(
        id: 'sauce',
        title: 'Choisissez votre sauce',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'dd-sketchup',
            name: 'Ketchup',
            emoji: '🍅',
            isDefault: true,
          ),
          ProductOption(id: 'dd-sbbq', name: 'BBQ', emoji: '🫙'),
          ProductOption(id: 'dd-sgarlic', name: 'Garlic Mayo', emoji: '🧄'),
        ],
      ),
    ],
  );

  static ProductModel largeFries = ProductModel(
    id: 'p3',
    name: 'Large Fries',
    description: 'Crispy golden french fries seasoned with secret spices.',
    emoji: '🍟',
    basePrice: 20,
    calories: 450,
    bgColor: const Color(0xFFFFF8E1),
    optionGroups: [
      ProductOptionGroup(
        id: 'size',
        title: 'Choisissez votre taille',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'fr-med',
            name: 'Medium',
            price: 0,
            isDefault: true,
          ),
          ProductOption(id: 'fr-lg', name: 'Large', price: 5),
        ],
      ),
      ProductOptionGroup(
        id: 'sauce',
        title: 'Choisissez votre sauce',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'fr-sketchup',
            name: 'Ketchup',
            emoji: '🍅',
            isDefault: true,
          ),
          ProductOption(id: 'fr-sbbq', name: 'BBQ', emoji: '🫙'),
          ProductOption(id: 'fr-smayo', name: 'Mayo', emoji: '🧄'),
          ProductOption(
            id: 'fs-scheese',
            name: 'Cheese Sauce',
            emoji: '🧀',
            price: 5,
          ),
        ],
      ),
    ],
  );

  static ProductModel classicMeal = ProductModel(
    id: 'p4',
    name: 'Classic Meal',
    description: 'Classic Burger + Medium Fries + Drink. The perfect combo!',
    emoji: '🍱',
    basePrice: 75,
    calories: 1100,
    bgColor: const Color(0xFFE8F5E9),
    optionGroups: [
      ProductOptionGroup(
        id: 'burger-size',
        title: 'Taille du burger',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(id: 'cm-reg', name: 'Regular', isDefault: true),
          ProductOption(id: 'cm-lg', name: 'Large', price: 10),
        ],
      ),
      ProductOptionGroup(
        id: 'cm-drink',
        title: 'Choisissez votre boisson',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'cm-cola',
            name: 'Cola',
            emoji: '🥤',
            isDefault: true,
          ),
          ProductOption(id: 'cm-sprite', name: 'Sprite', emoji: '🥤'),
          ProductOption(
            id: 'cm-juice',
            name: 'Orange Juice',
            emoji: '🧃',
            price: 5,
          ),
          ProductOption(id: 'cm-tea', name: 'Iced Tea', emoji: '🫖', price: 4),
        ],
      ),
      ProductOptionGroup(
        id: 'cm-dessert',
        title: 'Ajoutez un dessert',
        isRequired: false,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'cdes-none',
            name: 'No dessert',
            emoji: '🍦',
            isDefault: true,
          ),
          ProductOption(
            id: 'cdes-cookie',
            name: 'Cookie',
            emoji: '🍪',
            price: 12,
          ),
          ProductOption(
            id: 'cdes-donut',
            name: 'Donut',
            emoji: '🍩',
            price: 10,
          ),
        ],
      ),
    ],
  );

  static ProductModel familyPack = ProductModel(
    id: 'p5',
    name: 'Family Pack',
    description:
        '4 Classic Burgers + 2 Large Fries + 4 Drinks. For the whole family!',
    emoji: '👨‍👩‍👧‍👦',
    basePrice: 130,
    calories: 2200,
    bgColor: const Color(0xFFFFF3E0),
    optionGroups: [
      ProductOptionGroup(
        id: 'fp-drinks',
        title: 'Choisissez vos boissons (x4)',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'fp-cola',
            name: 'Cola',
            emoji: '🥤',
            isDefault: true,
          ),
          ProductOption(id: 'fp-sprite', name: 'Sprite', emoji: '🥤'),
          ProductOption(
            id: 'fp-juice',
            name: 'Orange Juice',
            emoji: '🧃',
            price: 5,
          ),
        ],
      ),
    ],
  );

  static ProductModel colaLarge = ProductModel(
    id: 'p6',
    name: 'Cola Large',
    description: 'Large refreshing Coca-Cola served with ice.',
    emoji: '🥤',
    basePrice: 15,
    calories: 210,
    bgColor: const Color(0xFFE3F2FD),
    optionGroups: [
      ProductOptionGroup(
        id: 'ice',
        title: 'Ajoutez des glaçons',
        isRequired: false,
        type: OptionType.radio,
        options: [
          ProductOption(id: 'ice-yes', name: 'With ice', isDefault: true),
          ProductOption(id: 'ice-no', name: 'No ice'),
        ],
      ),
    ],
  );

  static ProductModel bigTasty = ProductModel(
    id: 'p7',
    name: 'Big Tasty',
    description:
        'Our signature Big Tasty with smoked sauce and fresh toppings.',
    emoji: '🍔',
    basePrice: 75,
    calories: 920,
    bgColor: const Color(0xFFE8EAF6),
    optionGroups: [
      ProductOptionGroup(
        id: 'bt-option',
        title: "Choisissez l'option",
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'bt-classic',
            name: 'Big Tasty Classic',
            isDefault: true,
          ),
          ProductOption(id: 'bt-bacon', name: 'Big Tasty Bacon', price: 10),
          ProductOption(id: 'bt-double', name: 'Big Tasty Double', price: 15),
          ProductOption(id: 'bt-xxl', name: 'Big Tasty XXL', price: 25),
        ],
      ),
      ProductOptionGroup(
        id: 'bt-custom',
        title: 'Personnalisez votre Big Tasty',
        subtitle: 'Ajustez les ingrédients',
        isRequired: false,
        type: OptionType.stepper,
        options: [
          ProductOption(
            id: 'bt-onions',
            name: 'Caramelized Onions',
            emoji: '🧅',
            isDefault: true,
          ),
          ProductOption(
            id: 'bt-pickles',
            name: 'Pickles',
            emoji: '🥒',
            isDefault: true,
          ),
          ProductOption(
            id: 'bt-cheese',
            name: 'Cheese Slices',
            emoji: '🧀',
            isDefault: true,
          ),
          ProductOption(
            id: 'bt-sauce',
            name: 'Big Tasty Sauce',
            emoji: '🫙',
            isDefault: true,
          ),
        ],
      ),
      ProductOptionGroup(
        id: 'bt-drink',
        title: 'Choisissez votre boisson',
        isRequired: true,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'bt-cola',
            name: 'Cola',
            emoji: '🥤',
            isDefault: true,
          ),
          ProductOption(id: 'bt-sprite', name: 'Sprite', emoji: '🥤'),
          ProductOption(
            id: 'bt-juice',
            name: 'Orange Juice',
            emoji: '🧃',
            price: 5,
          ),
          ProductOption(id: 'bt-tea', name: 'Iced Tea', emoji: '🫖', price: 4),
        ],
      ),
      ProductOptionGroup(
        id: 'bt-extras',
        title: 'Ajoutez des extras',
        isRequired: false,
        maxSelections: 3,
        type: OptionType.checkbox,
        options: [
          ProductOption(id: 'btx-bacon', name: 'Bacon', emoji: '🥓', price: 8),
          ProductOption(
            id: 'btx-cheese',
            name: 'Cheese',
            emoji: '🧀',
            price: 5,
          ),
          ProductOption(
            id: 'btx-egg',
            name: 'Fried Egg',
            emoji: '🥚',
            price: 6,
          ),
        ],
      ),
      ProductOptionGroup(
        id: 'bt-dessert',
        title: 'Choisissez votre dessert',
        isRequired: false,
        type: OptionType.radio,
        options: [
          ProductOption(
            id: 'btd-none',
            name: 'No dessert',
            emoji: '🍦',
            isDefault: true,
          ),
          ProductOption(
            id: 'btd-muffin',
            name: 'Muffin',
            emoji: '🧁',
            price: 14,
          ),
          ProductOption(
            id: 'btd-cheese',
            name: 'Cheesecake',
            emoji: '🍰',
            price: 18,
          ),
          ProductOption(id: 'btd-donut', name: 'Donut', emoji: '🍩', price: 10),
        ],
      ),
    ],
  );

  static Map<String, List<ProductModel>> storeProducts = {
    'r1': [
      classicBurger,
      doubleSmash,
      largeFries,
      classicMeal,
      familyPack,
      colaLarge,
      bigTasty,
    ],
    'r2': [
      ProductModel(
        id: 'pz1',
        name: 'Margherita',
        description: 'Fresh mozzarella, tomato sauce, basil',
        emoji: '🍕',
        basePrice: 55,
        calories: 700,
        bgColor: const Color(0xFFFFEBEE),
        optionGroups: [
          ProductOptionGroup(
            id: 'pz-size',
            title: 'Choisissez la taille',
            isRequired: true,
            type: OptionType.radio,
            options: [
              ProductOption(id: 'pz-m', name: 'Medium', isDefault: true),
              ProductOption(id: 'pz-l', name: 'Large', price: 15),
              ProductOption(id: 'pz-xl', name: 'XL', price: 25),
            ],
          ),
          ProductOptionGroup(
            id: 'pz-drink',
            title: 'Choisissez votre boisson',
            isRequired: true,
            type: OptionType.radio,
            options: [
              ProductOption(
                id: 'pzc-cola',
                name: 'Cola',
                emoji: '🥤',
                isDefault: true,
              ),
              ProductOption(id: 'pzc-sprite', name: 'Sprite', emoji: '🥤'),
            ],
          ),
        ],
      ),
      ProductModel(
        id: 'pz2',
        name: 'Pepperoni',
        description: 'Loaded with pepperoni and mozzarella',
        emoji: '🍕',
        basePrice: 65,
        calories: 850,
        bgColor: const Color(0xFFFFCDD2),
        optionGroups: [
          ProductOptionGroup(
            id: 'pp-size',
            title: 'Choisissez la taille',
            isRequired: true,
            type: OptionType.radio,
            options: [
              ProductOption(id: 'pp-m', name: 'Medium', isDefault: true),
              ProductOption(id: 'pp-l', name: 'Large', price: 15),
              ProductOption(id: 'pp-xl', name: 'XL', price: 25),
            ],
          ),
          ProductOptionGroup(
            id: 'pp-extras',
            title: 'Extras',
            isRequired: false,
            maxSelections: 3,
            type: OptionType.checkbox,
            options: [
              ProductOption(
                id: 'ppx-cheese',
                name: 'Extra Cheese',
                emoji: '🧀',
                price: 5,
              ),
              ProductOption(
                id: 'ppx-pep',
                name: 'Extra Pepperoni',
                emoji: '🍖',
                price: 7,
              ),
            ],
          ),
        ],
      ),
    ],
    'r3': [
      ProductModel(
        id: 'sl1',
        name: 'Caesar Salad',
        description: 'Romaine, parmesan, croutons, caesar dressing',
        emoji: '🥗',
        basePrice: 40,
        calories: 320,
        bgColor: const Color(0xFFE8F5E9),
        optionGroups: [
          ProductOptionGroup(
            id: 'cs-size',
            title: 'Taille',
            isRequired: true,
            type: OptionType.radio,
            options: [
              ProductOption(id: 'cs-reg', name: 'Regular', isDefault: true),
              ProductOption(id: 'cs-lg', name: 'Large', price: 8),
            ],
          ),
          ProductOptionGroup(
            id: 'cs-protein',
            title: 'Ajoutez une protéine',
            isRequired: false,
            type: OptionType.radio,
            options: [
              ProductOption(id: 'cs-none', name: 'None', isDefault: true),
              ProductOption(
                id: 'cs-chicken',
                name: 'Grilled Chicken',
                price: 12,
              ),
              ProductOption(id: 'cs-salmon', name: 'Salmon', price: 18),
            ],
          ),
        ],
      ),
    ],
    'r4': [
      ProductModel(
        id: 'su1',
        name: 'California Roll',
        description: 'Crab, avocado, cucumber',
        emoji: '🍣',
        basePrice: 55,
        calories: 400,
        bgColor: const Color(0xFFE3F2FD),
        optionGroups: [
          ProductOptionGroup(
            id: 'su-qty',
            title: 'Nombre de pièces',
            isRequired: true,
            type: OptionType.radio,
            options: [
              ProductOption(id: 'su-6', name: '6 pcs', isDefault: true),
              ProductOption(id: 'su-8', name: '8 pcs', price: 15),
              ProductOption(id: 'su-12', name: '12 pcs', price: 30),
            ],
          ),
        ],
      ),
    ],
    'b1': [],
    'b2': [],
    'b3': [],
    's1': [],
    's2': [],
    's3': [],
  };

  static List<ProductModel> getProductsForStore(String storeId) {
    final products = storeProducts[storeId];
    if (products == null || products.isEmpty) {
      // Return placeholder products
      return [
        ProductModel(
          id: 'placeholder',
          name: 'Coming Soon',
          description: 'Products coming soon for this store',
          emoji: '🛍️',
          basePrice: 0,
          bgColor: const Color(0xFFF5F5F5),
          optionGroups: [],
        ),
      ];
    }
    return products;
  }
}

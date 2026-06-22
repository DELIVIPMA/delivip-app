import '../models/store.dart';
import '../models/store_type.dart';
import '../models/product.dart';

class StoresData {
  static List<Store> getAllStores() {
    return [
      ...getRestaurants(),
      ...getGroceryStores(),
      ...getPharmacies(),
      ...getShops(),
    ];
  }

  static List<Store> getRestaurants() {
    return [
      Store(
        id: 'r1',
        name: 'McDonald\'s Agadir',
        description: 'Fast-food américain',
        image:
            'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800',
        storeType: StoreType.restaurant,
        category: 'Fast-food',
        rating: 4.5,
        deliveryTime: 20,
        deliveryFee: 0,
        isVIP: true,
        address: 'Avenue Hassan II, Agadir',
        products: [
          Product(
            id: 'r1-p1',
            name: 'Big Mac',
            description: 'Double steak, sauce Big Mac, salade, cornichons',
            price: 45.00,
            image:
                'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400',
            category: 'Burgers',
            isPopular: true,
            rating: 4.7,
            options: [
              ProductOption(
                id: 'size',
                name: 'Taille',
                isRequired: true,
                variants: [
                  ProductVariant(
                    id: 'normal',
                    name: 'Normal',
                    priceModifier: 0,
                  ),
                  ProductVariant(
                    id: 'maxi',
                    name: 'Maxi Best Of',
                    priceModifier: 15,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: 'r1-p2',
            name: 'Frites',
            description: 'Frites croustillantes',
            price: 15.00,
            image:
                'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
            category: 'Accompagnements',
            rating: 4.5,
            options: [
              ProductOption(
                id: 'size',
                name: 'Taille',
                isRequired: true,
                variants: [
                  ProductVariant(id: 'small', name: 'Petite', priceModifier: 0),
                  ProductVariant(
                    id: 'medium',
                    name: 'Moyenne',
                    priceModifier: 5,
                  ),
                  ProductVariant(
                    id: 'large',
                    name: 'Grande',
                    priceModifier: 10,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: 'r1-p3',
            name: 'Coca-Cola',
            description: 'Boisson gazeuse',
            price: 10.00,
            image:
                'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
            category: 'Boissons',
            rating: 4.8,
            options: [
              ProductOption(
                id: 'size',
                name: 'Taille',
                isRequired: true,
                variants: [
                  ProductVariant(
                    id: 'small',
                    name: 'Petite (25cl)',
                    priceModifier: 0,
                  ),
                  ProductVariant(
                    id: 'medium',
                    name: 'Moyenne (40cl)',
                    priceModifier: 5,
                  ),
                  ProductVariant(
                    id: 'large',
                    name: 'Grande (50cl)',
                    priceModifier: 8,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: 'r1-p4',
            name: 'Sauce Ketchup',
            description: 'Sauce tomate',
            price: 2.00,
            image:
                'https://images.unsplash.com/photo-1598214886806-c87b84b7078b?w=400',
            category: 'Sauces',
            rating: 4.3,
          ),
          Product(
            id: 'r1-p5',
            name: 'Sauce Mayonnaise',
            description: 'Sauce mayonnaise',
            price: 2.00,
            image:
                'https://images.unsplash.com/photo-1598214886806-c87b84b7078b?w=400',
            category: 'Sauces',
            rating: 4.3,
          ),
          Product(
            id: 'r1-p6',
            name: 'Nuggets (6 pièces)',
            description: 'Nuggets de poulet croustillants',
            price: 30.00,
            image:
                'https://images.unsplash.com/photo-1562967914-608f82629710?w=400',
            category: 'Accompagnements',
            isPopular: true,
            rating: 4.6,
          ),
        ],
      ),
      Store(
        id: 'r2',
        name: 'Pizza Hut Agadir',
        description: 'Pizzas et pâtes italiennes',
        image:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
        storeType: StoreType.restaurant,
        category: 'Italien',
        rating: 4.6,
        deliveryTime: 30,
        deliveryFee: 15,
        isVIP: false,
        address: 'Boulevard Mohammed V, Agadir',
        products: [
          Product(
            id: 'r2-p1',
            name: 'Pizza Margherita',
            description: 'Tomate, mozzarella, basilic',
            price: 85.00,
            image:
                'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
            category: 'Pizzas',
            isPopular: true,
            rating: 4.7,
            options: [
              ProductOption(
                id: 'size',
                name: 'Taille',
                isRequired: true,
                variants: [
                  ProductVariant(
                    id: 'medium',
                    name: 'Moyenne',
                    priceModifier: 0,
                  ),
                  ProductVariant(
                    id: 'large',
                    name: 'Grande',
                    priceModifier: 25,
                  ),
                  ProductVariant(
                    id: 'xlarge',
                    name: 'Très Grande',
                    priceModifier: 45,
                  ),
                ],
              ),
              ProductOption(
                id: 'crust',
                name: 'Pâte',
                isRequired: true,
                variants: [
                  ProductVariant(
                    id: 'classic',
                    name: 'Classique',
                    priceModifier: 0,
                  ),
                  ProductVariant(id: 'thin', name: 'Fine', priceModifier: 0),
                  ProductVariant(
                    id: 'stuffed',
                    name: 'Farcie',
                    priceModifier: 15,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: 'r2-p2',
            name: 'Pizza 4 Fromages',
            description: 'Mozzarella, gorgonzola, parmesan, chèvre',
            price: 95.00,
            image:
                'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
            category: 'Pizzas',
            rating: 4.8,
          ),
          Product(
            id: 'r2-p3',
            name: 'Coca-Cola 1.5L',
            description: 'Bouteille familiale',
            price: 15.00,
            image:
                'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
            category: 'Boissons',
            rating: 4.5,
          ),
        ],
      ),
      Store(
        id: 'r3',
        name: 'Tajine Royal',
        description: 'Cuisine marocaine traditionnelle',
        image:
            'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?w=800',
        storeType: StoreType.restaurant,
        category: 'Marocain',
        rating: 4.8,
        deliveryTime: 35,
        deliveryFee: 0,
        isVIP: true,
        address: 'Rue de la Kasbah, Agadir',
        products: [
          Product(
            id: 'r3-p1',
            name: 'Couscous Royal',
            description: 'Couscous avec viandes et légumes',
            price: 110.00,
            image:
                'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?w=400',
            category: 'Plats',
            isPopular: true,
            rating: 4.9,
          ),
          Product(
            id: 'r3-p2',
            name: 'Tajine Poulet',
            description: 'Tajine aux olives et citron confit',
            price: 95.00,
            image:
                'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?w=400',
            category: 'Plats',
            rating: 4.7,
          ),
          Product(
            id: 'r3-p3',
            name: 'Thé à la Menthe',
            description: 'Thé traditionnel marocain',
            price: 20.00,
            image:
                'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
            category: 'Boissons',
            rating: 4.9,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Burger King — Burger
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r4',
        name: 'Burger King Agadir',
        description: 'Burgers grillés à la flamme',
        image:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
        storeType: StoreType.restaurant,
        category: 'Burger',
        rating: 4.5,
        deliveryTime: 20,
        deliveryFee: 0,
        isVIP: true,
        address: 'Avenue Mohammed V, Agadir',
        products: [
          Product(
            id: 'r4-p1',
            name: 'Whopper',
            description:
                'Steak haché grillé, salade, tomate, oignons, cornichons',
            price: 55.00,
            image:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
            category: 'Burgers',
            isPopular: true,
            rating: 4.7,
            options: [
              ProductOption(
                id: 'size',
                name: 'Menu',
                isRequired: false,
                variants: [
                  ProductVariant(id: 'alone', name: 'Seul', priceModifier: 0),
                  ProductVariant(
                    id: 'menu',
                    name: 'Menu (frites + boisson)',
                    priceModifier: 20,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: 'r4-p2',
            name: 'Double Whopper',
            description: 'Double steak, fromage fondant, sauce BBQ',
            price: 75.00,
            image:
                'https://images.unsplash.com/photo-1565299507177-b0ac605638b1?w=400',
            category: 'Burgers',
            rating: 4.8,
          ),
          Product(
            id: 'r4-p3',
            name: 'Chicken Fries',
            description: 'Frites de poulet croustillantes',
            price: 30.00,
            image:
                'https://images.unsplash.com/photo-1562967914-608f82629710?w=400',
            category: 'Accompagnements',
            rating: 4.5,
          ),
          Product(
            id: 'r4-p4',
            name: 'Onion Rings',
            description: 'Beignets d\'oignons croustillants (8 pièces)',
            price: 28.00,
            image:
                'https://images.unsplash.com/photo-1639024471283-03518883512d?w=400',
            category: 'Accompagnements',
            isPopular: true,
            rating: 4.6,
          ),
          Product(
            id: 'r4-p5',
            name: 'Milkshake Oreo',
            description: 'Milkshake onctueux aux morceaux d\'Oreo',
            price: 35.00,
            image:
                'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=400',
            category: 'Boissons',
            rating: 4.7,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Tacos King — Tacos
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r5',
        name: 'Tacos King',
        description: 'Tacos et cuisine mexicaine',
        image:
            'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=800',
        storeType: StoreType.restaurant,
        category: 'Tacos',
        rating: 4.6,
        deliveryTime: 25,
        deliveryFee: 10,
        isVIP: false,
        address: 'Rue des Orangers, Agadir',
        products: [
          Product(
            id: 'r5-p1',
            name: 'Tacos Poulet',
            description: 'Tacos garni de poulet mariné, fromage, frites maison',
            price: 55.00,
            image:
                'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400',
            category: 'Tacos',
            isPopular: true,
            rating: 4.7,
            options: [
              ProductOption(
                id: 'size',
                name: 'Taille',
                isRequired: true,
                variants: [
                  ProductVariant(id: 'small', name: 'Petit', priceModifier: 0),
                  ProductVariant(
                    id: 'medium',
                    name: 'Moyen',
                    priceModifier: 10,
                  ),
                  ProductVariant(id: 'large', name: 'Grand', priceModifier: 20),
                ],
              ),
            ],
          ),
          Product(
            id: 'r5-p2',
            name: 'Tacos Mixte',
            description:
                'Tacos viande hachée, poulet, frites, fromage, sauce blanche',
            price: 65.00,
            image:
                'https://images.unsplash.com/photo-1597541464519-003c0d6063b1?w=400',
            category: 'Tacos',
            rating: 4.8,
          ),
          Product(
            id: 'r5-p3',
            name: 'Quesadillas',
            description: 'Tortillas garnies de fromage et poulet',
            price: 45.00,
            image:
                'https://images.unsplash.com/photo-1618040996337-56904b7850b1?w=400',
            category: 'Spécialités',
            isPopular: true,
            rating: 4.6,
          ),
          Product(
            id: 'r5-p4',
            name: 'Nachos Cheese',
            description: 'Nachos avec sauce fromage fondant',
            price: 35.00,
            image:
                'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=400',
            category: 'Entrées',
            rating: 4.5,
          ),
          Product(
            id: 'r5-p5',
            name: 'Soda Mexicain',
            description: 'Boisson gazeuse importée du Mexique',
            price: 15.00,
            image:
                'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
            category: 'Boissons',
            rating: 4.4,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Fresh & Healthy — Salade
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r6',
        name: 'Fresh & Healthy',
        description: 'Salades fraîches et cuisine healthy',
        image:
            'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
        storeType: StoreType.restaurant,
        category: 'Salade',
        rating: 4.7,
        deliveryTime: 20,
        deliveryFee: 0,
        isVIP: true,
        address: 'Quartier Founty, Agadir',
        products: [
          Product(
            id: 'r6-p1',
            name: 'Salade César',
            description:
                'Laitue romaine, poulet grillé, parmesan, croûtons, sauce César',
            price: 65.00,
            image:
                'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
            category: 'Salades',
            isPopular: true,
            rating: 4.8,
          ),
          Product(
            id: 'r6-p2',
            name: 'Salade Avocat Crevettes',
            description: 'Avocat frais, crevettes, roquette, sauce citronnée',
            price: 78.00,
            image:
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
            category: 'Salades',
            rating: 4.7,
          ),
          Product(
            id: 'r6-p3',
            name: 'Buddha Bowl',
            description:
                'Quinoa, avocat, légumes grillés, pois chiches, sauce tahini',
            price: 72.00,
            image:
                'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
            category: 'Bowls',
            isPopular: true,
            rating: 4.6,
          ),
          Product(
            id: 'r6-p4',
            name: 'Jus Vert Détox',
            description: 'Jus frais pomme, épinard, gingembre, citron',
            price: 28.00,
            image:
                'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400',
            category: 'Boissons',
            rating: 4.5,
          ),
          Product(
            id: 'r6-p5',
            name: 'Smoothie Bowl',
            description: 'Bol de fruits frais, granola, graines de chia, miel',
            price: 55.00,
            image:
                'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400',
            category: 'Bowls',
            rating: 4.7,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Kebab Chef — Chawarma
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r7',
        name: 'Kebab Chef',
        description: 'Chawarma et kebab authentiques',
        image:
            'https://images.unsplash.com/photo-1653312727963-479e2901287b?w=800',
        storeType: StoreType.restaurant,
        category: 'Chawarma',
        rating: 4.5,
        deliveryTime: 15,
        deliveryFee: 10,
        isVIP: false,
        address: 'Boulevard Hassan II, Agadir',
        products: [
          Product(
            id: 'r7-p1',
            name: 'Chawarma Poulet',
            description:
                'Pain libanais garni de poulet mariné, salade, sauce blanche',
            price: 30.00,
            image:
                'https://images.unsplash.com/photo-1653312727963-479e2901287b?w=400',
            category: 'Chawarmas',
            isPopular: true,
            rating: 4.6,
          ),
          Product(
            id: 'r7-p2',
            name: 'Chawarma Viande',
            description: 'Pain libanais garni de viande hachée épicée',
            price: 35.00,
            image:
                'https://images.unsplash.com/photo-1653312727963-479e2901287b?w=400',
            category: 'Chawarmas',
            rating: 4.5,
          ),
          Product(
            id: 'r7-p3',
            name: 'Kebab Assiette',
            description: 'Assiette de kebab avec frites, salade et sauce',
            price: 55.00,
            image:
                'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=400',
            category: 'Plats',
            isPopular: true,
            rating: 4.7,
          ),
          Product(
            id: 'r7-p4',
            name: 'Falafel (6 pièces)',
            description: 'Boulettes de pois chiches frites, sauce tahini',
            price: 25.00,
            image:
                'https://images.unsplash.com/photo-1593001874117-c99c1590e5c7?w=400',
            category: 'Entrées',
            rating: 4.4,
          ),
          Product(
            id: 'r7-p5',
            name: 'Jus d\'Orange Frais',
            description: 'Jus d\'orange pressé',
            price: 18.00,
            image:
                'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400',
            category: 'Boissons',
            rating: 4.6,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Grill House — Grillades
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r8',
        name: 'Grill House',
        description: 'Grillades et viandes au barbecue',
        image:
            'https://images.unsplash.com/photo-1558030006-450675393462?w=800',
        storeType: StoreType.restaurant,
        category: 'Grillades',
        rating: 4.7,
        deliveryTime: 30,
        deliveryFee: 0,
        isVIP: true,
        address: 'Route de l\'Oued, Agadir',
        products: [
          Product(
            id: 'r8-p1',
            name: 'Brochette de Bœuf',
            description: '3 brochettes de bœuf mariné, grillées au charbon',
            price: 85.00,
            image:
                'https://images.unsplash.com/photo-1558030006-450675393462?w=400',
            category: 'Grillades',
            isPopular: true,
            rating: 4.8,
          ),
          Product(
            id: 'r8-p2',
            name: 'Côtelette d\'Agneau',
            description: 'Côtelettes d\'agneau grillées, marinade aux herbes',
            price: 110.00,
            image:
                'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
            category: 'Grillades',
            rating: 4.9,
          ),
          Product(
            id: 'r8-p3',
            name: 'Poulet Grillé',
            description: 'Demi-poulet grillé, épices maison',
            price: 65.00,
            image:
                'https://images.unsplash.com/photo-1587593810167-a84920ea5efb?w=400',
            category: 'Grillades',
            isPopular: true,
            rating: 4.6,
          ),
          Product(
            id: 'r8-p4',
            name: 'Merguez (6 pièces)',
            description: 'Merguez grillées, sauce piquante',
            price: 40.00,
            image:
                'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400',
            category: 'Grillades',
            rating: 4.5,
          ),
          Product(
            id: 'r8-p5',
            name: 'Frites Maison',
            description: 'Frites épaisses maison',
            price: 20.00,
            image:
                'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
            category: 'Accompagnements',
            rating: 4.4,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Sushi Master — Sushi
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r9',
        name: 'Sushi Master',
        description: 'Sushis et cuisine japonaise authentique',
        image:
            'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800',
        storeType: StoreType.restaurant,
        category: 'Sushi',
        rating: 4.9,
        deliveryTime: 30,
        deliveryFee: 0,
        isVIP: true,
        address: 'Marina d\'Agadir',
        products: [
          Product(
            id: 'r9-p1',
            name: 'Plateau Sushi Premium',
            description:
                '20 pièces : 6 sushis saumon, 6 sushis thon, 8 makis variés',
            price: 180.00,
            image:
                'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400',
            category: 'Plateaux',
            isPopular: true,
            rating: 5.0,
          ),
          Product(
            id: 'r9-p2',
            name: 'Sashimi Deluxe',
            description:
                '15 tranches de poissons frais (saumon, thon, daurade)',
            price: 160.00,
            image:
                'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=400',
            category: 'Plateaux',
            rating: 4.9,
          ),
          Product(
            id: 'r9-p3',
            name: 'California Roll',
            description: 'Maki crabe, avocat, concombre, sésame',
            price: 75.00,
            image:
                'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
            category: 'Makis',
            isPopular: true,
            rating: 4.7,
          ),
          Product(
            id: 'r9-p4',
            name: 'Tempura Crevettes',
            description: 'Crevettes panées à la japonaise, sauce soja',
            price: 65.00,
            image:
                'https://images.unsplash.com/photo-1569058242567-93de6f36f8e6?w=400',
            category: 'Entrées',
            rating: 4.6,
          ),
          Product(
            id: 'r9-p5',
            name: 'Thé Matcha',
            description: 'Thé vert japonais premium',
            price: 25.00,
            image:
                'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
            category: 'Boissons',
            rating: 4.8,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Darna — Marocain
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r10',
        name: 'Darna',
        description: 'Restaurant marocain traditionnel et authentique',
        image:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
        storeType: StoreType.restaurant,
        category: 'Marocain',
        rating: 4.8,
        deliveryTime: 35,
        deliveryFee: 0,
        isVIP: true,
        address: 'Médina d\'Agadir',
        products: [
          Product(
            id: 'r10-p1',
            name: 'Pastilla au Poulet',
            description: 'Feuilleté sucré-salé au poulet, amandes et cannelle',
            price: 80.00,
            image:
                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=400',
            category: 'Entrées',
            isPopular: true,
            rating: 4.8,
          ),
          Product(
            id: 'r10-p2',
            name: 'Tajine Kefta',
            description: 'Boulettes de viande hachée, œufs, sauce tomate',
            price: 85.00,
            image:
                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=400',
            category: 'Plats',
            rating: 4.7,
          ),
          Product(
            id: 'r10-p3',
            name: 'Couscous aux 7 Légumes',
            description: 'Semoule fine, 7 légumes de saison, merguez',
            price: 95.00,
            image:
                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=400',
            category: 'Plats',
            isPopular: true,
            rating: 4.8,
          ),
          Product(
            id: 'r10-p4',
            name: 'Harira',
            description: 'Soupe marocaine traditionnelle aux légumes et viande',
            price: 30.00,
            image:
                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=400',
            category: 'Entrées',
            rating: 4.5,
          ),
          Product(
            id: 'r10-p5',
            name: 'Cornes de Gazelle',
            description: 'Pâtisserie marocaine aux amandes (6 pièces)',
            price: 35.00,
            image:
                'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=400',
            category: 'Desserts',
            rating: 4.9,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Le Port — Fruits de Mer
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r11',
        name: 'Le Port',
        description: 'Fruits de mer frais et poissons grillés',
        image:
            'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
        storeType: StoreType.restaurant,
        category: 'Fruits de Mer',
        rating: 4.8,
        deliveryTime: 30,
        deliveryFee: 0,
        isVIP: true,
        address: 'Port de Pêche, Agadir',
        products: [
          Product(
            id: 'r11-p1',
            name: 'Plateau Royal de Fruits de Mer',
            description: 'Huîtres, crevettes, langoustines, crabes, bulots',
            price: 220.00,
            image:
                'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
            category: 'Plateaux',
            isPopular: true,
            rating: 4.9,
          ),
          Product(
            id: 'r11-p2',
            name: 'Sole Meunière',
            description:
                'Sole fraîche grillée, beurre citronné, légumes de saison',
            price: 130.00,
            image:
                'https://images.unsplash.com/photo-1534604973900-c43ab4c2e0ab?w=400',
            category: 'Poissons',
            rating: 4.8,
          ),
          Product(
            id: 'r11-p3',
            name: 'Tagine de Poisson',
            description:
                'Poisson blanc, pommes de terre, olives, tomates confites',
            price: 95.00,
            image:
                'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
            category: 'Tajines',
            isPopular: true,
            rating: 4.7,
          ),
          Product(
            id: 'r11-p4',
            name: 'Crevettes Grillées',
            description: 'Crevettes royales grillées, sauce ail et persil',
            price: 110.00,
            image:
                'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
            category: 'Grillades',
            rating: 4.7,
          ),
          Product(
            id: 'r11-p5',
            name: 'Paella aux Fruits de Mer',
            description: 'Riz espagnol aux fruits de mer, safran',
            price: 120.00,
            image:
                'https://images.unsplash.com/photo-1534604973900-c43ab4c2e0ab?w=400',
            category: 'Plats',
            rating: 4.6,
          ),
        ],
      ),
      // ═══════════════════════════════════════════════════════════
      // Pizza Napoli — Pizza
      // ═══════════════════════════════════════════════════════════
      Store(
        id: 'r12',
        name: 'Pizza Napoli',
        description: 'Pizzas italiennes artisanales au feu de bois',
        image:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
        storeType: StoreType.restaurant,
        category: 'Pizza',
        rating: 4.6,
        deliveryTime: 25,
        deliveryFee: 10,
        isVIP: false,
        address: 'Rue de la Liberté, Agadir',
        products: [
          Product(
            id: 'r12-p1',
            name: 'Pizza Margherita',
            description: 'Sauce tomate, mozzarella di bufala, basilic frais',
            price: 75.00,
            image:
                'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
            category: 'Pizzas',
            isPopular: true,
            rating: 4.7,
            options: [
              ProductOption(
                id: 'size',
                name: 'Taille',
                isRequired: true,
                variants: [
                  ProductVariant(
                    id: 'medium',
                    name: 'Moyenne',
                    priceModifier: 0,
                  ),
                  ProductVariant(
                    id: 'large',
                    name: 'Grande',
                    priceModifier: 20,
                  ),
                  ProductVariant(
                    id: 'xlarge',
                    name: 'Extra Large',
                    priceModifier: 35,
                  ),
                ],
              ),
            ],
          ),
          Product(
            id: 'r12-p2',
            name: 'Pizza Pepperoni',
            description: 'Pepperoni, mozzarella, sauce tomate, origan',
            price: 85.00,
            image:
                'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
            category: 'Pizzas',
            rating: 4.6,
          ),
          Product(
            id: 'r12-p3',
            name: 'Pizza 4 Fromages',
            description: 'Mozzarella, gorgonzola, parmesan, chèvre',
            price: 95.00,
            image:
                'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
            category: 'Pizzas',
            isPopular: true,
            rating: 4.8,
          ),
          Product(
            id: 'r12-p4',
            name: 'Pâtes Carbonara',
            description: 'Spaghetti, crème, lardons, parmesan, jaune d\'œuf',
            price: 70.00,
            image:
                'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400',
            category: 'Pâtes',
            rating: 4.5,
          ),
          Product(
            id: 'r12-p5',
            name: 'Tiramisu',
            description: 'Dessert italien mascarpone, café, cacao',
            price: 40.00,
            image:
                'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
            category: 'Desserts',
            rating: 4.9,
          ),
        ],
      ),
    ];
  }

  static List<Store> getGroceryStores() {
    return [
      Store(
        id: 'g1',
        name: 'Marjane Market',
        description: 'Supermarché - Courses en ligne',
        image:
            'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=800',
        storeType: StoreType.grocery,
        category: 'Supermarché',
        rating: 4.4,
        deliveryTime: 25,
        deliveryFee: 0,
        isVIP: true,
        address: 'Centre Commercial Marjane, Agadir',
        products: [
          Product(
            id: 'g1-p1',
            name: 'Coca-Cola Pack 6x33cl',
            description: 'Pack de 6 canettes',
            price: 45.00,
            image:
                'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
            category: 'Boissons',
            isPopular: true,
            rating: 4.7,
            discount: 10,
          ),
          Product(
            id: 'g1-p2',
            name: 'Fanta Orange 1.5L',
            description: 'Boisson gazeuse à l\'orange',
            price: 12.00,
            image:
                'https://images.unsplash.com/photo-1624517452488-04869289c4ca?w=400',
            category: 'Boissons',
            rating: 4.5,
          ),
          Product(
            id: 'g1-p3',
            name: 'Sprite 1.5L',
            description: 'Boisson gazeuse citron-lime',
            price: 12.00,
            image:
                'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?w=400',
            category: 'Boissons',
            rating: 4.5,
          ),
          Product(
            id: 'g1-p4',
            name: 'Ketchup Heinz 500g',
            description: 'Sauce tomate classique',
            price: 25.00,
            image:
                'https://images.unsplash.com/photo-1598214886806-c87b84b7078b?w=400',
            category: 'Sauces & Condiments',
            rating: 4.6,
          ),
          Product(
            id: 'g1-p5',
            name: 'Mayonnaise Amora 465g',
            description: 'Mayonnaise onctueuse',
            price: 28.00,
            image:
                'https://images.unsplash.com/photo-1598214886806-c87b84b7078b?w=400',
            category: 'Sauces & Condiments',
            rating: 4.5,
          ),
          Product(
            id: 'g1-p6',
            name: 'Moutarde Dijon 250g',
            description: 'Moutarde forte',
            price: 18.00,
            image:
                'https://images.unsplash.com/photo-1598214886806-c87b84b7078b?w=400',
            category: 'Sauces & Condiments',
            rating: 4.4,
          ),
          Product(
            id: 'g1-p7',
            name: 'Pommes de terre 1kg',
            description: 'Pommes de terre fraîches',
            price: 8.00,
            image:
                'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400',
            category: 'Fruits & Légumes',
            rating: 4.3,
            unit: 'kg',
          ),
          Product(
            id: 'g1-p8',
            name: 'Tomates 1kg',
            description: 'Tomates fraîches',
            price: 12.00,
            image:
                'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=400',
            category: 'Fruits & Légumes',
            rating: 4.4,
            unit: 'kg',
          ),
          Product(
            id: 'g1-p9',
            name: 'Pain de mie',
            description: 'Pain de mie tranché',
            price: 10.00,
            image:
                'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
            category: 'Boulangerie',
            rating: 4.2,
          ),
          Product(
            id: 'g1-p10',
            name: 'Lait Centrale 1L',
            description: 'Lait demi-écrémé',
            price: 9.00,
            image:
                'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',
            category: 'Produits Laitiers',
            isPopular: true,
            rating: 4.6,
            unit: 'L',
          ),
        ],
      ),
      Store(
        id: 'g2',
        name: 'Carrefour Express',
        description: 'Épicerie de proximité',
        image:
            'https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=800',
        storeType: StoreType.grocery,
        category: 'Épicerie',
        rating: 4.3,
        deliveryTime: 15,
        deliveryFee: 10,
        isVIP: false,
        address: 'Avenue du Prince Moulay Abdellah, Agadir',
        products: [
          Product(
            id: 'g2-p1',
            name: 'Eau Sidi Ali 1.5L',
            description: 'Eau minérale naturelle',
            price: 6.00,
            image:
                'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400',
            category: 'Boissons',
            rating: 4.5,
          ),
          Product(
            id: 'g2-p2',
            name: 'Chips Lay\'s Nature 150g',
            description: 'Chips croustillantes',
            price: 15.00,
            image:
                'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400',
            category: 'Snacks',
            isPopular: true,
            rating: 4.6,
          ),
          Product(
            id: 'g2-p3',
            name: 'Chocolat Milka 100g',
            description: 'Chocolat au lait',
            price: 18.00,
            image:
                'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400',
            category: 'Confiserie',
            rating: 4.7,
          ),
        ],
      ),
    ];
  }

  static List<Store> getPharmacies() {
    return [
      Store(
        id: 'p1',
        name: 'Pharmacie Centrale',
        description: 'Médicaments et parapharmacie',
        image:
            'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=800',
        storeType: StoreType.pharmacy,
        category: 'Pharmacie',
        rating: 4.7,
        deliveryTime: 20,
        deliveryFee: 0,
        isVIP: true,
        address: 'Avenue Hassan II, Agadir',
        products: [
          Product(
            id: 'p1-p1',
            name: 'Doliprane 1000mg',
            description: 'Paracétamol - Boîte de 8 comprimés',
            price: 25.00,
            image:
                'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400',
            category: 'Médicaments',
            isPopular: true,
            rating: 4.8,
          ),
          Product(
            id: 'p1-p2',
            name: 'Vitamine C 500mg',
            description: 'Complément alimentaire - 30 comprimés',
            price: 45.00,
            image:
                'https://images.unsplash.com/photo-1550572017-4a6e8e8e2f8f?w=400',
            category: 'Compléments',
            rating: 4.6,
          ),
          Product(
            id: 'p1-p3',
            name: 'Masques chirurgicaux',
            description: 'Boîte de 50 masques',
            price: 80.00,
            image:
                'https://images.unsplash.com/photo-1584744982491-665216d95f8b?w=400',
            category: 'Protection',
            rating: 4.5,
          ),
          Product(
            id: 'p1-p4',
            name: 'Gel hydroalcoolique 100ml',
            description: 'Désinfectant pour les mains',
            price: 35.00,
            image:
                'https://images.unsplash.com/photo-1584744982491-665216d95f8b?w=400',
            category: 'Hygiène',
            isPopular: true,
            rating: 4.7,
          ),
          Product(
            id: 'p1-p5',
            name: 'Thermomètre digital',
            description: 'Thermomètre médical',
            price: 120.00,
            image:
                'https://images.unsplash.com/photo-1584744982491-665216d95f8b?w=400',
            category: 'Matériel médical',
            rating: 4.6,
          ),
        ],
      ),
    ];
  }

  static List<Store> getShops() {
    return [
      Store(
        id: 's1',
        name: 'Boutique Tech',
        description: 'Accessoires électroniques',
        image:
            'https://images.unsplash.com/photo-1601524909162-ae8725290836?w=800',
        storeType: StoreType.shop,
        category: 'Électronique',
        rating: 4.5,
        deliveryTime: 30,
        deliveryFee: 20,
        isVIP: false,
        address: 'Centre Ville, Agadir',
        products: [
          Product(
            id: 's1-p1',
            name: 'Écouteurs Bluetooth',
            description: 'Écouteurs sans fil',
            price: 250.00,
            image:
                'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
            category: 'Audio',
            isPopular: true,
            rating: 4.6,
            discount: 15,
          ),
          Product(
            id: 's1-p2',
            name: 'Câble USB-C',
            description: 'Câble de charge rapide 2m',
            price: 45.00,
            image:
                'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=400',
            category: 'Accessoires',
            rating: 4.4,
          ),
          Product(
            id: 's1-p3',
            name: 'Powerbank 10000mAh',
            description: 'Batterie externe portable',
            price: 180.00,
            image:
                'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=400',
            category: 'Accessoires',
            rating: 4.5,
          ),
        ],
      ),
    ];
  }

  static List<Store> getStoresByType(StoreType type) {
    return getAllStores().where((store) => store.storeType == type).toList();
  }
}

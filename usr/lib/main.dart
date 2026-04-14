import 'package:flutter/material.dart';

void main() {
  runApp(const WorldLifeSimulatorApp());
}

class GameState extends ChangeNotifier {
  int money = 10000;
  
  List<String> ownedClothes = ['Basic T-Shirt', 'Jeans'];
  String currentTop = 'Basic T-Shirt';
  String currentBottom = 'Jeans';

  List<String> ownedCars = [];
  String? currentCar;

  List<String> ownedHouses = ['Small Apartment'];
  String currentHouse = 'Small Apartment';

  List<Map<String, dynamic>> ownedPets = [];

  void buyItem(String item, int price, String category) {
    if (money >= price) {
      money -= price;
      if (category == 'clothes') ownedClothes.add(item);
      if (category == 'car') ownedCars.add(item);
      if (category == 'house') ownedHouses.add(item);
      notifyListeners();
    }
  }

  void buyPet(String type, String name, int price) {
    if (money >= price) {
      money -= price;
      ownedPets.add({'type': type, 'name': name, 'accessories': <String>[]});
      notifyListeners();
    }
  }

  void equipClothes(String item, String type) {
    if (type == 'top') currentTop = item;
    if (type == 'bottom') currentBottom = item;
    notifyListeners();
  }

  void driveCar(String car) {
    currentCar = car;
    notifyListeners();
  }

  void parkCar() {
    currentCar = null;
    notifyListeners();
  }

  void decoratePet(int index, String accessory) {
    ownedPets[index]['accessories'].add(accessory);
    notifyListeners();
  }
}

final gameState = GameState();

class WorldLifeSimulatorApp extends StatelessWidget {
  const WorldLifeSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Life Simulator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.public, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'World Life Simulator',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WorldMapScreen(mode: 'Single Player')),
                  );
                },
                icon: const Icon(Icons.person),
                label: const Text('Single Player'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const WorldMapScreen(mode: 'Multiplayer')),
                  );
                },
                icon: const Icon(Icons.people),
                label: const Text('Multiplayer (Local/Offline)'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorldMapScreen extends StatefulWidget {
  final String mode;
  const WorldMapScreen({super.key, required this.mode});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  @override
  void initState() {
    super.initState();
    gameState.addListener(_update);
  }

  @override
  void dispose() {
    gameState.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('World Map - ${widget.mode}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text('\$${gameState.money}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildLocationCard(context, 'Home', Icons.home, Colors.orange, const HomeScreen()),
          _buildLocationCard(context, 'Shopping Mall', Icons.shopping_bag, Colors.purple, const MallScreen()),
          _buildLocationCard(context, 'Car Dealership', Icons.directions_car, Colors.red, const CarDealershipScreen()),
          _buildLocationCard(context, 'Real Estate', Icons.location_city, Colors.blue, const RealEstateScreen()),
          _buildLocationCard(context, 'Pet Shop', Icons.pets, Colors.brown, const PetShopScreen()),
          _buildLocationCard(context, 'Drive Around', Icons.map, Colors.green, const DriveScreen()),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, String title, IconData icon, Color color, Widget destination) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    gameState.addListener(_update);
  }

  @override
  void dispose() {
    gameState.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Current House: ${gameState.currentHouse}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(),
          const Text('Wardrobe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: gameState.ownedClothes.map((c) => ChoiceChip(
              label: Text(c),
              selected: gameState.currentTop == c || gameState.currentBottom == c,
              onSelected: (selected) {
                if (selected) {
                  gameState.equipClothes(c, c.contains('Jeans') || c.contains('Pants') || c.contains('Shorts') ? 'bottom' : 'top');
                }
              },
            )).toList(),
          ),
          const SizedBox(height: 20),
          const Text('My Pets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...gameState.ownedPets.asMap().entries.map((entry) {
            int idx = entry.key;
            var pet = entry.value;
            return Card(
              child: ListTile(
                leading: Icon(pet['type'] == 'Cat' ? Icons.pets : Icons.pets, color: pet['type'] == 'Cat' ? Colors.orange : Colors.brown),
                title: Text(pet['name']),
                subtitle: Text('Accessories: ${pet['accessories'].join(', ')}'),
                trailing: IconButton(
                  icon: const Icon(Icons.checkroom),
                  onPressed: () => _decoratePetDialog(context, idx),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _decoratePetDialog(BuildContext context, int petIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decorate Pet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Add Bowtie'),
              onTap: () {
                gameState.decoratePet(petIndex, 'Bowtie');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add Hat'),
              onTap: () {
                gameState.decoratePet(petIndex, 'Hat');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MallScreen extends StatelessWidget {
  const MallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Fancy Shirt', 'price': 50},
      {'name': 'Leather Jacket', 'price': 200},
      {'name': 'Designer Pants', 'price': 150},
      {'name': 'Sneakers', 'price': 100},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Mall')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: const Icon(Icons.checkroom),
            title: Text(item['name'] as String),
            trailing: ElevatedButton(
              onPressed: () => gameState.buyItem(item['name'] as String, item['price'] as int, 'clothes'),
              child: Text('\$${item['price']}'),
            ),
          );
        },
      ),
    );
  }
}

class CarDealershipScreen extends StatelessWidget {
  const CarDealershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Sedan', 'price': 5000},
      {'name': 'Sports Car', 'price': 25000},
      {'name': 'SUV', 'price': 15000},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Car Dealership')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text(item['name'] as String),
            trailing: ElevatedButton(
              onPressed: () => gameState.buyItem(item['name'] as String, item['price'] as int, 'car'),
              child: Text('\$${item['price']}'),
            ),
          );
        },
      ),
    );
  }
}

class RealEstateScreen extends StatelessWidget {
  const RealEstateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Suburban House', 'price': 50000},
      {'name': 'Luxury Villa', 'price': 250000},
      {'name': 'Penthouse', 'price': 500000},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Real Estate')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: const Icon(Icons.house),
            title: Text(item['name'] as String),
            trailing: ElevatedButton(
              onPressed: () => gameState.buyItem(item['name'] as String, item['price'] as int, 'house'),
              child: Text('\$${item['price']}'),
            ),
          );
        },
      ),
    );
  }
}

class PetShopScreen extends StatelessWidget {
  const PetShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'type': 'Cat', 'price': 200},
      {'type': 'Dog', 'price': 300},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pet Shop')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: const Icon(Icons.pets),
            title: Text(item['type'] as String),
            trailing: ElevatedButton(
              onPressed: () {
                _showNameDialog(context, item['type'] as String, item['price'] as int);
              },
              child: Text('\$${item['price']}'),
            ),
          );
        },
      ),
    );
  }

  void _showNameDialog(BuildContext context, String type, int price) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Name your $type'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Pet Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                gameState.buyPet(type, controller.text, price);
                Navigator.pop(context);
              }
            },
            child: const Text('Adopt'),
          ),
        ],
      ),
    );
  }
}

class DriveScreen extends StatefulWidget {
  const DriveScreen({super.key});

  @override
  State<DriveScreen> createState() => _DriveScreenState();
}

class _DriveScreenState extends State<DriveScreen> {
  @override
  void initState() {
    super.initState();
    gameState.addListener(_update);
  }

  @override
  void dispose() {
    gameState.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drive Around')),
      body: Center(
        child: gameState.currentCar != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_car, size: 100, color: Colors.blue),
                  const SizedBox(height: 20),
                  Text('Driving: ${gameState.currentCar}', style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => gameState.parkCar(),
                    child: const Text('Park Car'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You are walking.', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  if (gameState.ownedCars.isNotEmpty) ...[
                    const Text('Choose a car to drive:'),
                    ...gameState.ownedCars.map((car) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => gameState.driveCar(car),
                            child: Text('Drive $car'),
                          ),
                        )),
                  ] else
                    const Text('You do not own any cars. Go to the dealership!'),
                ],
              ),
      ),
    );
  }
}

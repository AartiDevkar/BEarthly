import 'package:flutter/material.dart';

class Reduce extends StatefulWidget {
  const Reduce({Key? key}) : super(key: key);

  @override
  _ReduceState createState() => _ReduceState();
}

class _ReduceState extends State<Reduce> {
  int currentIndex = 2; // Set initial index to 2 for Reduce page
  double totalCarbonFootprint = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Simulate data initialization, replace with actual data fetching logic
    await Future.delayed(Duration(seconds: 1));

    // Simulate total carbon footprint calculation
    setState(() {
      totalCarbonFootprint = 25.0; // Replace with actual calculation
    });
  }

  List<ReduceSection> getSections(double carbonFootprint) {
    if (carbonFootprint < 20) {
      // High carbon footprint, show suggestions for reducing it
      return [
        ReduceSection(
          description:
              'Choose public transportation over driving for your next outing.',
          icon: Icons.directions_bus,
          color: Color.fromARGB(255, 167, 207, 239),
        ),
        ReduceSection(
          description: 'Plan one meatless dinner for the upcoming week.',
          icon: Icons.restaurant,
          color: const Color.fromARGB(255, 171, 232, 173),
        ),
        ReduceSection(
          description:
              'Plant trees or participate in local tree-planting initiatives.',
          icon: Icons.eco,
          color: Color.fromARGB(255, 241, 198, 135),
        ),
        ReduceSection(
          description:
              'Conserve water by fixing leaks and using water-saving devices.',
          icon: Icons.water_damage,
          color: const Color.fromARGB(255, 227, 137, 131),
        ),
        // Add more suggestions for high carbon footprint
      ];
    } else if (carbonFootprint > 20) {
      return [
        ReduceSection(
          description: 'Walk or bike for short trips instead of driving.',
          icon: Icons.directions_bike,
          color: Color.fromARGB(255, 163, 180, 194),
        ),
        ReduceSection(
          description:
              'Replace one meat-based meal with a vegetarian option each week.',
          icon: Icons.local_florist,
          color: Color.fromARGB(255, 156, 240, 159),
        ),
        ReduceSection(
          description:
              'Use reusable bags and containers when shopping to reduce plastic waste.',
          icon: Icons.shopping_bag,
          color: Color.fromARGB(255, 248, 202, 134),
        ),
        ReduceSection(
          description:
              'Turn off lights and unplug electronics when not in use to save energy.',
          icon: Icons.lightbulb_outline,
          color: Color.fromARGB(255, 162, 113, 110),
        ),
        // Add more suggestions for medium carbon footprint
      ];
    } else if (carbonFootprint > 40) {
      return [
        ReduceSection(
          description:
              'Use eco-friendly transportation like walking, biking, or carpooling.',
          icon: Icons.directions_walk,
          color: Color.fromARGB(255, 116, 144, 167),
        ),
        ReduceSection(
          description:
              'Reduce meat consumption by incorporating more plant-based meals.',
          icon: Icons.restaurant_menu,
          color: Color.fromARGB(255, 109, 172, 111),
        ),
        ReduceSection(
          description:
              'Opt for energy-efficient appliances and practices at home.',
          icon: Icons.power,
          color: Color.fromARGB(255, 223, 191, 143),
        ),
        ReduceSection(
          description:
              'Recycle paper, plastic, glass, and other materials to reduce waste.',
          icon: Icons.delete,
          color: Color.fromARGB(255, 202, 141, 137),
        ),
        // Add more suggestions for low carbon footprint
      ];
    } else {
      // Low carbon footprint, show general suggestions
      return [
        ReduceSection(
          description:
              'Turn off lights when not in use, unplug electronics, etc.',
          icon: Icons.lightbulb,
          color: Color.fromARGB(255, 118, 141, 160),
        ),
        ReduceSection(
          description: 'Dispose of waste responsibly and recycle materials.',
          icon: Icons.restore_from_trash,
          color: Color.fromARGB(255, 134, 181, 136),
        ),
        // Add more general suggestions
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ReduceSection> sections = getSections(totalCarbonFootprint);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reduce'),
        backgroundColor: const Color.fromARGB(255, 191, 228, 228),
      ),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return AnimatedReduceCard(section: sections[index]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          // Navigate to the corresponding page when an icon is tapped
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/track');
              break;
            case 2:
              // Navigator.pushNamed(context, '/reduce');
              break;
            case 3:
              Navigator.pushNamed(context, '/connect');
              break;
          }
        },
        selectedItemColor: const Color.fromARGB(255, 20, 137, 135),
        unselectedItemColor: const Color.fromARGB(255, 121, 154, 203),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Reduce',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded),
            label: 'Connect',
          ),
        ],
      ),
    );
  }
}

class ReduceSection {
  final String description;
  final IconData icon;
  final Color color;

  ReduceSection({
    required this.description,
    required this.icon,
    required this.color,
  });
}

class AnimatedReduceCard extends StatefulWidget {
  final ReduceSection section;

  const AnimatedReduceCard({Key? key, required this.section}) : super(key: key);

  @override
  _AnimatedReduceCardState createState() => _AnimatedReduceCardState();
}

class _AnimatedReduceCardState extends State<AnimatedReduceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _offsetAnimation,
        child: GestureDetector(
          onTap: () {
            // Handle card tap if needed
          },
          child: Card(
            color: widget.section.color,
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(widget.section.icon, color: Colors.white),
                      SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              widget.section.description,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up, color: Colors.white),
                      onPressed: () {
                        // Handle thumb button press
                      },
                    ),
                    SizedBox(width: 8),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Handle done button press
                    //   },
                    //   child: Text('Done'),
                    // ),
                    // SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

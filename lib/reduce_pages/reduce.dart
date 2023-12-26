import 'package:flutter/material.dart';

class Reduce extends StatefulWidget {
  const Reduce({Key? key}) : super(key: key);

  @override
  _ReduceState createState() => _ReduceState();
}

class _ReduceState extends State<Reduce> {
  int currentIndex = 0;

  final List<ReduceSection> sections = [
    ReduceSection(
      title: 'Food Choices',
      description:
          'Make sustainable food choices to reduce your carbon footprint.',
      imageUrl: 'assets/images/veges.jpg',
      suggestions: [
        'Include more plant-based meals in your diet.',
        'Buy local and seasonal produce.',
        'Minimize food waste by planning meals.',
      ],
    ),
    ReduceSection(
      title: 'Transportation',
      description: 'Explore eco-friendly transportation options.',
      imageUrl: 'assets/images/bicycle.png',
      suggestions: [
        'Use public transportation or carpool.',
        'Consider biking or walking for short distances.',
        'Choose energy-efficient vehicles.',
      ],
    ),
    ReduceSection(
      title: 'Energy Efficiency',
      description: 'Implement energy-efficient practices at home.',
      imageUrl: 'assets/images/solar_panels.jpg',
      suggestions: [
        'Switch to LED bulbs.',
        'Turn off lights and appliances when not in use.',
        'Use energy-efficient appliances.',
      ],
    ),
    ReduceSection(
      title: 'Energy Efficiency',
      description: 'Implement energy-efficient practices at home.',
      imageUrl: 'assets/images/solar_panels.jpg',
      suggestions: [
        'Switch to LED bulbs.',
        'Turn off lights and appliances when not in use.',
        'Use energy-efficient appliances.',
      ],
    ),
    ReduceSection(
      title: 'Energy Efficiency',
      description: 'Implement energy-efficient practices at home.',
      imageUrl: 'assets/images/solar_panels.jpg',
      suggestions: [
        'Switch to LED bulbs.',
        'Turn off lights and appliances when not in use.',
        'Use energy-efficient appliances.',
      ],
    )
    // Add more sections as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reduce'),
        backgroundColor: Color.fromARGB(255, 191, 228, 228),
      ),
      backgroundColor: Color.fromRGBO(8, 128, 90, 0.833),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return AnimatedReduceCard(section: sections[index]);
        },
      ),
    );
  }
}

class ReduceSection {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> suggestions;

  ReduceSection({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.suggestions,
  });
}

class AnimatedReduceCard extends StatefulWidget {
  final ReduceSection section;

  const AnimatedReduceCard({Key? key, required this.section}) : super(key: key);

  @override
  _AnimatedReduceCardState createState() => _AnimatedReduceCardState();
}

class _AnimatedReduceCardState extends State<AnimatedReduceCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Card(
        margin: EdgeInsets.all(16),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: Image.asset(
                widget.section.imageUrl,
                height: expanded ? 200 : 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.section.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.section.description,
                    style: TextStyle(fontSize: 16),
                    maxLines: expanded ? 10 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  if (expanded)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suggestions:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ...widget.section.suggestions
                            .map((suggestion) => Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(suggestion),
                                ))
                            .toList(),
                      ],
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

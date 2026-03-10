import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:flutter/material.dart';

import '../data/videos_repository.dart';
import '../widgets/category_button.dart';
import '../widgets/course_card.dart';
import 'course_detail.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body
      appBar: GlobalAppBar(title: "Courses", canGoBack: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Blue header
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.grid_view, color: Colors.white, size: 28),
                        Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hi, Programmer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Search bar (white) with controlled FocusNode
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              focusNode: _searchFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Search Here',
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Category buttons 2x3
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [

                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        CategoryButton(icon: Icons.storefront, label: 'BookStore'),
                        CategoryButton(icon: Icons.live_tv, label: 'Live Course'),
                        CategoryButton(icon: Icons.emoji_events, label: 'LeaderBoard'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Courses header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Courses',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Courses grid (2 columns)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Flutter card (tappable)
                        CourseCard(
                          title: 'Flutter',
                          iconPath: "assets/icons/flutter_icon.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  courseTitle: 'Flutter',
                                  playlist: FlutterVideos,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        CourseCard(
                          title: 'React Native',
                          iconPath: "assets/icons/react_native_icon.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  courseTitle: 'React Native',
                                  playlist: ReactNativeVideos,
                                ),
                              ),
                            );
                          },
                          // icon: SimpleIcons.react,
                          // iconColor: Colors.cyan,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CourseCard(
                          title: 'Python',
                          iconPath: "assets/icons/python.jpeg",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  courseTitle: 'Python',
                                  playlist: PythonVideos,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        CourseCard(
                          title: 'C#',
                          iconPath: "assets/icons/c#.png",
                          onTap: () {
                            Navigator.push(
                              context,
                               MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  courseTitle: 'C#',
                                  playlist: CSharpVideos,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
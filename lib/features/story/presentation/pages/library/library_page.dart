import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pho_truyen/features/story/presentation/widgets/library/library_header.dart';
import 'package:pho_truyen/features/story/presentation/widgets/library/library_list_item.dart';

import 'package:get/get.dart';
import 'package:pho_truyen/features/story/presentation/controllers/library_controller.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final LibraryController controller = Get.find<LibraryController>();
  Timer? _debounce;
  Future<List<StoryModel>>? _searchFuture;
  bool _isSearching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          _isSearching = true;
          _searchFuture = controller.searchStories(query);
        });
      } else {
        setState(() {
          _isSearching = false;
          _searchFuture = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              LibraryHeader(onSearchChanged: _onSearchChanged),
              const SizedBox(height: 24),
              //  List Items
              Expanded(
                child: _isSearching
                    ? FutureBuilder<List<StoryModel>>(
                        future: _searchFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          final results = snapshot.data;
                          if (results == null || results.isEmpty) {
                            return const Center(
                              child: Text(
                                'Không tìm thấy kết quả',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final story = results[index];
                              final libraryItem = LibraryItem(
                                id: story.id,
                                title: story.name,
                                chapters: '${story.chapterCount} chương',
                                imageUrl:
                                    story.image ??
                                    'https://picsum.photos/100/150',
                                tags: story.hashtags
                                    .map((e) => e.name)
                                    .toList(),
                              );

                              return LibraryListItem(
                                item: libraryItem,
                                onTap: () => controller.goToComicDetail(story),
                              );
                            },
                          );
                        },
                      )
                    : Obx(() {
                        if (controller.isLoadingLibrary.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.libraryStories.isEmpty) {
                          return const Center(
                            child: Text(
                              'Chưa có truyện nào trong thư viện',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: controller.libraryStories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final story = controller.libraryStories[index];
                            final libraryItem = LibraryItem(
                              id: story.id,
                              title: story.name,
                              chapters: '${story.chapterCount} chương',
                              imageUrl:
                                  story.image ??
                                  'https://picsum.photos/100/150',
                              tags: story.hashtags.map((e) => e.name).toList(),
                            );
                            return LibraryListItem(
                              item: libraryItem,
                              onTap: () => controller.goToComicDetail(story),
                            );
                          },
                        );
                      }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

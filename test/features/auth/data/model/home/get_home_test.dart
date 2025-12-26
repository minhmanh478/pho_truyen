import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';

void main() {
  test('GetHomeResponse.fromJson parses correctly', () {
    const jsonString = '''
{
    "code": "success",
    "message": "Thành công",
    "data": {
        "list_home": [
            {
                "type": "TEST123",
                "title": "TEST thêm"
            },
            {
                "type": "BANNER",
                "code": "BANNER",
                "title": "BANNER",
                "data": [
                    {
                        "id": 6,
                        "code": "IMAGE",
                        "object_id": 997,
                        "object_type": 1,
                        "image": "https://photruyen-media.deepviet.com/uploads/2025-02-06/c35dc5d0-8fbd-45bc-bd67-213d96b69092.jpg",
                        "link": "/truyen/no-em-mot-tam-chan-tinh",
                        "link_mobile": "{\\"route\\":\\"/app/story_detail\\",\\"id\\":997}",
                        "state": 1,
                        "time_update": "2024-07-09T15:22:19.000Z",
                        "time_create": "2024-07-09T15:22:22.000Z"
                    }
                ]
            },
            {
                "type": "STORY_PROPOSAL",
                "code": "STORY_PROPOSAL",
                "title": "Đề xuất cho bạn",
                "limit_mobile": 10,
                "data": [
                    {
                        "id": 1066,
                        "app_id": 1,
                        "user_id": 101668,
                        "image": "https://photruyen-media.deepviet.com/uploads/2025-06-08/ed0adb81-adba-4590-84dd-ebe4eae25b98.png?width=400&height=600",
                        "name": "Cả Một Đời 1232323",
                        "content": "Content...",
                        "description": "",
                        "seo_title": null,
                        "seo_description": null,
                        "seo_keywords": null,
                        "chapter_release_schedule": null,
                        "name_search": "ca mot doi",
                        "slug": "ca-mot-doi-1232323",
                        "tags": "0",
                        "category_ids": "0",
                        "tag_ids": "0",
                        "price": 0,
                        "sale_price": 0,
                        "total_price_buy": 38070,
                        "chapter_count": 80,
                        "chapter_author_count": 81,
                        "read_count": 150692,
                        "comment_count": 28,
                        "nominations": 14,
                        "limit_age": 0,
                        "is_buy_full": 0,
                        "is_free": 0,
                        "is_full": 0,
                        "is_exclusive_content": 0,
                        "is_vip": 1,
                        "is_draft": 0,
                        "is_send_approved": 0,
                        "is_approved": 1,
                        "reject_message": null,
                        "type": 0,
                        "state": 1,
                        "time_update": "2025-06-08T16:13:52.000Z",
                        "time_create": "2025-04-12T13:42:16.000Z",
                        "hashtags": [
                            {
                                "name": "Vip",
                                "color": "1976d2"
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
    ''';

    final jsonMap = json.decode(jsonString);
    final response = GetHomeResponse.fromJson(jsonMap);

    expect(response.code, 'success');
    expect(response.data!.listHome.length, 3);

    // Check Banner
    final bannerSection = response.data!.listHome[1];
    expect(bannerSection.type, 'BANNER');
    expect(bannerSection.banners!.length, 1);
    final banner = bannerSection.banners![0];
    expect(banner.id, 6);
    expect(banner.state, 1);
    expect(banner.timeUpdate, "2024-07-09T15:22:19.000Z");

    // Check Story
    final storySection = response.data!.listHome[2];
    expect(storySection.type, 'STORY_PROPOSAL');
    expect(storySection.stories!.length, 1);
    final story = storySection.stories![0];
    expect(story.id, 1066);
    expect(story.appId, 1);
    expect(story.slug, "ca-mot-doi-1232323");
    expect(story.totalPriceBuy, 38070);
    expect(story.chapterAuthorCount, 81);
    expect(story.isVip, 1);
  });
}

import '../chat/presentation/view/chat_room_screen.dart';
import '../chat/presentation/view/chat_screen.dart';
import '../models/stroy.dart';
import '../page/comment_page.dart';
import '../page/create_account_page.dart';
import '../page/create_post_page.dart';
import '../page/create_story_page.dart';
import '../page/home_page.dart';
import '../page/main_page.dart';
import '../page/profile_page.dart';
import '../page/story_detail_page.dart';
import '../page/verified_page.dart';
import 'package:go_router/go_router.dart';

final routeConfig = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, routeState) => const MainPage()),
  GoRoute(
      path: HomePage.routeName,
      builder: (context, routeState) => const HomePage()),
  GoRoute(
      path: CreateAccountPage.routeName,
      builder: (context, routeState) => const CreateAccountPage()),
  GoRoute(
      path: VerifiedPage.routeName,
      builder: (context, routeState) => const VerifiedPage()),
  GoRoute(
      path: CreatePostPage.routeName,
      builder: (context, routeState) => const CreatePostPage()),
  GoRoute(
      path: CommentPage.routeName,
      builder: (context, routeState) {
        final postId = routeState.extra as String;
        return CommentPage(
          postId: postId,
        );
      }),
  GoRoute(
      path: ProfilePage.routeName,
      builder: (context, routeState) {
        final userId = routeState.extra as String;
        return ProfilePage(
          userId: userId,
        );
      }),
  GoRoute(
      path: CreateStoryPage.routeName,
      builder: (context, routeState) => const CreateStoryPage()),
  GoRoute(
      path: StoryDetailPage.routeName,
      builder: (context, routeState) {
        final stories = routeState.extra as List<Story>;
        return StoryDetailPage(
          stories: stories,
        );
      }),
  GoRoute(
      path: ChatRoomScreen.routeName,
      builder: (context, routeState) => const ChatRoomScreen()),
  GoRoute(
      path: ChatScreen.routeName,
      builder: (context, routeState) {
        final userId = routeState.extra as String;
        return ChatScreen(
          userId: userId,
        );
      }),
]);

import 'package:flutter/material.dart';
import 'package:uni_link/router/routing_argument_keys.dart';
import 'package:uni_link/router/routing_constants.dart';
import 'package:uni_link/views/chat_room_view.dart';
import 'package:uni_link/views/comments_view.dart';
import 'package:uni_link/views/conversation_view.dart';
import 'package:uni_link/views/home.dart';
import 'package:uni_link/views/login_view.dart';
import 'package:uni_link/views/profile_view.dart';
import 'package:uni_link/views/search_view.dart';
import 'package:uni_link/views/sign_up_view.dart';

class AppRouter {
  static PageRoute _getPageRoute({
    required RouteSettings settings,
    required Widget viewToShow,
  }) {
    return MaterialPageRoute(
        builder: (context) => viewToShow, settings: settings);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> routeArgs = settings.arguments != null
        ? settings.arguments as Map<String, dynamic>
        : {};

    switch (settings.name) {
      case NavigatorRoutes.home:
        // var accountDetailsEnum =
        //     routeArgs[RoutingArgumentKey.accountDetailsEnum];
        return _getPageRoute(
          settings: settings,
          viewToShow: const Home(),
        );
      case NavigatorRoutes.login:
        // var accountDetailsEnum =
        //     routeArgs[RoutingArgumentKey.accountDetailsEnum];
        return _getPageRoute(
          settings: settings,
          viewToShow: const LoginView(),
        );
      case NavigatorRoutes.signup:
        // var accountDetailsEnum =
        //     routeArgs[RoutingArgumentKey.accountDetailsEnum];
        return _getPageRoute(
          settings: settings,
          viewToShow: const SignupView(),
        );
      case NavigatorRoutes.chatRoom:
        // var accountDetailsEnum =
        //     routeArgs[RoutingArgumentKey.accountDetailsEnum];
        return _getPageRoute(
          settings: settings,
          viewToShow: const ChatRoomView(),
        );
      case NavigatorRoutes.conversationView:
        var chatRoomId = routeArgs[RoutingArgumentKey.chatRoomId];
        return _getPageRoute(
          settings: settings,
          viewToShow: ConversationView(chatRoomId: chatRoomId),
        );
      case NavigatorRoutes.profileView:
        var uid = routeArgs[RoutingArgumentKey.profileUid];
        return _getPageRoute(
          settings: settings,
          viewToShow: ProfileView(uid: uid),
        );
      case NavigatorRoutes.searchView:
        var showUser = routeArgs[RoutingArgumentKey.showUser];
        return _getPageRoute(
          settings: settings,
          viewToShow: SearchView(isShowUsers: showUser),
        );

      case NavigatorRoutes.commentView:
        var snap = routeArgs[RoutingArgumentKey.snap];
        return _getPageRoute(
          settings: settings,
          viewToShow: CommentsView(snap: snap),
        );
      default:
        return _getPageRoute(
          settings: settings,
          viewToShow: const Scaffold(),
        );
    }
  }
}

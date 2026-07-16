/// Centralized route path constants. Pages and the router both
/// reference these instead of hardcoding path strings, so a path
/// only ever needs to change in one place.
class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';
  static const String search = '/search';
  static const String library = '/library';
  static const String statistics = '/statistics';
  static const String profile = '/profile';

  static const String movieDetail = '/movie/:id';
  static String movieDetailPath(String id) => '/movie/$id';
}

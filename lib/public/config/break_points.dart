class BreakPoint {
  static const double mobile = 600;
  static const double tablet = 1024;
  static bool isMobile(double width) => width < mobile;
  static bool isWeb(double width) => width >= mobile;
}

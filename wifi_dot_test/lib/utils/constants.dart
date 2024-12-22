class AppConstants {
  // 와이파이 설정
  static const String targetSSID = 'DotMatrix_AP';
  static const String wifiPassword = '12345678';  // 라즈베리파이 AP의 비밀번호

  // 웹소켓 서버 설정
  static const String websocketUrl = 'ws://192.168.4.1:8080';  // 라즈베리파이의 웹소켓 서버 주소
  static const int websocketPort = 8080;
  static const Duration connectionTimeout = Duration(seconds: 5);
  static const Duration reconnectDelay = Duration(seconds: 3);

  // 도형 타입
  static const String shapeCircle = 'circle';
  static const String shapeTriangle = 'triangle';
  static const String shapeSquare = 'square';

  // 에러 메시지
  static const String errorNoWifi = '와이파이 연결이 필요합니다.';
  static const String errorWrongNetwork = '올바른 네트워크에 연결해주세요.';
  static const String errorConnection = '연결 중 오류가 발생했습니다.';
  static const String errorTimeout = '연결 시간이 초과되었습니다.';
  static const String errorDisconnected = '연결이 끊어졌습니다.';

  // 성공 메시지
  static const String successConnection = '연결되었습니다.';
  static const String successShapeSent = '도형이 전송되었습니다.';

  // UI 관련 상수
  static const double buttonSize = 100.0;
  static const double iconSize = 48.0;
  static const double spacing = 16.0;
  static const double borderRadius = 16.0;

  // 애니메이션 duration
  static const Duration animationDuration = Duration(milliseconds: 300);
}
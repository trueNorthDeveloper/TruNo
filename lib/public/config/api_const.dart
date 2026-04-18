class Apiconstants {
// //   static const String baseUrl ="https://fe5f-106-222-214-87.ngrok-free.app/auth/api";
//   static const String baseUrl = "https://306011160ec5.ngrok-free.app/auth/api";

//   // static const String imageBaseUrl="https://fe5f-106-222-214-87.ngrok-free.app/api";
//   static const String imageBaseUrl = "https://306011160ec5.ngrok-free.app/api";
//   // ignore: unnecessary_string_interpolations
//   static const String login = "$baseUrl/login";
//   static const String logout = "$baseUrl/logout";
//   static const String register = "$baseUrl/register";
//   static const String upload = "$imageBaseUrl/v1/image/driveUpload";
//   static const String updateImageId = "$imageBaseUrl/v1/image/updatelinkId";
//   static const String userProfile = "$baseUrl/";
//   static const String userLoginInfo = "$baseUrl/userLoginData/";
//   static const String checkUserIdPass = "$baseUrl/checkAccountWithSession";

// //user-project api............................
//   static const projectbaseUrl =
//       "https://306011160ec5.ngrok-free.app/api/tnec-project";
//   static const String userProjectType = "$projectbaseUrl/getProType/";
//   static const String userAllProject = "$projectbaseUrl/getProject/";
//   static const String userProjectTeam = "$projectbaseUrl/getTeam/";
//   static const String userTaskById = "$projectbaseUrl/getTask/";
//   static const String userAllTaskInTeam = "$projectbaseUrl/allTask/";
//   static const String submitTaskByUser = "$projectbaseUrl/submitTask";
//   static const String uploadTask = "$projectbaseUrl/uploadTaskImgPdf";
//   static const String uploadfileOfTask = "$projectbaseUrl/uploadTaskImgPdf";
//   //---------------------------task--------13-9-25-------------------------
//   static const String submitTaskWithFiles = "$projectbaseUrl/submitTask";
//   static const String reviewTask = "$projectbaseUrl/review";
//   static const String teamMember = "$projectbaseUrl/getTeamMember/";
//   static const String reviewTaskUpdate = "$projectbaseUrl/updateReview";
//   static const String crtTask = "$projectbaseUrl/createTask";
//   static const String viewCompleteTask = '$projectbaseUrl/completed-detail';
//   //resubmit task and delete file from google drive..........
//   static const String resubmitupdate = '$projectbaseUrl/resubmitupdate/';
//   static const String deleteFile = '$projectbaseUrl/deletefile/';

//   //here all admin api...........................start..........................
//   static const String adminBaseUrl =
//       "https://306011160ec5.ngrok-free.app/auth/adminApi";

//   static const String adminlog = "$adminBaseUrl/adminLogin";
//   static const String fatchAllUser = "$adminBaseUrl/allUser";
//   //-----------------collection of user project api...........
//   static const String userProjectById = "$adminBaseUrl/projects/";

// //date wise project
//---------------------new api--------------------------------------------------
  static String url = "";
  static String baseUrl = url + "/auth/api";
  //static  String baseUrl = "https://306011160ec5.ngrok-free.app/auth/api";

  // static const String imageBaseUrl = "https://306011160ec5.ngrok-free.app/api";

  static String imageBaseUrl = url + "/api";

  // static  String login = "$baseUrl/login";

  static String logout = "$baseUrl/logout";
  static String register = "$baseUrl/register";
  static String upload = "$imageBaseUrl/v1/image/driveUpload";
  static String updateImageId = "$imageBaseUrl/v1/image/updatelinkId";
  static String userProfile = "$baseUrl/";
  static String userLoginInfo = "$baseUrl/userLoginData/";
  static String checkUserIdPass = "$baseUrl/checkAccountWithSession";

//user-project api............................
  // static const projectbaseUrl =
  //     "https://306011160ec5.ngrok-free.app/api/tnec-project";
  static String projectbaseUrl = url + "/api/tnec-project";
  static String userProjectType = "$projectbaseUrl/getProType/";
  static String userAllProject = "$projectbaseUrl/getProject/";
  static String userProjectTeam = "$projectbaseUrl/getTeam/";
  static String userTaskById = "$projectbaseUrl/getTask/";
  static String userAllTaskInTeam = "$projectbaseUrl/allTask/";
  static String submitTaskByUser = "$projectbaseUrl/submitTask";
  static String uploadTask = "$projectbaseUrl/uploadTaskImgPdf";
  static String uploadfileOfTask = "$projectbaseUrl/uploadTaskImgPdf";
  //---------------------------task--------13-9-25-------------------------
  static String submitTaskWithFiles = "$projectbaseUrl/submitTask";
  static String reviewTask = "$projectbaseUrl/review";
  // static  String teamMember = "$projectbaseUrl/getTeamMember/";
  static String reviewTaskUpdate = "$projectbaseUrl/updateReview";
  static String crtTask = "$projectbaseUrl/createTask";
  static String viewCompleteTask = '$projectbaseUrl/completed-detail';
  //resubmit task and delete file from google drive..........
  static String resubmitupdate = '$projectbaseUrl/resubmitupdate/';
  static String deleteFile = '$projectbaseUrl/deletefile/';

  //here all admin api...........................start..........................
  static String adminBaseUrl =
      "https://306011160ec5.ngrok-free.app/auth/adminApi";

  static String adminlog = "$adminBaseUrl/adminLogin";
  static String fatchAllUser = "$adminBaseUrl/allUser";
  //-----------------collection of user project api...........
  static String userProjectById = "$adminBaseUrl/projects/";

//date wise projet 10-12-25

//jwt
  static String login = "$baseUrl/v2login";
  static String me = "$baseUrl/v2me";
  static String refreshTokenAcess = "$baseUrl/v2refreshToken";
  static String userlogout = "$baseUrl/automaticLogout";
  static String checkuserCredentail = "$baseUrl/checkCredentail";
}

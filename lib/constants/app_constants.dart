const mailAddressMaxLength = 254;
const phoneNumberLength = 10.0;
const nameLengthMax = 60;
const addressLengthMax = 254;

class AppConstants {
  //Shared Preference
  static const String loginToken = "login_token";
  static const String loginFailed = "Login Failed";
  static const String somethingWentWrong = "Something Went Wrong";
  static const String enterEmail = "Enter Email";
  static const String enterPassword = "Enter Password";
  static const String signIn = "SignIn";
}

class FailureConstants {
  static const String enterFullName = "Please enter full name";
  static const String enterEmail = "Please enter email id";
  static const String enterPassword = "Please enter password";
  static const String enterConfirmPassword = "Please enter confirm password";
  static const String passwordAndConfirmPasswordSame =
      "Passwords mismatch. Please verify and try again";
  static const String checkTermsAndConditions =
      "Please accept the terms and conditions to proceed";
  static const String registrationFailed = "Registration Failed";
  static const String enterValidEmail = "Please enter valid email id";
  static const String emailOTPSendFailed = "Email OTP Send Failed!";
  static const String emailOTPVerificationFailed =
      "Email OTP Verification Failed!";
  static const String enterOTP = "Please enter a OTP";
  static const String enterValidOTP = "Please enter a valid OTP";
  static const String selectRating = "Please select star rating";
}

class BaseUrl {
  static const String devBaseURL = "";
  static const String prodBaseURL = "";
}

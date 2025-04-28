// auth routes
import 'package:schoolsto/utils/constants/constants.dart';
const auth="$baseUrl/auth";
const signIn="$auth/signin";
const signUp="$auth/signup";
const verification="$auth/verification";
const resetPassword="$auth/resetPassword";
const resend="$auth/resend";

//student routes
const student="$baseUrl/student";
const createStudentUrl="$student/create";

//driver routes
const driver="$baseUrl/driver";
const driverCreate="$driver/create";
const assignVehicle="$driver/assignVehicle";

//car
const vehicle="$baseUrl/vehicle";
const vehicleAdd="$vehicle/create";
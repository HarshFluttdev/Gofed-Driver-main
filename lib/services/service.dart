
// import 'package:dio/dio.dart';

// class ImageService{
//   static Future<dynamic> uploadFile(filePath) async {

//     try {
//       FormData formData =
//       new FormData.fromMap({
//         "image":
//         await MultipartFile.fromFile(filePath, filename: "dp")});

//       Response response =
//       await Dio().put(
//           "http://gofedtransport.nexinfosoft.com/api/Partner/kycUpload",
//           data: formData,
//           options: Options(
//               headers: <String, String>{
//               }
//           )
//       );
//       return response;
//     }on DioError catch (e) {
//       return e.response;
//     } catch(e){
//     }
//   }
// }
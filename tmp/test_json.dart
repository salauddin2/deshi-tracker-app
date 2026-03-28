import 'dart:convert';

void main() {
  final jsonStr = r'''
  {"success":true,"message":"All Businesses retrieved successfully","meta":{"page":1,"limit":1,"total":1412,"totalPage":1412},"data":[{"_id":"69317f9e7611439a339e79b8","businessName":"Chamisse Restaurant","slug":"chamisse-restaurant","owner":{"_id":"693178727611439a339e79ab","name":"Chamisse Restaurant","userStatus":"new","email":"info@chamisse.com","phone":"02074300799","role":"business_owner","isBlocked":false,"isDeleted":false,"createdAt":"2025-12-04T12:02:58.427Z","updatedAt":"2025-12-04T12:33:49.555Z","__v":0,"profilePic":"https://res.cloudinary.com/dzem7xarv/image/upload/v1764851628/FB_IMG_1764850976928_rx2p6e.jpg"},"category":{"_id":"681dbc765b8b2e16603253ef","name":"Food & Dining","icon":"https://res.cloudinary.com/djn7wzals/image/upload/v1746779251/business-tracker/file-1746779249524-327159722.png","slug":"food-dining","details":"Food & Dining","subCategories":["681dc3975b8b2e166032541f"],"createdAt":"2025-05-09T08:27:34.971Z","updatedAt":"2025-06-09T18:16:06.485Z","__v":0},"subCategory":{"_id":"6834b5f8a5b9fb12cda870bf","name":"Lebanese","slug":"lebanese","details":"Lebanese","parentCategory":"681dbc765b8b2e16603253ef","createdAt":"2025-05-26T18:42:00.064Z","updatedAt":"2025-05-26T18:42:00.064Z","__v":0},"description":"The cuisine offers traditional Lebanese and Mediterranean food...","selectedType":"Restaurant","logo":"https://res.cloudinary.com/dycstwphn/image/upload/v1764851536/logo/file-1764851535973-569690865.jpg","contactDetails":{"phoneNumber":"02074300799","email":"info@chamisse.com","websiteUrl":"https://www.chamisse.com/","facebook":"https://www.facebook.com/ChamisseRestaurant","instagram":"https://www.instagram.com/chamisselondon/","linkedin":"","twitter":"","_id":"69317f9e7611439a339e79b9"},"locations":{"address":"55 Grays Inn Rd","homeTown":"","exactBusinessLocation":"","postCode":"WC1X 8PP","city":"London","country":"United Kingdom","isMultipleLocation":false,"branches":[],"_id":"69317f9e7611439a339e79ba"},"operationDetails":{"provideHomeDelivery":true,"provideOnlineService":true,"offerInStorePickup":true,"isParkingAvailable":false,"offerOnlineBooking":true,"onlineBookingLink":"https://www.chamisse.com/booking-calendar","whatsappNumber":"+442074300799","_id":"69317f9e7611439a339e79bb","menuLink":""},"features":{"officialLanguage":"Arabic","secondLanguage":"English","offerSpecialDiscount":true,"isWheelChairAccessible":true,"_id":"69317f9e7611439a339e79bc"},"media":{"thumbnail":[{"url":"https://res.cloudinary.com/dycstwphn/image/upload/v1764851592/images/file-1764851591895-697526867.jpg","description":"imageDescription","_id":"69317f9e7611439a339e79be"}],"images":[{"url":"https://res.cloudinary.com/dycstwphn/image/upload/v1764851546/images/file-1764851545728-995351611.jpg","description":"imageDescription","_id":"69317f9e7611439a339e79bf"}],"videos":[],"_id":"69317f9e7611439a339e79bd"},"agreeToTermsConditions":true,"hasCustomerTestimonials":true,"isActive":true,"isHalal":true,"isTrash":false,"isDeleted":false,"openingHours":[{"day":"Monday","start":"11:00","end":"22:30","_id":"69317f9e7611439a339e79c7"}],"paymentMethods":["Credit Card","Debit Card"],"createdAt":"2025-12-04T12:33:34.090Z","updatedAt":"2025-12-04T12:33:34.090Z"}]}
  ''';

  final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  final dataList = decoded['data'] as List;
  final data = dataList[0] as Map<String, dynamic>;

  print('Business Name: ${data['businessName']}');
  
  // Test specific fields safely
  final owner = data['owner'];
  final category = data['category'];
  final subCategory = data['subCategory'];

  print('owner type: ${owner.runtimeType}');
  print('category type: ${category.runtimeType}');
  print('subCategory type: ${subCategory.runtimeType}');

  if (owner is Map) {
    print('Owner Name: ${owner['name']}');
  }
}

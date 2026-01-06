import 'package:intl/intl.dart';

import '../config.dart';

class AppArray {
  final List<Map<String, String>> paymentMethods = [
    {'name': 'PayPal', 'icon': svgAssets.logoPaypal},
    {'name': 'Apple Pay', 'icon': svgAssets.cibApplePay},
    {'name': 'Google Pay', 'icon': svgAssets.gPay}
  ];
  var bottomNavigationBarList = [
    {
      "title": appFonts.home,
      "icon": svgAssets.homeLight,
      "iconDark": svgAssets.homeDark
    },
    {
      "title": appFonts.category,
      "icon": svgAssets.categoryLight,
      "iconDark": svgAssets.categoryDark
    },
    {
      "title": appFonts.myRides,
      "icon": svgAssets.carLight,
      "iconDark": svgAssets.carDark
    },
    {
      "title": appFonts.settings,
      "icon": svgAssets.settingLight,
      "iconDark": svgAssets.settingDark
    }
  ];

  var localList = <Locale>[
    const Locale('en'),
    const Locale('ar'),
    const Locale('fr'),
    const Locale('hi'),
  ];

  var currencyList = [
    {
      "id": 1,
      "code": "USD",
      "symbol": "\$",
      "no_of_decimal": "2.00",
      "exchange_rate": "1.00",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "0",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-11-13T03:43:17.000000Z",
      "deleted_at": null,
      "title": appFonts.usDollar,
      "icon": svgAssets.usDollar
    },
    {
      "id": 2,
      "code": "INR",
      "symbol": "₹",
      "no_of_decimal": "2.00",
      "exchange_rate": "83.24",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "1",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-11-13T03:43:17.000000Z",
      "deleted_at": null,
      "title": appFonts.inr,
      "icon": svgAssets.inr
    },
    {
      "id": 3,
      "code": "GBP",
      "symbol": "£",
      "no_of_decimal": "2.00",
      "exchange_rate": "100.00",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "0",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-09-08T16:55:08.000000Z",
      "deleted_at": null,
      "title": appFonts.pound,
      "icon": svgAssets.pound
    },
    {
      "id": 4,
      "code": "EUR",
      "symbol": "€",
      "no_of_decimal": "2.00",
      "exchange_rate": "0.01",
      "thousands_separator": "comma",
      "decimal_separator": "comma",
      "system_reserve": "0",
      "status": "1",
      "created_by_id": null,
      "created_at": "2023-09-08T16:55:08.000000Z",
      "updated_at": "2023-09-08T16:55:08.000000Z",
      "deleted_at": null,
      "title": appFonts.euro,
      "icon": svgAssets.euro
    }
  ];

  // language list
  var languageList = [
    {
      "title": appFonts.english,
      "locale": const Locale('en', 'EN'),
      "code": "en",
      "icon": imageAssets.english
    },
    {
      "title": appFonts.arabic,
      "locale": const Locale("ar", 'AE'),
      "code": "ar",
      "icon": imageAssets.arabic
    },
    {
      "title": appFonts.french,
      "locale": const Locale('fr', 'FR'),
      "code": "fr",
      "icon": imageAssets.french
    },
    {
      "title": appFonts.spanish,
      "locale": const Locale("hi", 'HI'),
      "code": "es",
      "icon": imageAssets.spanish
    },
  ];

  var carCards = [imageAssets.card1, imageAssets.card2];
  var categories = [
    {
      'image': imageAssets.ride,
      'title': "Ride",
      "subtitle": "Used for intercity travelling"
    },
    {
      'image': imageAssets.outstation,
      'title': "Outstation",
      "subtitle": "Used for travel city to city"
    },
    {
      'image': imageAssets.rental,
      'title': "Rental",
      "subtitle": "Used for get vehicle on rent"
    },
  ];

  var offer = [
    {
      "profile": imageAssets.profileImage,
      "title": "Johnson Smithkover",
      "area": "Up to 10 km from Wankover city area",
      "car": "Mini sedan",
      "person": "4 person",
      "Valid till": "20/11/2023"
    },
    {
      "profile": imageAssets.profileImage,
      "title": "Johnson Smithkover",
      "area": "Up to 10 km from Wankover city area",
      "car": "Mini sedan",
      "person": "4 person",
      "Valid till": "20/11/2023"
    }
  ];

  var notification = [
    {
      "title": "Account Alert!",
      "subtitle": "This allow you to retrieve your account if you lose access.",
      "icon": svgAssets.alert,
      "isRead": false
    },
    {
      "title": "Receive 20% discount for first ride",
      "subtitle": "You have booked plumber service today at 6:30pm.",
      "icon": svgAssets.discountCircle,
      "isRead": true
    },
    {
      "title": "New year shopping with rider!",
      "subtitle": "You have booked plumber service today at 6:30pm.",
      "icon": svgAssets.driving,
      "isRead": true
    },
    {
      "title": "You have received 1 coupon",
      "subtitle": "You have booked plumber service today at 6:30pm.",
      "icon": svgAssets.ticketDiscount,
      "isRead": true
    }
  ];
  var selectCategory = [
    {
      "title": "Home",
      "isSelected": true,
    },
    {
      "title": "Work",
      "isSelected": false,
    },
    {
      "title": "Other",
      "isSelected": false,
    }
  ];
  var setting = [
    {
      "title": appFonts.general,
      "data": [
        {"subTitle": appFonts.profileSettings, "icon": svgAssets.profile},
        {"subTitle": appFonts.savedLocation, "icon": svgAssets.locationSetting},
        {"subTitle": appFonts.bankDetails, "icon": svgAssets.bank},
        {"subTitle": appFonts.promoCodeList, "icon": svgAssets.promoCode}
      ]
    },
    {
      "title": appFonts.appDetails,
      "data": [
        {"subTitle": appFonts.appSettings, "icon": svgAssets.check},
        {"subTitle": appFonts.shareApp, "icon": svgAssets.share},
        {"subTitle": appFonts.chatSupport, "icon": svgAssets.chatSupport}
      ]
    },
    {
      "title": appFonts.alertZone,
      "data": [
        {"subTitle": appFonts.deleteAccount, "icon": svgAssets.delete},
        {"subTitle": appFonts.logout, "icon": svgAssets.logout}
      ]
    }
  ];
  var promoList = [
    {
      "off": appFonts.off,
      "code": appFonts.couponCode,
      "fairPrice": appFonts.farePriceMust,
      "date": "23/12/2023"
    },
    {
      "off": appFonts.off,
      "code": appFonts.couponCode,
      "fairPrice": appFonts.farePriceMust,
      "date": "23/12/2023"
    },
    {
      "off": appFonts.off,
      "code": appFonts.couponCode,
      "fairPrice": appFonts.farePriceMust,
      "date": "23/12/2023"
    },
    {
      "off": appFonts.off,
      "code": appFonts.couponCode,
      "fairPrice": appFonts.farePriceMust,
      "date": "23/12/2023"
    },
    {
      "off": appFonts.off,
      "code": appFonts.couponCode,
      "fairPrice": appFonts.farePriceMust,
      "date": "23/12/2023"
    },
  ];
  var saveLocation = [
    {
      "title": "Home",
      "icon": svgAssets.home,
      "address": "220 Yonge St, Toronto, ON M5B 2H1, Canada",
      "droppingAddress": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
    {
      "title": "Work",
      "icon": svgAssets.briefcase,
      "address": "220 Yonge St, Toronto, ON M5B 2H1, Canada",
      "droppingAddress": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
  ];

  //app setting
  List appSetting(isNotification) => [
        {
          'title':
              isNotification ? appFonts.notification : appFonts.notification,
          'icon': svgAssets.notification
        },
        {'title': appFonts.changeCurrency, 'icon': svgAssets.currency},
        {'title': appFonts.changeLanguage, 'icon': svgAssets.translate},
      ];

  //chat list
  var chatList = [
    {
      "type": "receiver",
      "message": "Hello ! How can i help you ?",
    },
    {
      "type": "source",
      "message": "Hello ! When will you arrive ?",
    },
    {
      "type": "receiver",
      "message": "I’ll be there soon.",
    },
    {
      "type": "source",
      "message": "Okay !! Thank you.",
    }
  ];
  var optionList = [appFonts.callNow, appFonts.clearChat];
  List monthList = [
    {"title": "January", "index": 1},
    {"title": "February", "index": 2},
    {"title": "March", "index": 3},
    {"title": "April", "index": 4},
    {"title": "May", "index": 5},
    {"title": "June", "index": 6},
    {"title": "July", "index": 7},
    {"title": "August", "index": 8},
    {"title": "September", "index": 9},
    {"title": "October", "index": 10},
    {"title": "November", "index": 11},
    {"title": "December", "index": 12}
  ];
  List<String> hourList = List.generate(12, (index) {
    DateTime time = DateTime.now().add(Duration(hours: index));
    String formattedTime = DateFormat('hh').format(time);
    return formattedTime;
  });

  List<String> minList = List.generate(60, (index) {
    DateTime time = DateTime.now().add(Duration(minutes: index));
    String formattedTime = DateFormat('mm').format(time);
    return formattedTime;
  });

  List<String> dayList = List.generate(2, (index) {
    DateTime time = DateTime.now().add(Duration(days: index));
    String formattedTime = DateFormat('a').format(time);

    return formattedTime;
  });

  var amPmList = ["AM", "PM"];
  var workHomeList = [
    {"title": 'Add Home', "icon": svgAssets.homeDark},
    {"title": 'Add Work', "icon": svgAssets.briefcaseDark}
  ];
  var recentLocationList = [
    {
      "area": "Koramangala",
      "address": "17600 Yonge St DD15, Newmarket, ON L3Y 4Z1..."
    },
    {
      "area": "Purdys Chocolatier",
      "address": "17600 Yonge St DD15, Newmarket, ON L3Y 4Z1..."
    },
    {
      "area": "Toronto Eaton Centre",
      "address": "601 Gerrard St E, Toronto, ON M4M 1Y2"
    },
    {
      "area": "Toronto PATH",
      "address": "335 Four Mile Creek Rd, St. Davids, ON L0S 1P0..."
    },
    {
      "area": "Purdys Chocolatier",
      "address": "220 Yonge St CRU #B210A, Toronto, ON M5B 2H1..."
    },
  ];
  List chooseRider = [
    {"icon": svgAssets.profileDark, "title": appFonts.mySelf},
    {"icon": svgAssets.contact, "title": appFonts.chooseAnotherContact}
  ];

  var vehicleType = [
    {
      "title": "Bike",
      "image": imageAssets.bike,
      "time": "5:42pm",
      "away": "2min away",
      "carName": appFonts.bike,
      "person": "1",
      "infoImage": imageAssets.carInfo,
      "amount": "50",
      "closeAmount": "57",
      "awayTime": appFonts.minAway,
      "advantage": appFonts.comfortableSedans,
      "dataTitle": appFonts.terms,
      "data": [
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
      ],
      "rentalTitle": "What's incorporated",
      "rentalInfo": [
        {
          "time": "9:00 am to 11:00 am",
          "sub": 'As soon as the driver starts the journey'
        },
        {"time": "2 hours included", "sub": '\$1 minute for extra time'},
        {"time": "20 km included", "sub": '\$10 km  for extra distance'},
      ],
      "policiesTitle": "Policies & fees",
      "policiesList": [
        {
          "PTitle": "Tolls and surcharges",
          "pSubTitle":
              "Any additional charges will be billed after your trip is completed."
        },
        {
          "PTitle": "Non refundable fare",
          "pSubTitle":
              "You’ll be charged the full upfront amount even if your trip is shorter than booked time or included mileage."
        },
      ]
    },
    {
      "title": "Car",
      "image": imageAssets.car,
      "time": "5:42pm",
      "away": "2min away",
      "carName": appFonts.teslaCar,
      "infoImage": imageAssets.carInfo,
      "person": "3",
      "amount": "50",
      "closeAmount": "57",
      "awayTime": appFonts.minAway,
      "advantage": appFonts.comfortableSedans,
      "dataTitle": appFonts.terms,
      "data": [
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
      ],
      "rentalTitle": "What's incorporated",
      "rentalInfo": [
        {
          "time": "9:00 am to 11:00 am",
          "sub": 'As soon as the driver starts the journey'
        },
        {"time": "2 hours included", "sub": '\$1 minute for extra time'},
        {"time": "20 km included", "sub": '\$10 km  for extra distance'},
      ],
      "policiesTitle": "Policies & fees",
      "policiesList": [
        {
          "PTitle": "Tolls and surcharges",
          "pSubTitle":
              "Any additional charges will be billed after your trip is completed."
        },
        {
          "PTitle": "Non refundable fare",
          "pSubTitle":
              "You’ll be charged the full upfront amount even if your trip is shorter than booked time or included mileage."
        },
      ]
    },
    {
      "title": appFonts.auto,
      "image": imageAssets.auto,
      "time": "5:42pm",
      "away": "2min away",
      "carName": appFonts.auto,
      "infoImage": imageAssets.carInfo,
      "person": "3",
      "amount": "50",
      "closeAmount": "57",
      "awayTime": appFonts.minAway,
      "advantage": appFonts.comfortableSedans,
      "dataTitle": appFonts.terms,
      "data": [
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
      ],
      "rentalTitle": "What's incorporated",
      "rentalInfo": [
        {
          "time": "9:00 am to 11:00 am",
          "sub": 'As soon as the driver starts the journey'
        },
        {"time": "2 hours included", "sub": '\$1 minute for extra time'},
        {"time": "20 km included", "sub": '\$10 km  for extra distance'},
      ],
      "policiesTitle": "Policies & fees",
      "policiesList": [
        {
          "PTitle": "Tolls and surcharges",
          "pSubTitle":
              "Any additional charges will be billed after your trip is completed."
        },
        {
          "PTitle": "Non refundable fare",
          "pSubTitle":
              "You’ll be charged the full upfront amount even if your trip is shorter than booked time or included mileage."
        },
      ]
    },
    {
      "title": appFonts.luxury,
      "image": imageAssets.sharedRide,
      "time": "5:42pm",
      "away": "2min away",
      "carName": appFonts.luxury,
      "infoImage": imageAssets.luxuryInfo,
      "person": "5",
      "amount": "50",
      "closeAmount": "57",
      "awayTime": appFonts.minAway,
      "advantage": appFonts.comfortableSedans,
      "dataTitle": appFonts.terms,
      "data": [
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
        appFonts.comfortableSedans,
      ],
      "rentalTitle": "What's incorporated",
      "rentalInfo": [
        {
          "time": "9:00 am to 11:00 am",
          "sub": 'As soon as the driver starts the journey'
        },
        {"time": "2 hours included", "sub": '\$1 minute for extra time'},
        {"time": "20 km included", "sub": '\$10 km  for extra distance'},
      ],
      "policiesTitle": "Policies & fees",
      "policiesList": [
        {
          "PTitle": "Tolls and surcharges",
          "pSubTitle":
              "Any additional charges will be billed after your trip is completed."
        },
        {
          "PTitle": "Non refundable fare",
          "pSubTitle":
              "You’ll be charged the full upfront amount even if your trip is shorter than booked time or included mileage."
        }
      ]
    }
  ];

  var cancelRide = [
    {
      "carName": "Tesla car",
      "driverName": "Jonathan Higgins",
      "price": "266",
      "time": "6 min",
      "km": "2 km",
      "rating": "4.8",
      "userRating": "(127)",
      "dateTime": "28 Nov 2023, 09:00AM",
      'image': imageAssets.jonathan,
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
    },
    {
      "carName": "Tesla car",
      "driverName": "Tony Danza",
      "price": "140",
      "time": "5 min",
      "km": "1.7 km",
      "rating": "4.7",
      "userRating": "(221)",
      "dateTime": "28 Nov 2023, 09:00AM",
      'image': imageAssets.tony,
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
    },
    {
      "carName": "Tesla car",
      "driverName": "Kate Tanner",
      "price": "100",
      "time": "8 min",
      "km": "3.1 km",
      "rating": "4.8",
      "userRating": "(417)",
      "dateTime": "28 Nov 2023, 09:00AM",
      'image': imageAssets.kate,
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
    },
    {
      "carName": "Tesla car",
      "driverName": "John Higgins",
      "price": "180",
      "time": "6 min",
      "km": "3.2 km",
      "rating": "4.9",
      "userRating": "(508)",
      "dateTime": "28 Nov 2023, 09:00AM",
      'image': imageAssets.john,
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
    },
  ];

  var selectOption = [
    {"image": imageAssets.sharedRide, "title": appFonts.sharedRide},
    {"image": imageAssets.parcel, "title": appFonts.parcel},
    {"image": imageAssets.freight, "title": appFonts.freight},
  ];
  var findingDriver = [
    {
      "image": imageAssets.sharedRide,
      "rideType": "\$400 for private ride",
      "date": "Tue, 28 Nov’23",
      "time": "9:00 AM",
      "paymentType": "Cash payment only",
      "currentLocation": "Toronto",
      "addLocation": "Ontario"
    }
  ];
  var bidingDriverList = [
    {
      "carName": "Tesla car",
      "driverName": "Jonathan Higgins",
      "price": "100",
      "time": "6 min",
      "rating": "4.8",
      "userRating": "(127)",
      "dateTime": "28 Nov 2023, 09:00AM",
      'image': imageAssets.jonathan,
      "mainCarImage": imageAssets.mainCar,
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
      "data": [
        {
          "dataTitle": "Total Trips",
          'totalData': '215',
        },
        {
          "dataTitle": "Rating",
          'totalData': '4.8/5',
        },
        {
          "dataTitle": "Total Years",
          'totalData': '2',
        },
      ],
      'reviews': [
        {
          "reviewerProfile": imageAssets.sledge,
          "name": 'Sledge Hammer',
          "rating": '4.8',
          'comments': '“Great service”'
        },
        {
          "reviewerProfile": imageAssets.john,
          "name": 'Sledge Hammer',
          "rating": '4.8',
          'comments': '“Great service”'
        },
      ]
    },
    {
      "carName": "Tesla car",
      "driverName": "Jonathan Higgins",
      "price": "100",
      "rating": "4.8",
      "userRating": "(127)",
      "dateTime": "28 Nov 2023, 09:00AM",
      'image': imageAssets.jonathan,
      'fullCarName': 'Blue Tesla Diesel Taxi',
      "mainCarImage": imageAssets.mainCar,
      'code': 'CLMV069',
      "data": [
        {
          "dataTitle": "Total Trips",
          'totalData': '215',
        },
        {
          "dataTitle": "Rating",
          'totalData': '4.8/5',
        },
        {
          "dataTitle": "Total Years",
          'totalData': '2',
        },
      ],
      'reviews': [
        {
          "reviewerProfile": imageAssets.sledge,
          "name": 'Sledge Hammer',
          "rating": '4.8',
          'comments': '“Great service”'
        },
        {
          "reviewerProfile": imageAssets.john,
          "name": 'Sledge Hammer',
          "rating": '4.8',
          'comments': '“Great service”'
        },
      ]
    },
  ];
  var packageList = [
    {"hour": "1 hr", "km": "10 km"},
    {"hour": "2 hr", "km": "30 km"},
    {"hour": "4 hr", "km": "40 km"},
    {"hour": "6 hr", "km": "60 km"},
    {"hour": "8 hr", "km": "80 km"},
  ];
  var rideStatus = [
    "Active Ride",
    "Pending Ride",
    "Complete Ride",
    "Cancel Ride"
  ];
  var rideStatusList = [
    {
      "id": "12000051",
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
      'price': '256.23',
      "status": "Active",
      'date': "15 Dec’23",
      'driverProfile': imageAssets.jonathan,
      "time": "10:15 AM",
      "driverName": 'Jonathan Higgins',
      "rating": "4.8",
      "userRatingNumber": "(127)",
      'carName': 'Tesla car',
      "image": svgAssets.myRideCar,
      "currentLocation":
          "220 Yonge St, Toronto, ON M5B 2H1, ON M5B 2H1, Yonge St, Canada",
      "addLocation": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
    {
      "id": "12000052",
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
      'price': '256.23',
      "status": "Pending",
      'driverProfile': imageAssets.jonathan,
      'date': "15 Dec’23",
      "time": "10:15 AM",
      "driverName": 'Jonathan Higgins',
      "rating": "4.8",
      "userRatingNumber": "(127)",
      'carName': 'Tesla car',
      "image": svgAssets.myRideCar,
      "currentLocation":
          "220 Yonge St, Toronto, ON M5B 2H1, ON M5B 2H1, Yonge St, Canada",
      "addLocation": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
    {
      "id": "12000052",
      'code': 'CLMV069',
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'price': '256.23',
      "status": "Pending",
      'driverProfile': imageAssets.sledge,
      'date': "15 Dec’23",
      "time": "10:15 AM",
      "driverName": 'Jonathan Higgins',
      "rating": "4.8",
      "userRatingNumber": "(127)",
      'carName': 'Tesla car',
      "image": svgAssets.myRideAuto,
      "currentLocation":
          "220 Yonge St, Toronto, ON M5B 2H1, ON M5B 2H1, Yonge St, Canada",
      "addLocation": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
    {
      "id": "12000051",
      'code': 'CLMV069',
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'price': '256.23',
      "status": "Complete",
      'driverProfile': imageAssets.jonathan,
      'date': "15 Dec’23",
      "time": "10:15 AM",
      "driverName": 'Jonathan Higgins',
      "rating": "4.8",
      "userRatingNumber": "(127)",
      'carName': 'Tesla car',
      "image": svgAssets.myRideCar,
      "currentLocation":
          "220 Yonge St, Toronto, ON M5B 2H1, ON M5B 2H1, Yonge St, Canada",
      "addLocation": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
    {
      "id": "12000052",
      'code': 'CLMV069',
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'price': '256.23',
      "status": "Complete",
      'driverProfile': imageAssets.jonathan,
      'date': "15 Dec’23",
      "time": "10:15 AM",
      "driverName": 'Jonathan Higgins',
      "rating": "4.8",
      "userRatingNumber": "(127)",
      'carName': 'Tesla car',
      "image": svgAssets.myRideAuto,
      "currentLocation":
          "220 Yonge St, Toronto, ON M5B 2H1, ON M5B 2H1, Yonge St, Canada",
      "addLocation": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
    {
      "id": "12000052",
      'price': '256.23',
      'fullCarName': 'Blue Tesla Diesel Taxi',
      'code': 'CLMV069',
      "status": "Cancelled",
      'driverProfile': imageAssets.jonathan,
      'date': "15 Dec’23",
      "time": "10:15 AM",
      "driverName": 'Jonathan Higgins',
      "rating": "4.8",
      "userRatingNumber": "(127)",
      'carName': 'Tesla car',
      "image": svgAssets.myRideLuxury,
      "currentLocation":
          "220 Yonge St, Toronto, ON M5B 2H1, ON M5B 2H1, Yonge St, Canada",
      "addLocation": "17600 Yonge St, Newmarket, ON L3Y 4Z1, Canada"
    },
  ];
  var whyCancelList = [
    {"svg": svgAssets.clockCircle, "question": "Driver asks for extra fare"},
    {"svg": svgAssets.drivingDark, "question": "Driver asked me to cancel"},
    {
      "svg": svgAssets.messageRemove,
      "question": "Driver asked to go directly/offline"
    },
    {"svg": svgAssets.securityTime, "question": "Wait time was too long"},
    {"svg": svgAssets.userCross, "question": "Driver doesn’t answer"},
    {
      "svg": svgAssets.userSpeakRounded,
      "question": "Complaint about the rider"
    },
    {
      "svg": svgAssets.timer,
      "question": "Driver asks for extra fareDriver getting closer"
    },
  ];
  var emergencyList = [
    {"image": svgAssets.sirenRounded, "title": "Call the police"},
    {"image": svgAssets.phone, "title": "Call safety support"},
    {"image": svgAssets.mapPoint, "title": "Share my location"},
  ];

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Ride with Ease",
      "description":
          "Discover seamless rides at your fingertips. Book your taxi anytime, anywhere, and travel stress-free."
    },
    {
      "title": "Safety First",
      "description":
          "Your safety is our priority. Enjoy real-time tracking, verified drivers, and 24/7 support on every journey."
    },
    {
      "title": "Affordable Rides for All",
      "description":
          "Choose from a variety of ride options to fit your budget. Affordable and reliable rides are just a tap away."
    },
  ];

  final List<Map<String, dynamic>> totalEarningTransactions = [
    {
      'type': 'Admin Commission Debit',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': false,
    },
    {
      'type': 'Wallet TopUp',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': true,
    },
    {
      'type': 'Wallet TopUp',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': true,
    },
    {
      'type': 'Admin Commission Debit',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': false,
    },
    {
      'type': 'Admin Commission Debit',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': false,
    },
    {
      'type': 'Wallet TopUp',
      'id': '#ACR148856',
      'amount': 200,
      'isCredit': true,
    },
  ];
  final List<Map<String, dynamic>> withdrawHistory = [
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123456',
      'amount': 300,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123457',
      'amount': 250,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123458',
      'amount': 400,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123459',
      'amount': 350,
      'isCredit': false
    },
    {
      'type': 'Withdrawal Processed',
      'id': '#WDR123460',
      'amount': 150,
      'isCredit': false
    }
  ];
}

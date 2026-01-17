import 'package:flutter/material.dart';

class RideDataModel {
  final String? image;
  final String? id;
  final String? status;
  final Color? statusColor;
  final String? price;
  final String? date;
  final String? time;
  final String? driverName;
  final String? rating;
  final String? userRatingNumber;
  final String? carName;
  final String? currentLocation;
  final String? addLocation;
  final String? distance;
  final Color? distanceColor;

  const RideDataModel({
    this.image,
    this.id,
    this.status,
    this.statusColor,
    this.price,
    this.date,
    this.time,
    this.driverName,
    this.rating,
    this.userRatingNumber,
    this.carName,
    this.currentLocation,
    this.addLocation,
    this.distance,
    this.distanceColor,
  });

  factory RideDataModel.fromMap(Map<String, dynamic> map) {
    return RideDataModel(
      image: map['image']?.toString(),
      id: map['id']?.toString(),
      status: map['status']?.toString(),
      statusColor: map['statusColor'] as Color?,
      price: map['price']?.toString(),
      date: map['date']?.toString(),
      time: map['time']?.toString(),
      driverName: map['driverName']?.toString(),
      rating: map['rating']?.toString(),
      userRatingNumber: map['userRatingNumber']?.toString(),
      carName: map['carName']?.toString(),
      currentLocation: map['currentLocation']?.toString(),
      addLocation: map['addLocation']?.toString(),
      distance: map['distance']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'id': id,
      'status': status,
      'statusColor': statusColor,
      'price': price,
      'date': date,
      'time': time,
      'driverName': driverName,
      'rating': rating,
      'userRatingNumber': userRatingNumber,
      'carName': carName,
      'currentLocation': currentLocation,
      'addLocation': addLocation,
      'distance': distance,
    };
  }
}

import 'package:flutter/material.dart' show IconData, Icons;

IconData getIconDataFromString(String iconString) {
  switch (iconString) {
    // HOUSING & UTILITIES
    case 'home':
      return Icons.home;
    case 'lightbulb_outline':
      return Icons.lightbulb_outline;
    case 'flash_on':
      return Icons.flash_on;
    case 'opacity':
      return Icons.opacity;
    case 'whatshot':
      return Icons.whatshot;
    case 'wifi':
      return Icons.wifi;
    case 'handyman':
      return Icons.handyman;
    case 'chair':
      return Icons.chair;

    // DAILY & GROCERIES
    case 'local_grocery_store':
      return Icons.local_grocery_store;
    case 'restaurant':
      return Icons.restaurant;
    case 'local_florist':
      return Icons.local_florist;
    case 'local_cafe':
      return Icons.local_cafe;
    case 'card_giftcard':
      return Icons.card_giftcard;

    // TRANSPORTATION
    case 'local_gas_station':
      return Icons.local_gas_station;
    case 'build':
      return Icons.build;
    case 'verified_user':
      return Icons.verified_user;
    case 'directions_transit':
      return Icons.directions_transit;
    case 'local_taxi':
      return Icons.local_taxi;
    case 'local_parking':
      return Icons.local_parking;

    // HEALTH & CARE
    case 'favorite_border':
      return Icons.favorite_border;
    case 'local_hospital':
      return Icons.local_hospital;
    case 'medical_services':
      return Icons.medical_services;
    case 'face':
      return Icons.face;
    case 'spa':
      return Icons.spa;

    // SHOPPING & PERSONAL
    case 'checkroom':
      return Icons.checkroom;
    case 'watch':
      return Icons.watch;
    case 'pets':
      return Icons.pets;

    // EDUCATION & DEVELOPMENT
    case 'school':
      return Icons.school;
    case 'cast_for_education':
      return Icons.cast_for_education;
    case 'menu_book':
      return Icons.menu_book;

    // TECH & MEDIA
    case 'phone_android':
      return Icons.phone_android;
    case 'subscriptions':
      return Icons.subscriptions;
    case 'devices_other':
      return Icons.devices_other;
    case 'apps':
      return Icons.apps;

    // TRAVEL
    case 'airplanemode_active':
      return Icons.airplanemode_active;
    case 'hotel':
      return Icons.hotel;
    case 'map':
      return Icons.map;

    // FINANCE & DEBTS
    case 'monetization_on':
      return Icons.monetization_on;
    case 'trending_up':
      return Icons.trending_up;
    case 'account_balance':
      return Icons.account_balance;
    case 'account_balance_wallet':
      return Icons.account_balance_wallet;
    case 'gavel':
      return Icons.gavel;
    case 'atm':
      return Icons.atm;

    // LEISURE & SOCIAL
    case 'local_movies':
      return Icons.local_movies;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'videogame_asset':
      return Icons.videogame_asset;
    case 'palette':
      return Icons.palette;
    case 'cake':
      return Icons.cake;
    case 'volunteer_activism':
      return Icons.volunteer_activism;

    // WORK & BUSINESS
    case 'business_center':
      return Icons.business_center;
    case 'create':
      return Icons.create;

    // OTHER
    case 'more_horiz':
      return Icons.more_horiz;

    default:
      return Icons.category;
  }
}

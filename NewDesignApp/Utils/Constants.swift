//
//  Constants.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import Foundation

enum NotificationType: String {
     case UpcomingOrder = "Upcoming"
     case OnGoingOrder = "Ongoing"
     case PastHistory = "History"
     case DineIn = "DineIn"
    case Offer = "Offer"
    case Others = "Other"
}

enum HomeSection: Int {
     case Banner
     case Slider
     case Cousine
     case DeliciousDeals
     case TopPicks
     case Rest
     case Norest
     case Count
}
//enum OfferRows: Int {
//     case OfferZone
//     case OnMind
//     case TopRated
//     case Count
//}
enum RestaurentDetailsSection: Int {
     case RestDetails
     case Deals
     case Featured
     case FoodType
     case Menu
     case Items
     case Count
}
enum TextType: String {
     case UnhideThisRestaurant = "Unhide this restaurant"
     case ShowSimilarRestaurants = "Show similar restaurants"
     case AddToFavourites = "Add to favourites"
     case HideThisRestaurant = "Hide this restaurant"
     case RemoveFromFavourites = "Remove from favourites"
}

enum StoryName: String {
     case Main = "Main"
     case DashBoard = "DashBoard"
     case FoodSeach = "FoodSeach"
     case History = "History"
     case Profile = "Profile"
    case OrderFlow = "OrderFlow"
    case Location = "Location"
    case CartFlow = "CartFlow"
    case DineIn = "DineIn"
}

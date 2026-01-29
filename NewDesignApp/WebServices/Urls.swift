//
//  Urls.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 23/08/24.
//

import Foundation
import UIKit

let GoogleApiKey = "AIzaSyAcpD8juDqASzLRWCdNP-ns4UzdVph1koU"

struct AppConfig {
    static let OldAPI_KEY = "ba6ee13256e5f0d75eacbf87de167541"
    static let API_ID = "GB19AP01"
   // static let API_KEY = "ba6ee13256e5f0d75"
    static let DeviceType =  UIDevice.current.systemName
}

struct OldServiceType {
    static let BASE = "https://www.webapi.grabull.shop/"
    //static let BASE = "https://www.grabull.com/web-api-ios/"
    static let resturantList = "restaurant/GetAllRestaurant"
    static let cuisine = "cuisine/"
    static let restaurantDetail = "restaurant-details/GetRestaurantById"
    //static let restaurantDetail = "restaurant-details-new/GetRestaurantById"
    static let getFavorite = "request/Favorite"
    static let addFavorite = "request/addFavoritres"
    static let removeFavorite = "request/RemoveFavorite"
    static let getReward = "reward/"
    static let getAddress = "request/GetAddress"
    static let getDistance = "distance/"
    
    
    static let getLogin = "user/"
    static let getSignup = "register/"
    static let editProfile = "request/Profile"
    static let forgotpass = "request/ForgetPassword"
    static let changePassword = "request/ChangePassword"
    static let removeAddress = "request/RemoveAddress"
    static let addAddress = "request/AddAddress"
    static let updateAddress = "request/UpdateAddress"
    static let options = "options/GetAllOptionsByItem"
    static let restaurantTime = "restaurant-time/GetRestaurantTimingById"
    static let orderHistory = "request/OrderHistory"
    static let bookdine = "book-dine/"
    static let placeOrder = "add-order/"
    static let getDineInOrders = "dine-history/"
    static let addReview = "add-reviews/"
    static let getReview = "view-reviews/"
    static let updateReview = "update-reviews/"
    
    static let ongoingOrder = "/request/OngoingOrder"
    static let upcomingOrder = "/request/UpcomingOrder"
    static let pastOrder = "/request/OrderHistoryPast"//(api_id/api_key/year/month/customer_id)
    
    static let addCard = "request/AddCard"//(api_id/api_key/customer_id/cardnumber/cardholder/cardzip)
    static let removeCard = "request/CardRemove"
    static let detailCard = "request/CardDetails"
    
    static let referFriend = "refer-friend/"
    static let referFriendList = "refer-friend-list/"
    
    static let referRestaurantList = "refer-restaurant-list/"
    static let referRestaurant = "refer-restaurant/"
    
    static let customerSupportList = "customer-support-list/"
    static let customerSupport = "customer-support/"
    static let getSupportDetail = "request/getSupportList"




    
    static let hiddenRestList = "hiddenRestList"
    static let favoriteRest = "favoriteRestList"
    static let hiddenRest = "hiddenRest"



    static let imageUrl = "https://www.grabull.com/restaurants-search/pics/"
    static let cuisineImageUrl = "https://www.grabull.com/files/cuisine-icons/"
    static let restaurantImageUrl = "https://www.grabull.com/files/restaurant/"
}
/*
struct APPURLS {
    private  struct Base {
        static let BASE = "https://www.grabull.com/"
    }
    private  struct Routes {
        static let BASE_URL = Base.BASE+"web-api/"
    }
    static let getHomePageRestList = Routes.BASE_URL+"getRest/"

    
    
    
//    static let BaseUrlImage =  Base.BASE+"files/restaurant/"
//    static let BaseUrlImageCuisins =  Base.BASE+"files/cuisine/"
//    static let GetAllCuisine = Routes.BASE_URL+"cuisine/GetAllCuisine"
    // static let UserLogin = Routes.BASE_URL+"user/GetUserById"
}
*/

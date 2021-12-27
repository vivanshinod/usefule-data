//
//  Response.swift
//  UBFit
//
//  Created by Apple on 22/10/21.
//

import UIKit
import ObjectMapper

class Response: Mappable {
    var data                            : [String: Any]?
    var status                          : Bool?
    var message                         : String?
    var totalPageIndex                  : Int?
    
    var userDetail                      : UserDetail?
    var questionList                    : [QuestionList]?
    var appVersion                      : AppVersion?
    var favoriteList                    : [FavoriteList]?
    var followingList                   : [FollowingList]?
    var creditHistoryData               : CreditHistoryData?
    var creditHistory                   : CreditHistory?
    var notificationList                : [NotificationList]?
    var paymentCardList                 : [PaymentCardList]?
    var userPostList                    : [UserPostList]?
    var categoriesList                  : [CategoriesList]?
    var discoverData                    : DiscoverData?
    var popular                         : [Popular]?
    var recommend                       : [Recommend]?
    var nearest                         : [Nearest]?
    var trainerListByCategory           : [TrainerListByCategory]?
    var trainersByName                  : [TrainersByName]?
    var trainerDetails                  : TrainerDetails?
    var followerList                    : [FollowerList]?
    var reviewsList                     : ReviewsList?
    var reviews                         : [Reviews]?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        status                          <- map["status"]
        message                         <- map["message"]
        data                            <- map["data"]
        totalPageIndex                  <- map["totalPageIndex"]
        
        userDetail                      <- map["data"]
        questionList                    <- map["data"]
        appVersion                      <- map["data"]
        favoriteList                    <- map["data"]
        creditHistoryData               <- map["data"]
        creditHistory                   <- map["credit_history"]
        notificationList                <- map["data"]
        paymentCardList                 <- map["data"]
        categoriesList                  <- map["data"]
        discoverData                    <- map["data"]
        popular                         <- map["data.popular"]
        recommend                       <- map["data.recommend"]
        nearest                         <- map["data.nearest"]
        trainerListByCategory           <- map["data"]
        trainersByName                  <- map["data"]
        trainerDetails                  <- map["data"]
        followerList                    <- map["data"]
        reviewsList                     <- map["data"]
        reviews                         <- map["reviews"]
    }
}

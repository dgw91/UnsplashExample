//
//  NetworkConstants.swift
//  UnsplashExample
//
//  Created by Derrick Wilde on 7/5/21.
//

import Foundation
struct NetworkConstants {

  private struct Domains {
      static let Unsplash = "api.unsplash.com"
  }

  private struct Routes {
      static let Photos = "/search/photos"
  }
   
    
    // In a real world usage I would want all of this code to have a back end wrapper around it.
    // To avoid calling a 3rd party directly and also to protect these keys better.
  private struct Keys {
    static let AccessKey = "kCKXwTYEZ-k1u600JghDiT1ZqF-MXaPjRdHWhx6cHtA"
    static let Private = "bK2JLmD1v12nd1-uTYktPZULCVexO8SEWdtvLXnGGw8"

  }

  public static let Domain = Domains.Unsplash
  public static let Route = Routes.Photos
  public static let BaseURL = Domain + Route
  public static let AccessKey = Keys.AccessKey

}

//
//  ListService.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import RxAlamofire
import Alamofire
import RxSwift

// Enum for response error code
enum ResponseCode: Int {
   case success = 200
   case somethingWentWrong = 0
}

// Common Error enum 
enum ResponseError: Error {
   case somethingWentWrong
}

class ListService: NSObject {
   //MARK:- Properties
   private let disposeBag = DisposeBag()
   
   // Service Method
   func getList() -> Single<[ListJsonBO]> {
      return Single.create { [weak self](observer) -> Disposable in
         guard let strongSelf = self else { return Disposables.create() }
         strongSelf.dataServiceRequest(stringUrl: ApiUrl.listUI).subscribe(onSuccess: { (data) in
            do{
               if let data = data as? Data {
                  let listJsonBO = try JSONDecoder().decode([ListJsonBO].self, from: data)
                  observer(.success(listJsonBO))
               }
            } catch {
               observer(.error(error))
            }
         }) { (error) in
            observer(.error(error))
            
         }.disposed(by: strongSelf.disposeBag)
         return Disposables.create()
      }
   }
}

extension ListService {
   // Create request
   private func dataServiceRequest(stringUrl: String) -> Single<AnyObject?> {
      return Single.create { [weak self](observer) -> Disposable in
         guard let strongSelf = self else { return Disposables.create() }
         if let url = stringUrl.toUrl {
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.get.rawValue
            RxAlamofire.request(request as URLRequestConvertible).responseJSON().asObservable().subscribe({ (response) in
               // Handle response and data
               self?.handleResponse(response: response.element?.response, data: response.element?.data) { (data, error) in
                  if error != nil {
                     observer(.error(error ?? ResponseError.somethingWentWrong))
                  } else {
                     observer(.success(data as AnyObject))
                  }
               }
            }).disposed(by: strongSelf.disposeBag)
         }
         return Disposables.create()
      }
   }
   
   // handle Response with status code
   private func handleResponse(response: HTTPURLResponse?, data: Data?, completionHandler: @escaping (_ response: Data?, _ error: Error?) -> Void) {
      switch response?.statusCode {
      case ResponseCode.success.rawValue :
         if let data = data {
            do {
               let responseJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments ) as? Array<Any>
               if (responseJSON?.count ?? 0) > 0 {
                  completionHandler(data, nil)
               } else {
                  let error = ResponseError.somethingWentWrong
                  completionHandler(nil, error)
               }
            } catch let error {
               completionHandler(nil, error)
            }
         } else {
            let error = ResponseError.somethingWentWrong
            completionHandler(nil, error)
         }
      default:
         let error = ResponseError.somethingWentWrong
         completionHandler(nil, error)
      }
   }
}

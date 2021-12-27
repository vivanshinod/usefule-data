  pod 'Alamofire'
  pod 'AlamofireObjectMapper'#, '~> 5.2'
  
  Alamofire Shourcut class: 
  
  //
//  APIManager.swift
//  UBFit
//
//  Created by Apple.
//

import Foundation
import Alamofire
import ObjectMapper

class APIManager {
    
    static let shared = APIManager()
    
    // -----------------------------------------------------------------
    //                          MARK:- Post API Request
    // -----------------------------------------------------------------
    
    public func GetApi(url: String, parameter: [String: Any]?, complition: @escaping (Bool, String, Response?) -> Void) {
        
        var header: HTTPHeaders = [:]
        
        let token = BaseVC.sharedInstance.getUserDefaultStringFromKey(.kAuthToken)
        if !token.isEmpty {
            header.add(HTTPHeader.contentType("application/json"))
            header.add(HTTPHeader.authorization("Bearer \(token)"))
            
        } else {
            header.add(HTTPHeader.contentType("application/json"))
        }
        //
        print("GetURL:\(url)")
        print("Parameters : \(parameter ?? [:])")
        
        AF.request(url, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                
                if let res = response.value as? [String: Any], let msg = res["message"] as? String, msg == "INVALID AUTHENTICATION TOKEN" {
                    //                    BaseVC.sharedInstance.logoutUser()
                }
                
                // do whatever you want here
                switch response.result {
                case .failure(let error):
                    print(error)
                    print(response.error?.localizedDescription as Any)
                    complition(false, response.error?.localizedDescription ?? "", nil)
                    
                case .success(let responseObject):
                    print(responseObject)
                    if let res = response.value as? [String: Any] {
                        
                        let r = Response(JSON: res)
                        
                        if r?.status == true {
                            complition(true, r?.message ?? "", r)
                        } else {
                            complition(false, r?.message ?? "", nil)
                        }
                    } else {
                        complition(false, "Response not able to parse", nil)
                    }
                }
            }
    }
    
    public func PostApi(url: String, parameter: [String: Any], complition: @escaping (Bool, String, Response?) -> Void) {
        
        var header: HTTPHeaders = [:]
        
        let token = BaseVC.sharedInstance.getUserDefaultStringFromKey(.kAuthToken)
        if !token.isEmpty {
            header.add(HTTPHeader.contentType("application/json"))
            header.add(HTTPHeader.authorization("Bearer \(token)"))
        } else {
            header.add(HTTPHeader.contentType("application/json"))
            
        }
        
        print("PostURL:\(url)")
        print("Parameters : \(parameter)")
        
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header)
            .responseJSON { response in
                // do whatever you want here
                //                print(response)
                
                if let res = response.value as? [String: Any], let msg = res["message"] as? String, msg == "INVALID AUTHENTICATION TOKEN" {
                    //                    BaseVC.sharedInstance.logoutUser()
                }
                
                switch response.result {
                case .failure(let error):
                    print(error)
                    //                    print(response.error?.localizedDescription as Any)
                    
                    complition(false, response.error?.localizedDescription ?? "", nil)
                    
                case .success(let responseObject):
                    print(responseObject)
                    if let res = response.value as? [String: Any] {
                        
                        let r = Response(JSON: res)
                        
                        if r?.status == true {
                            complition(true, r?.message ?? "", r)
                        } else {
                            complition(false, r?.message ?? "", nil)
                        }
                        
                    } else {
                        complition(false, "Response not able to parse", nil)
                    }
                }
            }
    }
    
    public func UploadImg(postUrl: String, image: UIImage?, imgKey: String, parameters: [String:Any], complition: @escaping (_ isSuccess: Bool ,_ message: String ,_ responce: Response?) -> Void) {
        
        var header: HTTPHeaders = [:]
        
        let token = BaseVC.sharedInstance.getUserDefaultStringFromKey(.kAuthToken)
        if !token.isEmpty {
            //            header = ["Content-Type": "application/json" , "Authorization": "Bearer \(token)"]
            header.add(HTTPHeader.contentType("application/json"))
            header.add(HTTPHeader.authorization("Bearer \(token)"))
        } else {
            //            header = ["Content-Type": "application/json"]
            header.add(HTTPHeader.contentType("application/json"))
        }
        
        print("PostURL:\(postUrl)")
        print("Parameters : \(parameters)")
        
        AF.upload(multipartFormData: { (MultipartFormData) in
            
            if let img = image {
                let imgData = img.jpegData(compressionQuality: 0.6)
                MultipartFormData.append(imgData!, withName: imgKey, fileName: "file.jpeg", mimeType: "img/jpeg")
            }
            
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        }, to: postUrl, method: .post, headers: header)
        
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
        
            .responseJSON(completionHandler: { dataResponce in
                
                print("API URL:->\(postUrl)")
                print(dataResponce)
                
                if let res = dataResponce.value as? [String:Any] {
                    let r = Response(JSON: res)
                    
                    if r?.status == true {
                        complition(true,r!.message ?? "",r)
                    } else {
                        complition(false,r!.message ?? "",nil)
                    }
                } else {
                    complition(false, dataResponce.error?.localizedDescription ?? "", nil)
                }
            })
    }
    
    public func UploadFile(postUrl: String, fileData: Data?, fileKey: String,mimeType: String, parameters: [String:Any], complition: @escaping (_ isSuccess: Bool ,_ message: String ,_ responce: Response?) -> Void) {
        
        var header: HTTPHeaders = [:]
        
        let token = BaseVC.sharedInstance.getUserDefaultStringFromKey(.kAuthToken)
        if !token.isEmpty {
            header.add(HTTPHeader.contentType("application/json"))
            header.add(HTTPHeader.authorization("Bearer \(token)"))
        } else {
            header.add(HTTPHeader.contentType("application/json"))
        }
        
        print("PostURL:\(postUrl)")
        print("Parameters : \(parameters)")
        
        AF.upload(multipartFormData: { (MultipartFormData) in
            
            if let fData = fileData {
                //                let imgData = img.jpegData(compressionQuality: 0.5)
                MultipartFormData.append(fData, withName: fileKey, fileName: "file.text", mimeType: mimeType)
            }
            
            for (key, value) in parameters {
                MultipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
        }, to: postUrl, method: .post, headers: header)
        
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
        
            .responseJSON(completionHandler: { dataResponce in
                
                print("API URL:->\(postUrl)")
                print(dataResponce)
                
                if let res = dataResponce.value as? [String:Any] {
                    let r = Response(JSON: res)
                    
                    if r?.status == true {
                        complition(true,r!.message ?? "",r)
                    } else {
                        complition(false,r!.message ?? "",nil)
                    }
                } else {
                    complition(false, dataResponce.error?.localizedDescription ?? "", nil)
                }
            })
    }
    
    public func downloadFileFrom(url: String, complition : @escaping (Bool, String,_ fileurl: URL?) -> Void) {
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(URL(string: url)!.lastPathComponent)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(
            url,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                //progress closure
            }).response(completionHandler: { (response) in
                //here you able to access the DefaultDownloadResponse
                //result closure
                if response.error == nil {
                    complition(true, "Download file successfully", response.value!?.absoluteURL)
                } else {
                    complition(false, (response.error?.localizedDescription ?? ""), nil)
                }
            })
    }
}

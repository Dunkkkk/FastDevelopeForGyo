import UIKit
import Foundation
import Security
import Alamofire
import UIKit

struct APIConstants {
    
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let auth = "x-auth-token"
    static let contentType = "Content-Type"

    static let applicationJSON = "application/json"
    static let formEncoded = "application/x-www-form-urlencoded"
    static let jwtToken = KeyChain.load(key: "token")
    
    // Base URL
    static let baseURL = "http://15.164.158.186:8080/v1/"
    static let loginURL = baseURL + "oauth/kakao"
    static let profilBasic = "users/"
}

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}


enum NetworkHeaderKey: String {
    case auth = "Authorization"
    case contentType = "Content-Type"
}

struct NetworkInfo {
    static let shared = NetworkInfo()
    static let token = APIConstants.jwtToken
    static var header: HTTPHeaders {
        [NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON]
    }
    static var headerWithToken: HTTPHeaders {
        [
            //NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON,
            NetworkHeaderKey.auth.rawValue: String(decoding: token ?? Data(), as: UTF8.self)
        ]
    }
}


class KeyChain {
    class func save(key: String, data: Data) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    class func load(key: String) -> Data? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject?
        let status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return data
            }
        }
        return nil
    }
    
    class func delete(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query)
    }
}

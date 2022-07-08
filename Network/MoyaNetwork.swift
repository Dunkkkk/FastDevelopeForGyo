//
//  MoyaNetwork.swift
//  FastDevelopeForGyo
//
//  Created by changgyo seo on 2022/07/08.
//

import Foundation
import Moya

enum serviceMoya {
    case load(currentLoacation: CLLocation ,query: String,distance: Int)
    
    func makeParameter(_ currentLoacation: CLLocation,_ query: String, _ distance: Int) -> [String: Any] {
        return ["query" : query ,
                "x" : currentLoacation.coordinate.longitude,
                "y" : currentLoacation.coordinate.latitude,
                "radius" : distance]
    }
}

extension serviceMoya: TargetType {
    var baseURL: URL {
        switch self{
        case .load(_, _, _):
            return URL(string: ApiContants.baseURL)!
        }
    }
    
    var path: String {
        switch self{
        case .load(_, _, _):
            return ApiContants.keyWordSearchingURL
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .load(_, _, _):
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .load(let currentLocation,let query,let distance):
            return .requestParameters(parameters: makeParameter(currentLocation, query, distance), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .load(_,_,_):
            return ["Authorization" : "KakaoAK 5f19a19bb386f2aa329de04bc6340fdb"]
        }
    }
}



class NetworkServiceMoya {
    static let shared = NetworkServiceMoya()
    let provider = MoyaProvider<serviceMoya>()
    
    func loadPOIDataMoya(_ currentLoacation: CLLocation ,_ query: String, _ distance: Int) -> Observable<[Document]> {
        return Observable.create { emitter in
            let provider = MoyaProvider<serviceMoya>()
            provider.request(.load(currentLoacation: currentLoacation, query: query, distance: distance)) { (result) in
                switch result {
                case let .success(response):
                    let result = try? response.map(DocRes.self)
                    emitter.onNext(result?.documents ?? [])
                    emitter.onCompleted()
                case let .failure(error):
                    emitter.onError(error)
                }
                
            }
            
            return Disposables.create()
        }
    }
}


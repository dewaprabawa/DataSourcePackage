//
//  RemoteDataSourcr.swift
//  plus_ultra
//
//  Created by OS Live Server on 12/11/22.
//

import Foundation
import RxSwift
import Alamofire

public protocol RemoteDataSourceProtocol: AnyObject {
    func retrieveGameList() -> Observable<[GameResponse]>
    func searchGameList(query: String) -> Observable<[GameResponse]>
}

final public class RemoteDataSource {
    
    ///MARK: Initialization
    private let session: Session?
    private let queues: QueueLoaderHelperAction = QueueLoaderHelperAction()
    
    init(session: Session?){
        self.session = session
    }
    
    
    static public let sharedInstance: (Session?) -> RemoteDataSourceProtocol = {
         sessionManager in return RemoteDataSource(session: sessionManager)
    }
}

///MARK: class Method
extension RemoteDataSource: RemoteDataSourceProtocol {
      
    public func retrieveGameList() -> Observable<[GameResponse]> {
        return Observable<[GameResponse]>.create { observer in
            self.request(urlString: Endpoints.Gets.games.url) { data, error in
                if let error = error {
                    observer.onError(error)
                }else{
                    observer.onNext(data ?? [])
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    
    public func searchGameList(query: String) -> Observable<[GameResponse]> {
        return Observable<[GameResponse]>.create { observer in
            self.request(urlString: Endpoints.Gets.search(query).url) { data, error in
                if let error = error {
                    observer.onError(error)
                }else{
                    print("\(query): \(data ?? [])")
                    observer.onNext(data ?? [])
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
}

extension RemoteDataSource {
    fileprivate func request(urlString: String, completion:@escaping ([GameResponse]?, Error?) -> Void) -> Void {
        if let url = URL(string: urlString){
            debugPrint("Initate Remote Source ...")
            let requestList = session?.request(url, parameters: API.parameters).validate()
            var temp: [GameResponse] = []
            requestList?.responseDecodable(of: GameResponses.self) { [weak self] response in
                switch(response.result){
                case .success(let value):
                    for item in value.results{
                        self?.queues.group.enter()
                        self?.queues.queueLoader.async(group: self?.queues.group){
                            self?.fetchMoreInfomation(input: item) { data in
                                temp.append(data)
                                self?.queues.group.leave()
                            }
                        }
                    }
                    self?.queues.group.notify(queue: .main) {
                        debugPrint("Success Remote Source ...")
                        completion(temp, nil)
                    }
                    break
                case .failure:
                    completion(nil, URLError.invalidResponse)
                }
            }
        }
    }
    
    fileprivate func fetchMoreInfomation(input item: GameResponse, completion:@escaping (GameResponse) -> Void) -> Void {
        var descriptionText: String? = nil
        var videoURL: VideoTriler? = nil
        
        self.queues.subgroup.enter()
        self.queues.subQueueLoader.async(group: self.queues.subgroup) { [weak self] in
            let descURL = URL(string: Endpoints.Gets.gameDetail(item.id).url)
            let requestDescription = self?.session?.request(descURL!, parameters: API.parameters)
            requestDescription?.responseDecodable(of: GameResponse.self) { descriptionResponse in
                descriptionText = descriptionResponse.value?.description
                self?.queues.subgroup.leave()
            }
        }
        
        self.queues.subgroup.enter()
        self.queues.subQueueLoader.async(group: self.queues.subgroup) { [weak self] in
            let trailerURL = URL(string: Endpoints.Gets.gameTrailer(item.id).url)
            let requestTrailer = self?.session?.request(trailerURL!,parameters: API.parameters)
            requestTrailer?.responseDecodable(of: VideoTriler.self) { trailerResponse in
                videoURL = trailerResponse.value
                self?.queues.subgroup.leave()
            }
        }
        
        
        self.queues.subgroup.notify(queue: .main, execute: {
            completion(GameResponse(id: item.id, description: descriptionText, slug: item.slug, name: item.name, released: item.released, backgroundImage: item.backgroundImage, rating: item.rating, videoTriler: videoURL, ratingsCount: item.ratingsCount, updated: item.updated, genres: item.genres, screenShoot: item.screenShoot, platforms: item.platforms, tags: item.tags, playtime: item.playtime))
        })
    }
}

private class QueueLoaderHelperAction {
      let subQueueLoader = DispatchQueue(label: "com.subLoader")
      let subgroup = DispatchGroup()
      let queueLoader = DispatchQueue(label: "com.Loader")
      let group = DispatchGroup()
}

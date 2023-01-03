//
//  LocalDataSource.swift
//  plus_ultra
//
//  Created by OS Live Server on 13/11/22.
//

import RealmSwift
import RxSwift

public protocol LocalGameDataSourceProtocol: AnyObject {
    func getGameList() -> Observable<[GameEntity]>
    func saveGameList(from categories: [GameEntity]) -> Observable<Bool>
    func getFavGameList() -> Observable<[FavEntity]>
    func saveFavGameList(from games: [FavEntity]) -> Observable<Bool>
    func saveOneGame(from savedOne: FavEntity, completion: @escaping (Bool)-> Void)
    func deleteOneGame(with id: Int, completion: @escaping (Bool)-> Void)
}


final public class LocaleGameDataSource {
    private let realm: Realm?
    
    private init(realm: Realm?){
        self.realm = realm
    }
    
    static public let sharedInstance: (Realm?) -> LocalGameDataSourceProtocol = {
        realmDataBase in return LocaleGameDataSource(realm: realmDataBase)
    }
}

extension LocaleGameDataSource: LocalGameDataSourceProtocol {
    
    public func getGameList() -> Observable<[GameEntity]> {
        debugPrint("Initate Local call...")
        return Observable<[GameEntity]>.create { observer in
            if let realm = self.realm {
                let categories: Results<GameEntity> = {
                    return realm.objects(GameEntity.self).sorted(byKeyPath: "name", ascending: true)
                }()
                observer.onNext(categories.toArray(ofType: GameEntity.self))
                debugPrint("Finish Local call...")
                observer.onCompleted()
            }else{
                debugPrint("Failure Local call...")
                observer.onError(DatabaseError.invalidInstance)
            }
            return Disposables.create()
        }
    }
    
    public func saveGameList(from categories: [GameEntity]) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            do {
                if let realm = self.realm {
                    try realm.write({
                        for category in categories {
                            realm.add(category, update: .all)
                        }
                        observer.onNext(true)
                        observer.onCompleted()
                    })
                }else{
                    observer.onError(DatabaseError.invalidInstance)
                }
            } catch  {
                observer.onError(DatabaseError.requestFailed)
            }
            return Disposables.create()
        }
    }
   
    
    public func getFavGameList() -> Observable<[FavEntity]> {
         debugPrint("Initate Local call...")
         return Observable<[FavEntity]>.create { observer in
             if let realm = self.realm {
                 let games: Results<FavEntity> = {
                     return realm.objects(FavEntity.self).sorted(byKeyPath: "name", ascending: true)
                 }()
                 observer.onNext(games.toArray(ofType: FavEntity.self))
                 debugPrint("Finish Local call...")
                 observer.onCompleted()
             }else{
                 debugPrint("Failure Local call...")
                 observer.onError(DatabaseError.invalidInstance)
             }
             return Disposables.create()
         }
     }
     
    public func saveFavGameList(from games: [FavEntity]) -> Observable<Bool> {
         return Observable<Bool>.create { observer in
             do {
                 if let realm = self.realm {
                     try realm.write({
                         for game in games {
                             realm.add(game, update: .all)
                         }
                         observer.onNext(true)
                         observer.onCompleted()
                     })
                 }else{
                     observer.onError(DatabaseError.invalidInstance)
                 }
             } catch  {
                 observer.onError(DatabaseError.requestFailed)
             }
             return Disposables.create()
         }
     }
     
    public func saveOneGame(from savedOne: FavEntity, completion: @escaping (Bool)-> Void) -> Void{
         do {
             if let realm = self.realm {
                 
                 try realm.write({
                     
                     let games: Results<FavEntity> = {
                         return realm.objects(FavEntity.self).sorted(byKeyPath: "name", ascending: true)
                     }()
                     
                     let isAlreadyExisted = games.first { selected in
                         return selected.id == savedOne.id
                     }
                     
                     if isAlreadyExisted != nil {
                         completion(false)
                     }else{
                         realm.add(savedOne)
                         completion(true)
                     }
                 })
             }else{
                 completion(false)
             }
         } catch  {
             completion(false)
         }
     }
     
    public func deleteOneGame(with id: Int, completion: @escaping (Bool) -> Void) {
         do {
             if let realm = self.realm {
                 try realm.write({
                     let games: Results<FavEntity> = {
                         return realm.objects(FavEntity.self).sorted(byKeyPath: "name", ascending: true)
                     }()
                     let deleting = games.first { selected in
                         return selected.id == id
                     }
                     if let deleting = deleting {
                         realm.delete(deleting)
                     }
                    
                 })
                 completion(true)
             }else{
                 completion(false)
             }
         } catch  {
             completion(false)
         }
     }
    
}


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for index in 0 ..< count {
            if let result = self[index] as? T {
                array.append(result)
            }
        }
        return array
    }
}



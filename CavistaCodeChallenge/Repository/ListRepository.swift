//
//  ListRepository.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import RxSwift
import RealmSwift

class ListRepository: NSObject {
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private lazy var fetchDataSubject = PublishSubject<Any>()
    var fetchDataObservable: Observable<Any> {
        return fetchDataSubject.asObservable()
    }
    private var notificationToken: NotificationToken?
    lazy private var listService = ListService()
    
    // MARK: Get project detail
    func setServiceRequestToGetList() {
        fetchDataFromRealm()
        listService.getList().subscribe(onSuccess: {[weak self] (list) in
            let filteredList = self?.filterNonEmptyData(list)
            let realm = try? Realm()
            try? realm?.write {
                realm?.add(filteredList ?? [], update: Realm.UpdatePolicy.all)
            }
        }) { (error) in
            print(error)
        }.disposed(by: self.disposeBag)
    }
    
    // filter empty data and date
    private func filterNonEmptyData(_ list: [ListJsonBO]) -> [ListJsonBO] {
        return list.filter{(($0.data != nil) && ($0.date != nil))}
    }
    
    //Fetch data from realm
    private func fetchDataFromRealm() {
        guard let realm = try? Realm(), !realm.isInWriteTransaction else {
            return
        }
        let list = realm.objects(ListJsonBO.self)
        
        notificationToken =  list.observe { [weak self] (changes) in
            self?.fetchDataSubject.onNext(changes)
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

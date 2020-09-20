//
//  ListViewModel.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

class ListViewModel: NSObject {
    //MARK:- Properties
    private let disposeBag = DisposeBag()
    private var sections = BehaviorRelay<[SectionOfDocumentData<ListJsonBO>]>(value: [])
    var jsonListObservable: Observable<[SectionOfDocumentData<ListJsonBO>]> {
        return sections.asObservable()
    }
    private lazy var listRepository = ListRepository()
    
    //MARK:- Override Method
    override init() {
        super.init()
        listRealmObserver()
    }
    
    //MARK:- Custom Methods
    private func sortByType(_ listJson: [ListJsonBO]) -> [SectionOfDocumentData<ListJsonBO>] {
        let sortByType = listJson.categorise{ $0[DictionaryKeys.type] as? String }
        var sections: [SectionOfDocumentData<ListJsonBO>] = []
        for item in sortByType {
            print(item)
            let section = SectionOfDocumentData(header: item.key ?? String.emptyString, items: item.value )
            sections.append(section)
        }
        return sections
    }
    
    func getListData() {
        listRepository.setServiceRequestToGetList()
    }
    
    //Get selected admin
    func getSelectedListItem(_ indexPath: IndexPath) -> ListJsonBO {
        return sections.value[indexPath.section].items[indexPath.row]
    }
    
    //MARK:- Observers
    private func listRealmObserver() {
        listRepository.fetchDataObservable.subscribe(onNext: { [weak self] (realmObject) in
            guard let self = self else {return}
            if let changes = realmObject as? RealmCollectionChange<Results<ListJsonBO>> {
                switch changes {
                case .initial(let properties):
                    let listJsonBO = Array(properties)
                    self.sections.accept(self.sortByType(listJsonBO))
                case .update(let properties, deletions: _, insertions: _, modifications: _):
                    let listJsonBO = Array(properties)
                    self.sections.accept(self.sortByType(listJsonBO))
                case .error(let error):
                    print(error)
                }
            }
            }, onError: { (error) in
                print(error)
        }).disposed(by: disposeBag)
    }
}

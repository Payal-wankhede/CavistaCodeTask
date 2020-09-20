//
//  ViewController.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class ListViewController: UIViewController {
    //MARK:- Properties
    private var internetStatusLabel = UILabel()
    private var listTableView = UITableView()
    private lazy var listViewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK:- Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    //MARK:- Customs Methods
    private func initializeView() {
        initialiseTableviewCell()
        makeListUI()
        configureData()
    }
    
    private func makeListUI() {
        // Adding Subviews
        self.view.addSubview(listTableView)
        
        //ListTableView Constraints
        listTableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        listTableView.backgroundColor = .white
    }
    
    //Initialise tableview cell
    private func initialiseTableviewCell() {
        self.listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.defaultReuseIdentifier)
    }
    
    private func configureData() {
        //Fetch data from api
        listViewModel.getListData()
        
        //Set datasource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfDocumentData<ListJsonBO>>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let strongSelf = self else { return UITableViewCell() }
                let cell: ListTableViewCell = strongSelf.listTableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.setCellData(item)
                return cell
                // Section Title
            }, titleForHeaderInSection: { dataSource, index in
                let sectionModel = dataSource.sectionModels[index]
                return "\(sectionModel.header)"
        })
        
        //bind data into tableview with their observer
        listViewModel.jsonListObservable.bind(to: listTableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // Item Selected
        listTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            if let listJson = self?.listViewModel.getSelectedListItem(indexPath) {
                self?.navigationController?.navigateToDetailView(listBO: listJson)
            }
        }).disposed(by: disposeBag)
    }
}

//
//  DetailViewController.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    //MARK:- Properties
    private var detailTextView = UILabel()
    private var dateLabel = UILabel()
    private var listImageView = UIImageView()
    var listDetailBO: ListJsonBO?
    private let dateText = "Date: "
    
    //MARK:- Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDetailUI()
    }
    
    //MARK:- Custom Method
    private func makeDetailUI() {
        self.view.backgroundColor = .white
        view.addSubview(detailTextView)
        view.addSubview(dateLabel)
        view.addSubview(listImageView)
        
        // listImageView constraints
        listImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.height.equalTo(view).multipliedBy(0.5)
        }
        
        //descriptionLabel Constraints
        detailTextView.snp.makeConstraints { (maker) in
            maker.leading.equalTo(listImageView.snp.leading)
            maker.trailing.equalTo(listImageView.snp.trailing)
            if listDetailBO?.type == DictionaryKeys.image {
                maker.top.equalTo(listImageView.snp.bottom).offset(15)
            } else {
                maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            }
        }
        
        //descriptionLabel Constraints
        dateLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(detailTextView.snp.leading)
            maker.trailing.equalTo(detailTextView.snp.trailing)
            maker.top.equalTo(detailTextView.snp.bottom).offset(15)
        }
        
        setData()
    }
    
    private func setData() {
        //Set Image
        if listDetailBO?.type == DictionaryKeys.image {
            listImageView.contentMode = .scaleAspectFit
            let _ = listImageView.downloadImage(from:  listDetailBO?.data ?? String.emptyString)
            detailTextView.isHidden = true
        } else {
            detailTextView.text = listDetailBO?.data
        }
        detailTextView.numberOfLines = 0
        detailTextView.textColor = .black
        detailTextView.textAlignment = .justified
        dateLabel.textAlignment = .center
        //set date
        dateLabel.text = dateText + (listDetailBO?.date ?? String.emptyString)
    }
}

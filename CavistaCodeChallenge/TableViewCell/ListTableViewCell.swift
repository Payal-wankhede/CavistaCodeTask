//
//  ListTableViewCell.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/20/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    //MARK:- Properties
    private var titleTextLabel = UILabel()
    private var descriptionTextLabel =  UILabel()
    private var listImageView = UIImageView()
    private var imageDownloadTask: URLSessionDataTask?
    
    //MARK:- Override Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleTextLabel.text = String.emptyString
        descriptionTextLabel.text = String.emptyString
        imageDownloadTask?.cancel()
        imageDownloadTask = nil
        listImageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Custom Methods
    //MARK:- Configure UI
    private func configure() {
        self.contentView.addSubview(titleTextLabel)
        self.contentView.addSubview(descriptionTextLabel)
        self.contentView.addSubview(listImageView)
        //List Imageview
        listImageView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(10)
            maker.top.equalToSuperview().offset(8)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
            maker.bottom.equalTo(-10)
        }
        // Title text label
        titleTextLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(listImageView.snp.top)
        }
        // Description text label
        descriptionTextLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(titleTextLabel.snp.leading)
            maker.trailing.equalTo(titleTextLabel.snp.trailing)
            maker.top.equalTo(titleTextLabel.snp.bottom).offset(10)
        }
    }
    
    //MARK:- Set Data
    func setCellData(_ listJson: ListJsonBO) {
        if listJson.type == DictionaryKeys.image {
            listImageView.contentMode = .scaleAspectFit
            if imageDownloadTask == nil {
                imageDownloadTask = listImageView.downloadImage(from: listJson.data ?? String.emptyString )
            }
            // Remake constraint as per type
            self.titleTextLabel.snp.remakeConstraints { (maker) in
                maker.trailing.equalToSuperview().offset(-8)
                maker.leading.equalTo(listImageView.snp.trailing).offset(10)
            }
            titleTextLabel.text = listJson.date
        } else {
            self.titleTextLabel.snp.remakeConstraints { (maker) in
                maker.trailing.equalToSuperview().offset(-8)
                maker.leading.equalToSuperview().offset(10)
            }
            titleTextLabel.text = listJson.data
            descriptionTextLabel.text = listJson.date
        }
    }
}

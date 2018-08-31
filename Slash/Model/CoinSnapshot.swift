//
//  CoinSnapshot.swift
//  Slash
//
//  Created by Michael Lema on 8/30/18.
//  Copyright © 2018 Michael Lema. All rights reserved.
//

import Foundation

struct Stats: Codable {
    let response, message: String
    let data: DataClass
    let type: Int
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case message = "Message"
        case data = "Data"
        case type = "Type"
    }
}

struct DataClass: Codable {
    let seo: SEO
    let general: General
    let ico: Ico
    let subs, streamerDataRaw: [String]
    
    enum CodingKeys: String, CodingKey {
        case seo = "SEO"
        case general = "General"
        case ico = "ICO"
        case subs = "Subs"
        case streamerDataRaw = "StreamerDataRaw"
    }
}

struct General: Codable {
    let id, documentType, h1Text, dangerTop: String
    let warningTop, infoTop, symbol, url: String
    let baseAngularURL, name, imageURL, description: String
    let features, technology, totalCoinSupply, difficultyAdjustment: String
    let blockRewardReduction, algorithm, proofType, startDate: String
    let twitter, websiteURL, website: String
    let lastBlockExplorerUpdateTS, blockNumber, blockTime: Int
    let netHashesPerSecond, totalCoinsMined: Double
    let previousTotalCoinsMined: Int
    let blockReward: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case documentType = "DocumentType"
        case h1Text = "H1Text"
        case dangerTop = "DangerTop"
        case warningTop = "WarningTop"
        case infoTop = "InfoTop"
        case symbol = "Symbol"
        case url = "Url"
        case baseAngularURL = "BaseAngularUrl"
        case name = "Name"
        case imageURL = "ImageUrl"
        case description = "Description"
        case features = "Features"
        case technology = "Technology"
        case totalCoinSupply = "TotalCoinSupply"
        case difficultyAdjustment = "DifficultyAdjustment"
        case blockRewardReduction = "BlockRewardReduction"
        case algorithm = "Algorithm"
        case proofType = "ProofType"
        case startDate = "StartDate"
        case twitter = "Twitter"
        case websiteURL = "WebsiteUrl"
        case website = "Website"
        case lastBlockExplorerUpdateTS = "LastBlockExplorerUpdateTS"
        case blockNumber = "BlockNumber"
        case blockTime = "BlockTime"
        case netHashesPerSecond = "NetHashesPerSecond"
        case totalCoinsMined = "TotalCoinsMined"
        case previousTotalCoinsMined = "PreviousTotalCoinsMined"
        case blockReward = "BlockReward"
    }
}

struct Ico: Codable {
    let status, whitePaper: String
    
    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case whitePaper = "WhitePaper"
    }
}

struct SEO: Codable {
    let pageTitle, pageDescription, baseURL, baseImageURL: String
    let ogImageURL, ogImageWidth, ogImageHeight: String
    
    enum CodingKeys: String, CodingKey {
        case pageTitle = "PageTitle"
        case pageDescription = "PageDescription"
        case baseURL = "BaseUrl"
        case baseImageURL = "BaseImageUrl"
        case ogImageURL = "OgImageUrl"
        case ogImageWidth = "OgImageWidth"
        case ogImageHeight = "OgImageHeight"
    }
}

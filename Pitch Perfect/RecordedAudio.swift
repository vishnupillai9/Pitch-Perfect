//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Vishnu on 18/01/15.
//  Copyright (c) 2015 Demons. All rights reserved.
//

import Foundation

class RecordedAudio {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
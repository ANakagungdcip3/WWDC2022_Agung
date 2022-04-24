//
//  File.swift
//  WWDCVer2Agung
//
//  Created by Anak Agung Gede Agung Davin on 22/04/22.
//

import Foundation
import UIKit
import RealityKit
import Combine

class ArModel{
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    var descImage1: String?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String, descImage1: String){
        self.modelName = modelName
        self.descImage1 = descImage1
        self.image = UIImage(named: modelName)!
        let fileName = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName).sink(receiveCompletion: {loadCompletion in
            print("Debug cant load model entity \(self.modelName)")
        }, receiveValue: {modelEntity in
            self.modelEntity = modelEntity
            print("Success load modelentity \(self.modelName)")
        })
    }
}

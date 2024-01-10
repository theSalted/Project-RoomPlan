//
//  SpaceObject.swift
//  ScanSpace
//
//  Created by Yuhao Chen on 1/11/24.
//

import RoomPlan
import SceneKit

class SpaceObject : Identifiable {
    private var _name : String
    var name : String {
        get { _name }
        set { 
            sceneNode?.name = newValue
            _name = newValue
        }
    }
    var id : UUID {
        roomPlanObject?.identifier ?? UUID()
    }
    var roomPlanObject : CapturedRoom.Object?
    var sceneNode : SCNNode?
    var category : CapturedRoom.Object.Category? {
        roomPlanObject?.category
    }
    
    init(name : String) {
        self._name = name
    }
    
    init(roomPlanObject : CapturedRoom.Object) {
        self.roomPlanObject = roomPlanObject
        self._name = roomPlanObject.category.getName()
    }
    
    init(roomPlanObject : CapturedRoom.Object, sceneNode : SCNNode) {
        self._name = sceneNode.name ?? roomPlanObject.category.getName()
        sceneNode.name = self._name
        self.roomPlanObject = roomPlanObject
        self.sceneNode = sceneNode
    }
}

extension CapturedRoom.Object.Category  {
    func getName() -> String {
        switch self {
        case .storage:
            return "Storage"
        case .refrigerator:
            return "Refrigerator"
        case .stove:
            return "Stove"
        case .bed:
            return "Bed"
        case .sink:
            return "Sink"
        case .washerDryer:
            return "Dryer/Washer"
        case .toilet:
            return "Toilet"
        case .bathtub:
            return "Bathtub"
        case .oven:
            return "Oven"
        case .dishwasher:
            return "Dishwasher"
        case .table:
            return "Table"
        case .sofa:
            return "Sofa"
        case .chair:
            return "Chair"
        case .fireplace:
            return "Fire Place"
        case .television:
            return "Television"
        case .stairs:
            return "Stairs"
        @unknown default:
            return "Unknown Object"
        }
    }
}

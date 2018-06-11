//
//  KoniecGryScene.swift
//  Space Invaders
//
//  Created by Kamil Kamilowski on 11/06/2018.
//  Copyright © 2018 Kamil Kamilowski. All rights reserved.
//

import Foundation
import SpriteKit

class KoniecGryScena: SKScene {
    override func didMoveToView(view: SKView) {
        let tlo = SKSpriteNode(imageNamed: "background")
        tlo.position = CGPoint(x:self.size.width/2, y: self.size.height/2)
        tlo.zPosition = 0
        self.addChild(tlo)
        
        let tloLabelka = SKLabelNode(fontNamed: "The Bold Font")
        tloLabelka.text = "Koniec gry"
        tloLabelka.fontSize = 200
        tloLabelka.fontColor = SKColor.whiteColor()
        tloLabelka.position = CGPoint(x:self.size.width * 0.5, y: self.size.height * 0.7)
        self.addChild(tloLabelka)
        
        let wynikLabelka = SKLabelNode(fontNamed: "The Bold Font")
        wynikLabelka.text = "Wynik: \(wynik)"
        wynikLabelka.fontSize = 125
        wynikLabelka.fontColor = SKColor.whiteColor()
        wynikLabelka.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        wynikLabelka.zPosition = 1
        self.addChild(wynikLabelka)
        
        let defaults = NSUserDefaults()
        var najwyzszyWynik = defaults.integerForKey("wynikZapis")
        
        if wynik > najwyzszyWynik {
            najwyzszyWynik = wynik
            defaults.setInteger(najwyzszyWynik, forKey: "wynikZapis")
        }
        
        let najwyzszyWynikLabelka = SKLabelNode(fontNamed: "The Bold Font")
        najwyzszyWynikLabelka.text = "Najwyzszy Wynik: \(najwyzszyWynik)"
        najwyzszyWynikLabelka.fontSize = 125
        najwyzszyWynikLabelka.fontColor = SKColor.whiteColor()
        najwyzszyWynikLabelka.zPosition = 1
        najwyzszyWynikLabelka.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        self.addChild(najwyzszyWynikLabelka)
        
        let restartLabelki = SKLabelNode(fontNamed: "The Bold Font")
        restartLabelki.text = "Restart"
        restartLabelki.fontSize = 90
        restartLabelki.fontColor = SKColor.whiteColor()
        restartLabelki.zPosition = 1
        restartLabelki.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        self.addChild(restartLabelki)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for dotyk: AnyObject in touches {
            let scenaDoZmiany = GameScene(size:self.size)
            let przejscie = SKTransition.fadeWithDuration(0.5)
            self.view!.presentScene(scenaDoZmiany, transition: przejscie)
            
        }
    }
}
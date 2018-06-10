//
//  GameScene.swift
//  Space Invaders
//
//  Created by Kamil Kamilowski on 09/06/2018.
//  Copyright (c) 2018 Kamil Kamilowski. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var wynik = 0
    let wynikCzcionka = SKLabelNode(fontNamed: "The Bold Font")
    let gracz = SKSpriteNode(imageNamed: "Spaceship")
    
    var liczbaZyc = 3
    let zyciaCzcionka = SKLabelNode(fontNamed: "The Bold Font")
    
    var jakiPoziom = 0;
    
    let dzwiekPocisku = SKAction.playSoundFileNamed("Laser Blaster-SoundBible.com-1388608841.mp3", waitForCompletion: false)
    
    let dzwiekEksplozji = SKAction.playSoundFileNamed("Bomb Explosion 1-SoundBible.com-980698079.wav", waitForCompletion: false)
    struct PhysicsCategories {
        static let Nic: UInt32 = 0
        static let Gracz: UInt32 = 0b1 //1
        static let Pocisk: UInt32 = 0b10 // 2
        static let Przeciwnik: UInt32 = 0b100 // 4
    }
    
    func losowe() ->CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func losowe(min min:CGFloat, max:CGFloat) -> CGFloat {
        return losowe() * (max - min) + min
    }
    
    var plansza: CGRect
    
    override init(size:CGSize) {
        let wspolczynnikProporcji: CGFloat = 16.0/9.0
        let szerokosc = size.height / wspolczynnikProporcji
        let margines = (size.width - szerokosc) / 2
        plansza = CGRect(x: margines, y: 0, width: szerokosc, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) { // po odpaleniu apki  ta metoda od razu sie wykonuje
        self.physicsWorld.contactDelegate = self
        let tlo = SKSpriteNode(imageNamed: "background")
        tlo.size = self.size
        tlo.position = CGPoint(x: self.size.width/2, y: self.size.height/2) // pokrywamy caly ekran tlem
        tlo.zPosition = 0
        self.addChild(tlo) // dodajemy
        
        
        gracz.setScale(1) // ustawiamy wielkosc statku
        gracz.position = CGPoint(x: self.size.width/2, y:self.size.height * 0.2)
        gracz.zPosition = 2 // statek nad tlem
        gracz.physicsBody = SKPhysicsBody(rectangleOfSize: gracz.size)
        gracz.physicsBody!.affectedByGravity = false
        gracz.physicsBody!.categoryBitMask = PhysicsCategories.Gracz
        gracz.physicsBody!.collisionBitMask = PhysicsCategories.Nic
        gracz.physicsBody!.contactTestBitMask = PhysicsCategories.Przeciwnik
        
        self.addChild(gracz) // dodajemy
        wynikCzcionka.text = "Wynik: 0"
        wynikCzcionka.fontSize = 70
        wynikCzcionka.fontColor = SKColor.whiteColor()
        wynikCzcionka.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        wynikCzcionka.position = CGPoint(x: self.size.width*0.15, y: self.size.height*0.9)
        wynikCzcionka.zPosition = 100
        self.addChild(wynikCzcionka)
        
        zyciaCzcionka.text = "Zycia: 3"
        zyciaCzcionka.fontSize = 70
        zyciaCzcionka.fontColor = SKColor.whiteColor()
        zyciaCzcionka.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        zyciaCzcionka.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.9)
        zyciaCzcionka.zPosition = 100
        self.addChild(zyciaCzcionka)
        
        stworzNowyPoziom()
    }
    
    func stracZycie() {
        liczbaZyc -= 1
        zyciaCzcionka.text = "Zycia: \(liczbaZyc)"
        
        let skalaGorna = SKAction.scaleTo(1.5, duration: 0.2)
        let skalaDolna = SKAction.scaleTo(1, duration: 0.2)
        let skalaSekwencja = SKAction.sequence([skalaGorna, skalaDolna])
        zyciaCzcionka.runAction(skalaSekwencja)
        
    }
    
    func dodajWynik() {
        wynik += 1
        wynikCzcionka.text = "Wynik: \(wynik)"
        if wynik == 10 || wynik == 25 || wynik == 50 {
            stworzNowyPoziom()
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var cialo1 = SKPhysicsBody()
        var cialo2 = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            cialo1 = contact.bodyA
            cialo2 = contact.bodyB
        } else {
            cialo1 = contact.bodyB
            cialo2 = contact.bodyA
        }
        
        if cialo1.categoryBitMask == PhysicsCategories.Gracz && cialo2.categoryBitMask == PhysicsCategories.Przeciwnik {
            if (cialo1.node != nil) {
            stworzEksplozje(cialo1.node!.position)
            }
            if (cialo2.node != nil) {
            stworzEksplozje(cialo2.node!.position)
            }
            cialo1.node?.removeFromParent()
            cialo2.node?.removeFromParent()
        }
        
        if cialo1.categoryBitMask == PhysicsCategories.Pocisk && cialo2.categoryBitMask == PhysicsCategories.Przeciwnik && cialo2.node?.position.y < self.size.height {
            
            dodajWynik()
            if cialo2.node != nil {
            stworzEksplozje(cialo2.node!.position)
            }
            cialo1.node?.removeFromParent()
            cialo2.node?.removeFromParent()
        }
        
        
    }
    
    func stworzEksplozje(pozycja: CGPoint) {
        let eksplozja = SKSpriteNode(imageNamed: "explosition")
        eksplozja.position = pozycja
        eksplozja.zPosition = 3
        eksplozja.setScale(0)
        self.addChild(eksplozja)
        
        let skala = SKAction.scaleTo(1, duration: 0.1)
        let wygasnij = SKAction.fadeOutWithDuration(0.1)
        let usun = SKAction.removeFromParent()
        
        let eksplozjaSekwencja = SKAction.sequence([dzwiekEksplozji, skala, wygasnij, usun])
        eksplozja.runAction(eksplozjaSekwencja)
        
    }
    
    
    func stworzNowyPoziom() {
        jakiPoziom += 1
        
        if self.actionForKey("tworzeniePrzeciwnikow") != nil {
            self.removeActionForKey("tworzeniePrzeciwnikow")
        }
        
        var poziomCzas = NSTimeInterval()
        
        switch jakiPoziom {
        case 1: poziomCzas = 1.2
        case 2: poziomCzas = 1
        case 3: poziomCzas = 0.8
        case 4: poziomCzas = 0.5
        default:
            poziomCzas = 0.5
        }
        
        let stworz = SKAction.runBlock(stworzPrzeciwnika)
        let czekajNaPrzeciwnika = SKAction.waitForDuration(poziomCzas)
        let stworzSekwencja = SKAction.sequence([czekajNaPrzeciwnika, stworz])
        let stworzNaZawsze = SKAction.repeatActionForever(stworzSekwencja)
        self.runAction(stworzNaZawsze, withKey: "tworzeniePrzeciwnikow")
        
    }
    
    func wystrzelPocisk() {
        
        let pocisk = SKSpriteNode(imageNamed: "bullet")
        pocisk.setScale(1)
        pocisk.position = gracz.position
        pocisk.zPosition = 1
        pocisk.physicsBody = SKPhysicsBody(rectangleOfSize: pocisk.size)
        pocisk.physicsBody!.affectedByGravity = false
        pocisk.physicsBody!.categoryBitMask = PhysicsCategories.Pocisk
        pocisk.physicsBody!.collisionBitMask = PhysicsCategories.Nic
        pocisk.physicsBody!.contactTestBitMask = PhysicsCategories.Przeciwnik
        self.addChild(pocisk)
        
        let ruszPocisk = SKAction.moveToY(self.size.height + pocisk.size.height, duration: 1)
        let usunPocisk = SKAction.removeFromParent()
        let pociskSekwencje = SKAction.sequence([dzwiekPocisku, ruszPocisk, usunPocisk])
        pocisk.runAction(pociskSekwencje)
        
    }
    
    func stworzPrzeciwnika() {
        let losowyXStart = losowe(min: CGRectGetMinX(plansza), max: CGRectGetMaxX(plansza))
        let losowyXKoniec = losowe(min:CGRectGetMinX(plansza), max: CGRectGetMaxX(plansza))
        
        let punktStartowy = CGPoint(x: losowyXStart, y: self.size.height * 1.2)
        let punktKoncowy = CGPoint(x: losowyXKoniec, y: -self.size.height * 0.2)
        
        let przeciwnik = SKSpriteNode(imageNamed: "enemyShip")
        przeciwnik.setScale(1)
        przeciwnik.position = punktStartowy
        przeciwnik.zPosition = 2
        przeciwnik.physicsBody = SKPhysicsBody(rectangleOfSize: przeciwnik.size)
        przeciwnik.physicsBody!.affectedByGravity = false
        przeciwnik.physicsBody!.categoryBitMask = PhysicsCategories.Przeciwnik
        przeciwnik.physicsBody!.collisionBitMask = PhysicsCategories.Nic
        przeciwnik.physicsBody!.contactTestBitMask = PhysicsCategories.Gracz | PhysicsCategories.Pocisk
        self.addChild(przeciwnik)
        
        let ruszPrzeciwnika = SKAction.moveTo(punktKoncowy, duration: 1.5)
        let usunPrzeciwnika = SKAction.removeFromParent()
        let stracZycieAkcja = SKAction.runBlock(stracZycie)
        
        let przeciwnikSekwencja = SKAction.sequence([ruszPrzeciwnika, usunPrzeciwnika, stracZycieAkcja])
        przeciwnik.runAction(przeciwnikSekwencja)
        
        let dx = punktKoncowy.x - punktStartowy.x
        let dy = punktKoncowy.y - punktStartowy.y
        let ileDoObrocenia = atan2(dy, dx)
        przeciwnik.zRotation = ileDoObrocenia
        
    }
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        wystrzelPocisk()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for dotkniecie: AnyObject in touches {
            let punktDotkniecia = dotkniecie.locationInNode(self)
            let poprzedniPunktDotkniecia = dotkniecie.previousLocationInNode(self)
            let ilePrzesunieto = punktDotkniecia.x - poprzedniPunktDotkniecia.x
            gracz.position.x += ilePrzesunieto
            
            if gracz.position.x > CGRectGetMaxX(plansza) - gracz.size.width/2 {
                gracz.position.x = CGRectGetMaxX(plansza) - gracz.size.width/2
            }
            
            if gracz.position.x < CGRectGetMinX(plansza) + gracz.size.width/2 {
                gracz.position.x = CGRectGetMinX(plansza) + gracz.size.width/2
            }
            
            
        }
    }

}

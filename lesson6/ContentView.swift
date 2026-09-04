//
//  ContentView.swift
//  lesson6
//
//  Created by Kakarla Hemanth Reddy on 31/8/26.
//
// abel was here
// elijah edited some stuff
import SwiftUI
import Combine

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var vx: CGFloat = 0.0
    var vy: CGFloat = 0.0
    var size: CGFloat = 6.0
    var color: Color
    var alpha: Double = 1.0
}

struct Ball: Identifiable {
    let id = UUID()
    var position: CGPoint
    var vx: CGFloat = 0.0
    var vy: CGFloat = 0.0
}

struct Goose: Identifiable {
    let id = UUID()
    var position = CGPoint(x: 150, y: 350)
    var target = CGPoint(x: 150, y: 350)
    var vx: CGFloat = 0.0
    var vy: CGFloat = 0.0
    var bounce: CGFloat = 0.0
    var driftX: CGFloat = 0.0
    var cooldown = 0
    var nextDecision = 0
    var isFacingRight = false
    var isFighting = false
    var isLeader = false
    var color = Color(red: .random(in: 0.2...0.9), green: .random(in: 0.2...0.9), blue: .random(in: 0.2...0.9))
}

struct ContentView: View {
    @State private var geese = [Goose()]
    @State private var balls = [Ball(position: CGPoint(x: 100, y: 400)), Ball(position: CGPoint(x: 260, y: 450))]
    @State private var particles: [Particle] = []
    @State private var tick = 0
    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.green.opacity(0.3).ignoresSafeArea()
            
            // The Blue Pond
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.blue.opacity(0.4))
                .frame(width: 280, height: 110)
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.blue.opacity(0.6), lineWidth: 3))
                .position(x: 190, y: 180)
            
            VStack {
                HStack {
                    Button("➕ Add Square Goose") {
                        if geese.count < 5 {
                            geese.append(Goose(position: CGPoint(x: .random(in: 50...300), y: .random(in: 250...600))))
                        }
                    }
                    .font(.headline).padding().background(geese.count >= 5 ? Color.gray : Color.blue).foregroundColor(.white).cornerRadius(12).disabled(geese.count >= 5)
                    Spacer()
                }.padding()
                Spacer()
            }
            
            ForEach(particles) { p in
                Rectangle().fill(p.color).frame(width: p.size, height: p.size).opacity(p.alpha).position(p.position)
            }
            
            ForEach(balls) { b in
                Circle().fill(Color.orange).frame(width: 100, height: 100).shadow(radius: 4).position(b.position)
            }
            
            ForEach(geese.indices, id: \.self) { i in
                ZStack {
                    RoundedRectangle(cornerRadius: 15).fill(geese[i].color).frame(width: 75, height: 75).shadow(radius: 3)
                    Text(geese[i].isFighting ? (geese[i].isFacingRight ? "(  ◣◊◢ )" : "( ◣◊◢  )") : (geese[i].isFacingRight ? "( •⊖•)" : "(•⊖• )")).font(.system(size: geese[i].isFighting ? 16 : 20, weight: .bold)).foregroundColor(.white)
                }
                .offset(x: geese[i].driftX, y: geese[i].bounce).position(geese[i].position)
                .gesture(DragGesture().onChanged { v in
                    geese[i].position = v.location
                    geese[i].target = v.location
                    geese[i].vx = 0; geese[i].vy = 0; geese[i].isFighting = false; geese[i].cooldown = 60
                })
            }
        }.onReceive(timer) { _ in runGameLoop() }
    }
    
    func runGameLoop() {
        tick += 1
        
        // 1. Move the Orange Balls
        for idx in balls.indices {
            balls[idx].position.x += balls[idx].vx
            balls[idx].position.y += balls[idx].vy
            balls[idx].vx *= 0.92; balls[idx].vy *= 0.92
            balls[idx].position.x = max(55, min(320, balls[idx].position.x))
            balls[idx].position.y = max(150, min(650, balls[idx].position.y))
        }
        
        // 2. Move and Fade out Splash Particles
        for idx in particles.indices.reversed() {
            particles[idx].position.x += particles[idx].vx
            particles[idx].position.y += particles[idx].vy
            particles[idx].alpha -= 0.04
            if particles[idx].alpha <= 0 { particles.remove(at: idx) }
        }
        
        // 3. Lower Cooldown Timers
        for i in geese.indices where geese[i].cooldown > 0 { geese[i].cooldown -= 1 }
        
        // 4. Check for New Fights (Only 1 Fight Allowed Globally)
        if geese.filter({ $0.isFighting }).count == 0 {
            var fightStarted = false
            for i in geese.indices where geese[i].cooldown == 0 && !fightStarted {
                for j in geese.indices where i != j && geese[j].cooldown == 0 {
                    if hypot(geese[i].position.x - geese[j].position.x, geese[i].position.y - geese[j].position.y) < 85 && Double.random(in: 0...1) < 0.25 {
                        geese[i].isFighting = true; geese[j].isFighting = true
                        geese[i].isLeader = true; geese[j].isLeader = false
                        geese[i].cooldown = 140; geese[j].cooldown = 140
                        geese[i].vx = 0; geese[i].vy = 0; geese[j].vx = 0; geese[j].vy = 0
                        geese[i].isFacingRight = geese[j].position.x > geese[i].position.x
                        geese[j].isFacingRight = geese[i].position.x > geese[j].position.x
                        
                        let mx = (geese[i].position.x + geese[j].position.x) / 2
                        let my = (geese[i].position.y + geese[j].position.y) / 2
                        geese[i].position = CGPoint(x: mx + (geese[i].isFacingRight ? -40 : 40), y: my)
                        geese[j].position = CGPoint(x: mx + (geese[j].isFacingRight ? -40 : 40), y: my)
                        fightStarted = true; break
                    }
                }
            }
        }
        
        // 5. Update Geese Actions and Behaviors
        for i in geese.indices {
            if geese[i].isFighting {
                let currentTick = geese[i].isLeader ? tick : tick + 6
                geese[i].bounce = (currentTick / 6) % 2 == 0 ? -25 : 0
                geese[i].driftX = cos(Double(tick) * 0.3) * 6 * (geese[i].isFacingRight ? 1.0 : -1.0)
                
                if tick % 8 == 0 {
                    particles.append(Particle(position: geese[i].position, vx: .random(in: -4...4), vy: .random(in: -6...2), size: .random(in: 4...8), color: geese[i].color))
                }
                
                if geese[i].cooldown <= 40 {
                    geese[i].isFighting = false; geese[i].bounce = 0; geese[i].driftX = 0
                    geese[i].position.x = max(40, min(320, geese[i].position.x + (geese[i].isFacingRight ? -70 : 70)))
                    geese[i].target = geese[i].position
                }
            } else {
                geese[i].bounce = 0; geese[i].driftX = 0
                
                if tick >= geese[i].nextDecision, let cb = balls.randomElement() {
                    let choose = Double.random(in: 0...1)
                    if choose < 0.4 { geese[i].target = cb.position }
                    else if choose < 0.7 { geese[i].target = CGPoint(x: .random(in: 80...300), y: .random(in: 150...210)) }
                    else { geese[i].target = CGPoint(x: .random(in: 50...300), y: .random(in: 250...600)) }
                    geese[i].nextDecision = tick + Int.random(in: 40...100)
                }
                
                let dx = geese[i].target.x - geese[i].position.x
                let dy = geese[i].target.y - geese[i].position.y
                let d = hypot(dx, dy)
                
                if d > 10 {
                    geese[i].vx += ((dx / d) * 3.0 - geese[i].vx) * 0.1
                    geese[i].vy += ((dy / d) * 3.0 - geese[i].vy) * 0.1
                    geese[i].isFacingRight = geese[i].vx > 0.2
                } else {
                    geese[i].vx *= 0.8; geese[i].vy *= 0.8
                }
                
                geese[i].position.x += geese[i].vx
                geese[i].position.y += geese[i].vy
                geese[i].position.x = max(40, min(320, geese[i].position.x))
                geese[i].position.y = max(120, min(680, geese[i].position.y))
                
                // Giant Splash Engine
                if geese[i].position.x >= 50 && geese[i].position.x <= 330 && geese[i].position.y >= 125 && geese[i].position.y <= 235 {
                    if abs(geese[i].vx) > 0.5 || abs(geese[i].vy) > 0.5 {
                        for _ in 0..<5 {
                            particles.append(Particle(
                                position: CGPoint(x: geese[i].position.x + .random(in: -25...25), y: geese[i].position.y + 25),
                                vx: .random(in: -4...4),
                                vy: .random(in: (-8)...(-2)),
                                size: .random(in: 3...12),
                                color: Color.blue.opacity(.random(in: 0.4...0.8))
                            ))
                        }
                    }
                }
                
                for b in balls.indices where hypot(geese[i].position.x - balls[b].position.x, geese[i].position.y - balls[b].position.y) < 85 {
                    balls[b].vx = geese[i].isFacingRight ? 18.0 : -18.0
                    balls[b].vy = .random(in: -7...7)
                    geese[i].target = geese[i].position
                }
            }
        }
    }
}

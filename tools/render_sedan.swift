// Rebuild with: xcrun swift tools/render_sedan.swift assets/sedan_sprites
// Original Meshwar sedan: one real mesh rendered at every heading.
import AppKit
import SceneKit
import Metal

let destination = CommandLine.arguments.dropFirst().first ?? "assets/sedan_sprites"
try FileManager.default.createDirectory(atPath: destination, withIntermediateDirectories: true)
let scene = SCNScene()
scene.background.contents = NSColor.clear
let car = SCNNode()
scene.rootNode.addChildNode(car)

func material(_ color: NSColor, metal: CGFloat = 0, roughness: CGFloat = 0.5) -> SCNMaterial {
    let m = SCNMaterial()
    m.diffuse.contents = color
    m.lightingModel = .physicallyBased
    m.metalness.contents = metal
    m.roughness.contents = roughness
    return m
}
let pearl = material(NSColor(calibratedWhite: 0.95, alpha: 1), metal: 0.22, roughness: 0.3)
let glass = material(NSColor(calibratedRed: 0.08, green: 0.15, blue: 0.23, alpha: 1), metal: 0.3, roughness: 0.18)
let rubber = material(NSColor(calibratedWhite: 0.045, alpha: 1), roughness: 0.95)
let silver = material(NSColor(calibratedWhite: 0.64, alpha: 1), metal: 0.7, roughness: 0.3)
let dark = material(NSColor(calibratedWhite: 0.12, alpha: 1))
let red = material(NSColor(calibratedRed: 0.9, green: 0.015, blue: 0.16, alpha: 1))
let headlight = material(NSColor(calibratedRed: 0.85, green: 0.94, blue: 1, alpha: 1))

func box(_ size: SCNVector3, _ at: SCNVector3, _ m: SCNMaterial, radius: CGFloat = 0.06) -> SCNNode {
    let shape = SCNBox(width: CGFloat(size.x), height: CGFloat(size.y), length: CGFloat(size.z), chamferRadius: radius)
    shape.chamferSegmentCount = 5
    shape.materials = [m]
    let node = SCNNode(geometry: shape)
    node.position = at
    car.addChildNode(node)
    return node
}

// Loft rounded cross-sections for the bonnet, belt line and rear deck.
// Each ring: longitudinal position, half width, bottom and top height.
func loft(_ rings: [(Float, Float, Float, Float)], _ m: SCNMaterial) -> SCNNode {
    let count = 24
    var vertices: [SCNVector3] = []
    for (z, halfWidth, bottom, top) in rings {
        for i in 0..<count {
            let a = Float(i) * 2 * .pi / Float(count)
            // A rounded rectangle, rather than an oval body.
            let c = cos(a), s = sin(a)
            let x = halfWidth * copysign(pow(abs(c), 0.35), c)
            let y = (bottom + top) / 2 + (top - bottom) / 2 * copysign(pow(abs(s), 0.35), s)
            vertices.append(SCNVector3(x, y, z))
        }
    }
    var indices: [Int32] = []
    for r in 0..<(rings.count - 1) {
        for i in 0..<count {
            let a = Int32(r * count + i), b = Int32(r * count + (i + 1) % count)
            let c = a + Int32(count), d = b + Int32(count)
            indices += [a, b, c, b, d, c]
        }
    }
    for i in 1..<(count - 1) {
        indices += [0, Int32(i + 1), Int32(i)]
        let o = Int32((rings.count - 1) * count)
        indices += [o, o + Int32(i), o + Int32(i + 1)]
    }
    var normals = Array(repeating: SCNVector3Zero, count: vertices.count)
    for i in stride(from: 0, to: indices.count, by: 3) {
        let a = Int(indices[i]), b = Int(indices[i + 1]), c = Int(indices[i + 2])
        let u = SCNVector3(vertices[b].x - vertices[a].x, vertices[b].y - vertices[a].y, vertices[b].z - vertices[a].z)
        let v = SCNVector3(vertices[c].x - vertices[a].x, vertices[c].y - vertices[a].y, vertices[c].z - vertices[a].z)
        let n = SCNVector3(u.y * v.z - u.z * v.y, u.z * v.x - u.x * v.z, u.x * v.y - u.y * v.x)
        for j in [a, b, c] {
            normals[j] = SCNVector3(normals[j].x + n.x, normals[j].y + n.y, normals[j].z + n.z)
        }
    }
    normals = normals.map { n in
        let length = max(0.0001, sqrt(n.x * n.x + n.y * n.y + n.z * n.z))
        return SCNVector3(n.x / length, n.y / length, n.z / length)
    }
    let source = SCNGeometrySource(vertices: vertices)
    let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
    let geometry = SCNGeometry(sources: [source, SCNGeometrySource(normals: normals)], elements: [element])
    geometry.materials = [m]
    let node = SCNNode(geometry: geometry)
    car.addChildNode(node)
    return node
}

_ = loft([
    (-2.15, 0.70, 0.33, 0.67), (-2.06, 0.85, 0.30, 0.79),
    (-1.65, 0.91, 0.30, 0.91), (-0.95, 0.94, 0.30, 1.01),
    (0.85, 0.94, 0.30, 1.01), (1.65, 0.88, 0.32, 0.88),
    (2.02, 0.83, 0.35, 0.80), (2.13, 0.69, 0.38, 0.73)
], pearl)

// Cabin glass and a separate painted roof expose depth in side views.
_ = loft([
    (-1.02, 0.78, 0.94, 0.97), (-0.43, 0.69, 0.98, 1.58),
    (0.60, 0.68, 0.98, 1.60), (1.26, 0.77, 0.94, 1.01)
], glass)
_ = loft([
    (-0.47, 0.64, 1.54, 1.57), (-0.25, 0.68, 1.55, 1.64),
    (0.43, 0.67, 1.57, 1.66), (0.64, 0.62, 1.55, 1.61)
], pearl)
_ = box(SCNVector3(0.88, 0.025, 0.65), SCNVector3(0, 1.65, 0.18), glass, radius: 0.012)

// Window pillars, mirrors and a subtle Meshwar crimson sill.
for side: Float in [-1, 1] {
    _ = box(SCNVector3(0.035, 0.49, 0.065), SCNVector3(side * 0.726, 1.24, 0.14), dark, radius: 0.012)
    _ = box(SCNVector3(0.22, 0.12, 0.28), SCNVector3(side * 0.98, 1.0, -0.79), pearl, radius: 0.055)
    _ = box(SCNVector3(0.03, 0.045, 2.50), SCNVector3(side * 0.928, 0.40, 0.05), red, radius: 0.012)
    for z: Float in [-0.45, 0.65] {
        _ = box(SCNVector3(0.026, 0.04, 0.21), SCNVector3(side * 0.94, 0.90, z), silver, radius: 0.012)
    }
    for z: Float in [-1.32, 1.38] {
        let wheel = SCNCylinder(radius: 0.39, height: 0.20)
        wheel.radialSegmentCount = 32
        wheel.materials = [rubber]
        let tire = SCNNode(geometry: wheel)
        tire.eulerAngles.z = .pi / 2
        tire.position = SCNVector3(side * 0.9, 0.39, z)
        car.addChildNode(tire)
        let rim = SCNCylinder(radius: 0.26, height: 0.025)
        rim.radialSegmentCount = 32
        rim.materials = [silver]
        let hub = SCNNode(geometry: rim)
        hub.eulerAngles.z = .pi / 2
        hub.position = SCNVector3(side * 1.01, 0.39, z)
        car.addChildNode(hub)
        let inset = SCNCylinder(radius: 0.19, height: 0.03)
        inset.materials = [dark]
        let disc = SCNNode(geometry: inset)
        disc.eulerAngles.z = .pi / 2
        disc.position = SCNVector3(side * 1.025, 0.39, z)
        car.addChildNode(disc)
        for spoke in 0..<5 {
            let a = Float(spoke) * 2 * .pi / 5
            let spokeNode = box(SCNVector3(0.035, 0.23, 0.055), SCNVector3(side * 1.045, 0.39 + cos(a) * 0.07, z + sin(a) * 0.07), silver, radius: 0.015)
            spokeNode.eulerAngles.x = CGFloat(a)
        }
    }
}
_ = box(SCNVector3(1.1, 0.18, 0.04), SCNVector3(0, 0.49, -2.13), dark, radius: 0.04)
for side: Float in [-1, 1] {
    _ = box(SCNVector3(0.43, 0.115, 0.055), SCNVector3(side * 0.55, 0.72, -2.06), headlight, radius: 0.045)
    _ = box(SCNVector3(0.43, 0.13, 0.055), SCNVector3(side * 0.54, 0.69, 2.06), red, radius: 0.045)
}

// A transparent, soft elliptical contact shadow, always below the car.
let shadowTexture = NSImage(size: NSSize(width: 256, height: 512))
shadowTexture.lockFocus()
let gradient = NSGradient(colors: [NSColor.black.withAlphaComponent(0.32), NSColor.black.withAlphaComponent(0.17), NSColor.black.withAlphaComponent(0)])!
gradient.draw(in: NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: 256, height: 512)), relativeCenterPosition: .zero)
shadowTexture.unlockFocus()
let shadowPlane = SCNPlane(width: 2.65, height: 5.05)
let shadowMaterial = SCNMaterial()
shadowMaterial.diffuse.contents = shadowTexture
shadowMaterial.lightingModel = .constant
shadowMaterial.isDoubleSided = true
shadowMaterial.writesToDepthBuffer = false
shadowPlane.materials = [shadowMaterial]
let shadowNode = SCNNode(geometry: shadowPlane)
shadowNode.eulerAngles.x = -.pi / 2
shadowNode.position = SCNVector3(0.12, 0.025, 0.12)
car.addChildNode(shadowNode)

let camera = SCNNode()
camera.camera = SCNCamera()
camera.camera!.usesOrthographicProjection = true
camera.camera!.orthographicScale = 3.25
camera.position = SCNVector3(0, 7.5, 6.1)
camera.look(at: SCNVector3(0, 0.50, 0))
scene.rootNode.addChildNode(camera)
let ambient = SCNNode()
ambient.light = SCNLight()
ambient.light!.type = .ambient
ambient.light!.intensity = 180
ambient.light!.color = NSColor.white
scene.rootNode.addChildNode(ambient)
let light = SCNNode()
light.light = SCNLight()
light.light!.type = .directional
light.light!.intensity = 750
light.position = SCNVector3(-4, 8, 5)
light.look(at: SCNVector3Zero)
scene.rootNode.addChildNode(light)

let renderer = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: nil)
renderer.scene = scene
renderer.pointOfView = camera
renderer.autoenablesDefaultLighting = false
func setTilt(_ tilt: Int) {
    let angle = CGFloat(tilt) * .pi / 180
    // Native map tilt is measured from directly overhead. Keep the camera
    // aimed at the ground anchor so the shadow stays pinned to the coordinate.
    camera.position = SCNVector3(0, 9.5 * cos(angle), max(0.001, 9.5 * sin(angle)))
    camera.look(at: SCNVector3Zero)
}
for tilt in stride(from: 0, through: 75, by: 5) {
    setTilt(tilt)
    for heading in stride(from: 0, to: 360, by: 3) {
        car.eulerAngles.y = -CGFloat(heading) * .pi / 180
        let image = renderer.snapshot(atTime: 0, with: NSSize(width: 192, height: 192), antialiasingMode: .multisampling4X)
        let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
        let data = bitmap.representation(using: .png, properties: [:])!
        try data.write(to: URL(fileURLWithPath: destination).appendingPathComponent(String(format: "tilt_%02d_heading_%03d.png", tilt, heading)))
    }
    print("Rendered tilt \(tilt)°: 120 headings with contact shadows")
}

// Optional larger preview of the actual production mesh on a light map tone.
if CommandLine.arguments.count > 2 {
    scene.background.contents = NSColor(calibratedRed: 0.91, green: 0.94, blue: 0.95, alpha: 1)
    setTilt(45)
    car.eulerAngles.y = -CGFloat(225) * .pi / 180
    let image = renderer.snapshot(atTime: 0, with: NSSize(width: 512, height: 512), antialiasingMode: .multisampling4X)
    let bitmap = NSBitmapImageRep(data: image.tiffRepresentation!)!
    try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[2]))
}

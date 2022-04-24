import SwiftUI
import RealityKit
import ARKit
 //import PlaygroundSupport


struct ContentView : View {
    //objectplaced is for x eye and question mark
    @State private var ObjectPlaced = false
    @State private var ChosenModels: ArModel?
    @State private var modelConfirmedPlacement: ArModel?
    @State private var showedBrowse = false
    
    
    private var models: [ArModel] = {
        //get files from file manager
        let fileManager = FileManager.default

        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else{
            return []
        }
        
        var ModelList: [ArModel] = []
        for filename in files where
        filename.hasSuffix("usdz"){
            let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
            if modelName == "Cube"{
                let Description1 = """
                It's a Cube! 🧊
                You can find Cube structure implementation in day to day objects such as Rubrik's Dice, Dice, Ice Cube. From the AR you see, Cube has these unique characteristics :
                12 Edges
                6 Faces
                8 Vertices
                
                Fact - Cubic has 6 faces and all of them are 2 Dimensional Squares, so you can count the Total Surface Area by counting 6 times of Squares surfaces.
                
                Area of Square : a x a
                Total Surface Area of Cube : 6 x (a x a)
                """
                let model = ArModel(modelName: modelName, descImage1: Description1)
                ModelList.append(model)
            }
            else if modelName == "Circle"{
                let Description1 = """
It's a Sphere! 🏀
You can find Sphere structure implementations in day to day objects such as Meatball, Golf Ball, World Globe. Because of its flawless shape and structure, Sphere has these characteristics:
No Edges and Vertices
Only have a Curved Face

Fact - Sphere is a perfectly round 3D Object, so All Distance from Surface Points are the same From Center of the Sphere.

Total Surface Area of Cylinder : 4 x π x r x r
"""
                let model = ArModel(modelName: modelName, descImage1: Description1)
                ModelList.append(model)
            }
            else if modelName == "Cone"{
                let Description1 = """
It’s a Cone ✋🏽
Usually you can find Objects that use cones such as Road Divider, Ice Cream Cone, and many more. Cone has its uniqueness too, for example :
1 Edges
2 Faces
1 Vertices

Fact - A Cone is a rotated right-angled Triangle, and it has a circle at the base surface.

Total Surface Area of Cone : π x r x (r+rootof((h x h)+(r x r)))
"""
                let model = ArModel(modelName: modelName, descImage1: Description1)
                ModelList.append(model)
            }
            else{
                let Description1 = """
It’s a Cylinder 🎂
You can find Cylinder structure implementations in your surroundings, for example a Can, your House Pipe, even it can be your Birthday Cake 😅 As you can see and analyze in the AR, Cylinder has these unique characteristics :
3 Faces
2 Identical Circular Faces
1 Rectangle Curved Side
NO Edges and Vertices

Fact - a Cylinder surfaces made of 2 Circles and 1 Rectangle, the Rectangle acts as the curved sleeve faces.

Area of Curved Surface Area : 2 x π x r x h
Area of Circle : π x r x r
Total Surface Area of Cylinder : 2 x π x r x (h + r)
"""
                let model = ArModel(modelName: modelName, descImage1: Description1)
                ModelList.append(model)
            }
        }
        return ModelList
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(modelConfirmedPlacement: self.$modelConfirmedPlacement)
            if ObjectPlaced{
                ButtonViewContainter(ObjectPlaced: self.$ObjectPlaced, ChosenModels: self.$ChosenModels, modelConfirmedPlacement: self.$modelConfirmedPlacement, showedBrowse: self.$showedBrowse)
            }
            else{
                ChooseModelView(ObjectPlaced: self.$ObjectPlaced, ChosenModels: self.$ChosenModels, models: self.models)
            }
        }
    }
}
              
struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedPlacement: ArModel?
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if
            ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConfirmedPlacement{
            if let modelEntity = model.modelEntity{ print("Debug adding model to scene \(model.modelName)")
                
                let anchorEntity = AnchorEntity(plane: .any).clone(recursive: true)
                
                anchorEntity.name = "objectAnchor"
                
                anchorEntity.addChild(modelEntity)
                
                uiView.scene.addAnchor(anchorEntity)
                
                modelEntity.generateCollisionShapes(recursive: true)
                uiView.installGestures([.all], for: modelEntity)
                uiView.applyObjectRemove()
                
            } else{
                print("Debug unable adding model to scene \(model.modelName)")
            }
            
            //ini buat ngereset si var model congirme
            //biar ga error pake dispatch, klo dia lgsgnan ntar lgsg ke run
            DispatchQueue.main.async {
                self.modelConfirmedPlacement = nil
            }
        }
    }
    
}

extension ARView{
    func applyObjectRemove(){
        let longPressGestureRecog = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        
        self.addGestureRecognizer(longPressGestureRecog)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        let location = recognizer.location(in: self)
        
        if let entity = self.entity(at: location){
            if let anchorEntity = entity.anchor, anchorEntity.name == "objectAnchor"{
                anchorEntity.removeFromParent()
                print("Debug removed anchor")
            }
        }
    }
}

struct ChooseModelView : View {
    @Binding var ObjectPlaced: Bool
    @Binding var ChosenModels: ArModel?
    
    var models: [ArModel]

    var body: some View {
        HStack(alignment: .center,spacing: 10){
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .trailing, spacing: 35){
                    Spacer()
                    ForEach(0..<self.models.count){
                        index in
                        Button(action: {print("Debug \(self.models[index].modelName)")
                            
                            self.ObjectPlaced = true
                            self.ChosenModels = self.models[index]
                            
                        }) {
                            Image(uiImage: self.models[index].image)
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                        .buttonStyle(PlainButtonStyle())
                            
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: 600)
            Spacer()
        }
    }
}

struct ButtonViewContainter: View{
    @Binding var ObjectPlaced: Bool
    @Binding var ChosenModels: ArModel?
    @Binding var modelConfirmedPlacement: ArModel?
    @Binding var showedBrowse: Bool
 
    
    var body: some View{
        HStack{
            
            //Canceling the AR button
            Button(action: {
                print("Debug : Cancel Model Placement ")
                self.resetObjectPlaced()
            }) {
                    Image(systemName: "xmark")
                        .frame(width: 80, height: 80)
                        .font(.title)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(50)
                        .padding(20)
                }
            
            //See ar
            Button(action: {
                print("Debug : confirm Model Placement ")
                self.modelConfirmedPlacement = self.ChosenModels
                self.resetObjectPlaced()
            }) {
                    Image(systemName: "eye")
                        .frame(width: 80, height: 80)
                        .font(.title)
                        .background(Color.white.opacity(0.75))
                        .cornerRadius(50)
                        .padding(20)
                }
            
            //Show Details
            Button(action: {
                print("debug Details modals")
                
                showedBrowse = true
//                self.resetObjectPlaced()
//                self.showedBrowse.toggle()
            }){
                Image(systemName: "questionmark.circle.fill")
                    .frame(width: 80, height: 80)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(50)
                    .padding(20)
            }.sheet(isPresented: $showedBrowse, content: {
                BrowseSheet(showedBrowse: $showedBrowse, chosenImage: self.ChosenModels!.image, chosenDesc: self.ChosenModels!.descImage1!)
            })
        }
    }
    
    func resetObjectPlaced(){
        self.ObjectPlaced = false
        self.ChosenModels = nil
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

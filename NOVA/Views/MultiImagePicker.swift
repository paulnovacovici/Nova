//
//  MultiImagePicker.swift
//  NOVA
//
//  Created by pnovacov on 7/14/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import Photos


//struct MultiImagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiImagePicker()
//    }
//}

struct PhotoRow : View {
    var photos: [UIImage]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(alignment: .top, spacing: 0){
                
                ForEach(self.photos, id: \.self){photo in
                    
                    Image(uiImage: photo)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
                    .padding(.leading, 15)
                }
            }
        }.frame(height: 185)
    }
}


//struct MultiImagePicker : View {
//
//    @State var selected : [SelectedImages] = []
//    @State var show = false
//
//    var body: some View{
//
//        ZStack(alignment: .leading){
//
//            Color.black.opacity(0.07).edgesIgnoringSafeArea(.all)
//
//            VStack(alignment: .leading){
//
//
//                if !self.selected.isEmpty{
//                    PhotoRow(photos: selected)
//                }
//
//                Button(action: {
//
//                    self.selected.removeAll()
//
//                    self.show.toggle()
//
//                }) {
//                    HStack{
//                        Text("Select Photos")
//                        Image(systemName: "photo")
//                    }
//                }
//                .sheet(isPresented: self.$show) {
//                    CustomPicker(selectedImages: self.$selected, show: self.$show)
//                }
//            }
//
//        }
//
//    }
//}


struct CustomPicker : View {
    @Binding var selectedImages : [SelectedImages]
    @Binding var show : Bool
    
    @State var grid : [[Images]] = []
    @State var disabled = false
    @State var selected: [SelectedImages] = []
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                

                if !self.grid.isEmpty{
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            
                            ForEach(self.grid,id: \.self){i in
                                
                                HStack{
                                    
                                    ForEach(i,id: \.self){j in
                                        
                                        Card(data: j, selected: self.$selected)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                    .padding(.top)
                    .listRowInsets(EdgeInsets())
                    
                    Button(action: {
                        self.selectedImages = self.selected
                        self.show.toggle()
                        
                    }) {
                        
                        Text("Select")
                            .foregroundColor(.white)
                            .padding(.vertical,10)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .background(Color.red.opacity((self.selected.count != 0) ? 1 : 0.5))
                    .clipShape(Capsule())
                    .padding(.bottom)
                    .disabled((self.selected.count != 0) ? false : true)
                    
                }
                else{
                    
                    if self.disabled{
                        
                        Text("Enable Storage Access In Settings !!!")
                    }
                    if self.grid.count == 0{
                        
                        Indicator()
                    }
                }
            }
        }
        .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
        .onTapGesture {
        
            self.show.toggle()
            
        })
        .onAppear {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized{
                    
                    self.getAllImages()
                    self.disabled = false
                }
                else{
                    
                    print("not authorized")
                    self.disabled = true
                }
            }
        }
    }
    
    func getAllImages(){
        
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let req = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        DispatchQueue.global(qos: .background).async {

           let options = PHImageRequestOptions()
           options.isSynchronous = true
                
        // New Method For Generating Grid Without Refreshing....
            
          for i in stride(from: 0, to: req.count, by: 3){
                    
                var iteration : [Images] = []
                    
                for j in i..<i+3{
                    
                    if j < req.count{
                        
                        PHCachingImageManager.default().requestImage(for: req[j], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in
                            
                            let data1 = Images(image: image!, selected: false, asset: req[j])
                            
                            iteration.append(data1)

                        }
                    }
                }
                    
                self.grid.append(iteration)
            }
            
        }
    }
}

struct Card : View {
    
    @State var data : Images
    @Binding var selected : [SelectedImages]
    
    var body: some View{
        
        ZStack{
            
            Image(uiImage: self.data.image)
            .resizable()
            .frame(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
            
            if self.data.selected{
                
                ZStack{
                    
                    Color.black.opacity(0.5)
                    
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 3 - 3, height: UIScreen.main.bounds.width / 3 - 3)
                        .foregroundColor(.white)
                }
            }
            
        }
        .onTapGesture {
            
            
            if !self.data.selected{

                
                self.data.selected = true
                
                // Extracting Orginal Size of Image from Asset
                
                DispatchQueue.global(qos: .background).async {
                    
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    
                    // You can give your own Image size by replacing .init() to CGSize....
                    
                    PHCachingImageManager.default().requestImage(for: self.data.asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in
                        DispatchQueue.main.async {
                            self.selected.append(SelectedImages(asset: self.data.asset, image: image!))
                        }
                    }
                }

            }
            else{
                
                for i in 0..<self.selected.count{
                    
                    if self.selected[i].asset == self.data.asset{
                        
                        self.selected.remove(at: i)
                        self.data.selected = false
                        return
                    }
                    
                }
            }
        }
        
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView  {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView:  UIActivityIndicatorView, context: Context) {
        
        
    }
}

struct Images: Hashable {
    
    var image : UIImage
    var selected : Bool
    var asset : PHAsset
}

struct SelectedImages: Hashable{
    
    var asset : PHAsset
    var image : UIImage
}

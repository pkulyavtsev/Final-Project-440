//
//  PlotDataClass.swift
//  SwiftUICorePlotExample
//  Shared
//
//  Created by Jeff Terry on 12/16/20.
//

import Foundation
import SwiftUI
import CorePlot

class PlotDataClass: NSObject, ObservableObject {
    
    @Published var plotData = [plotDataType]()
    @Published var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()
    
    //In case you want to plot vs point number
    @Published var pointNumber = 1.0
    
    init(fromLine line: Bool) {
        
        
        //Must call super init before initializing plot
        super.init()
       
        
        //Intitialize the first plot
        self.plotBlank()
        
       }
    
    
    
    func plotBlank()
    {
        plotData = []
        
        //set the Plot Parameters
        changingPlotParameters.yMax = 10.0
        changingPlotParameters.yMin = 0.0
        changingPlotParameters.xMax = 10.0
        changingPlotParameters.xMin = 0.0
        changingPlotParameters.xLabel = "x" //change
        changingPlotParameters.yLabel = "y" //change
        changingPlotParameters.title = "Wave Plot" //change
        
    }
    
    func zeroData(){
            
            plotData = []
            pointNumber = 1.0
            
        }
        
        func appendData(dataPoint: [plotDataType])
        {
          
            plotData.append(contentsOf: dataPoint)
            pointNumber += 1.0
            
            
            
        }
    
    

}



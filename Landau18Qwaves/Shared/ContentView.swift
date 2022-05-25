
import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @ObservedObject var plotDataModel = PlotDataClass(fromLine: true)
    @ObservedObject private var waveCalculator = CalculateWave()
    @State var xInput: String = "\(Double.pi/2.0)"
    @State var waveOutput: String = "0.0"
    @State var computerWave: String = "\(cos(Double.pi/2.0))"
  
    

    var body: some View {
        
        VStack{
      
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
            
            Divider()
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("x:")
                        .font(.callout)
                        .bold()
                    TextField("xValue", text: $xInput)
                        .padding()
                }.padding()
                       
            }
            
            HStack{
                
                HStack(alignment: .center) {
                    Text("Expected:")
                        .font(.callout)
                        .bold()
                    TextField("Expected:", text: $computerWave)
                        .padding()
                }.padding()
                         
            }
            
            
            HStack{
                Button("Calculate Wave", action: {self.calculateWave()} )
                .padding()
                
            }
            
        }
        
    }
    
    
    
    
    /// calculateWave
    /// Function accepts the command to start the calculation from the GUI
    func calculateWave(){
        
        let x = Double(xInput)
        xInput = "\(x!)"
        
        var wave_calc = 0.0
        
        //pass the plotDataModel to the cosCalculator
        waveCalculator.plotDataModel = self.plotDataModel
                
        //Calculate the new plotting data and place in the plotDataModel
        wave_calc = waveCalculator.calculate_Harmos(x: x!)
               
        waveOutput = "\(wave_calc)"

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

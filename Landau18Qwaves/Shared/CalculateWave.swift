//
//  main.swift
//  Landau18Qwaves
//
//  Created by Paulina on 5/16/22.
//
// based on cos(x) by Dr Jeff Terry

import Foundation
import SwiftUI
import CorePlot

class CalculateWave: ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var plotData :[plotDataType] = []
    
    func calculate_Harmos(x: Double) -> Double{
        
        plotDataModel!.zeroData()
        
        //set the Plot Parameters
        plotDataModel!.changingPlotParameters.yMax = 1
        plotDataModel!.changingPlotParameters.yMin = -1
        plotDataModel!.changingPlotParameters.xMax = 800
        plotDataModel!.changingPlotParameters.xMin = -1
        plotDataModel!.changingPlotParameters.xLabel = "X"
        plotDataModel!.changingPlotParameters.yLabel = "Yvalue"
        plotDataModel!.changingPlotParameters.title = "x vs time (probability)"
        
        // Plot first point of the wave
        var dataPoint: plotDataType = [.X: 0.0, .Y: (0.0)]
        
        
        let debug = true

        // Constants
        let NX  = 750     // NX steps per X
        let MAX =  NX     // same, steps per X

        /*
        let NSTEPS    = 5000  // time iterations (final)
        let OUTSTEP_T =  200  // output every OUTSTEP_T lines for animation
        let OUTSTEP_X =   10  // output every OUTSTEP_X value for animation
        */

        let NSTEPS    =  400  // time iterations
        let OUTSTEP_T =  200  // output every OUTSTEP_T lines for animation
        let OUTSTEP_X =   75  // output every OUTSTEP_X value for animation


        // 18.6.2: problem constants
        // V(x) = 0   for xmin <= x <= xmax
        //      = inf outside
        // Square potential boundary conditions
        let xmin: Double =  0 // left side
        let xmax: Double = 15 // right side

        // for eq 18.38:
        let x0: Double =  5.0       // initial X coordinate at t=0 (given by Landau, can change)
        let sigma0: Double = 0.5    // exp(( x - x0)/sigma0)), in Landau given x0 is 5
        let k0: Double = 17.0 * Double.pi // initial momentum
        let dt_dx2: Double = 0.5    // dt/dx2; Task conditions : dt = 1/2 /(dx)**2 :: dt/(dx**2) = 1/2

        // 750 steps * 0.02 = 15
        // 750+1 points from 0 to 15
        let dx: Double = 0.02       // delta x : step in x
        let dx2: Double = dx * dx
        let dt:  Double = dx2/2.0   // delta t: step in t

        //class notmain:ObservableObject {
            
                
        //========================================================================
        // Arrays:
        //var psr: [[Double]] // Psi, Real,      [NX+1,2], Current and Next
        //var psi: [[Double]] // Psi, Imaginary, [NX+1,2], Current and Next
        //note reference from Java code array initializing is flipped Java[x][y] = > Swift[y][x]

        // psr[0][i] : Psi, Real, Current use 0
        // psr[1][i] : Psi, Real, Future use 1
        var psr: [[Double]] = Array(repeating: Array(repeating: 0.0, count: NX+1),
                                    count: 2)
        // psi[0][i] : Psi, Imaginary, Current
        // psi[1][i] : Psi, Imaginary, Future
        var psi: [[Double]] = Array(repeating: Array(repeating: 0.0, count: NX+1),
                                    count: 2)

        // we need rho[0] = rho[NX] = 0
        var rho: [Double]  = Array(repeating: 0.0, count: NX+1 )  // probability

        //var p2: [Double] = []
        //var v: [Double] = []  // potential V : not used for square potential ? extra from Java program...

        //=====

        // debug false vs true toggles debug mode, just for ease degub handles less info so more quick to dev

        if debug {
            print("NX   = \(NX)" )
            print("NSTEPS = \(NSTEPS)" )
            print("xmin = \(xmin)" )
            print("xmax = \(xmax)" )
            print("sigma0 = \(sigma0)" )
            print("k0   = \(k0)" )
            print("dx   = \(dx)" )
            print("dt   = \(dt)" )
                }

        //============================================
        // step 3 : 495
        //   psr[j][1] at t=0 FLIP
        //   psr[j][1] at t=1/2 *dt FLIP
        // @todo: check is it psi or psu_next

        var x = 0.0

        var i: Int = 0
        

        // initialize
        // start w eq 18.38 (step 3 pg 495)

        x = x0
        for i in 0...NX { //cycle i from 0 to NX (this is x coord)
            var xxs,k0x,psi_a: Double

            xxs = (x-x0)/sigma0
            psi_a = exp(-0.5 * xxs * xxs)
            k0x = k0*x

            // testing
            //psi_re[i] = psi_a * cos(k0x) //Re Psi
            //psi_im[i] = psi_a * sin(k0x) //Im Psi

            psr[0][i] = psi_a * cos(k0x) //Re Psi
            psi[0][i] = psi_a * sin(k0x) //Im Psi
            
           print("this is i: \(i)" )
           print("this is x: \(x)" )
            
           x += dx
            /*
             what happens in this loop:
             i iterates through the array (0 -> 750)
             x increases by dx every iteration.
             psr and psi are calculated, saved in position [0][i] in respective arrays
             */
            
        }
        print("OKAY IM DONE WITH THE FIRST FOR LOOP, WOOHOO!!! Next i'll iterate over time [here][i]" )
        //=============================================================
        // Iterate over time
        var n: Int = 0 // time step, WHY DOES IT SAY IT WAS NEVER USED???
        var total: Double = 0.0
        
        for n in 0...NSTEPS { //currently NSTEP is 400 for debug, increased to 5000 when running
            
            print("this is n: \(n)" )
            
            for i in 1...MAX-1 {
                psr[1][i] = psr[0][i] - dt_dx2 * (psi[0][i+1] + psi[0][i-1] - 2.0 * psi[0][i])
                // note, above omits vector potential from Harmos.java as it is given as 0 to 15, we set to 0. (ref 494, 18.6.2)
                // with current givn const v pot = 0, if change const, v pot must be considered
                // see boundary conditions
                
                // TODO: ... [0] * ...[1] - typo in original code? how is more correct...?
                // compare to eq 18.47, vs Harmos code...
                rho[i]    = psr[0][i] * psr[1][i] + psi[0][i] * psi[0][i]
                // should we take square of real part, at index 0 (current value of wavefunction)
                //total = rho[i]
                //print("this is rho[i]: \(rho[i]) for n: \(n)" )
                
                
                
            }
     
            for i in 1...MAX-1 {
                psi[1][i] = psi[0][i] + dt_dx2 * (psr[1][i+1] + psr[1][i-1] - 2.0*psr[1][i])
            }
            
            // print on first and every OUTSTEP_T'th step
            if ( n == 0 || (n % OUTSTEP_T == 0) ) { // code example in book asked for every 200, can change w/OUTSTEP_T
                // print psi for output
                if debug {
                    print("DEBUG: rho[i] n=\(n)" )
                    
                }
             
                //prints every OUTSTEP_Xth element
                for i in stride(from: 0, through: MAX, by: OUTSTEP_X) {
                    // print("\(i) \(rho[i]) ### ", terminator: "") // DEBUG
                    print("\(rho[i]) ", terminator: "") //terminator is empty, no new line character added, print on one line
                    
                    dataPoint = [.X: Double(i) ,.Y: rho[i]]
                    plotDataModel!.appendData(dataPoint: [dataPoint])
                    
                    
                }
                print("") //end line
                
            }

            // prepare for the next time step :
            
         //   dataPoint = [.X: Double(n) ,.Y: rho[n]]
          //  plotDataModel!.appendData(dataPoint: [dataPoint])
            
            // copy arrays, future to current
            
          
            
            psr[0] = psr[1]
            psi[0] = psi[1]
            
            
            
            
        } // iterate over time

        if debug {
            print("DEBUG:done" )
        }
        return x
    }
}

/* safe keeping
 dataPoint = [.X: Double(i) ,.Y: rho[i]]
 print(dataPoint)
 plotDataModel!.appendData(dataPoint: [dataPoint])
 */

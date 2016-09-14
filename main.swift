//
//  main.swift
//  toy
//
//  Created by Lane Schwartz on 2016-09-14.
//  Copyright © 2016 Lane Schwartz. All rights reserved.
//

import Foundation


var output: CInt = 0
getInput(&output)

print(output)

let x = DataOnGPU()
x.foo()

let v = CUDA_Vector()

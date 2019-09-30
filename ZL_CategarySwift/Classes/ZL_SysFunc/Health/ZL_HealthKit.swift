//
//  ZL_HealthKit.swift
//  LiShe
//
//  Created by lishe on 2019/7/18.
//  Copyright © 2019 lishe. All rights reserved.
//

import Foundation
import HealthKit
import UIKit

typealias Health_StepClosure = (_ stepList: [Double]? , Error?) -> ()

public class ZL_HealthKit: NSObject {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    var resultBlock: Health_StepClosure?
    
    var startDate: Date?
    var endDate: Date?
    
    /// 获取30天步数数据
    public public func getUserSteps(resultBlock: @escaping Health_StepClosure) {
        self.resultBlock = resultBlock
        
        AuthorizeUtils.zl_authorizeHealthKit { (authorized) in
            if !authorized {
                self.resultBlock?(nil,HealthkitSetupError.dataTypeNotAvailable)
            }else{
                self.getStep();
            }
        }
    }
    
    private func getStep() {

        let now = Date()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var unitFlags = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        self.endDate = calendar.date(from: unitFlags)
        unitFlags.hour = 0
        unitFlags.minute = 0
        unitFlags.second = 0
        self.startDate = calendar.date(from: unitFlags)
        
        
        var stepList = [Double]();
        
        /*
         semaphore 信号量 控制任务顺序执行
         DispatchSemaphore(value:)：用于创建信号量，可以指定初始化信号量计数值，这里我们默认1。
         semaphore.wait()：会判断信号量，如果为1，则往下执行。如果是0，则等待。
         semaphore.signal()：代表运行结束，信号量加1，有等待的任务这个时候才会继续执行。
         */
        let semaphore = DispatchSemaphore(value: 1)
        for i in 0...30 {
            DispatchQueue.global().async {
                
                semaphore.wait()     //等待
                
                self.queryStepBy(startTime: self.startDate, endTime: self.endDate) { (lastDayStepData) in
                    
                    print("前\(i)天++\(String(describing: self.startDate)) == \(String(describing: self.endDate))")
                    
                    let tempData = self.startDate               //今天的开始时间是昨天的结束时间
                    self.startDate = self.getLastDay(tempData); //昨天的开始时间
                    self.endDate = tempData                     //昨天的结束时间
                    
                    stepList.append(lastDayStepData)
                    
                    if i == 29 {
                        self.resultBlock?(stepList ,nil)
                    }
                    
                    semaphore.signal()  //代表运行结束，信号量加1
                }
            }
        }
    }
    
    // MARK: 前1天的时间
    // nowDay 是传入的需要计算的日期
    private func getLastDay(_ nowDay: Date?) -> Date? {
        let lastTime: TimeInterval = -(24*60*60) // 往前减去 n 天的秒数，昨天
        let lastDate = nowDay?.addingTimeInterval(lastTime)
        return lastDate
    }
    
    

    /// 查询一天的步数数据
    ///
    /// - Parameters:
    ///   - startTime: 开始时间一天的0000点
    ///   - endTime: 现在
    ///   - completed: 回调
    private func queryStepBy(startTime: Date? , endTime: Date?, completed: @escaping (_ stepData: Double)->()){
        
        // 1、sampleType
        guard let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            fatalError("*** This method should never fail ***")
        }
        
        // 2、查询步数
        HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: startTime , end: endTime, options: HKQueryOptions.strictStartDate)
        
        // 3、 NSSortDescriptors用来告诉healthStore怎么样将结果排序
        let start = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let stop  = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // 查询语句
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [start, stop]) { (query, results, error) in
            var localSum: Double = 0  //手机写入步数
            var currentDeviceSum: Double = 0  //软件写入步数
            guard (results as? [HKQuantitySample]) != nil else {
                print("获取步数error ---> \(String(describing: error?.localizedDescription))")
                return
            }
            for res in results! {
                if res.sourceRevision.source.bundleIdentifier == Bundle.main.bundleIdentifier {
                    print("其他应用app写入数据")
                    let _res = res as? HKQuantitySample
                    currentDeviceSum = currentDeviceSum + (_res?.quantity.doubleValue(for: HKUnit.count()))!
                }else {     //手机录入数据
                    let _res = res as? HKQuantitySample
                    localSum = localSum + (_res?.quantity.doubleValue(for: HKUnit.count()))!
                }
            }
            print("当前手机写入步数B  -- \(localSum)")
            completed(localSum);
        }
        //4、 执行查询
        HKHealthStore().execute(query)
    }
    
}

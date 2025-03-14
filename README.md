
EN | [中文](./README-zh.md)

### This demo does not support running on the simulator. If you encounter an error when using the simulator, try switching to running on a real device.

##Update log
|Version| description |time|
|:-:|-|:-:|

|1.13.10| Compatible with firmware version 6.0 |2025/3/14|

|1.13.9| Fixed the issue of incorrect parsing of monitoring report duration when leaving the hand |2024/8/21|

|1.13.8| Supports analysis of C11G/H model ring SN. |2024/8/15|

|1.13.6| Fix the incompatibility issue between MRFramework and Xcode 15.3 version. |2024/4/19|

|1.13.5| AppID and AppKey adapt to wildcard bundleId verification |2024/4/12|

|1.13.4| Fixed the issue where the 'monitorModeUpdated' proxy method is not called after some models of ring are connected. |2024/3/20|

|1.13.3| Add a callback that returns the rawData data stream |2024/1/15|
|1.13.2| Update the algorithm for parsing data (algorithm version: 12292) |2024/1/9|
|1.13.1| Fixed the problem of pulling respiratory rate data and the wrong HRV parsing time |2024/1/3|
|1.13.0| Add real-time monitoring data to return respiratory rate and respiratory type data analysis |2023/12/14|
|1.12.9| Update the algorithm for parsing data (algorithm version: 12292) to quickly collect data |2023/10/31|


|1.12.6 | SDK AppId and AppKey only need to be verified once，When parsing data, do not verify AppId and appKey through the network (Solve the problem that data cannot be parsed when there is a network error) | 2022/12/29|
|1.12.5| After collecting the ring data, add the report details UI page of sleep, HRV and  sport |2022/11/15|
|1.12.4| SN adaptations of different ring models are added (mainly C11H, P11G, P11H) |2022/11/9|
|1.12.3| Resolve whether the device is disconnected and crashes when it is nil |2022/9/21|
|1.12.2| Enable bitcode. |2022/08/30|
|1.12.1| 5.0.11803 firmware version supports the function of closing and opening HRV. |2022/08/26|
|1.12.0| fix the problem of scanning for old devices and restricting connections. |2022/08/15|
|1.11.91| add some notes on readme file and project interface |2022/07/19|
|1.11.9| update the algorithm for parsing data (algorithm version: 11737)|2022/07/07|
|1.11.8| 1. Add in the demo how to reconnect after the device is disconnected, and the simple process of collecting data (click to stop monitoring to collect data) <br/> 2. Add some descriptions of whether blood pressure measurement attributes and ECG are supported. |2022/07/03|
|1.11.72| further description of ECG |2022/05/03|
|1.11.7| add the blood pressure monitoring function and UI in the demo <br/> after generating ECG data, draw the details of the UI for ECG |2022/04/20|
|1.11.61| solve the bug of 50% electricity always |2022/04/08|
|1.11.5| verify the appid and appkey of SDK and add callback function |2022/02/25|
|1.11.4| fix the failure of the method of starting glumode |2022/02/24|
|1.11.3| fix the problem that HRV data cannot be parsed after it is generated |2022/02/22|
|1.11.2| fixed the bug that the progress bar exceeded when obtaining the ring data |2022/01/28|
|1.11.1| 1. Add the function of turning on and off logs <br/> 2. Modify the time of parsing HRV data |2022/01/12|

...... For more information, please see the released release list .




MegaRing SDK & Demo for iOS in Objective-C

Please provide your own package name (i.e. BundleId) to the official to obtain a valid appID and AppKey. The SDK does not support simulators. Please use mobile phone for debugging.

This text introduces the components of MRFramework, hoping to make it easier to use.




## About the Ring

### Connection and user identity verification
- The user ID and token need to be provided for the bound user connection, and only the ID needs to be provided for the new user connection;
- After the connection is completed, a token will be generated for the next connection;

### Monitoring

- After the ring is connected, it can be monitored through the mobile phone switch;
- The function of opening real-time data is to receive the value of blood oxygen and pulse rate per second;
- Monitoring may end automatically in some cases, such as low power, charging, space full, more than 12 hours, etc;

### Data

- 256 bytes of data are generated every 82 seconds of monitoring;
- At the end of the monitoring, the ring will store the monitored data, and the part less than 256 bytes will be discarded;
- Data is automatically deleted after being collected;
- The inner space of the ring can store 12 hours of sleep monitoring. It is recommended to check and collect data before starting a new monitoring;



## About SDK


### Initialize

1. Import the SDK to your Project.
2. Call `+[MRApi setUpWithAppId:appKey:completion:];` to setup. Contact the SDK Provider for `id` & `key`. （Callback results described in MRApi.h）

### Connection

1. Register the notification `kMRCentralStateUpdatedNotification` to observe the cellphone bluetooth status; Assign a delegate to `[MRConnecter connecter]`.

2. If `[MRConnecter connecter].isCentralPowerOn` turns YES, call `-[MRConnecter startScanning]` to scan devices, make sure the target device has enough power and is in connectable distance.

3. Implement method `-[MRConnecterDelegate connecter:didDiscoverDevice:]`; The method will be called once a device is discovered.

4. Call `-[MRConnecter connectDevice:]` to connect the target device.

5. Implement method `-[MRConnecterDelegate connecter:didUpdateDeviceConnectState:]`, The method will be called once a device is connected.

6. Then call `-[MRConnecter stopScanning]` to stop scanning. Or set `autoStopScanning = true` to automatically stop scanning after connecting the device.



###  Binding Device & User

1. Set MRDevice.delegate.

2. Implement method `-[MRDeviceDelegate bindUserIdentifier]` and `-[MRDeviceDelegate bindToken]` to provide user id and token. The userid is a 24-bit hexadecimal string. Use the token you get in step 6 to connect the old device.
    Prompt: [userid is returned by the server to the app, and then bind is set to the ring; you can ask the server to generate a 24 bit hexadecimal string returned to the app (let the server search online, there are many)]; （ Example: @"5a4331011579a30038c790de"）
3. Implement method `-[MRDeviceDelegate bindDeviceResp:]` to observe binding response. 

4. A `MRBindRespOld` comes when the same user connect the same device. 

5. If another user try to connect the device, A `MRBindRespChangeUser` will comes at first. Then call `-[MRDevice confirmChangingUser:]` to continue(YES) or end(NO) the connection. If YES, you'll reveive `MRBindRespShake`, means user should shake the ring to confirm the connection. After the shaking, at last, it will be `MRBindRespNew`. This is the process of changing a device's user.

6. Implement method `-[MRDeviceDelegate finishBindingWithToken:]` to get the new token after changing user.

7. Implement method `-[MRDeviceDelegate bindUserInfo]` to set user physical signs.



### Device control

1. Call `-[MRDevice startLiveData]` to start the live data, implement method `-[MRDeviceDelegate liveDataValueUpdated:]`, an realtime data array will be received every second when device's monitoring.

2. Call `-[MRDevice endLiveData]` to end the live data.

3. Call `-[MRDevice switchToSleepMode]` to start sleep monitoring.（Monitor for at least 30 minutes to obtain effective data）

4. Call `-[MRDevice switchToSportMode]` to start sport monitoring.（Monitor for at least 10 minutes to obtain valid data）

5. Call `-[MRDevice switchToNormalModel]` to stop monitoring.

6. Call `-[MRDevice switchToRealtimeMode]` to start realtime monitoring.

7. Call `-[MRDevice switchToPulseMode]` to start pulse monitoring.

8. Call `-[MRDevice setRawdataEnabled:]` to enable rawData, implement method `-[MRDeviceDelegate rawdataUpdated:]` or `-[MRDeviceDelegate rawdataUpdatedData:]` to receive rawData. Only certain versions are available.

9. Call -[MRDevice setPeriodicMonitorOn:afterSeconds:duration:repeat:] to set periodic monitor, the paras are on/off, seconds between now and start time, monitor duration, is repeat everyday;

10. Call -[MRDevice getMonitorTimer] to get current periodic monitor state;

<!--11. Call -[MRDevice clearCache] to clear the monitoring data in the ring has been deprecated.-->

12. Call -[MRDevice switchToBPMode] to measure blood pressure, see  DeviceManagerViewController.m.

13. Call -[MRDevice setHrvModeEnable:]  Set yes or no to determine whether HRV function is enabled; When you click sleep, the HRV function is turned on by default. When you turn off the HRV function, you can save the battery power; Note: Only 28 rings (rings that support the blood pressure monitoring function) and the firmware version is greater than or equal to 5.0.11803, the switch HRV function is supported (see the demo for how to judge.).



### Device status

This are some methods that can help getting device's status in protocol `MRDeviceDelegate`:

```
- (void)deviceDidUpdateConnectState; // Status of device connection

- (void)deviceIsReady:(BOOL)isReady; // You can check whether the hardware of the ring is good？ ；isReady == YES --- > There is no problem with the hardware of the device 。

- (void)deviceInfoUpdated; // btVersion, hwVersion, swVersion...

- (void)deviceBatteryUpdated; // batState batValue

- (void)liveDataStateUpdated; // MRLiveDataState

- (void)monitorStateUpdated; // isMonitorOn

- (void)liveDataValueUpdated:(NSArray *)liveData; // [SpO2, PR, state == 0（Valid） ==1（invalid） , duration, accx, accy, accz]

<!--- (void)deviceModeUpdated; // MRDeviceMode-->

- (void)monitorModeUpdated; // MRDeviceMode--> When the device mode is successfully switched, this agent method will be used.(when the monitoring mode changes）----- For example, from sleep monitoring to turn off monitoring, or from normal status to turn on monitoring successfully, you can view the current mode .

- (void)screenStateUpdated; // isScreenOff

- (void)operationFailWithErrorCode:(MRErrCode)errCode; 

- (void)rawdataUpdated:(NSArray *_Nullable)data; 
- (void)rawdataUpdatedData:(NSData *)data;//Callback for receiving rawData channel data stream in MRDeviceMonitorModeSleep, MRDeviceMonitorModeRealTime and MRDeviceMonitorModePulse modes. eg: In MRDeviceMonitorModeRealTime mode, Every rawdata packet has 182 bytes. The first byte is 0x5e.
- (void)bpDataUpdated:(NSData *)data // receive blood pressure data
```


### Data processing

1. Call `-[MRDevice requestData:progress:finish:]` to get data from device. Call it again until the data is nil, which means there is no more data in it. (you can view the use in the demo)
	1. MRDataTypeMonitor, sport & sleep data
	2. MRDataTypeDaily, daily data 
    3. 3. MHBLEDataRequestTypeHRV, It is a 28 ring (which supports blood pressure monitoring), and it generates HRV data when turning on sleep.   
    3. To prevent data operations from being synchronized all the time, after method finish: add xxxDevice.isDownloadingData = NO， Judge before calling this method：  when xxxDevice.isDownloadingData = YES，The return operation prevents ongoing data synchronization operations，（See DeviceManagerViewController+Methods.h use of instances）.   

2. Call `+[MRApi parseMonitorData:completion:]` to parse data (And HRV data), you will receive a `MRReport` object.

3. Call `+[MRApi parseBPData:time:caliSBP:caliDBP:block:]` to parse blood pressure data.

    3.1. Tips:   +[MRApi parseMonitorData:completion:] and
                 +[MRApi parseBPData:time:caliSBP:caliDBP:block:] methods :
                  Latest tips:   no need to verify the AppKey and AppID through the network  after v1.12.6；As long as [MRApi setUpWithAppId: appKey: completion:] successfully verifies the AppId and appKey。


4. Call +[MRApi parseDaily:data] to parse daily data, then you'll get temperature data, only valid duration sleep monitoring;
5. Call +[MRApi parseRespiratoryData:block:] to parse respiratory data, you will receive a `MRRespiratoryReport` object.;
6. When generating an HRV data report, call + [MRApi parseMonitorData: completion:] to parse the data and generate an HRV report. You can view the attribute description of ([MRReport.h]).

7. Description of HRV: after turning on sleep monitoring, HRV data will be generated when [fingers and rings remain stationary] for at least 28 minutes. (during the test, it's not easy to measure. It's best to test for a long time, because the HRV data may not be generated if the test finger shakes for a short time. It's recommended to start sleep monitoring when taking it home to sleep and collect the data the next day).

8. ECG Description: after the blood pressure detection is started, the ECG data is obtained by analyzing the data. [Turn on blood pressure monitoring and view the UI drawing details of ECG after measurement]


### Device upgrade
1. Use class `MRDeviceUpgrader` to upgrade device's firmware.
2. After device connected, assgin a firmware's absolute path to `-[MRDeviceUpgrader defaultInstance]`, then call `-[MRDeviceUpgrader start]` to start.
3. Implement the functions in protocol `MRDeviceUpgraderDelegate` to observe the status of the upgrade.
4. It is better to [#[do not upgrade from high version firmware to low version firmware]#] when testing firmware upgrade, which may cause ring error and cannot be used.

### Wearing Test
* The method to detect whether the user wears it correctly or not.
	* Switch to realtime mode `-[MRDevice switchToRealtimeMode]`.
	* Enable data notifying `-[MRDevice startLiveData]`.
	* Get acc values `-(void)liveDataValueUpdated:(NSArray *)liveData`.
	* Guide user to pose the specified gestures. If the user wears the ring correctly: accy > 0 when fingers point to the ground; accz > 0 when Palms up.

 ### Log   
 * Set whether log storage printing is enabled ` -[MRApi setMRLogEnabled:YES].
 * Set the storage path size and content of logs  ` -[MRApi setLogsPathName:@"xxxddMegaXX" tempLogFileName:@"Megaxx.txt" pathSize:500000 noTempLogFile:YES];  When it is greater than the set value (500000 ---- > 500K), a new file timestamp will be generated txt。。
    
 * Path to get log: `[MRApi getLogsForUpload]; 
 * Delete a log: `-[MRApi deleteLog:@"2011111xxxx.txt"];
 * Switch to generate a new log TXT file: `-[MRApi switchToNewLog]

 * For the log, you can also go to (MRApi.h) to view the annotation description of the method

### Recommended Workflow

![Workflow](./RecommendedWorkflow.png)



### For Swift project

You just need to put the ".framework" file into your project and select Embed & Sign.  
![](./Embed.png)


--------------------------------Some descriptions are as follows----------

One:
###****** development note - the ring may sometimes be disconnected******

1. When the signal is weak.
2. Connect frequently in a short time.
3. When the monitoring mode is switched many times in a short time.
4. When binding a new device, the ring does not shake.

Two: Some situations of ending monitoring 
     If the battery is low, charged, the space is full,set timing end, and it is used for more than 12 hours, the monitoring will end -- > and it will switch to mrdevicemonitormodenormal mode;

Three: Failure to scan the device:
    1. Low or no power  --> xxDevice.batState == MRBatteryStateLowPower ( == 3 ; low)
    2. The device is being connected: it cannot be scanned when connected to other apps or its own app.

Four: After the token expires: the binding needs to be shaken again
    1. When connecting in other apps, the connection in this app will fail again
    2. When the locally stored token is cleared, the token will become invalid when reconnecting


Five: When monitoring is enabled: [if the ring generates data every time a monitoring mode is enabled, the data in the ring will be collected to ensure that the data in the ring is empty before a monitoring mode is enabled]

Six: 
 *** Tip：please test the use in (DeviceManagerViewController.m and DeviceManagerViewController+Methods) to help you : 

        1. Data collection: after the monitoring is turned on, the ring generates data. After the monitoring is completed (after power failure and reconnection, and after restarting the app), the ring collects data: (as long as the post monitoring inspection mode is turned off, the data is collected at the beginning). You can check the simple process.
        
        2. Demo the process of obtaining ring data:
            (1) First get the dailydata data in the ring -- Type: MRDataTypeDaily.
            (2) Get the sleep data generated in the ring again -- Type: MRDataTypeMonitor.
            (3) Get HRV data in the ring -- Type: MHBLEDataRequestTypeHRV.
            
            ---------
            
            (4) [if you do not use daily daily data or generated HRV data in your project, these data are not needed. It's better to get these data; ensure that the data in the ring is empty before starting the monitoring. ( 'Three':  explanations.)] .
            (5) Our app also uses demo to collect ring data ; Of course, you can collect data of type MRDataTypeMonitor first, and then collect data of type MRDataTypeDaily ... 
            (6)Please check the methods in the demo：[-（void) requestDailySleepHRVSportDataTest Data collection process and notes：In 'DeviceManagerViewController+Methods.h' -- there are also notes on this method ].
            
        3. You can check the simple process of reconnecting after disconnection.



  Seven:
      Prompt description: 
      
        7.1 If you want to view the details of the UI generating the report, After obtaining the data, jump to SleepReportViewController, HRVReportViewController, and WorkoutReportViewController.
        
        7.2 If you want to view the UI of blood pressure monitoring and blood pressure details, TestBPViewController(UI of blood pressure monitoring), click Finish to view BPReportViewController(UI of blood pressure details).

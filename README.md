# iOS-Tip

##App Store 审核被拒原因
### 新版本提交 更新提示包含  “安卓应用市场” 2016年12月06日09:46:09 

### 打包时证书选择
####1.Save for iOS App Store Deployment
保存到本地 准备上传App Store 或者在越狱的iOS设备上使用

####2.Save for Ad Hoc Deployment
保存到本地 准备在账号添加的可使用设备上使用（具体为在开发者账户下添加可用设备的udid），该app包是发布证书编译的（The app will be code signed with the distribution certificate.）

####3.Save for Enterprise Deployment
这种主要针对企业级账户下 准备本地服务器分发的app

####4.Save for Development Deployment
针对内部测试使用，主要给开发者的设备(具体也为在开发者账户下添加可用设备的udid)。该app包是开发证书编译的（The app will be code signed with your development certificate）

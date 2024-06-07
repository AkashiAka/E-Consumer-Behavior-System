import router from '@ohos.router';
import Prompt from '@system.prompt';
import http from '@ohos.net.http';
@Entry
@Component
struct Page_14 {
  @State message: string = '分析-主界面'
  @State money:number = 0
  @State time:number = 0

  getPaymentStats() {
    const httpRequest = http.createHttp();
    httpRequest.request(
      'http://localhost:3000/payment-stats', // URL 应为字符串
      {
        method: http.RequestMethod.GET, // 使用正确的枚举类型
        header: { 'Content-Type': 'application/json' }, // 设置正确的请求头
        readTimeout: 60000, // 读取超时
        connectTimeout: 60000 // 连接超时
      }
    ).then((data) => {
      const response = JSON.parse(data.result as string); // 确保 result 是字符串类型
      if (data.responseCode === 200) {
        // 请求成功，处理返回的数据
        console.log('获取支付统计信息成功');
        this.money = response.avgAmount; // 更新状态
        this.time = response.avgCount; // 更新状态
      } else {
        // 请求失败，显示错误信息
        Prompt.showDialog({
          message: '获取支付统计信息失败: ' + response.message,
        });
      }
    }).catch((err) => {
      // 网络错误或其他错误
      console.error('获取支付统计信息请求错误:', err); // 输出完整的错误对象
      Prompt.showDialog({
        message: '网络错误: ' + err,
      });
    });
  }
  build() {
      Column() {
        Row(){
          Text('<返回')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              router.back({url:"pages/Index"})
            })
            .margin({
              top:'40vp',
              left:'10vp'
            })
        }.justifyContent(FlexAlign.Start)
        .width('100%')
        Row(){
          Text('全部数据')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }.margin({right:180,
                  top:50  })
        Row(){
          Column(){
            Text('平均缴费金额')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Text('￥'+this.money)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#209EA6')}
              .margin({top:50})
          Button('所有用户类型')
            .type(ButtonType.Normal)
            .width(125)
            .height(100)
            .borderRadius(10)
            .backgroundColor(Color.Green)
            .margin({top:50})
            .onClick(()=>{
              router.pushUrl({
                url:'pages/classification'
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
        }.justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        Row(){
          Column(){
            Text('平均缴费次数')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Text(this.time +'次')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#209EA6')}
              .margin({top:50})
          Button('预测高价值TOP5')
            .type(ButtonType.Normal)
            .width(125)
            .height(100)
            .borderRadius(10)
            .backgroundColor(Color.Green)
            .margin({top:50})
            .onClick(()=>{
              router.pushUrl({
                url:'pages/Top5',
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
        }.justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        Button('重新上传')
          .type(ButtonType.Normal)
          .width(300)
          .height(50)
          .borderRadius(10)
          .backgroundColor(Color.Blue)
          .margin({top:80})
          .onClick(()=>{
            router.back({url:"pages/upload"})
          })
      }
      .width('100%')
      .height('100%')
      .onAppear(() => {
        this.getPaymentStats()
      });
  }
}
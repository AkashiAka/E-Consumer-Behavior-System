import router from '@ohos.router';
@Entry
@Component
struct Info {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Row(){
        Text('< 返回')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            router.back({url:"pages/Index"})
          })
          .margin({
            top:'40vp',
            left:'10vp'
          })
      }
      .width('100%')

      Text('电了吗电力用户行为分析')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
        .margin({top:20})
      Text('版本1.0')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
        .margin({top:20})
      Column(){
        Text('功能：')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20})
        Text('1.计算平均缴费金额与次数')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20,right:120})
        Text('2.对每个居民客户的用电缴费情况按照四种居民客户类型进行归类')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20})
        Text('3.预测最有可能成为高价值客户的TOP5')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20,right:10})
        Text('4.根据电力客户数据编码，建立电力用户用电模型')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20})
        Text('5.根据不同的标准对用户进行集群划分')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:20,right:20})
        Text('前端实现：桂筠懿，叶振宇')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({top:40})
        Text('后端接口：文杰')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
        Text('模型训练与数据处理：赵阳军')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
      }.height('100%')
    }
    }
  }
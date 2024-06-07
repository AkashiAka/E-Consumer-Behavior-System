import router from '@ohos.router';
import Prompt from '@system.prompt';
import http from '@ohos.net.http';
class customer {
  name:string
  probability:number
  top:number
  constructor(name:string,probability:number,top:number) {
    this.name = name
    this.probability = probability
    this.top = top
  }
}
@Entry
@Component
struct Page_16 {
  @State message: string = 'TOP 5'
  @State private customers:Array<customer> = []


  getCsvData() {
    const httpRequest = http.createHttp();
    httpRequest.request(
      'http://localhost:3000/csv3-data', // URL 应为字符串
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
        console.log('获取CSV数据成功');
        this.customers = response.map((item: any, index: number) =>
        new customer(
          item['用户编号top5'],
          parseInt(item['预测用电量']),
          index + 1
        ))
        console.log(JSON.stringify(this.customers, null, 2));
      } else {
        // 请求失败，显示错误信息
        const errorMessage = '获取CSV数据失败: ' + response.message;
        console.error(errorMessage);
        Prompt.showDialog({
          message: errorMessage,
        });
      }
    }).catch((err) => {
      // 网络错误或其他错误
      const errorMessage = '网络错误: ' + err.message;
      console.error('获取CSV数据请求错误:', err);
      Prompt.showDialog({
        message: errorMessage,
      });
    });
  }


  build() {
      Column() {
        Row() {
          Text('<返回')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .onClick(()=>{
              router.back()
            })
            .margin({
              top:'40vp',
              left:'10vp'
            })
        }.justifyContent(FlexAlign.Start)
        .width('100%')
        Column(){
          Text('高价值预测TOP5')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
          Text('预测月份：20XX.XX')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        Text('预测结果')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({right:250,top:100})}
        Column(){
          Text('TOP       用户         预测用电量   ')
            .fontSize(20)
            .fontColor(Color.Green)
            .fontWeight(FontWeight.Bold)
          ForEach(
            this.customers,
            (customers:customer) => {
              Row(){
                Text(customers.top.toString())
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .margin({left:50})
                Text(customers.name)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .margin({right:10})
                Text(customers.probability.toString())
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .margin({right:70})
              }.justifyContent(FlexAlign.SpaceBetween).width('100%')
            }
          )
        }
      }
      .width('100%')
    .height('100%')
      .onAppear(() => {
        this.getCsvData()
      });
  }
}
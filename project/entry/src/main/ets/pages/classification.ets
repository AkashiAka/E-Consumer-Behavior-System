import router from '@ohos.router';
import Prompt from '@system.prompt';
import http from '@ohos.net.http';
class customer {
  userid:number
  money:number
  frequency:number
  type:string

  constructor(userid:number,money:number,frequency:number,type:string) {
    this.userid = userid
    this.money = money
    this.frequency = frequency
    this.type = type
  }
}

@Entry
@Component
struct Page_15 {
  @State message: string = '分析-用户分类'
  @State private customers:Array<customer> = []
  @State type1:number = 0
  @State type2:number = 0
  @State type3:number = 0
  @State type4:number = 0

  getCsvData() {
    const httpRequest = http.createHttp();
    httpRequest.request(
      'http://localhost:3000/csv2-data',
      {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
        readTimeout: 60000,
        connectTimeout: 60000
      }
    ).then((data) => {
      const response = JSON.parse(data.result as string);
      if (data.responseCode === 200) {
        console.log('获取CSV数据成功');
        this.customers = response.map((item) =>
        new customer(
          parseInt(item['用户编号'])-1000000000,
          parseFloat(item['缴费金额']) / parseInt(item['缴费次数']),
          parseInt(item['缴费次数']),
          item['客户类型']
        )
        );
        this.customers.forEach(customer => {

          if (customer.type === "高价值型客户") {
            this.type1++;
          }
          else if (customer.type === "大众型客户") {
            this.type2++;
          }
          else if (customer.type === "潜力型客户") {
            this.type3++;
          }
          else{
            this.type4++;
          }
          console.log(this.type4.toString());
        });
      } else {
        const errorMessage = '获取CSV数据失败: ' + response.message;
        console.error(errorMessage);
        Prompt.showDialog({
          message: errorMessage,
        });
      }
    }).catch((err) => {
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

        Text('所有用户类型')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 50, right: 90 })
        DataPanel({ values: [this.type1,this.type2,this.type3,this.type4], max: this.type1+this.type2+this.type3+this.type4, type: DataPanelType.Line }).width(360).height(30)
        Row(){
          Text('高价值: '+this.type1).fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F5B621')
          Text('大众型: '+this.type2).fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F1521E')
          Text('潜力型: '+this.type3).fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#EE64A1')
          Text('低价值: '+this.type4).fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#A64CEF')
        }
        .justifyContent(FlexAlign.SpaceBetween).width('100%')
        Text('用户  平均缴费金额   缴费次数  类型')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Green)
          .margin({top:50})
        List(){
          ForEach(
            this.customers,
            (customer: customer) => {
              ListItem(){
                Row(){
                  Text(''+customer.userid)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .width('25%')
                  Text('￥'+customer.money.toFixed(2).toString())
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .width('25%')
                  Text(customer.frequency.toString() + '次')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .width('25%')
                  Text(customer.type)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .textAlign(TextAlign.Center)
                    .width('25%')
                }.justifyContent(FlexAlign.SpaceBetween).width('100%')
              }
            }
          )
        }
        .height(400)
        Button('下载')
          .width(300)
          .height(50)
          .type(ButtonType.Normal)
          .backgroundColor(Color.Green)
          .borderRadius(10)
          .backgroundColor(Color.Green)
          .margin({top:20})
      }
      .width('100%')
      .height('100%')
      .onAppear(() => {
        this.getCsvData()
      });
  }
}
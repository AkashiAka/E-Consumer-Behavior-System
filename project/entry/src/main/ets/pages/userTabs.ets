import router from '@ohos.router';
import Prompt from '@system.prompt';
import http from '@ohos.net.http';
class GDP {
  name:string
  Average:number
  GDP_top:string
  Average_GDP:number
  power_top:number
  constructor(name:string,Average:number,GDP_top:string,Average_GDP:number,power_top:number) {
    this.name = name
    this.Average = Average
    this.GDP_top = GDP_top
    this.Average_GDP = Average_GDP
    this.power_top = power_top
  }
}
@Entry
@Component
struct UserTabs {
  @State message: string = '集群分析-分类展示'
  @State private gdp:Array<GDP> = []

  getCsvData() {
    const httpRequest = http.createHttp();
    httpRequest.request(
      'http://localhost:3000/gdp-electricity-data', // URL 应为字符串
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
        this.gdp = response.map((item: any) =>
        new GDP(
          item['地区'],
          parseFloat(item['近10年单位用电量GDP平均值']),
          item['近10年单位用电量GDP平均值排行'],
          parseInt(item['近10年年均GDP排行']),
          parseInt(item['近10年年均用电量排行'])
        ))
        console.log(JSON.stringify(this.gdp, null, 2));
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
  private controller:TabsController = new TabsController()

  build() {
    Row() {
      Column() {
        Row() {
          Text('< 返回')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              router.back({ url: "pages/Index" })
            })
            .margin({
              top: '40vp',
              left: '10vp'
            })
        }
        .width('100%')

        Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
          TabContent() {
            Column(){
              Image($r('app.media.5_fengzhi_line_chart')).width(400)
              Image($r('app.media.5_fengzhi_kmeans_figure')).width(400)
              Image($r('app.media.5_fengzhi_initial_figure')).width(400)
            }
              .width('100%')
              .height('100%')

          }
          .tabBar('峰值分类')

          TabContent() {
            Column(){
              Image($r('app.media.5_jiguang_line_chart')).width(400)
              Image($r('app.media.5_jiguang_kmeans_figure')).width(400)
              Image($r('app.media.5_jiguang_initial_figure')).width(400)
            }
              .width('100%')
              .height('100%')

          }
          .tabBar('企业分类')
          TabContent() {
            Column(){
              Image($r('app.media.5juleichu_selection')).width(400)
              Image($r('app.media.5juleijieguo1')).width(400)
              Image($r('app.media.5juleijieguo2')).width(400)
            }
              .width('100%')
              .height('100%')

          }
          .tabBar('用电特征聚类分析')
          TabContent() {
            Column(){
              Image($r('app.media.5two_user_bi')).width(400)
              Image($r('app.media.5two_user_show')).width(400)
            }
              .width('100%')
              .height('100%')

          }
          .tabBar('缴费行为分类')
          TabContent() {
            Column(){
              Text('地区 用电GDP平均 用电量GDP排行 GDP排行 用电排行')
                .fontSize(14)
                .fontColor(Color.Green)
                .fontWeight(FontWeight.Bold)
              ForEach(
                this.gdp,
                (gdp:GDP) => {
                  Row(){
                    Text(gdp.name.toString())
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                    Text(gdp.Average.toString())
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .margin({right:10})
                    Text(gdp.GDP_top.toString())
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .margin({right:10})
                    Text(gdp.Average_GDP.toString())
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .margin({right:10})
                    Text(gdp.power_top.toString())
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .margin({right:10})
                  }.justifyContent(FlexAlign.SpaceBetween).width('100%')
                }
              )
            }
              .width('100%')
              .height('100%')

          }
          .tabBar('省份GDP电量关系')
          TabContent() {
            Column(){Image($r('app.media.5power')).width(400)}
              .width('100%')
              .height('100%')

          }
          .tabBar('能源分类')
        }
        .barMode(BarMode.Scrollable)
        .barWidth('100%')
        .barHeight(60)
        .width('100%')
        .height('100%')
      }
    }      .onAppear(() => {
      this.getCsvData()
    });
  }

}
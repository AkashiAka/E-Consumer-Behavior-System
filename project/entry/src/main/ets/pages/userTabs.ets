import router from '@ohos.router'
@Entry
@Component
struct UserTabs {
  @State message: string = '集群分析-分类展示'
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
            Column(){Image($r('app.media.5_fengzhi_line_chart')).width(400)
              Image($r('app.media.5_fengzhi_kmeans_figure')).width(400)
              Image($r('app.media.5_fengzhi_initial_figure')).width(400)
            }
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('峰值分类')

          TabContent() {
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('企业分类')
          TabContent() {
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('用电特征聚类分析')
          TabContent() {
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('用户分类')
          TabContent() {
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('缴费行为分类')
          TabContent() {
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('省份GDP电量关系')
          TabContent() {
            Column()
              .width('100%')
              .height('100%')
              .backgroundColor(Color.Gray)
          }
          .tabBar('能源分类')
        }
        .barMode(BarMode.Scrollable)
        .barWidth('100%')
        .barHeight(60)
        .width('100%')
        .height('100%')
      }
    }
  }}
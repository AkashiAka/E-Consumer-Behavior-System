import router from '@ohos.router';
@Entry
@Component
struct Index {
  @State message: string = '主界面'
  //@State username: string = router.getParams()['username']
  build() {
      Column({space:10}) {
        Column() {
          Image($r('app.media.head'))
            .width(100)
          Text(this.message)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({top:10})
          Button('软件信息')
            .margin({top:10})
            .onClick(()=>{
              router.pushUrl({
                url:'pages/info'
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
        }
        .margin({top:50})
        Row() {
          Button('用电归类')
            .onClick(()=>{
              router.pushUrl({
                url:'pages/upload',
                params:{mode:1}
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
            .type(ButtonType.Normal)
            .width('125')
            .height('125')
            .borderRadius(10)
            .backgroundColor(Color.White)
            .fontColor(Color.Black)
            .fontSize(22)
            .borderWidth(1)
          Button('历史记录')
            .onClick(()=>{
              router.pushUrl({
                url:'pages/history'
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
            .type(ButtonType.Normal)
            .width('125')
            .height('125')
            .borderRadius(10)
            .backgroundColor(Color.White)
            .fontColor(Color.Black)
            .fontSize(22)
            .borderWidth(1)
        }
        .margin({top:50})
        .justifyContent(FlexAlign.SpaceBetween)
        .width('80%')
        .height('10%')
        Row() {
          Button('用电调度')
            .onClick(()=>{
              router.pushUrl({
                url:'pages/upload',
                params:{mode:2}
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
            .type(ButtonType.Normal)
            .width('125')
            .height('125')
            .borderRadius(10)
            .backgroundColor(Color.White)
            .fontColor(Color.Black)
            .fontSize(22)
            .borderWidth(1)
          Button('集群分析')
            .onClick(()=>{
              router.pushUrl({
                url:'pages/upload',
                params:{mode:3}
              },router.RouterMode.Single,
                err => {
                  if(err){
                    console.log('路由失败')
                  }
                }
              )
            })
            .type(ButtonType.Normal)
            .width('125')
            .height('125')
            .borderRadius(10)
            .backgroundColor(Color.White)
            .fontColor(Color.Black)
            .fontSize(22)
            .borderWidth(1)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('80%')
        .height('10%')
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      .height('80%')

  }
}
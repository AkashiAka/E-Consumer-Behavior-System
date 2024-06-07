import router from '@ohos.router';

@Entry
@Component
struct Page_19 {
  @State message: string = '4'
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
      Text('输入数据批次')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Image($r('app.media.4input_data_plot'))
        .width(400)
      Text('聚类图')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Image($r('app.media.4cluster_plot'))
        .width(400)

  }//.backgroundColor(Color.Gray)
}
}
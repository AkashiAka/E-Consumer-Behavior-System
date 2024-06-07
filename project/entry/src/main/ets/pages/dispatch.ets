import router from '@ohos.router';

@Entry
@Component
struct Page_19 {
  @State message: string = '4'
  build() {
    Column() {
        Text('< 返回')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(()=>{
            router.back({url:"pages/Index"})
          })
      Image($r('app.media.clean'))
        .width(100)

  }
}
}
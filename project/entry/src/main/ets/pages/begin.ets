import router from '@ohos.router'
@Entry
@Component
struct begin {
  @State translateY_Logo:number = 0    //定义一个用@state修饰的number型变量translateY_Logo
  @State translateY_Title:number = 0    //定义一个用@state修饰的number型变量translateY_Title
  build() {
    Row() {
      Column() {
        //删除页面初始化时默认带有的Text组件, 增加一个新的image组件和一个新的Text组件
        Image($r('app.media.icon'))
          .height(120)
          .width(120)
            //添加关键属性
          .translate({
            y:this.translateY_Logo
          })
          .animation({
            //播放时长（ms）
            duration:5000,
            //播放速度
            tempo:1,
            //播放曲线，所选择的是‘慢出快入’
            curve:Curve.LinearOutSlowIn,
            //延迟（ms）
            delay:2000,
            //循环次数（-1为无限循环）
            iterations:1,
            //播放模式
            playMode:PlayMode.Normal
          })

        Text('电死了吗')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .margin({
            top:7
          })
            //添加关键属性
          .translate({
            y:this.translateY_Title
          })
          .animation({
            delay:2000,
            duration:5000,
            curve:Curve.LinearOutSlowIn,
            tempo:1,
          })
            //增加onAppear回调
          .onAppear(()=>{
            //改变属性参数
            this.translateY_Logo = -500
            this.translateY_Title = 500

            //设置定时器
            let id = setInterval(()=>{
              //打印日志
              console.info('router to Second')
              //页面跳转
              router.replaceUrl({
                url:'pages/Indexbeforelogin'
              })
              //定时器执行之后立即销毁
              clearInterval(id)
            },6000,[])
          })

      }
      .width('100%')
    }
    .height('100%')
  }
}
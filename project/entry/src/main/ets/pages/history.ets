class file {
  id:string
  time:string
  type:string

  constructor(id:string,time:string,type:string) {
    this.id = id
    this.time = time
    this.type = type
  }
}
import router from '@ohos.router';
import Prompt from '@system.prompt'
import http from '@ohos.net.http'
@Entry
@Component
struct Page_17 {
  @State message: string = '历史记录'
  @State private files:Array<file> = []
  onLoadComplete(Tape:string) {
    // 跳转到另一个页面
    if (Tape==='居民用电分类') {
      router.pushUrl({
        url: 'pages/analysis'
      }, router.RouterMode.Single,
        err => {
          if (err) {
            console.log('路由失败');
          }
        }
      )
    }
    else if(Tape==='企业用电分析'){
      router.pushUrl({
        url: 'pages/dispatch'
      }, router.RouterMode.Single,
        err => {
          if (err) {
            console.log('路由失败');
          }
        }
      )
    }
    else{
      router.pushUrl({
        url: 'pages/userTabs'
      }, router.RouterMode.Single,
        err => {
          if (err) {
            console.log('路由失败');
          }
        }
      )
    }
  }
  fetchOperationLogs() {
    const httpRequest = http.createHttp();
    console.log('Fetching operation logs...');
    httpRequest.request(
      'http://localhost:3000/log-operation',
      {
        method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' },
        readTimeout: 60000,
        connectTimeout: 60000
      }
    ).then((data) => {
      console.log('Response data:', data.result);
      try {
        const logs = JSON.parse(data.result.toString());
        console.log('Parsed logs:', JSON.stringify(logs));

        // Debugging: Check the structure of each log entry
        logs.forEach((log, index) => {
          console.log(`Log ${index}: id=${log.id}, timestamp=${log.timestamp}, operation=${log.operation}`);
        });

        this.files = logs.map((log) => {
          // 创建文件实例并返回
          const fileInstance = new file(log.id, log.timestamp, log.operation);
          console.log('Created file instance:', JSON.stringify(fileInstance)); // Debugging
          return fileInstance;
        });

        console.log('Updated files state:', JSON.stringify(this.files));
      } catch (e) {
        console.error('JSON parsing error:', e, 'Response data:', data.result);
        Prompt.showDialog({
          message: 'JSON解析错误: ' + e.message,
        });
      }
    }).catch((err) => {
      console.error('Network error:', err);
      Prompt.showDialog({
        message: '网络错误: ' + err,
      });
    });
  }
  deleteLog(logId: string) {
    const httpRequest = http.createHttp(); // 创建 HTTP 请求实例
    httpRequest.request(
      `http://localhost:3000/log-operation/${logId}`,
      {
        method: http.RequestMethod.DELETE,
        header: { 'Content-Type': 'application/json' },
        readTimeout: 60000,
        connectTimeout: 60000
      }
    ).then((data) => {
      // 处理删除成功的情况
      console.log('Operation log deleted successfully:', data.result);
      // 在成功删除后，你可能还需要更新界面，例如从this.files中删除相应的记录
      const updatedFiles = this.files.filter(file => file.id !== logId);
      this.files = updatedFiles;
    }).catch((err) => {
      // 处理删除失败的情况
      console.error('Error deleting operation log:', err);
      Prompt.showDialog({
        message: '删除操作记录失败: ' + err,
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
      Text('历史记录')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({top:30,right:200})
      Column(){
        Text('  编号        提交时间         类型       删除 ')
          .fontSize(20)
          .fontColor(Color.Green)
          .fontWeight(FontWeight.Bold)
          .margin({top:30})
      }
      List(){
        ForEach(
          this.files,
          (files:file,index) => {
            ListItem(){
              Row(){
                Text('10-'+files.id)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.Blue)
                  .textAlign(TextAlign.Center)
                  .onClick(()=>{
                    const Type = files.type;
                    this.onLoadComplete(Type)
                  })
                  .width('25%')
                Text(files.time)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('25%')
                Text(files.type)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .width('25%')
                Image($r('app.media.clean'))
                  .onClick(() => {
                    this.files.splice(index,1)
                    const logId = files.id; // 获取要删除的操作记录的ID
                    this.deleteLog(logId);
                  })
                  .width(30)

              }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({top:10})
            }
          }
        )
      }
      .margin({right:'20vp'})
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      this.fetchOperationLogs();
    });
  }
}
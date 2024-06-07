import router from '@ohos.router';
import Prompt from '@system.prompt';
import http from '@ohos.net.http';

class Item {
  id: number;
  name: string;
  image: ResourceStr;

  constructor(id: number, name: string, image: ResourceStr) {
    this.id = id;
    this.name = name;
    this.image = image;
  }
}

@Entry
@Component
struct Page_18 {
  @State message: string = '文档';
  @State mode_name:string = ''
  @State private items: Array<Item> = [];
  @State mode: number = router.getParams()['mode'];
  log_operation() {
    const timestamp = new Date().toISOString();
    const operation = this.mode_name;
    const requestData = {
      timestamp: timestamp, // 获取当前时间，格式化为ISO字符串
      operation: operation // 替换为实际的操作内容
    };

    console.log('Request data:', requestData); // 打印请求数据

    const httpRequest = http.createHttp();
    httpRequest.request(
      'http://localhost:3000/log-operation',
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(requestData),
        readTimeout: 60000,
        connectTimeout: 60000
      }
    ).then((data) => {
      console.log('Response data:', data.result);
      try {
        const response = JSON.parse(data.result.toString());
        if (data.responseCode === 201 && response.message === 'Operation logged successfully') {
          console.log('操作记录成功');
          // 根据需要添加其他操作，例如页面跳转
        } else {
          Prompt.showDialog({
            message: '操作记录失败: ' + response.message,
          });
        }
      } catch (e) {
        console.error('JSON parsing error:', e, 'Response data:', data.result);
        Prompt.showDialog({
          message: 'JSON解析错误: ' + e.message,
        });
      }
    }).catch((err) => {
      Prompt.showDialog({
        message: '网络错误: ' + err,
      });
    });
  }
  item_input() {
    const newItems: Array<Item> = [];
    if (this.mode === 1) {
      for (let i = 1; i <= 8; i++) {
        this.mode_name = '居民用电分类'
        newItems.push(new Item(i, `居民用电分类${i}.xlsx`, $r('app.media.xlsx')));
      }
    } else if (this.mode === 2) {
      for (let i = 1; i <= 4; i++) {
        this.mode_name = '企业用电分析'
        newItems.push(new Item(i, `企业用电分析${i}.csv`, $r('app.media.xlsx')));
      }
      for (let i = 5; i <= 8; i++) {
        newItems.push(new Item(i, `企业用电分析${i-4}.xlsx`, $r('app.media.xlsx')));
      }
    } else {
      for (let i = 1; i <= 8; i++) {
        this.mode_name = '集群分析'
        newItems.push(new Item(i, `集群分析${i}.csv`, $r('app.media.xlsx')));
      }
    }
    this.items = newItems;
  }

  onLoadComplete(selectedId: number) {
    // 跳转到另一个页面，并带上所选择文章的id
    router.pushUrl({
      url: 'pages/loading',
      params: {
        mode: this.mode,
        selectedId: selectedId
      }
    }, router.RouterMode.Single,
      err => {
        if (err) {
          console.log('路由失败');
        }
      });
  }

  build() {
    Column() {
      Row() {
        Text('< 返回')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.back();
          })
          .margin({
            top: '40vp',
            left: '10vp'
          });
      }
      .width('100%');

      Text('请选择已存储至库中的文件')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 });

      List({ space: 10 }) {
        ForEach(this.items, (item: Item) => {
          ListItem() {
            Row({ space: 10 }) {
              Image(item.image).width(100);
              Column() {
                Text(`${item.id}: ${item.name}`)
                  .fontSize(18)
                  .fontColor('#444')
                  .fontWeight(FontWeight.Bold);
                Button('选择')
                  .width(150)
                  .fontSize(18)
                  .backgroundColor(Color.Gray)
                  .margin({ top: 20 })
                  .onClick(() => {
                    this.log_operation();
                    this.onLoadComplete(item.id);
                  });
              }
              .alignItems(HorizontalAlign.Start);
            }
            .width('100%')
            .padding({ left: 14, right: 14 })
            .backgroundColor('#fff')
            .borderRadius(8);
          }
          .width('100%');
        });
      }
      .height('80%')
      .margin({ top: 10 })
      .padding({ bottom: 10 });
    }
    .onAppear(() => {
      this.item_input();
    });
  }
}

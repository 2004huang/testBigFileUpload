//测试媒体服务器地址 https://47.92.29.183:4443
//媒体服务器地址
const serverIp = '192.168.4.154'; //媒体服务器IP *必须参数
const serverPort = 4443;  //媒体服务器port *必须参数
const secure = true; // 服务器是否为https 默认为https,secure = true;
//peerId 当前用户的ID，必须为唯一值，是用户唯一标识
const peerId = Math.random().toString(36).substring(2, 15);

const curroomId = '20572541210'; //roomId 房间号

const displayName = 'testpeer'; //本用户的显示名称

//以下参数为预留值，暂时不用改动，不做修改即可
const produce = false; // 是否开启授权开启自己音视频 暂不修改
const consume = false; // 是否开启接收对方音视频 暂不修改
const device = { flag: 'testdevice' }; // 设备平台名称，可自定义flag值
const SDK = true;  // SDK 为true，不可修改
const meetConfig = {
	mainAudio:1, // 自己是创建者是否开启音频
	mainVideo:1, // 自己是创建者是否开启视频
	participantVideo:1, // 自己是非创建者是否开启视频
	participantAudio:1, // 自己是非创建者是否开启音频
	isCreateUser:1 // 是否房间创建者 1 是 | 0 否
};

window.fileUrl = 'https://doc.kaihuibao.net';

// 初始化client对象
let roomClient = new RoomClient({
	SDK,
	serverIp,
	serverPort,
	secure,
	roomId:curroomId,
	peerId,
	device,
	displayName,
	produce,
	consume,
	meetConfig
});

let contextList={}; // 视频内canvas标注context预存

/**
 * 发送IM消息
 * chatMessage = {
                type : 'message',
                sender:'response',
                text : '消息内容',
                time : Date.now(),
                name : 发送者的名字
                ...
		    }
 * name :消息类型 可自定义
 * to: 接受者peerId默认'_all_'
 */
// roomClient.sendMessage(chatMessage,  name = 'chat', to = '_all_');
/**
 * 单独发送chat可用 sendChatMsg
 */
// roomClient.sendChatMsg(chatMessage, peerId);

/**
 * 收到IM chat消息
 */
roomClient._eventListener.on('chat', (data) => {
	console.log('chat', data);
});
/**
 * 发送IM pub-msg自定义类型消息
 * data={
 *     to, 接受消息者，'_all_' => 所有人不包括自己 || '_all_and_sender_' => 所有人包括自己 || 'peerId' => 单个peer
 *     id, 消息id，判断是否同一类消息，
 *     name, 消息类型
 *     body, 消息类型 object || string || number
 *     save  消息是否保存 0 | 1   1代表保存 保存了的消息可以在历史消息函数记录收到
 * }
 */
// roomClient.sendPubMsg(data);

/**
 * 收到IM自定义类型消息
 */
roomClient._eventListener.on('pub-msg', (data) => {
	try
	{
		console.log('pub-msg', data);
		const { from, name, body } = data;
		/**
		 * from :来自谁发的消息
		 * name : 消息类型
		 * body : 消息内容
		 */
		console.log('pub-msg data', from, name, body);

		switch (name)
		{
			case 'chat':
			{

				break;
			}
			case 'draw':
			{
				onMessage(data);
				break;
			}
			case 'drawRect':
			{
				const { peerId, rect } = body;

				if (!contextList[peerId])
				{
					var canvas = document.getElementById('canvas-' + peerId);

					if (!canvas)
					{
						console.log('not find canvas');
						return;
					}
					var context = canvas.getContext('2d');  //getContext() 方法可返回一个对象
					contextList[peerId] = context;
					contextList[peerId] = {
						context,
						canvas
					};
				}
				console.log(contextList);

				clearRect(peerId);

				for (var i=0; i< rect.length; i++)
				{
					var { x, y, w, h } = rect[i];

					drawRect(peerId, x, y, w, h);
				}

				break;
			}
		}
	}
	catch (e)
	{
		console.error('pub-msg error', e);
	}
});

/**
 * 收到历史消息记录
 * msgs <array>
 */
roomClient._eventListener.on('msg-history', (msgs) => {
	console.log('msg-history', msgs);
});
/**
 * 发送IM 删除消息
 * data={
 *     to, 接受消息者，'_all_' => 所有人不包括自己 || '_all_and_sender_' => 所有人包括自己
 *     id, 消息id，判断是否同一类消息，
 *     name, 消息类型
 *     body, 消息类型 object || string || number
 * }
 */
// roomClient.sendDelMsg(data);
/**
 * 收到IM 删除消息
 * data ：object
 */
roomClient._eventListener.on('del-msg', (data) => {
	const { from, name } = data;

	console.log('del-msg', data);
	try
	{
		switch (name)
		{
			case '':
			{

				break;
			}
			case '':
			{
				break;
			}
		}
	}
	catch (e)
	{
		console.error('delMsg err', e);
	}

});


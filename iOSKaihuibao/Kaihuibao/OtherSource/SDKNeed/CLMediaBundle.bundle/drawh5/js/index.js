// (function (doc, win) {
//     const GW = 750,
//     docEl = doc.documentElement,
//     resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
//     recalc = function () {
//         const clientWidth = docEl.clientWidth;

//         if (!clientWidth)
//             return;
//         // if (clientWidth >= GW)
//         {
//             docEl.style.fontSize = `${100 * (clientWidth / GW) }px`;
//         }
//         // else
//         // {
//         // 	docEl.style.fontSize = `${100 * (clientWidth / GW) }px`;
//         // }
//     };

//     if (!doc.addEventListener)
//         return;
//     recalc();
//     win.addEventListener(resizeEvt, recalc, false);
//     doc.addEventListener('DOMContentLoaded', recalc, false);

//     /* DOMContentLoaded文档加载完成不包含图片资源 onload包含图片资源*/
// })(document, window);

var lc = null,
tools,
url,
strokeWidths,
clientWidth,
clientHeight,
setCurrentByName,
findByName,
selectedShape = {},
LCinit,
curStrokeWidth = 5,
curColor = '#0000FF',
selectTool,
JPEG_IMAGE,
isShareDoc = false,
isMeShare = false,
drawTool,
gap = 8;
var localUrl = location.href;
var shareBox = document.querySelector('.share-box');

var isDraw = localUrl.indexOf('drawh5.html') >= 0 || false;
var isDoc = localUrl.indexOf('document.html') >= 0 || false;
var isImage = localUrl.indexOf('image.html') >= 0 || false;
var istool = false;
var historyDraw = null, remoteDraw = null,
docDraw = null;
var shareFile = JSON.parse(localStorage.getItem('shareFile')) || {};

// var roomId = 172634230,
var roomId,
token,
userId;
var initLang=null;

var drawStyle = {
    width: 0,
    height: 0,
    scale: 1
},
naturalStyle = {
    width: 0,
    height: 0,
    scale: 1
},
shareStyle = {
    width: 0,
    height: 0,
    scale: 1
};
var webUrl;
// webUrl = 'http://w.kaihuibao.net';
// webUrl = 'https://192.168.4.69:443';
// webUrl = 'http://192.168.4.69:90';
webUrl = 'https://doc.kaihuibao.net';

var getUrlParam = function (name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)
        return unescape(r[2]);
    return null;
}
var UpdateUrlParam = function (name, val) {
    var thisURL = window.location.href;
    var pathname = window.location.pathname;
    var search = window.location.search;
    var urlArr =pathname.split('/');
    // var filename=urlArr[urlArr.length-1];
    console.log('urlArr00', urlArr)

    if (name == 'image') {
        urlArr[urlArr.length-1] = 'image.html';
    } else {
        urlArr[urlArr.length-1] = 'document.html';
    }

    console.log('urlArr11', urlArr)
    console.log('urlArr222', urlArr.join('/'))

    thisURL = urlArr.join('/')+search;

    console.log('thisURL111', thisURL)

    // if (name == 'image') {
    //     thisURL = thisURL.replace('document.html', 'image.html');
    // } else {
    //     thisURL = thisURL.replace('image.html', 'document.html');
    // }

    // 如果 url中包含这个参数 则修改
    if (thisURL.indexOf(name + '=') > 0) {
        var v = getUrlParam(name);
        if (v != null) {
            // 是否包含参数
            thisURL = thisURL.replace(name + '=' + v, name + '=' + val);

        } else {
            thisURL = thisURL.replace(name + '=', name + '=' + val);
        }

    } // 不包含这个参数 则添加
    else {
        if (thisURL.indexOf("?") > 0) {
            thisURL = thisURL + "&" + name + "=" + val;
        } else {
            thisURL = thisURL + "?" + name + "=" + val;
        }
    }
    console.log('thisURL', thisURL);

    location.href = thisURL;
    return thisURL;
};

function sendmsg(msg, name = 'draw') {
    const message = {
        to: '_all_' || '_all_',
        id: Date.now(),
        name: name,
        body: msg,
        save: 0,
        // from : 1,  //消息发布者
        // ts   : 1,  //消息时间戳
        // seq  : 1  //消息序列号
    };
    console.log('message', message);
    // channel.emit('pub-msg', message);

    window.roomClient && window.roomClient.sendPubMsg(message);
}

// 当接受消息时  receive
// window.Share && window.Share.send('disableDrawShare');
// window.onMessage
var isgetdoc=isDoc;
var msgLsit=[];
function onMessage(data) {
    console.log('onMessage data:', data);
    try {
        if (data == 'null' || !data) {
            console.log('空消息:', data);
            return;
        }
        console.log('typeof:', typeof data);
        if (typeof data === 'string') {
            data = JSON.parse(data);
        }

        var content = data.content ? data.content : data;
        console.log('ToShapes content', content);

        // 文档消息
        if (data.name == 'document') {
            console.log('document', data);

            if (Array.isArray(content) && content.length) {
                var file = content[0];

                localStorage.shareFile = JSON.stringify(file);

                if (data.page) {
                    pageNum = localStorage.pageNum = data.page;
                }
                $('#fileList').hide();

                UpdateUrlParam(file.file_type, file.url);

            } else if (content.file) {
                var file = content.file[0];
                if (content.page) {
                    pageNum = data.page;
                }
                $('#fileList').hide();

                UpdateUrlParam(file.file_type, file.url);

            } else if (data.page) {

                if(isDoc)
                {
                    renderPage(data.page);
                }
                else{
                    renderImg(data.page);
                }
            }
        }
        // 画板消息
        else {
            if (!window.drawlc){
                localStorage.docDraw = JSON.stringify(content);

                return;
            }
            if (content.shapes) {
                remoteDraw = content;
                if (window.drawlc) {
                    window.drawlc.loadSnapshot(content);
                    setZoom(window.drawlc);
                }
            } else if (content.id) {
                var shape = content;
                var last = window.LC.JSONToShape(shape);
                console.log(last);

                var shapes = window.drawlc.shapes;

                shapes.forEach((s, i) => {
                    if (s.id === shape.id) {
                        shapes.splice(i, 1);

                        return;
                    }
                });

                setZoom(window.drawlc);
                lc.saveShape(last, false);
                lc.repaintAllLayers();
            }

            if (content === 'clear') {
                lc.clear(false);
            } else if (content === 'undo') {
                lc.undo(false);
            } else if (content === 'redo') {
                lc.redo(false);
            }
        }
    } catch (e) {
        console.log('onMessage err', e);
    }
}

function sendHistDraw() {
    console.log('sendHistDraw  ios调用');
    console.log('window.historyDraw:', historyDraw);

    try {
        var data;
        if (isDraw) {
            data = historyDraw;
        } else {
            data = docDraw;
        }
        if (window.Share) {
            // 安卓把数据发出去
            console.log('sendHist:', JSON.stringify(data));
            window.Share.sendHist(JSON.stringify(data));
        } else {
            // ios把数据返给他
            return data
        }
    } catch (e) {
        console.log('window.historyDraw: err', e);
    }
}

Array.prototype.remove = function (val) {
    var index = this.indexOf(val);
    if (index > -1) {
        this.splice(index, 1);
    }
};

var box = document.getElementById('literally');
var pdfcanvas = document.querySelector('.pdf-box');
var toolset = document.getElementById("toolset");

window.addEventListener('beforeunload', function () {
    historyDraw = null,
    remoteDraw = null;
    docDraw = null;
    if(!isDoc){
        window.localStorage.setItem('docDraw', '{}');
    }
})

function sendDrawApp(data) {
    data = {
        content: data,
        name: 'draw'
    };
    console.log('sendDrawApp', data);
    sendIos(data);
    sendAndroid(data);

    sendmsg(data);
}
function sendDocApp(file, page) {
    var data = {
        content: file,
        page: page,
        name: 'document'
    };
    console.log('sendDocApp', data);
    sendIos(data);
    sendAndroid(data);

    sendmsg(data);
}
function sendIos(data) {
    try {
        if (window.webkit) {
            console.log('sendIos', data);
            window.webkit.messageHandlers.send.postMessage(data);
        }
    } catch (error) {
        console.error('sendIos window.webkit：send', error);
    }
}

function sendTouch(data) {
    try {
        if (window.webkit) {
            console.log('sendIosTouch', data);
            window.webkit.messageHandlers.touch.postMessage(data);
        }
        if (window.Share) {
            console.log('sendAndroidTouch:', data);
            window.Share.touch(data);
        }
    } catch (error) {
        console.error('sendTouch window sendTouch', error);
    }
}

function sendTouchTool(data) {
    try {
        if (window.webkit) {
            console.log('sendIosTouchTool', data);
            window.webkit.messageHandlers.touchTool.postMessage(data);
        }
        if (window.Share) {
            console.log('sendAndroidTouchTool:', data);
            window.Share.touchTool(data);
        }
    } catch (error) {
        console.error('sendTouchTool window sendTouchTool', error);
    }
}

function sendAndroid(data) {
    try {
        if (window.Share) {
            if (typeof data !== 'string') {
                data = JSON.stringify(data);
            }
            // data.content=JSON.stringify(data.content);
            // console.log('sendAndroid:', data);
            window.Share.send(data);
        }
    } catch (error) {
        console.error('sendAndroid window.Share', error);
    }
}

// window.addEventListener('load', function () {
//     try {
//         console.log('window load:', window.Share);
//         if (window.Share) {
//             window.Share.onload();
//         }
//     } catch (error) {
//         console.error('load window.Share', error);
//     }
// })

function domLoad() {
    try {
        console.log('window load:', window.Share);
        if (window.Share) {
            window.Share.onload();
        }
    } catch (error) {
        console.error('load window.Share', error);
    }
}

function teardown() {
    if (lc) {
        lc.teardown();
        lc = null;
    }
}

var isfull = false;
var isClick = false;
var touchtime = Date.now();
var cTimer = null;

function setFullwh(isfull) {
    console.log('clientHeight', clientHeight);
    console.log('clientWidth', clientWidth);
    if (isfull) {
        var w = Number(clientHeight * 16 / 9);
        console.log('toFixed clientHeight', w);
        console.log('toFixed w', w);
        $(box).width(w).height(clientHeight);
        $(".no-draw").width(w).height(clientHeight);
    } else {
        var h = clientWidth * 9 / 16;
        console.log('toFixed h', h);
        $(".no-draw").width(clientWidth).height(h);
        $(box).width(clientWidth).height(h);
    }
    showLC();
}

function clicksendIosTouch() {
    console.log("istool", istool)
    if (!istool) {
        if (isClick) {
            isClick = false;
        } else {
            isClick = true;
        }
        console.log('isClick', isClick);
        sendTouch(isClick);
        console.log('sendTouch');
    }
}

$('.fs-container').on('click', function (e) {
    // e.stopPropagation();
    // e.preventDefault();
    if (!(e.target.id == 'Cancel' || e.target.id == 'Add' || e.target.id == 'change-0' || e.target.id == 'change-1')) {
        // $(".tool").removeClass('show');
        // $(".toolset").removeClass('active');
        $(".color-poupe").removeClass('show');
    }

    console.log(clientWidth);
    if (Date.now() - touchtime < 250) {
        clearTimeout(cTimer);
        // console.log("dbclick")
        // 如果是共享文档双击无效
        if (!isDraw)
        {
            return;
        }
        if (isfull) {
            isfull = false;
        } else {
            isfull = true;
        }
        setFullwh(isfull);
        console.log('dbclick  isfull', isfull);
    } else {
        touchtime = Date.now();
        cTimer = setTimeout(clicksendIosTouch, 300)
            $(".set-wid").toggleClass('show', false);
    }
});

var touchCanvastime = Date.now();
var CanvasTimer = null;

function docTouchend(e) {
    console.log(45854158145);
    e.stopPropagation();
    e.preventDefault();
    return false
}

$("#tools-icon").bind('click', function (e) {
    e.stopPropagation();
    $(".toolset").toggleClass('active');
    $(".tool").toggleClass('show');
    $(".set-wid").toggleClass('show', false);

    if (!istool) {
        istool = true;
        $(".no-draw").addClass('hide');
        // $('.fs-container').removeClass('doc');
    } else {
        // console.log( historyDraw );

        istool = false;
        $('#setWidth').removeClass('active');
        $(".no-draw").removeClass('hide');
        // $('.fs-container').addClass('doc');
    }
    console.log('sendTouchTool', istool);
    sendTouchTool(istool);
});
$("#tool-color").bind('click', function (e) {
    e.stopPropagation();
    var pencil = new LC.tools.Pencil(lc);
    pencil.strokeWidth = curStrokeWidth;
    lc.setTool(pencil);
    lc.setColor('primary', curColor);
    $(".set-wid").toggleClass('show');
    $(this).addClass('active').siblings().removeClass('active');
    $('#tool-pencil').addClass('active').siblings().removeClass('active');
});

$(".toolset").bind('click', function (e) {
    if (e.target.id !== 'tool-color') {
        $(".color-poupe").removeClass('show');
    }
});

$(".color-poupe").bind('touchend', function (e) {
    e.stopPropagation();
    e.preventDefault();
    var target = e.target;
    var val = target.getAttribute('color');
    $(".set-wid").toggleClass('show', false);
    $(".color-poupe").removeClass('show');
    curColor = val;
    lc.setColor('primary', val);
    $("#tool-color").css('background', val);
    window.localStorage.setItem('color', val);
});
function setZoom(lc) {
    var w = $(box).width();
    var scale = w / 960;
    scale = scale.toFixed(2);
    console.log('scale', scale);
    lc.setZoom(scale);
    lc.setPan(0, 0);
}
function size(width, height) {
    clientWidth = document.documentElement.clientWidth || document.body.offsetWidth;
    clientHeight = document.documentElement.clientHeight || document.body.offsetHeight;

    if (pdfcanvas) {
        // $(box).width(width).height(height);
    } else if (JPEG_IMAGE) {
        // $(box).width(clientWidth).height(clientHeight);
    } else {
        if (clientWidth < clientHeight) {
            $(box).width('100%').height(clientWidth * 9 / 16);
            // $(pdfContainer).width('100%').height(clientWidth * 9 / 16);
            $('.no-draw').width('100%').height(clientWidth * 9 / 16);
        } else {
            $(box).width(clientWidth).height('100%');
            // $(pdfContainer).width(clientWidth).height('100%');
            $('.no-draw').width(clientWidth).height('100%');
        }
    }

    return true
}

window.addEventListener('orientationchange' in window ? 'orientationchange' : 'resize', onresize)
function onresize(width, height) {
    if (!height && isDoc) {
        location.href = '';
        return;
    }
    size(width, height);
    setTimeout(function () {
        $('.toolset').removeClass('hide');

        showLC();
        $(".toolset").css({
            left: '28px',
            bottom: '100px',
            top: 'auto'
        });
    }, 150)
}
function showLC() {
    teardown();
    function init(lc) {
        console.log('lc', lc);
        window.drawlc = lc;
        lc.setColor('primary', curColor);
        lc.trigger('setStrokeWidth', curStrokeWidth);
        var Timer = setTimeout(function () {
                setZoom(lc);
                clearTimeout(Timer);
            }, 200);

        if (!isDraw) {
            return; // 如果不是白板不发送
        }
        if (isMeShare) {
            var data = JSON.parse(window.localStorage.getItem('drawing'));
            sendDrawApp(data ? data : 'clear');
        } else {
            remoteDraw && lc.loadSnapshot(remoteDraw);
        }
    }
    function LCinit() {
        console.log('LCinit', historyDraw);
        if (window.LC){
            lc = LC.init(box, {
                snapshot: isDraw ? JSON.parse(window.localStorage.getItem('drawing')) : JSON.parse(window.localStorage.getItem('docDraw')),
                // defaultStrokeWidth: 5,
                // strokeWidths: [1, 2, 5, 10, 20, 30],
                secondaryColor: 'transparent',
                onInit: init
            });
        }
    }
    LCinit();

    if (!window.LC || !lc) return;
    var Event = {
        onSave: function (data) {
            data = lc.getSnapshot();
            console.log('drawingChange', data, 'isMeShare', isMeShare);
            // 如果不是共享画板记录不保存
            if (!isDraw) {
                docDraw = data;
                window.localStorage.setItem('docDraw', JSON.stringify(data));

                return;
            }

            if (isMeShare) {
                historyDraw = data;

                window.localStorage.setItem('drawing', JSON.stringify(data));
            } else {
                remoteDraw = data;
            }
        },
        newShapeSave: function (data) {
            var shape = data.shape;
            console.log(data);
            shape = LC.shapeToJSON(shape);
            console.log('shape：', shape);
            // console.log(JSON.stringify(data));
            sendDrawApp(shape);
        },
        onClear: function () {
            sendDrawApp('clear');
        },
        onUndo: function () {
            sendDrawApp('undo');
        },
        onRedo: function () {
            sendDrawApp('redo');
        },
        onSnapshotLoad: function (data) {
            console.log(data);
        },
        onShapeMoved: function (data) {
            var shape = data.shape;
            console.log(data);
            shape = LC.shapeToJSON(shape);
            sendDrawApp(shape);
        },
        onShapeSelected: function (data) {
            selectedShape = data.selectedShape;
            console.log(data);
            console.log(selectedShape);
        },
        onRepaint: function (data) {
            console.log(data);
        },
        onsetStroke: function (data) {
            console.log(data);
        },
        onDidUpdate: function (data) {
            console.log(data);
        },
    };

    lc.on('drawingChange', Event.onSave);
    lc.on('shapeSave', Event.newShapeSave);
    lc.on('clear', Event.onClear);
    lc.on('undo', Event.onUndo);
    lc.on('redo', Event.onRedo);
    lc.on('snapshotLoad', Event.onSnapshotLoad);
    lc.on('shapeMoved', Event.onShapeMoved);
    lc.on('shapeSelected', Event.onShapeSelected);
    // lc.on('repaint', Event.onRepaint);
    lc.on('setStrokeWidth', Event.onsetStroke);
    lc.on('toolDidUpdateOptions', Event.onDidUpdate);

    $(document).on('keydown', function (e) {
        if (e.keyCode == 37)
            lc.pan(-10, 0);
        if (e.keyCode == 38)
            lc.pan(0, -10);
        if (e.keyCode == 39)
            lc.pan(10, 0);
        if (e.keyCode == 40)
            lc.pan(0, 10);
        if (e.keyCode >= 37 && e.keyCode <= 40) {
            e.preventDefault(); // prevents keyboard page scrolling!
            lc.repaintAllLayers();
        }
        if (e.keyCode == 8) {
            // lc.shapes.remove(selectedShape);
            // console.log(lc.shapes);
            // e.preventDefault();
            // lc.repaintAllLayers();
        }
    });

    // Set up our own tools...
    tools = [{
            name: 'pencil',
            el: document.getElementById('tool-pencil'),
            tool: function () {
                pencil = new LC.tools.Pencil(lc);
                pencil.strokeWidth = curStrokeWidth;
                return pencil;
            }
            ()
        }, {
            name: 'eraser',
            el: document.getElementById('tool-eraser'),
            tool: function () {
                eraser = new LC.tools.Eraser(lc);
                eraser.strokeWidth = curStrokeWidth;
                return eraser;
            }
            ()
        }, {
            name: 'text',
            el: document.getElementById('tool-text'),
            tool: new LC.tools.Text(lc)
        }, {
            name: 'line',
            el: document.getElementById('tool-line'),
            tool: new LC.tools.Line(lc)
        }, {
            name: 'arrow',
            el: document.getElementById('tool-arrow'),
            tool: function () {
                arrow = new LC.tools.Line(lc);
                arrow.hasEndArrow = true;
                return arrow;
            }
            ()
        }, {
            name: 'dashed',
            el: document.getElementById('tool-dashed'),
            tool: function () {
                dashed = new LC.tools.Line(lc);
                dashed.isDashed = true;
                return dashed;
            }
            ()
        }, {
            name: 'ellipse',
            el: document.getElementById('tool-ellipse'),
            tool: new LC.tools.Ellipse(lc)
        }, {
            name: 'tool-rectangle',
            el: document.getElementById('tool-rectangle'),
            tool: new LC.tools.Rectangle(lc)
        }, {
            name: 'tool-polygon',
            el: document.getElementById('tool-polygon'),
            tool: new LC.tools.Polygon(lc)
        }, {
            name: 'tool-select',
            el: document.getElementById('tool-select'),
            tool: new LC.tools.SelectShape(lc)
        }, {
            name: 'tool-pan',
            el: document.getElementById('tool-pan'),
            tool: new LC.tools.Pan(lc)
        }
    ];

    strokeWidths = [{
            name: 2,
            el: document.getElementById('sizeTool-1'),
            size: 2
        }, {
            name: 5,
            el: document.getElementById('sizeTool-2'),
            size: 5
        }, {
            name: 10,
            el: document.getElementById('sizeTool-3'),
            size: 10
        }, {
            name: 20,
            el: document.getElementById('sizeTool-4'),
            size: 20
        }, {
            name: 30,
            el: document.getElementById('sizeTool-5'),
            size: 30
        }
    ];

    setCurrentByName = function (ary, val) {
        ary.forEach(function (i) {
            $(i.el).toggleClass('current', (i.name == val));
        });
    };

    findByName = function (ary, val) {
        var vals;
        vals = ary.filter(function (v) {
                return v.name == val;
            });
        if (vals.length == 0)
            return null;
        else
            return vals[0];
    };
    var wsArr = ['pencil', 'eraser', 'arrow', 'tool-rectangle'];
    var setWidth = $('#setWidth');
    // Wire tools
    tools.forEach(function (t) {
        $(t.el).bind('touchend', function (e) {
            e.stopPropagation();
            if (t.name == 'eraser' || t.name == 'pencil') {
                t.tool.strokeWidth = curStrokeWidth;
            }
            if (t.name == 'text') {
                t.tool.font = "bold 24px sans-serif";
            }
            lc.setColor('primary', curColor);
            lc.setTool(t.tool);
            if ($(this).hasClass('active') && wsArr.indexOf(t.name) > -1) {
                setWidth.toggleClass('active');
            } else {
                $(this).addClass('active').siblings().removeClass('active');
                setCurrentByName(tools, t.name);
                setCurrentByName(strokeWidths, t.tool.strokeWidth);
                $('#tools-sizes').toggleClass('disabled', (t.name == 'text'));
                setWidth.removeClass('active');
            }
            $(".set-wid").toggleClass('show', false);
        });
    });
    setCurrentByName(tools, tools[0].name);

    // Wire Stroke Widths
    // NOTE: This will not work until the stroke width PR is merged...
    strokeWidths.forEach(function (sw) {
        $(sw.el).bind('touchend', function () {
            console.log(sw);
            console.log(lc);
            curStrokeWidth = sw.size;
            lc.trigger('setStrokeWidth', sw.size);
            setCurrentByName(strokeWidths, sw.name);
        })
    })

    setCurrentByName(strokeWidths, strokeWidths[1].name);

    $("#open-image").bind('touchend', function () {

        var canvas = lc.canvas;
        var w = $(box).width();
        var h = $(box).height();

        var c = document.createElement('canvas');
        var ctx = c.getContext('2d');
        var dataURL = canvas.toDataURL();
        var img = new Image();
        var openImg = document.getElementById('openImg');

        img.src = dataURL;
        img.width = w;
        img.height = h;
        c.width = w;
        c.height = h;

        ctx.fillStyle = '#ffffff';

        ctx.fillRect(0, 0, w, h);
        ctx.fillStyle = 'rgba(255,255,255,0.1)';

        img.onload = () => {
            ctx.drawImage(img, 0, 0, w, h);
            var DataURL = c.toDataURL('image/png');

            openImg.href = DataURL;
            var e = document.createEvent('MouseEvents');

            e.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
            openImg.dispatchEvent(e);
        };
        // $(this).addClass('active').siblings().removeClass('active');
    });

    $("#change-size").bind('touchend', function () {
        lc.setImageSize(null, 200);
        $(this).addClass('active').siblings().removeClass('active');
    });

    $("#reset-size").bind('touchend', function () {
        lc.setImageSize(null, null);
        $(this).addClass('active').siblings().removeClass('active');
    });

    $("#clear-lc").bind('touchend', function () {
        lc.clear(true);
        // $(this).addClass('active').siblings().removeClass('active');
        $(".set-wid").toggleClass('show', false);
        $(this).addClass('active');
        setTimeout(() => {
            $(this).removeClass('active');
        }, 200);
    });

    $("#change-1").bind('touchend', function () {
        lc.zoom(lc.config.zoomStep);
        $(this).addClass('active').siblings().removeClass('active');
    });

    $("#change-0").bind('touchend', function () {
        lc.zoom(-lc.config.zoomStep);
        $(this).addClass('active').siblings().removeClass('active');
    });

    $("#Cancel").bind('touchend', function (e) {
        if (lc) {
            lc.undo(true);
        }
        // $(this).addClass('active').siblings().removeClass('active');
        $(".set-wid").toggleClass('show', false);
        $(this).addClass('active');
        setTimeout(() => {
            $(this).removeClass('active');
        }, 200);
    });
    $("#Add").bind('touchend', function (e) {
        if (lc) {
            lc.redo(true);
        }
        $(".set-wid").toggleClass('show', false);
        $(this).addClass('active');
        setTimeout(() => {
            $(this).removeClass('active');
        }, 200);
        // $(this).addClass('active').siblings().removeClass('active');
    });

};

function drag(div2) {
    console.log('drag', div2);
    if(!div2) return;

    var flag = false;
    var setWid = $('.set-wid');
    var cur = {
        x: 0,
        y: 0
    }
    var nx,
    ny,
    dx,
    dy,
    x,
    y;
    function down() {
        flag = true;
        var touch;
        if (event.touches) {
            touch = event.touches[0];
        } else {
            touch = event;
        }
        cur.x = touch.clientX;
        cur.y = touch.clientY;
        dx = div2.offsetLeft;
        dy = div2.offsetTop;
    }
    function move() {
        if (flag) {
            var touch;
            if (event.touches) {
                touch = event.touches[0];
            } else {
                touch = event;
            }
            nx = touch.clientX - cur.x;
            ny = touch.clientY - cur.y;
            x = dx + nx;
            y = dy + ny;

            if (x <= 0)
                x = 0;
            if (x >= clientWidth - 30)
                x = clientWidth - 30;
            if (y <= 0)
                y = 0;
            if (y >= clientHeight - 36)
                y = clientHeight - 36;
            div2.style.left = x + "px";
            div2.style.top = y + "px";
            if (y < 140) {
                setWid.addClass('top');
            } else {
                setWid.removeClass('top');
            }
            //阻止页面的滑动默认事件
            document.addEventListener("touchmove", function () {
                event.preventDefault();
            }, false);
        }
    }
    //鼠标释放时候的函数
    function end() {
        flag = false;
    }
    // var div2 = document.getElementById("toolset");

    div2.addEventListener("touchstart", function () {
        down();
    }, false)
    div2.addEventListener("touchmove", function () {
        move();
    }, false)
    div2.addEventListener("touchend", function () {
        end();
    }, false);
}

function docInit() {
    isShareDoc=true; // 判断已经共享了文件
    if(shareBox){
        var w = shareBox.offsetWidth;
        var h = shareBox.offsetHeight;
        shareStyle = {
            width: w,
            height: h,
            scale: w / h
        };
    }

    // 如果 url中包含这个参数 则不显示列表
    if ((window.location.href.indexOf('image' + '=') >= 0) || (window.location.href.indexOf('file' +
                '=') >= 0)) {
        $('#fileList').hide();
        showLoading();

        if (isDoc) {
            if (url == 'null' || !url) {
                mui.toast(Language.shareFail);
            } else {
                // 如果分享的文档不一样就清空白板记录
                if (url != localStorage.docUrl)
                {
                    localStorage.docUrl = url;
                    window.localStorage.setItem('docDraw', '{}');
                }
                winResize();
            }
        } else {
            if (!JPEG_IMAGE || JPEG_IMAGE == 'null') {
                mui.toast(Language.shareFail);
            } else {
                 // 如果分享的文档不一样就清空白板记录
                 if (JPEG_IMAGE != localStorage.docUrl)
                 {
                     localStorage.docUrl = url;
                     window.localStorage.setItem('docDraw', '{}');
                 }
                winResize();
            }
        }
    } else {
        if (!JPEG_IMAGE && !url)
        {
            console.log('showLoading', );
            showLoading();
        }
    }
    // winResize();
    window.addEventListener('orientationchange' in window ? 'orientationchange' : 'resize', winResize)
    initData();
}

function initData() {
    drag(pdfTool);
    mui.init();

    mui('.mui-scroll-wrapper').scroll();
    mui('body').on('shown', '.mui-popover', function (e) {
        console.log('shown', e.detail.id); //detail为当前popover元素
    });
    mui('body').on('hidden', '.mui-popover', function (e) {
        console.log('hidden', e.detail.id); //detail为当前popover元素
    });

    $('#scaleList').on('click', function (e) {
        console.log(e.target);
        var val = $(e.target).attr('value');
        var text = $(e.target).html();
        $('#scaleSelectContainer .mui-navigate-right').html(text);
        setScaleVal(val);
        mui('#topPopover').popover('hide');
    });
}

// 新人进来发送文件和页码给他
function sendNewPeerFile() {
    try {
        // 如果共享时候有新人进来，就不发送；
        if ((window.location.href.indexOf('image=') ===-1) && (window.location.href.indexOf('file=') ===-1)) {
            return;
        }

        var file = [shareFile];
        var page = pageNum;

        var data = {
            content: file,
            page: page,
            name: 'document'
        };

        console.log('sendNewPeerFile:', data);

        if (window.Share) {
            // 安卓把数据发出去
            window.Share.sendHist(JSON.stringify(data));
        } else {
            // ios把数据返给他
            return data
            // sendIos(data);
        }
    } catch (e) {
        console.error('sendNewPeerFile: err', e);
    }
}

function setShare(data) {
    if (typeof data == 'string') {
        data = JSON.parse(data);
    }
    // data={
    //     isMeShare:true,
    //     webUrl : 'https://w.kaihuibao.net',
    //     // webUrl : 'http://192.168.4.48:90',
    //     roomId:'20572541210',
    //     // roomId:'172634230',
    //     lang:'zh-CN',
    //     token:'187d18a1-0518-4347-8aa5-e1ef524656ab'
    // };
    console.log('isMeShare data', data);
    isMeShare = data.isMeShare;
    roomId = data.roomId;
    token = data.token;
    userId = data.userId;
    webUrl = data.webUrl;
    lang = data.lang || lang;

    setLang(lang);
    // 安卓调用
    domLoad();

    if (!isMeShare) {
        $('.peer-hidden').addClass('hide');
        if(document.getElementById('page_num')){
            document.getElementById('page_num').disabled = true;
        }
    }

    if (isMeShare && isDoc) {
        // getFileHistory();
        // getCloudFiles();
    }
    else if(!isMeShare && !isDraw){
        if (!JPEG_IMAGE && !url)
        {
            console.log('JPEG_IMAGE', JPEG_IMAGE);

            showLoading();
        }
    }

    drag(toolset);

    if (isMeShare && (isImage || isDoc)) {
        $('#end-share').removeClass('hide');
    }

    initLang && initLang(isMeShare);
}
// 移动端退出共享调用方法
function endWebview(){
    // endShare
    try {
        console.log('endWebview');
        if (window.webkit) {
            console.log('endShare webkit');
            window.webkit.messageHandlers.endShare.postMessage('');
        }
        if (window.Share) {
            console.log('endShare Share');
            window.Share.endShare();
        }
    } catch (error) {
        console.error('endWebview', error);
    }
}

$(document).ready(function () {
    $(document).bind('touchmove', function (e) {
        if (e.target === document.documentElement) {
            return e.preventDefault();
        }
    });

    FastClick.attach(document.body);
    url = getUrlParam('file');
    JPEG_IMAGE = getUrlParam('image');

    var params = window.location.href.substring(window.location.href.lastIndexOf("?") + 1);
    // if (params.indexOf('vConsole') >= 0) {
    if (0) {
        // var vConsole = new VConsole(); // 初始化
        console.log('vConsole is cool');
    } else {
        window.console.log = function () {
            return;
        };
    }

    clientWidth = document.documentElement.clientWidth || document.body.offsetWidth;
    clientHeight = document.documentElement.clientHeight || document.body.offsetHeight;

    if (isDraw) {
        onresize(1, 1);
    } else if (isDoc) {
        docInit();
    } else if (isImage) {
        docInit();
    }

    $(".pdf-tool").bind('click', function (e) {
        e.stopPropagation();
    });

    console.log('load ready! ');
    // document.write(12315);
    if($(window).width() === 375 && $(window).height() === 812 && window.devicePixelRatio === 3){
        $(document.body).addClass("iphone");
    }
    if($(window).width() === 414 && $(window).height() === 896){
        $(document.body).addClass("iphone");
    }

    // setShare({
    //     isMeShare:true,
    //     webUrl : 'https://kaihuibao.net',
    //     // webUrl : 'http://192.168.4.48:90',
    //     roomId:'20572541210',
    //     // roomId:'172634230',
    //     lang:'zh',
    //     // lang:'en-US',
    //     token:'187d18a1-0518-4347-8aa5-e1ef524656ab'
    // });
});

function setDrawTool(data) {
    console.log('setDrawTool', data);
    if(data){
        $('#toolset').show();
    }else
    {
        $('#toolset').hide();
    }
}


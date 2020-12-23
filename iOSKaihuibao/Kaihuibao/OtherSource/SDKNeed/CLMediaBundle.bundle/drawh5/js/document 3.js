var pdfDoc = null,
pageNum = localStorage.pageNum || 1,
curPage = null,
curViewport = null,
defaultScale = 'page-fit',
scale = 1,
pageRendering = false,
pageNumPending = null,
scale = 0.8, //放大系数
canvas = document.getElementById('pdf-canvas'),
ctx = canvas.getContext('2d'),
container = document.querySelector('.pdf-box'),
pdfTool = document.querySelector('.pdf-tool');

var clientWidth,
clientHeight,
isNext = null,
isPrve = null,
isIn = null,
isOut = null;
var renderTimer=null;
//
// Get page info from document, resize canvas accordingly, and render page
//
function renderPage(num) {
    if (typeof num == 'string') {
        num = Number(num);
    }

    localStorage.pageNum = pageNum = num;

    clearInterval(renderTimer);
    renderTimer=setInterval(() =>
    {
        if (!pageRendering)
        {
            clearInterval(renderTimer);
            pageRendering = true;

            // Using promise to fetch the page
            pdfDoc.getPage(num).then(function (page) {
                curPage = page;

                var viewport = curViewport = page.getViewport(1);
                // console.log('viewport000', viewport);
                // var curScale=fitW/viewport.width;
                naturalStyle = {
                    width: viewport.width,
                    height: viewport.height,
                    scale: viewport.width / viewport.height
                };

                pageRender();
                // 发送页面消息给其他人
            });
            document.getElementById('page_num').value = pageNum;
            document.getElementById('page_count').textContent = pdfDoc.numPages;
        }
    }, 10);
}

function pageRender(scale) {
    if (!scale) {
        var pageWidthScale = (clientWidth - gap) /
        curViewport.width * curViewport.scale;
        var pageHeightScale = (clientHeight - gap) /
        curViewport.height * curViewport.scale;

        if (clientWidth < clientHeight) {
            scale = pageWidthScale;
        } else {
            scale = Math.min(pageWidthScale, pageHeightScale);
        }
    }

    console.log('curScale', scale)

    // var curviewport = curPage.getViewport(1);
    var curviewport = curPage.getViewport(1);
    // console.log('viewport111', curviewport)

    canvas.height = curviewport.height;
    canvas.width = curviewport.width;
    ctx.clearRect(0,0,canvas.width,canvas.height);
    // Render PDF page into canvas context
    var renderContext = {
        canvasContext: ctx,
        viewport: curviewport
    };
    curPage.render(renderContext).then(() =>
    {
        pageRendering = false;
        drawStyle = {
            width: curviewport.width*scale,
            height: curviewport.height*scale,
            // scale: curviewport.width / curviewport.height
        };

        setContainer();
    });

}

function setContainer() {
    var left,
    top;
    var width = drawStyle.width;
    var height = drawStyle.height;

    // console.log('shareStyle', shareStyle)
    if (width > shareStyle.width) {
        left = gap / 2;
    } else {
        left = (shareStyle.width - width) / 2;
    }

    if (height > shareStyle.height) {
        top = gap / 2;
    } else {
        top = (shareStyle.height - height) / 2;
    }

    $(container).css({
        width: width,
        height: height,
        left: left,
        top: top
    });
    $(box).css({
        width: width,
        height: height,
        left: left,
        top: top
    });
    $('.no-draw').css({
        width: width,
        height: height,
        left: left,
        top: top
    });
    onresize(width, height);
    if (msgLsit.length===2)
    {
        onMessage(msgLsit[1]);
    }
    if ($(shareBox).width() < $(canvas).width()) {
        // $(canvas).removeClass('center');
    } else {
        // $(canvas).addClass('center');
    }
}

function goPrevious() {
    if (pageNum <= 1)
        return;

    if (!isPrve) {
        pageNum--;
        renderPage(pageNum);
        sendDocApp([], pageNum);

        if (lc)
        {
            lc.clear(true);
        }

        isPrve = setTimeout(() => {
                clearTimeout(isPrve);
                isPrve = null;
            }, 1000);
    } else {
        // showTip(2);
    }
}

function goNext() {
    if (pageNum >= pdfDoc.numPages)
        return;

    if (!isNext) {
        pageNum++;
        renderPage(pageNum);
        sendDocApp([], pageNum);
        if (lc)
        {
            lc.clear(true);
        }
        isNext = setTimeout(() => {
                clearTimeout(isNext);
                isNext = null;
            }, 1000);
    } else {
        // showTip(2);
    }
}

function chooseFile() {
    $('.pdf-tool').toggleClass('close');
}

function winResize() {

    pdfjsLib.disableWorker = false;
    pdfjsLib.GlobalWorkerOptions.workerSrc = './js/pdf.worker.js';

    if (clientWidth < clientHeight) {
        $(shareBox).removeClass('height');
    } else {
        $(shareBox).addClass('height');
    }

    initPdf(url);
}
function initPdf(url) {
    pdfjsLib.getDocument(url).then(function getPdfHelloWorld(_pdfDoc) {
        pdfDoc = _pdfDoc;
        hideLoading();

        console.log('pdfDoc', pdfDoc)

        renderPage(pageNum);
    });
}

$(function () {
    // window.addEventListener('orientationchange' in window ? 'orientationchange' : 'resize', winResize)
    // drag(pdfTool);

    // mui.init();

    // mui('.mui-scroll-wrapper').scroll();
    // mui('body').on('shown', '.mui-popover', function(e) {
    //     console.log('shown', e.detail.id);//detail为当前popover元素
    // });
    // mui('body').on('hidden', '.mui-popover', function(e) {
    //     console.log('hidden', e.detail.id);//detail为当前popover元素
    // });

    // $('#scaleList').on('click', function (e) {
    //     // console.log(e.target);
    //     var val=$(e.target).attr('value');
    //     var text=$(e.target).html();
    //     $('#scaleSelectContainer .mui-navigate-right').html(text);
    //     setScaleVal(val);
    //     mui('#topPopover').popover('hide');
    // });

});

function scalePage(value) {
    value = parseFloat(value);
    console.log('scalePage value', value);
    console.log(pageNum, 'pageNum');
    pdfDoc.getPage(pageNum).then(function (page) {
        curPage = page;
        var viewport = page.getViewport(value);
        canvas.height = viewport.height;
        canvas.width = viewport.width;
        var renderContext = {
            canvasContext: ctx,
            viewport: viewport
        };
        page.render(renderContext);

        drawStyle = {
            width: viewport.width,
            height: viewport.height,
            scale: viewport.width / viewport.height
        };

        setContainer();
    });
}

// console.log('pdfjsLib', pdfjsLib)
function zoomin() {
    if (scale <= 0.2)
        return;

    if (!isIn) {
        scale -= 0.2;
        // console.log(scale)
        // $(canvas).width(100*scale+'%');
        // zoom(scale);
        scalePage(scale);

        isIn = setTimeout(() => {
                clearTimeout(isIn);
                isIn = null;
            }, 1000);
    } else {
        // showTip(2);
    }
}

function zoomout() {
    if (scale >= 1.4)
        return;

    if (!isIn) {
        scale += 0.2;
        // console.log(scale)
        scalePage(scale);

        isIn = setTimeout(() => {
                clearTimeout(isIn);
                isIn = null;
            }, 1000);
    } else {
        // showTip(2);
    }
}

function setScaleVal(val) {
    var s;
    var curScale;
    var viewport = curViewport;

    var pageWidthScale = (clientWidth - gap) /
    curViewport.width * curViewport.scale;
    var pageHeightScale = (clientHeight - gap) /
    curViewport.height * curViewport.scale;

    switch (val) {
    case 'page-actual':
        s = 1;
        break;
    case 'page-fit': {
            if (clientWidth < clientHeight) {
                curScale = pageWidthScale;
            } else {
                curScale = Math.min(pageWidthScale, pageHeightScale);
            }

            s = curScale;
        }
        break;
    case 'page-width':
        s = pageWidthScale;
        break;
    case 'page-height':
        s = pageHeightScale;
        break;
    default:
        s = val;
        break;
    }

    scalePage(s);
}

$('#page_num').on('change', function (e) {
    console.log(e.target.value);
});

$(window).keydown(function (event) {
    // Auto-focus the current input when a key is typed
    // if (!(event.ctrlKey || event.metaKey || event.altKey)) {
    //   $currentInput.focus();
    // }
    if (event.which === 13) {
        pageNum = $('#page_num').val();

        renderPage(pageNum);
        sendDocApp([], pageNum);

        if (lc)
        {
            lc.clear(true);
        }
    }
});

$('#openFile').on('change', function (e) {
    var file = document.getElementById("openFile").files[0];
    var userId = '';
    var formData = new FormData();
    formData.append('file', file);
    formData.append('name', e.target.value);
    formData.append('roomId', this._roomId);
    formData.append('peerName', userId);

    console.log(formData);
    // $.post(webUrl+'/api/confdoc/upload',formData,function (res) {
    //     console.log('文件上传',res);
    //     if (res.code ==1){
    //         console.log(res.data)
    //         initPdf(res.data.url);
    //     }
    // })

    // $.ajax({
    //     type:"post",//请求方式
    //     url:webUrl+'/api/confdoc/upload',//发送请求地址
    //     // timeout:30000,//超时时间：30秒
    //     dataType:"json",//设置返回数据的格式
    //     //请求成功后的回调函数 data为json格式
    //     beforeSend: function() {
    //         // 开始进度条
    //         // begeinProgress(10);
    //     },
    //     complete: function(){
    //     // 设置 进度条到80%
    //     },
    //     success:function(data){
    //         console.log(data);
    //         if(data.code == 0){
    //             // doClearInterval();
    //             setProgress(progressbar, 100);
    //         }
    //     },
    //     //请求出错的处理
    //     error:function(){
    //         // doClearInterval();
    //         alert("请求出错");
    //     }
    // });

    // url = 'https://www.p-y.xyz/car.pdf';

    if (URL.createObjectURL) {
        var url = URL.createObjectURL(file);
        if (file.name) {
            url = {
                url,
                originalUrl: file.name,
            };
        }
        initPdf(url);
    } else {
        var fileReader = new FileReader();
        fileReader.onload = function webViewerChangeFileReaderOnload(evt) {
            var buffer = evt.target.result;
            file = new Uint8Array(buffer);

            initPdf(file);
        };
        fileReader.readAsArrayBuffer(file);
    }
});

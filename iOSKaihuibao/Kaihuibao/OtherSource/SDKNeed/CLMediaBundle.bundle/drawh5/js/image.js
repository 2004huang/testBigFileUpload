var scale = 1,
pageNum = 1,
pdfTool = document.querySelector('.pdf-tool');
var imgBox = $('#image-box');
var isNext = null,
isPrve = null,
isIn = null,
isOut = null;
var imagelist = [], numPages = 1;
function chooseFile() {
    $('.pdf-tool').toggleClass('close');
}

function zoomin() {
    if (scale <= 0.2) {
        return;
    }

    if (!isIn) {
        scale -= 0.2;
        console.log(scale)
        scaleImage(scale);

        isIn = setTimeout(function(){
            clearTimeout(isIn);
            isIn = null;
        }, 1000);
    } else {
        // showTip(2);
    }
}

function zoomout() {
    if (scale >= 1.4) {
        return;
    }

    if (!isIn) {
        scale += 0.2;

        console.log(scale)
        scaleImage(scale);

        isIn = setTimeout(function(){
            clearTimeout(isIn);
            isIn = null;
        }, 1000);
    } else {
        // showTip(2);
    }
}

function setScaleVal(val) {
    var s;
    var pageWidthScale = shareStyle.width /
        naturalStyle.width;

    var pageHeightScale = shareStyle.height /
        naturalStyle.height;

    switch (val) {
    case 'page-actual':
        s = 1.0;
        break;
    case 'page-fit':
        if (clientWidth < clientHeight) {
            s = pageWidthScale;
        } else {
            s = Math.min(pageWidthScale, pageHeightScale);
        }
        break;
    case 'page-width':
        s = pageWidthScale;

        break;
    case 'page-height':
        s = pageHeightScale;

        break;
    default:
        s = parseFloat(val);
        break;
    }

    scaleImage(s);
}
function winResize() {
    clientWidth = document.documentElement.clientWidth || document.body.offsetWidth;
    clientHeight = document.documentElement.clientHeight || document.body.offsetHeight;

    if (clientWidth < clientHeight) {
        $(shareBox).removeClass('height');
    } else {
        $(shareBox).addClass('height');
    }
    numPages = shareFile.children.length ? shareFile.children.length : 1;

    if (numPages > 1) {
        imagelist = shareFile.children;
    } else {
        imagelist.push(shareFile);
    }
    console.log('shareFile', shareFile);
    console.log('imagelist', imagelist);

    renderImg(pageNum);
    // initImage(JPEG_IMAGE);
}
function initImage(src) {
    var showImg = $('.showImg').get(0);

    $('.showImg').on('load', function () {
        hideLoading();

        var w = showImg.naturalWidth;
        var h = showImg.naturalHeight;

        naturalStyle = {
            width: w,
            height: h,
            scale: w / h
        };

        scale = clientWidth / w;
        scaleImage(scale);
    });
    $('.showImg').attr('src', src);
}

function scaleImage(scale) {
    console.log('scaleImage', scale);

    drawStyle = {
        width: clientWidth,
        height: clientWidth / naturalStyle.scale,
        scale: naturalStyle.scale
    };

    var left,
    top;
    var width = naturalStyle.width * scale;
    var height = width / naturalStyle.scale;

    // var width = $(imgBox).width() * scale;
    // var height = width / naturalStyle.scale;

    // console.log('shareStyle', shareStyle)
    if (width > shareStyle.width) {
        left = 0;
    } else {
        left = (shareStyle.width - width) / 2;
    }

    if (height > shareStyle.height) {
        top = gap / 2;
    } else {
        top = (shareStyle.height - height) / 2;
    }

    $(imgBox).css({
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
    hideLoading();
}

function goPrevious() {
    if (pageNum <= 1)
        return;

    if (!isPrve) {
        pageNum--;
        renderImg(pageNum);
        sendDocApp([], pageNum);

        if (lc) {
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
    if (pageNum >= numPages)
        return;

    if (!isNext) {
        pageNum++;
        renderImg(pageNum);
        sendDocApp([], pageNum);
        if (lc) {
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

function renderImg(num) {
    localStorage.pageNum = pageNum = num;

    var src = imagelist[num - 1].url;
    initImage(src);
    document.getElementById('page_num').value = pageNum;
    document.getElementById('page_count').textContent = numPages;
}

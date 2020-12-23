var lang='zh_CN',
Language={};

var langData={
    'zh-CN':{ // 中文简体
        'tips'              : '提示',
        'ok'                : '确定',
        'cancel'            : '取消',
        'delete'            : '删除',
        'share'             : '共享',
        'multipleImg'       : '多图',
        'confirmDel'        : '确定删除这个文件吗？',
        'shareFail'         : '文件共享失败。',
        'uploadFile'        : '上传文件',
        'fileSizeLimit'     : '大小不应超过100M。',
        'unsupportedFormat' : '文件格式不支持。',
        'file'              : '文件',
        'selectFile'        : '请选择一个文件',
        'pleaseLogin'       : '请登录后添加云空间文件',
        'NetworkTip'        : '网络请求超时，请稍后重试。',
        'pageActual'        : '实际大小',
        'pageFit'           : '适应页面',
        'pageWidth'         : '适应宽度',
        'pageHeight'        : '适应高度',
        'fileList'          : '文件列表',
        'localFile'         : '当前会议文件',
        'cloudFiles'        : '云空间文件',
        'noCloudFiles'      : '暂无云空间文件',
        'add'               : '添加',
        'uploadTips'        : '末安排会议文件，可进行共享本地文件和云空间文件哦 ~',
        'fileSize'          : '上传文件大小不能超过100M。',
        'uploadFormats'     : '支持 jpg, jpeg, webp, png, gif, bmp, svg, txt, doc, docx, pdf, xls, xlsx, ppt, pptx 格式',
        'imgFormat'         : '图片支持 jpg, jpeg, webp, png, gif, bmp, svg 格式',
        'docFormat'         : '文件支持 txt, doc, docx, pdf, xls, xlsx, ppt, pptx 格式',
        'searchDocName'     : '请输入文件名进行搜索',
        'addFileCould'      : '上传文件到云空间',
        'shareLoDoc'        : '上传本地文件',
        'emptyCould'        : '云空间没有上传文件',
        'emptyLocal'        : '没有上传文件',
        'fileShare'         : '文件共享',
        'notDelCould'       : '云空间文件只能在文件管理后台删除。',
        'addCurMeetFile'    : '上传当前会议文件',
        'curMeetFile'       : '当前文件',
        'curMeetImage'      : '图片',
        'uploadImage'       : '上传图片',
        'pencil'            : '画笔',
        'text'              : '文字',
        'color'             : '颜色',
        'select'            : '选择',
        'eraser'            : '擦除',
        'undo'              : '撤销',
        'redo'              : '恢复',
        'clear'             : '清除',
        'save'              : '保存',
        'closeShare'        : '结束'
    },
    'zh-TW':{ // 中文繁体
        'tips'              : '提示',
        'ok'                : '確定',
        'cancel'            : '取消',
        'confirmDel'        : '確定删除這個檔嗎？',
        'shareFail'         : '檔案共亯失敗。',
        'uploadFile'        : '上傳檔案',
        'fileSizeLimit'     : '大小不應超過100M。',
        'unsupportedFormat' : '檔案格式不支持。',
        'file'              : '檔案',
        'selectFile'        : '請選擇一個檔案',
        'pleaseLogin'       : '請登入後添加雲空間檔案',
        'NetworkTip'        : '網絡請求超時，請稍後重試。',
        'delete'            : '删除',
        'share'             : '共享',
        'multipleImg'       : '多圖',
        'pageActual'        : '實際大小',
        'pageFit'           : '適應頁面',
        'pageWidth'         : '適應寬度',
        'pageHeight'        : '適應高度',
        'fileList'          : '檔案清單',
        'localFile'         : '當前會議檔案',
        'cloudFiles'        : '雲空間檔案',
        'noCloudFiles'      : '暫無雲空間檔案',
        'add'               : '添加',
        'uploadTips'        : '末安排會議檔案，可進行共亯本地檔案和雲空間檔案哦 ~',
        'fileSize'          : '上傳文件大小不能超過100M。',
        'uploadFormats'     : '支持 jpg, jpeg, webp, png, gif, bmp, svg, txt, doc, docx, pdf, xls, xlsx, ppt, pptx 格式檔案',
        'imgFormat'         : '圖片支持 jpg, jpeg, webp, png, gif, bmp, svg 格式',
        'docFormat'         : '檔案支持 txt, doc, docx, pdf, xls, xlsx, ppt, pptx 格式',
        'searchDocName'     : '請輸入文檔名進行搜索',
        'addFileCould'      : '添加文檔到雲空間',
        'shareLoDoc'        : '上傳本地文檔',
        'emptyCould'        : '雲空間沒有上傳文檔',
        'emptyLocal'        : '沒有上傳文檔',
        'fileShare'         : '文檔共享',
        'notDelCould'       : '雲空間文檔只能在文檔管理後台刪除。',
        'addCurMeetFile'    : '上傳當前會議文檔',
        'curMeetFile'       : '當前文檔',
        'curMeetImage'      : '當前圖片',
        'uploadImage'       : '上傳圖片',
        'pencil'            : '畫筆',
        'text'              : '文字',
        'color'             : '顏色',
        'select'            : '選取',
        'eraser'            : '擦除',
        'undo'              : '撤銷',
        'redo'              : '恢復',
        'clear'             : '清除',
        'save'              : '保存',
        'closeShare'        : '結束'
    },
    'ja':{ // 日语

    },
    'en-US':{ // 英文
        'tips'              : 'Tips',
        'ok'                : 'OK',
        'cancel'            : 'Cancel',
        'delete'            : 'Delete',
        'share'             : 'Share',
        'multipleImg'       : 'Multiple image',
        'confirmDel'        : 'Are you sure you want to delete this file? ',
        'shareFail'         : 'Document sharing failed. ',
        'uploadFile'        : 'Upload File',
        'fileSizeLimit'     : 'The size should not exceed 100M. ',
        'unsupportedFormat' : 'The file format is not supported. ',
        'file'              : 'File',
        'selectFile'        : 'Please select a file',
        'pleaseLogin'       : 'Please add a cloud space document after logging in',
        'NetworkTip'        : 'The network request timed out, please try again later. ',
        'pageActual'        : 'Actual size',
        'pageFit'           : 'Fit to page',
        'pageWidth'         : 'Fit to width',
        'pageHeight'        : 'Fit to height',
        'fileList'          : 'File list',
        'localFile'         : 'Meeting documents',
        'cloudFiles'        : 'Cloud space documents',
        'noCloudFiles'      : 'No Cloud space Files',
        'add'               : 'Add',
        'uploadTips'        : 'Haven\'t scheduled meeting file, can share local files and cloud files ~',
        'fileSize'          : 'The upload file size cannot exceed 100M. ',
        'uploadFormats'     : 'Supports jpg, jpeg, webp, png, gif, bmp, svg, txt, doc, docx, pdf, xls, xlsx, ppt, pptx formats',
        'imgFormat'         : 'Image supports jpg, jpeg, webp, png, gif, bmp, svg format',
        'docFormat'         : 'Document supports txt, doc, docx, pdf, xls, xlsx, ppt, pptx format',
        'searchDocName'     : 'Please enter a document name to search for',
        'addFileCould'      : 'Upload files to cloud space',
        'shareLoDoc'        : 'Upload local document',
        'emptyCould'        : 'Cloud space did not upload documents.',
        'emptyLocal'        : 'No documents upload',
        'fileShare'         : 'Document Share',
        'notDelCould'       : 'Cloud disk files can only be deleted in the document management background. ',
        'addCurMeetFile'    : 'Upload file',
        'curMeetFile'       : 'Documents',
        'curMeetImage'      : 'Picture',
        'uploadImage'       : 'Upload image',
        'pencil'            : 'Pencil',
        'text'              : 'Text',
        'color'             : 'Color',
        'select'            : 'Select',
        'eraser'            : 'Eraser',
        'undo'              : 'Undo',
        'redo'              : 'Redo',
        'clear'             : 'Clear',
        'save'              : 'Save',
        'closeShare'        : 'End'
    },
    'ko':{  // 韩语

    },
};

function setLang(lang) {
    switch(lang){
        case 'zh-Hans':
        case 'zh-Hans-CN':
        case 'zh_CN':
        case 'zh-CN':
            Language =langData['zh-CN'];
            break;
        case 'zh-Hant':
        case 'zh-Hant-TW':
        case 'zh_TW':
        case 'zh-TW':
            Language =langData['zh-TW'];
            break;
        case 'ja':
            Language =langData['en-US'];
            break;

        case (lang.match(/^en/) || {}).input: // 英语(英国)
        case 'en': // 英语(英国)
        case 'en-GB': // 英语(英国)
        case 'en-US': // 英语(美国)
        case 'en-AU': // 英语(澳大利亚)
        case 'en-CA': // 英语(新西兰)
        case 'en-NZ': // 英语(加拿大)
        case 'en-ZA': // 英语(南非)
            Language =langData['en-US'];
            break;
        case 'ko':
            Language =langData['en-US'];
            break;
        default:
            Language =langData['zh-CN'];
            break;
    }
    $('.dropdownToolbarButton .mui-navigate-right').html(Language.pageFit);
    $('#fileList .mui-title').html(Language.fileList);
    $('.no-file').html(`
        <p>${Language.emptyLocal}</p>
        <p>${Language.imgFormat}</p>
        <p>${Language.docFormat}</p>
        <p>${Language.fileSize}</p>
    `);
    $('#addCloud input[type="button"]').val(Language.addFileCould);
    $('#addLocal input[type="button"]').val(Language.addCurMeetFile);
    $('#shareBtn input').val(Language.share);
    $('#deleteBtn input').val(Language.delete);
    $('#cloudBox .mui-title').html(Language.cloudFiles);
    $('#chooseCloudFile').html(Language.add);
    $('#pageActual').html(Language.pageActual);
    $('#pageFit').html(Language.pageFit);
    $('#pageWidth').html(Language.pageWidth);
    $('#pageHeight').html(Language.pageHeight);
    $('.tab-control .tab-item').eq(0).html(Language.localFile);
    $('.tab-control .tab-item').eq(1).html(Language.cloudFiles);
    $('#fileList .mui-title').html(Language.fileShare);
    $('#nav-cancel').html(Language.cancel);
    $('#shareLocal').html(Language.shareLoDoc);
    $('#shareCould').html(Language.addFileCould);
    $('#end-share').html(Language.closeShare);

    setTimeout(()=>{
        $('#searchBtn').attr('placeholder', Language.searchDocName);
    },500);
}

function showLoading() {
    if (document.getElementById('loading'))
    {
        return;
    }
    var load = $(`<div id="loading" class="loading active">
        <a class="load-box">
            <span class="mui-spinner mui-spinner-white"></span>
        </a>
    </div>`);
    // <p>shared documents... please wait. </p>
    $('.fs-container').append(load);
}

function hideLoading() {
    $('.loading').each(function (i, ele) {
        $(ele).remove();
        $(ele).hide();
    })
}

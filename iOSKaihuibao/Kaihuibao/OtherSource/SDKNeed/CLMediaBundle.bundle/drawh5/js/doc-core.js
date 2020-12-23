var fileShow =$('#fileShow');

var cloudFileList =$('#cloudFileList');
var PHPSESSID='087v1ktjl7g1lda6e4qse8e6p2';
var uploadFiles =[];
var files =[];
var cloudfiles =[];
var curType ='local';
var timer1=null;
var timer2=null;
var timer3=null;

var fileTypes  = [
    '.jpg',
    '.jpeg',
    '.webp',
    '.png',
    '.gif',
    '.bmp',
    '.svg',
    '.txt',
    '.doc',
    '.docx',
    '.pdf',
    '.xls',
    '.xlsx',
    '.ppt',
    '.pptx'
];

function getFileHistory(type) {
    showLoading()

    time1Out();
    $.get(`${webUrl}/api/confdoc/all?roomId=${roomId}&lang=${lang}`,function(data){
        console.log('getFileHistory', data)
        hideLoading()
        clearTimeout(timer1);
        timer1=null;
        if (data.code==1){
            if(type){
                files=data.data.filter((item)=>item.file_type === type);
            }else{
                files=data.data;
            }
            console.log('files', files)

            renderFiles(files);
        }else
        {
            mui.toast(data.msg);
        }
    });
}
function renderFiles(files, render){
    var html='';
    {/*<a className="mui-slider-handle mui-navigate-right mui-checkbox">*/}
    files.forEach((item,index)=>{
        html+=`<li class="mui-table-view-cell mui-media">
            <div class="mui-slider-right mui-disabled">
                <a class="mui-btn mui-btn-red">${Language.delete}</a>
            </div>
            <div class="mui-slider-handle mui-navigate-right mui-checkbox">
                <label>
                    <input name="checkbox${index+1}" type="checkbox" id="checkbox${index+1}" value=${item.docId} />
                    <img class="mui-media-object mui-pull-left" src=${item.file_type =='file'?'./doc/icon-doc-black.svg':item.url}>
                    <div class="mui-media-body">
                        <span class="mui-ellipsis">${index+1}.${item.name+(item.children && item.children.length>0 ?`(${Language.multipleImg})`:'')}</span>
                        <p class="mui-ellipsis">${item.time}</p>
                    </div>
                </label>
            </div>
        </li>`;
    });

    if (html || render)
    {
        if (html)
        {
            $('.no-file').hide();
        }
        else
        {
            $('.no-file').show();
        }

        fileShow.html(html);
    }
}

function getCloudFiles(cb,type) {
    showLoading();
    time2Out();
    $.get(`${webUrl}/api/confdoc/myself?token=${token}&lang=${lang}`,function(data){
        if (typeof data ==='string')
        {
            data=JSON.parse(data);
        }
        console.log('data',data);
        clearTimeout(timer2);
        timer2=null;
        if (data.code==1){
            if(type){
                cloudfiles=data.data.filter((item)=>item.file_type ===type);
            }else{
                cloudfiles=data.data;
            }
            console.log('cloudfiles',cloudfiles);
            // renderCloudFiles(cloudfiles);
            cb && cb();
        }else
        {
            // mui.toast(data.msg);
        }
        hideLoading()
    });
}


function delFileList(docId) {
    showLoading()
    time3Out();
    $.get(`${webUrl}/api/confdoc/del?docId=${docId}&roomId=${roomId}&lang=${lang}`,function(data){
        if (typeof data ==='string')
        {
            data=JSON.parse(data);
        }
        console.log('data',data);
        clearTimeout(timer3);
        timer3=null;
        hideLoading()
        if (data.code==1){
            if (curType === 'local')
            {
                files.forEach((item,index)=>{
                    if(item.docId==docId)
                    {
                        files.splice(index, 1);
                        return;
                    }
                });
                console.log('files',files)
                if (files.length===0)
                {
                    fileShow.html('');
                    $('.no-file').show();
                }
                else
                {
                    renderFiles(files);
                }
            }else {
                cloudfiles.forEach((item,index)=>{
                    if(item.docId==docId)
                    {
                        cloudfiles.splice(index, 1);
                        return;
                    }
                });
                console.log('cloudfiles',cloudfiles)
                if (cloudfiles.length===0)
                {
                    fileShow.html('');
                    $('.no-file').show();
                }
                else
                {
                    renderFiles(cloudfiles);
                }
            }
        }
        mui.toast(data.msg);
    });
}
function renderCloudFiles(cloudfiles){
    var html='';

    if (cloudfiles.length){
        cloudfiles.forEach((item,index)=>{
            html+=`<li class="mui-table-view-cell">
        <a class="mui-input-row mui-checkbox mui-left">
            <label>
                <img class="mui-media-object mui-pull-left" src=${item.file_type =='file'?'./doc/icon-doc-black.svg':item.url}>
                ${index+1}. ${item.name+(item.children && item.children.length>0 ?`(${Language.multipleImg})`:'')}
                <input name="checkbox${index+1}" type="checkbox" value=${item.docId} />
                <span class="mui-pull-right">${item.time}</span>
            </label>
        </a>
    </li>`;
        });
    }
    else
    {
        html+=`<div class="mui-card">
            <div class="mui-card-content">
                <div class="mui-card-content-inner">
                    ${Language.noCloudFiles}
                </div>
            </div>
        </div>`;
    }

    cloudFileList.html(html);
}
function uploadFileToServer(file, fileName, type) {
    showLoading();
    const formData = new FormData();

    // formData.append('name', fileName);
    formData.append('file', file, fileName);
    token && formData.append('token', token);

    console.log('uploadFileToServer', file, fileName, type);

    if (type === 'local')
    {
        formData.append('roomId', roomId);
    }
    formData.append('lang', lang);
    // formData.append('peerName', userId);
    console.log('formData',formData);

    $.ajax({
        type: "POST", // 数据提交类型
        url: `${webUrl}/api/confdoc/newupload`, // 发送地址
        data: formData, //发送数据
        async: true, // 是否异步
        processData: false, //processData 默认为false，当设置为true的时候,jquery ajax 提交的时候不会序列化 data，而是直接使用data
        contentType: false,
        success: function(data){
            if (typeof data ==='string')
            {
                data=JSON.parse(data);
            }
            console.log('data',data)

            if (data.code==1){
                console.log('data.data',data.data);
                if (type === 'local')
                {
                    files.push(data.data);
                    console.log('files',files);
                    renderFiles(files);
                }
                else
                {
                    cloudfiles.push(data.data);
                    console.log('cloudfiles',cloudfiles);
                    renderFiles(cloudfiles);
                }
                $("[data-type="+type+"]").addClass('active').siblings().removeClass('active');
            }
            mui.toast(data.msg);
            hideLoading()
        },
        error: function(err) {
            console.error('uploadFileToServer',err)
        }
    });
}
function time1Out() {
    timer1 = setTimeout(() =>
    {
        if (!timer1)return;
        mui.toast(Language.NetworkTip);
        clearTimeout(timer1);
        hideLoading();
    }, 15 * 1000);
}
function time2Out() {
    timer2 = setTimeout(() =>
    {
        if (!timer2)return;
        mui.toast(Language.NetworkTip);
        clearTimeout(timer2);
        hideLoading();
    }, 15 * 1000);
}
function time3Out() {
    timer3 = setTimeout(() =>
    {
        if (!timer3)return;
        mui.toast(Language.NetworkTip);
        clearTimeout(timer3);
        hideLoading();
    }, 15 * 1000);
}
$(function () {
    $('#backlist').on('click',function () {
        $('#cloudBox').addClass('hide');
    });
    $('#addLocal').bind('click',function () {
        // uploadFileToServer(file, file.name);
    });
    // $('#addCloud').click('click',function () {
    //     if (!token)
    //     {
    //         mui.toast(Language.pleaseLogin);
    //         return;
    //     }
    //     $('#cloudBox').removeClass('hide');
    //     getCloudFiles();
    // });
    // 确定共享按钮
    $('#shareBtn').click('click',function () {
        var val = $('#fileShow input[type=checkbox]:checked').val();

        if (val)
        {
            var arr=curType=='local' ?files:cloudfiles;
            var file = arr.find((item)=>item.docId==val);
            shareFile =  file;
            localStorage.shareFile = JSON.stringify(file);
            pageNum = localStorage.pageNum = 1;

            console.log('file', file);

            // 发送文件url给其他人
            sendDocApp([file], 1);
            if (file.file_type =='file')
            {
                UpdateUrlParam('file', file.url);
            }else
            {
                UpdateUrlParam('image', file.url);
            }

            $('#fileList').hide();
        }
        else{
            mui.toast(Language.selectFile);
        }
    });

    $('#deleteBtn').click('click',function (e) {
        e.stopPropagation();
        var btnArray = [ Language.ok, Language.cancel  ];
        var delMsg = Language.confirmDel;

        var elem = $('#fileShow input[type=checkbox]:checked');
        var val = elem.val();
        var li = elem.parent().parent().get(0);
        console.log('deleteBtn111', Language);

        if (curType==='could')
        {
            mui.toast(Language.notDelCould);

            return;
        }
        if(!val)
        {
            mui.toast(Language.selectFile);

            return;
        }

        layer.open({
            content: delMsg,
            btn: btnArray,
            yes: function(index) {
                delFileList(val);
                layer.close(index);
            }
        });

        // mui.confirm(delMsg, Language.tips, btnArray, function(e) {
        //     console.log('confirm', e);
        //
        //     if (e.index == 0) {
        //         setTimeout(function() {
        //             mui.swipeoutClose(li);
        //         }, 0);
        //     } else {
        //         delFileList(val);
        //     }
        // });
    });
    $('#fileShow').on('click', '.mui-btn', function(e) {
        // e.stopPropagation();
        var elem = $(this);
        var li = elem.parent().parent();
        var val = li.find('input[type=checkbox]').val();
        var btnArray = [ Language.ok, Language.cancel  ];
        var delMsg = Language.confirmDel;

        if (curType==='could')
        {
            mui.toast(Language.notDelCould);

            return;
        }

        layer.open({
            content: delMsg,
            btn: btnArray,
            yes: function(index) {
                delFileList(val);
                layer.close(index);
            }
        });

        // mui.confirm(delMsg, Language.tips, btnArray, function(e) {
        //     console.log('confirm', e);
        //
        //     if (e.index == 0) {
        //         setTimeout(function() {
        //             mui.swipeoutClose(li);
        //         }, 0);
        //     } else {
        //         delFileList(val);
        //     }
        // });
    });
    $('#chooseCloudFile').bind('click',function () {
        if ($('#cloudFileList input[type=checkbox]:checked').length>0)
        {
            console.log($('#cloudFileList input[type=checkbox]:checked'));
            var values = [];
            $('#cloudFileList input[type=checkbox]:checked').each(function (index,item) {
                values.push(Number(item.value))
            })
            console.log(values);
            var curFiles = cloudfiles.filter((item)=>values.includes(item.docId));
            files = files.concat(curFiles);
            console.log(files);
            renderFiles(files);
            $('#cloudBox').addClass('hide');
        }
        else{
            mui.toast(Language.selectFile);
        }
    });

    $('#fileShow').on('change','input',function (e) {
        if (isiOS)
        {
            // if (!$(this).prop('checked'))
            // {
            //     $(this).prop('checked',false);
            // }
            // else{
            //     $('#fileShow input[type=checkbox]').prop('checked',false);
            //     $(this).prop('checked',true);
            // }
            console.log('change');

            if ($('#fileShow input[type=checkbox]:checked').length>0)
            {
                if (!$(this).prop('checked'))
                {
                    $(this).prop('checked',false);
                }
                else{
                    $('#fileShow input[type=checkbox]').prop('checked',false);
                    $(this).prop('checked',true);
                }
                // $('#handleBtns').removeClass('hide');
                // $('#addCloud').addClass('hide');
                // $('#addLocal').addClass('hide');
            }
            else{
                // $('#handleBtns').addClass('hide');
                // $('#addCloud').removeClass('hide');
                // $('#addLocal').removeClass('hide');
            }
        }
    });

    $('#fileShow').on('click','label',function (e) {
        e.stopPropagation();

        if (isiOS)
        {
            if ($(this).find('input[type=checkbox]').prop('checked'))
            {
                $('#fileShow input[type=checkbox]').prop('checked',false);
            }
            else{
                $('#fileShow input[type=checkbox]').prop('checked',false);
                $(this).find('input[type=checkbox]').prop('checked',true)
            }

            // if ($('#fileShow input[type=checkbox]:checked').length>0)
            // {
            //     $('#handleBtns').removeClass('hide');
            //     $('#addCloud').addClass('hide');
            //     $('#addLocal').addClass('hide');
            // }
            // else{
            //     $('#handleBtns').addClass('hide');
            //     $('#addCloud').removeClass('hide');
            //     $('#addLocal').removeClass('hide');
            // }
        }
        else
        {
            if ($(this).find('input[type=checkbox]').prop('checked'))
            {
                $(this).find('input[type=checkbox]').prop('checked',true)
            }
            else{
                $('#fileShow input[type=checkbox]').prop('checked',false);
                $(this).find('input[type=checkbox]').prop('checked',false)
            }

            // if ($('#fileShow input[type=checkbox]:checked').length>0)
            // {
            //     $('#handleBtns').addClass('hide');
            //     $('#addCloud').removeClass('hide');
            //     $('#addLocal').removeClass('hide');
            // }
            // else{
            //     $('#handleBtns').removeClass('hide');
            //     $('#addCloud').addClass('hide');
            //     $('#addLocal').addClass('hide');
            // }
        }
    });
    $('#fileShow').on('click','input',function (e) {
        e.stopPropagation();
    });

    $(document).on('change','#cloudFileList input',function () {
        if ($('#fileShow input[type=checkbox]:checked').length>0)
        {
            console.log($('#fileShow input[type=checkbox]:checked'));
        }
    });
    // 上传本地文档
    $(document).on('change','#addInput',function () {
        console.log('imgfiles',this.files);
        var arrfiles=this.files;
        var len=arrfiles.length;
        // uploadFileToServer(file, file.name);

        for(var i=0; i < len;i++){
            var file=arrfiles[i];
            var arr=file.name.split('.');
            var last=arr[arr.length-1];
            if (file.size > 100 * 1000 * 1000)
			{
                mui.toast(Language.uploadFile + file.name +Language.fileSizeLimit   );

				continue;
			}

            if (fileTypes.indexOf(`.${last}`.toLowerCase())>=0)
            {
                uploadFileToServer(file, file.name);
            }
            else{
                mui.toast(Language.uploadFile + file.name + Language.unsupportedFormat);
                continue;
            }
        }

    });

    // 上传本地文档1
    $(document).on('change','#addLocalInput',function () {
        console.log('imgfiles',this.files);
        var arrfiles=this.files;
        var len=arrfiles.length;
        // uploadFileToServer(file, file.name);

        for(var i=0; i < len;i++){
            var file=arrfiles[i];
            var arr=file.name.split('.');
            var last=arr[arr.length-1];
            if (file.size > 100 * 1000 * 1000)
            {
                mui.toast(Language.uploadFile + file.name +Language.fileSizeLimit   );

                continue;
            }

            if (fileTypes.indexOf(`.${last}`.toLowerCase())>=0)
            {
                uploadFileToServer(file, file.name, 'local');
            }
            else{
                mui.toast(Language.uploadFile + file.name + Language.unsupportedFormat);
                continue;
            }
        }

    });
    // 上传云端文档
    $(document).on('change','#addCouldInput',function (e) {
        console.log('imgfiles',this.files);
        var arrfiles=this.files;
        var len=arrfiles.length;

        for(var i=0; i < len;i++){
            var file=arrfiles[i];
            var arr=file.name.split('.');
            var last=arr[arr.length-1];
            if (file.size > 100 * 1000 * 1000)
            {
                mui.toast(Language.uploadFile + file.name +Language.fileSizeLimit   );

                continue;
            }

            if (fileTypes.indexOf(`.${last}`.toLowerCase())>=0)
            {
                uploadFileToServer(file, file.name, 'could');
            }
            else{
                mui.toast(Language.uploadFile + file.name + Language.unsupportedFormat);
                continue;
            }
        }

    });
    $('#cloudBox .mui-search').bind('click',function (e) {
        e.stopPropagation();
        $('#searchBtn').focus();
    });

    // document.getElementById("searchBtn").addEventListener('input', function(e) {
    //     var arrFiles=JSON.parse(JSON.stringify(cloudfiles));
    //     console.log(arrFiles)
    //     var data =arrFiles.filter((file)=>String(file.name).indexOf(e.target.value)>-1);
    //     renderCloudFiles(data);
    // });

    $('.tab-control .tab-item').bind('click',function () {
        $(this).addClass('active').siblings().removeClass('active');
        curType= $(this).data('type');
        if (curType === 'local')
        {
            $('.no-file').html(`
                <p>${Language.emptyLocal}</p>
                <p>${Language.imgFormat}</p>
                <p>${Language.docFormat}</p>
                <p>${Language.fileSize}</p>
            `);
            console.log('files',files);
            renderFiles(files, true);
        }
        else
        {
            $('.no-file').html(`
                <p>${Language.emptyCould}</p>
                <p>${Language.imgFormat}</p>
                <p>${Language.docFormat}</p>
                <p>${Language.fileSize}</p>
            `);
            console.log('cloudfiles',cloudfiles);
            renderFiles(cloudfiles, true);
        }
    });

    $('#nav-cancel').bind('click',function (e) {
        e.stopPropagation();
        // 取消按钮关闭共享
        endWebview();
    });
    $('#addUpload').bind('click',function (e) {
        e.stopPropagation();
        // 取消按钮关闭共享
    });

    $('#add-btns').on('click', function (e) {
        console.log(e.target);
        var id = $(e.target).attr('id');

        if (id ==='addLocalInput')
        {
            curType= 'local';
        }
        else
        {
            if (!token)
            {
                e.preventDefault();
                mui.toast(Language.pleaseLogin);
                return;
            }
            curType= 'could';
        }
        // mui('#topUploadPop').popover('hide');
    });
});


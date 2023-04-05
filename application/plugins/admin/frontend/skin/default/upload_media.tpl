<div>
    <input type="hidden" name="security_ls_key" value="{$LIVESTREET_SECURITY_KEY}" />


    <ul id="filelist"></ul>
    <br />

    <div id="container" style="margin-bottom: 40px">
        {component button text="Выбрать..." id="browse"}
        {component button text="Начать загрузку" id="start-upload" mods='primary'}
    </div>
</div>

{literal}
    <script type="text/javascript">
        var uploader = new plupload.Uploader({
            browse_button: 'browse',
            url: ADMIN_URL+'media/upload/',
            multipart_params: { }
        });
        var bReload = {/literal}{($bReload == false) ? 0 : true}{literal};

        uploader.init();
        uploader.bind('FilesAdded', function(up, files) {
            var html = '';
            plupload.each(files, function(file) {
                html += '<li id="' + file.id + '">' + file.name + ' (' + plupload.formatSize(file.size) + ') <b></b></li>';
            });
            document.getElementById('filelist').innerHTML += html;
        });
        uploader.bind('UploadProgress', function(up, file) {
            document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
        });
        uploader.bind('Error', function(up, err) {
            document.getElementById('console').innerHTML += "\nError #" + err.code + ": " + err.message;
        });
        uploader.bind('FileUploaded', function(Up, File, Response) {
            if(typeof bReload != 'undefined' && bReload == true && uploader.total.uploaded == uploader.files.length) {
                window.location.reload(1);
            }
            Response = $.parseJSON(Response.response);
            if (typeof Response.sHtml != 'undefined') {
                $('#media_list').prepend(Response.sHtml);
                if (typeof bindMedia == 'function') bindMedia();
            }

        });
        document.getElementById('start-upload').onclick = function() {
            uploader.settings.multipart_params["target_type"] = '{/literal}{($sTargetType) ? $sTargetType : 'media'}{literal}';
            uploader.settings.multipart_params["target_id"] = '{/literal}{($iTargetId) ? $iTargetId : 1}{literal}';
            uploader.settings.multipart_params["security_ls_key"] = $('input[name="security_ls_key"]').val();
            uploader.start();
        };
    </script>
{/literal}
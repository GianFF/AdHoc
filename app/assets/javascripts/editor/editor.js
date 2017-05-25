function iniciarEditor() {
    tinymce.init(configuracion_del_editor());
    traducir_editor_al_castellano();
}

function iniciarEditorConTitulosParaDemanda(){
    var editor = new tinymce.Editor('editor', {
        selector: '#editor',
        branding: false,
        plugins: [
            'advlist autolink lists charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars fullscreen insertdatetime nonbreaking',
            'save table contextmenu directionality paste textcolor'
        ],
        toolbar: 'save | insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | ' +
        'bullist numlist outdent indent | print preview fullpage | forecolor backcolor emoticons',
        removed_menuitems: 'undo, redo, newdocument, formats',
        setup: function(editor){
            editor.on("init", function(){tinymce.activeEditor.setContent(titulosParaDemanda());});
        }
    }, tinymce.EditorManager);
    traducir_editor_al_castellano();
    editor.render();
}


// private

function configuracion_del_editor() {
    return {
        selector: '#editor',
        branding: false,
        plugins: [
            'code advlist autolink lists charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars fullscreen insertdatetime nonbreaking',
            'save table contextmenu directionality paste textcolor'
        ],
        toolbar: 'code | save | insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | ' +
        'bullist numlist outdent indent | print preview fullpage | forecolor backcolor emoticons',
        removed_menuitems: 'undo, redo, newdocument, formats'
    };
}

function traducir_editor_al_castellano() {
    tinymce.addI18n('es', traduccion_castellano);
}

function titulosParaDemanda() {
    return '<h1 style="text-align: center;">I.- OBJETO</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">II.- HECHOS</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">III.- DERECHO</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">IV.- PRUEBA</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">V.- PETITORIO</h1>'+
        '<p>&nbsp;</p>';
}

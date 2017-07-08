function iniciarEditor() {
    recargarEditor();
    traducirEditorAlCastellano();
}

function iniciarEditorConEncabezadoPatrocinanteYTitulosParaDemanda(){
    var editor = new tinymce.Editor('editor', {
        selector: '#editor',
        branding: false,
        plugins: [
            'advlist autolink lists charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars fullscreen insertdatetime nonbreaking',
            'table contextmenu directionality paste textcolor'
        ],
        toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | ' +
        'bullist numlist outdent indent | print preview fullpage | forecolor backcolor emoticons',
        removed_menuitems: 'undo, redo, newdocument, formats',
        setup: function (editor){
            editor.on("init", function(){encabezadoYTitulos();});
        }
    }, tinymce.EditorManager);
    traducirEditorAlCastellano();
    editor.render();
}

function iniciarEditorConEncabezadoPatrocinanteParaContestacionDeDemanda() {
    var editor = new tinymce.Editor('editor', {
        selector: '#editor',
        branding: false,
        plugins: [
            'advlist autolink lists charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars fullscreen insertdatetime nonbreaking',
            'table contextmenu directionality paste textcolor'
        ],
        toolbar: 'insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | ' +
        'bullist numlist outdent indent | print preview fullpage | forecolor backcolor emoticons',
        removed_menuitems: 'undo, redo, newdocument, formats',
        setup: function (editor){
            editor.on("init", function(){encabezadoYTitulosParaContestacion();});
        }
    }, tinymce.EditorManager);
    traducirEditorAlCastellano();
    editor.render();
}

function iniciarEditorNotificacion() {
    var editor = new tinymce.Editor('editor', {
        selector: '#editor',
        branding: false,
        plugins: [
            'code advlist autolink lists charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars fullscreen insertdatetime nonbreaking',
            'table contextmenu directionality paste textcolor'
        ],
        toolbar: 'code | insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | ' +
        'bullist numlist outdent indent | print preview fullpage | forecolor backcolor emoticons',
        removed_menuitems: 'undo, redo, newdocument, formats',
        setup: function (editor){
            editor.on("init", function(){formularioParaNotificacion();});
        }
    }, tinymce.EditorManager);
    traducirEditorAlCastellano();
    editor.render();
}


// private

function recargarEditor() {
    tinymce.remove(); // TODO: eliminar este hack
    /*
    * Este hack lo hago porque el navegador cachea la info de que tiny ya fue cargado
    * y no me lo vuelve a cargar, entonces para evitar que se muestre el editor in-line
    * decidí eliminar la instancia de tiny y volverla a cargar a mano.
    */
    tinymce.init(configuracionDelEditor());
}

function configuracionDelEditor() {
    return {
        selector: '#editor',
        branding: false,
        plugins: [
            'code advlist autolink lists charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars fullscreen insertdatetime nonbreaking',
            'table contextmenu directionality paste textcolor'
        ],
        toolbar: 'code | insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | ' +
        'bullist numlist outdent indent | print preview fullpage | forecolor backcolor emoticons',
        removed_menuitems: 'undo, redo, newdocument, formats'
    };
}

function traducirEditorAlCastellano() {
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

// Setear contenido

function encabezadoYTitulos() {
    tinymce.activeEditor.setContent(contenidoDelEncabezadoParaDemanda().concat(titulosParaDemanda()));
}

function encabezadoYTitulosParaContestacion() {
    tinymce.activeEditor.setContent(contenidoDelEncabezadoParaContestacion());
}

function formularioParaNotificacion() {
    tinymce.activeEditor.setContent(contenidoDelFormularioParaNotificacion());
}

function setearContenido(contenido) {
    tinymce.activeEditor.setContent(contenido);
}

// Contenido

function contenidoDelEncabezadoParaDemanda() {
    return $('#encabezado').text();
}

function contenidoDelEncabezadoParaContestacion() {
    return $('#encabezado_para_demanda').text();
}

function contenidoDelFormularioParaNotificacion() {
    return $('#formulario_notificacion').html();
}

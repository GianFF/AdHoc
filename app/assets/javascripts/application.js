// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap/modal
//= require sweetalert2
//= require sweet-alert2-rails
//= require_tree .

document.addEventListener("turbolinks:load", function() {
    comportamiento_alertas();
    comportamiento_buscador();
    comportamiento_archivador();
    comportamiento_boton_clonar();
});

// private

function link_to(id, titulo, path) {
    return "<a href=" + '/' + path + '/' + id + ">" + titulo + "</a>";
}
function dropdown(escritos) {
    return "<select class='form-control' name='notificacion[tipo_domicilio]' id='notificacion_tipo_domicilio'>"+
                "<option value=''></option>" +
                escritos.map(function (escrito) {
                    return "<option value=''>" + escrito['escrito_titulo'] + "</option>";
                });
}
function link_to_clonar(expediente_id, desde_id, hasta_id, titulo, tipo) {
    var id = "clonar_escrito"+desde_id;
    var link = "<a id='"+id+"' href='/expedientes/" + expediente_id + "/clonar/" + desde_id+"/"+hasta_id+"'"+ ">"+titulo+"</a>";
    return link;
}


/// Comportamientos
function comportamiento_boton_clonar(){

    $('#escritos__boton_clonar').on('ajax:success', function (e, data, status, xhr) {
        var filas = data.map(function( escrito ) {
            return "<tr>" +
                        "<td>" + link_to_clonar(escrito['expediente_id'], escrito['id'], escrito['hasta_id'], escrito['titulo'], escrito['tipo']) + "</td>" +
                        "<td>" + escrito['expediente'] + "</td>" +
                        "<td>" + escrito['cliente'] + "</td>" +
                    "</tr>";
        });

        $('#escritos__table_body').html(filas);
        $('#clonar-modal').modal('show');
    });
}
function comportamiento_archivador(){

    $('#panel_izquierdo__archivador').on('ajax:success', function (e, data, status, xhr) {
        var filas = data.map(function( expediente_archivado ) {
            return "<tr>"+
                "<td>" + link_to(expediente_archivado['cliente_id'], expediente_archivado['cliente_nombre'], 'clientes') + "</td>" +
                "<td>" + link_to(expediente_archivado['id'], expediente_archivado['titulo'], 'expedientes') + "</td>" +
                "<td>" + dropdown(expediente_archivado['escritos'])+"</td>" +
                "</tr>";
        });

        $('#expedientes_archivados__table_body').html(filas);

        $('#archivador-modal').modal('show');
    });
}
function comportamiento_buscador() {
    vaciar_buscador();

    deshabilitar_buscador();

    habilitar_deshabilitar_segun_corresponda();

    habilitar_enter_para_buscar();
}
function comportamiento_alertas() {
    borrarAlertaDentroDe(7000);

    cerrarAlerta();
}


/// Alertas

function borrarAlertaDentroDe(unCiertoTiempo) {
    setTimeout(function () {
        $('.alert').remove();
    }, unCiertoTiempo);
}
function cerrarAlerta() {
    $(".close").click(function () {
        $('.alert').remove();
    });
}


/// Buscador

function contenido_buscador() {
    return $("#panel_izquierdo__query");
}
function vaciar_buscador() {
    contenido_buscador().val("");
}
function buscador() {
    return $("#panel_izquierdo__buscar");
}
function deshabilitar_buscador() {
    buscador().prop('disabled', true);
}

function habilitar_buscador() {
    buscador().prop('disabled', false);
}
function habilitar_deshabilitar_segun_corresponda() {
    contenido_buscador().on('change keyup paste', function () {
        var busqueda = contenido_buscador().val();

        if (busqueda != "") habilitar_buscador();
        else deshabilitar_buscador();
    });
}
function habilitar_enter_para_buscar() {
    contenido_buscador().keypress(function (e) {
        if (e.keyCode == 13) buscador().click();
    });
}
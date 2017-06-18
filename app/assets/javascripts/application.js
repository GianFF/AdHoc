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
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap/modal
//= require sweetalert2
//= require sweet-alert2-rails
//= require_tree .

document.addEventListener("turbolinks:load", function() {
    comportamiento_alertas();
    comportamiento_buscador();
    comportamient_archivador();
});

function comportamient_archivador(){

    $('#panel_izquierdo__archivador').on('ajax:success', function (e, data, status, xhr) {
        var filas = data.map(function( expediente_archivado ) {
            return "<tr>"+
                        "<td>" + link_to(expediente_archivado['cliente_id'], expediente_archivado['cliente_nombre'], 'clientes')+"</td>" +
                        "<td>" + link_to(expediente_archivado['id'], expediente_archivado['titulo'], 'expedientes')+"</td>" +
                        "<td>"+dropdawn(expediente_archivado['escritos'])+"</td>" +
                    "</tr>";
        });

        $('#expedientes_archivados__table_body').html(filas);

        $('#archivador-modal').modal('show');
    });
}

// private

function link_to(id, titulo, path) {
    return "<a href=" + '/' + path + '/' + id + ">" + titulo + "</a>";
}

function dropdawn(escritos) {
    return "<select class='form-control' name='notificacion[tipo_domicilio]' id='notificacion_tipo_domicilio'>"+
                "<option value=''></option>" +
                escritos.map(function (escrito) {
                    return "<option value=''>" +
                        link_to(escrito['escrito_id'], escrito['escrito_titulo'], 'escritos') +
                        "</option>"
                });
}


/// Comportamientos

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
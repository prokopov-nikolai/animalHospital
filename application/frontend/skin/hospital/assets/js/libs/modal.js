/**
 * Created by User on 30.01.2018.
 */
window.scrollTop = 0;
window.scrollLeft = 0;
window.scrolled = 0;

function ModalShow(obj) {
    $('#modal-work, #modal-rules, #modal-youtube').removeClass('visible');
    obj.css({display: 'block'});
    let scrolledLeft = 0;
    if (!$('html').hasClass('modal-show')) {
        window.scrollTop = scrolled;
        window.scrollLeft = scrolledX;
        $('#modal-back').css({display: 'block'});
        $('html').addClass('modal-show');
        $('html').height($(window).height());
        scrolledLeft = scrolledX;
        $('html').css({
            display: 'block',
            top: -scrolled,
            left: -scrolledX
        });
        $('html').data('modal-name', obj.attr('id'));
    } else {
        var sModalName =$('html').data('modal-name');
        $('html').data('modal-name', obj.attr('id'));
        window.setTimeout(function () {
            $('#'+sModalName).css({display: 'none'});
        }, 350);
    }
    window.setTimeout(function () {
        $('#modal-back').css({display:'block'}).addClass('visible');
        if (!obj.hasClass('menu')) {
            obj.css({
                top: scrollTop + (obj.innerHeight() < $(window).height() ? ($(window).height() - obj.innerHeight()) / 2 : 0),
            });
        }
        if (obj.hasClass('left-scrolled')) {
            obj.css({
                left: scrolledLeft + (obj.innerWidth() < $(window).width() ? ($(window).width() - obj.innerWidth()) / 2 : 0)
            });
        }
        console.log(obj.css('left'));
        obj.addClass('visible');
    }, 100);

    $('#modal-back, #'+obj.attr('id')+' .modal-close').off('click').on('click', function(){
        log(obj.attr('id'));
        ModalHide(true, obj);
    });
}

function ModalHide(bScroll, oObject) {
    let sId = false;
    if (typeof oObject == 'object') sId = oObject.attr('id');
    if (typeof bScroll == 'undefined') {
        if (bScroll !== false) bScroll = true;
    }
    $(' #modal-back, #modal-rules, #modal-work, #modal-youtube, #'+sId).removeClass('visible');
    $('html').removeClass('modal-show').css({height: 'auto', top: 0, left: 0});
    console.log('bScroll', bScroll)
    if (bScroll) $('html,body').animate({
        scrollTop: scrollTop,
        scrollLeft: scrollLeft
    }, 0);
    console.log(scrollLeft);
    window.setTimeout(function () {
        $('#modal-back, #modal-rules, #modal-work, #modal-youtube, #'+sId).css({display: 'none'});
    }, 350);
    if (typeof playerYouTubeModal != 'undefined') playerYouTubeModal.pauseVideo();
}

$(function(){
    $('#modal-back').on('click', function(){
        ModalHide();
    });
});
window.onscroll = function () {
    scrolled = window.pageYOffset || document.documentElement.scrollTop;
    // log(scrolled);
}

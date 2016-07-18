var page_data = { top: 0, slide_html: ''};
var cars_data = {};

(function (window) {
    // Bind to StateChange Event
    History.Adapter.bind(window, 'statechange', function () {
        var State = History.getState();

        console.log(JSON.stringify(State));

        if(typeof State.data.scrollTop !== 'undefined') {
            if($('.msc_modal').is(':visible')) {
               close_modal();
               History.replaceState({scrollTop:State.data.scrollTop}, null, "");
               $(document).scrollTop(State.data.scrollTop);
            }
        }

        if(typeof State.data.p !=='undefined' && State.data.p === 'brand' && typeof State.data.brand !== 'undefined') {
            open_cars_modal(State.data.brand);
        }

    });

    $(window).on('popstate',function(event) {
        var State = History.getState();
        //console.log("location: " + JSON.stringify(State));
    });

    if (isMySuperCar()){
        cars_data = JSON.parse($("#cars_data").html());

        // 브랜드 아이콘 템플릿 렌더링
        var $el_brand_container = $('.brand_icons');
        var brand_icons_template = Handlebars.compile($("#brand_icons_template").html());
        for(var brand in cars_data){
            var $li = $(brand_icons_template({'brand':brand,'logo':cars_data[brand]['logo']}));
            $li.data(cars_data[brand]);
            $el_brand_container.append($li);
        }

        var entrance = JSON.parse($("#entrance").html());
        if( entrance.brand != null ){
            setTimeout(function(){
                History.replaceState({scrollTop:0}, null, "?page=top");
                History.pushState({p:'brand',brand:entrance.brand}, null, "?brand=" + entrance.brand);
            },10);
        }
        else if (entrance.page!=null){
            setTimeout(function(){
                History.replaceState({scrollTop:0}, null, "?page=top");
                open_page_modal(entrance.page.title, entrance.page.link);
            },10);
        }
    }
    else if (isMySuperVan()){
        cars_data = JSON.parse($("#cars_data").html());

        var $el_cars_list = $('.cars_list');
        var cars_item_template = Handlebars.compile($("#cars_template").html());
        for(var key in cars_data) {
            var $li = $(cars_item_template(cars_data[key]));
            $li.data(cars_data[key]);
            $el_cars_list.append($li);
        }

        var entrance = JSON.parse($("#entrance").html());
        if (entrance.page!=null){
            setTimeout(function(){
                History.replaceState({scrollTop:0}, null, "?page=top");
                open_page_modal(entrance.page.title, entrance.page.link);
            },10);
        }
    }

})(window);

$(function(){
    $("a[href='#']").click(function(e){
        e.preventDefault();
    });

    // intro 랜덤 배경
    if (isMySuperCar()){
        var intro_bg_size = 2;
    } else if (isMySuperVan()) {
        var intro_bg_size = 3;
    }
    var intro_bg_van_no = Math.floor(Math.random() * 10 % intro_bg_size + 1);
    $('.intro_area').addClass("bg" + intro_bg_van_no);

    // 스와이프
    page_data.slide_html = $('#slide_container').html();
    init_slider();


    History.replaceState(null, null, "");
    $(".action_link").on('click', function(){
        var action_category = $(this).data('action-category');
        var action_detail = $(this).data('action-detail');
        var area = $(this).data('area');
        var brand = $(this).data('brand');
        var model = $(this).data('model');
        var link = $(this).attr('href');
        logging(action_category, action_detail, brand, model, area, link);
    });


    // 브랜드 아이콘 클릭 이벤트
    $(".brand_icon_link").on('click', function(){
        var brand = $(this).data('brand');
        var scrollTop = $(document).scrollTop();

        //History.pushState({scrollTop:scrollTop}, null, "");
        History.replaceState({scrollTop:scrollTop}, null, "");

        History.pushState({p:'brand',brand:brand}, null, "?brand=" + brand);
    });

    // Escape 모달 닫기
    $(window).on('keyup', function(e){
        if(e.keyCode===27 && $('.msc_modal').is(':visible')){
            e.preventDefault();
            close_modal(e);
            history.back();
        }
    });

    $('.msc_modal_close').on('click', function(e){
        e.preventDefault();
        close_modal(e);
        history.back();
    });

    /*if(window.location.href.includes("brand=")){
        alert("brand");
    }*/


});


function logging(category, action_detail, brand, model, area, link) {
    if (category == null) category = action_detail;
    if (action_detail == null) action_detail = category;

    $.ajax({
        url: "/log/submit",
        type: "POST",
        dataType: "json",
        data: {"action_category": category, "action_detail": action_detail, "area":area, "brand":brand, "model":model }
    });

    var ga_label = action_detail;
    if (link && link.startsWith('http') && model == null ){
        ga_label = link;
    }

    ga('send', 'event', {
        eventCategory: category,
        eventAction: action_detail,
        eventLabel: ga_label,
        transport: 'beacon'
    });
}

function open_cars_modal(brand){
    $('.msc_modal_tit').html(cars_data[brand].title);

    var cars_item_template = Handlebars.compile($("#cars_item_template").html());
    var html = cars_item_template(cars_data[brand]);
    $('.msc_container').hide();
    $('.cars_container').show().html(html);
    $('.cars_container .action_link').on('click', function(){

        var action_category = $(this).data('action-category');
        var action_detail = $(this).data('action-detail');
        var area = $(this).data('area');
        var brand = $(this).data('brand');
        var model = $(this).data('model');
        var link = $(this).attr('href');

        logging(action_category, action_detail, brand, model, area, link);
    });

    open_modal();

    $('head title').html("Mysupercar::" + cars_data[brand].title);
    ga('set', 'page', '/'+brand);
    ga('send', 'pageview');
}

function open_page_modal(title, url){
    $.ajax({
        url : url,
        success : function(html){
            var scrollTop = $(document).scrollTop();

            //History.pushState({scrollTop:scrollTop}, null, "");
            History.replaceState({scrollTop:scrollTop}, null, "");

            History.pushState({p:title, scrollTop:scrollTop}, null, "?page=" +title);

            $('.msc_modal_tit').html(title);
            $('.page_container').html(html);
            $('.msc_container').hide();
            $('.page_container').show();
            open_modal();

            $('head title').html("Mysupercar::" + title);
            ga('set', 'page', '/' + title);
            ga('send', 'pageview');
        }
    });
}


function open_modal(){
    page_data.top = $(document).scrollTop();

    $('.msc_modal').show();
    $('.content_wrap').hide();
}

function close_modal(){
    $('.msc_modal').hide();
    $('.content_wrap').show();
    $(document).scrollTop(page_data.top);

    $('head title').html("Mysupercar");
    ga('set', 'page', '/');
    ga('send', 'pageview');

    reinit_slider();
    //History.replaceState(null, null, "");
}

function reinit_slider(){
    $('#slide_container').html(page_data.slide_html);
    init_slider();
}

function init_slider(){
    var max = $('#slider li').length;
    var start = Math.floor((Math.random() * 5) + 1);
    $('#slider').slidesjs({
        navigation:{active:false},
        width: 568,
        height: 314,
        start: start,
        play: {
            auto: false,
            interval: 3000,
            swap: true,
            pauseOnHover: false,
            restartDelay: 2500
        }
    });
}

function isMySuperCar(){
    return window.location.href.includes("mysupercar");
}

function isMySuperVan(){
    return window.location.href.includes("mysupervan");
}
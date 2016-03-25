var loadScript = function(url){
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = url;
    head.appendChild(script);
};

/*
var cars_data = {
    'bentley': {'title': '벤틀리', 'models':[]},
    'maserati': {'title': '마세라티', 'models':[]},
    'porsche': {'title': '포르쉐', 'models':[]},
    'benz': {'title': '메르세데스 벤츠', 'models':[]},
    'bmw': {'title': 'BMW', 'models':[]},
    'audi': {'title': '아우디', 'models':[]},
    'volkswagen': {'title': '폭스바겐', 'models':[]},
    'landrover': {'title': '랜드로버', 'models':[]},
    'jaguar': {'title': '재규어', 'models':[]},
    'toyota': {'title': '토요타', 'models':[]},
    'citroen': {'title': '시트로엥', 'models':[]},
    'fiat': {'title': '피아트', 'models':[]},
    'hyundai': {'title': '현태', 'models':[]},
    'kia': {'title': '기아', 'models':[]}
};*/

var page_data = {
    top: 0,
    slide_html: ''
};


(function(window){
    // Bind to StateChange Event
    History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
        var State = History.getState(); // Note: We are using History.getState() instead of event.state

        if(typeof State.data.scrollTop !== 'undefined') {
            if($('.msc_modal').is(':visible')) {
                close_modal();
                $(document).scrollTop(State.data.scrollTop);
            }
        }

        if(typeof State.data.p !=='undefined' && State.data.p === 'brand' && typeof State.data.brand !== 'undefined') {
            open_cars_modal(State.data.brand);
        }

        if(typeof State.data.p !=='undefined' && State.data.p === 'agreement') {
            open_agreement_modal();
        }
    });


    // 브랜드 아이콘 템플릿 렌더링
    var $el_brand_container = $('.brand_icons');
    var brand_icons_template = Handlebars.compile($("#brand_icons_template").html());
    for(var brand in cars_data){
        var $li = $(brand_icons_template({'brand':brand}));
        $li.data(cars_data[brand]);
        $el_brand_container.append($li);
    }

})(window);

$(function(){
    $("a[href='#']").click(function(e){
        e.preventDefault();
    });

    // intro 랜덤 배경
    //var intro_bg_no = Math.floor(Math.random()*10%2+1);
    //$('.intro_area').addClass('bg' + intro_bg_no);

    // 스와이프
    page_data.slide_html = $('#slide_container').html();
    init_slider();


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
    $(".brand_icons a[data-brand]").on('click', function(){
        var brand = $(this).data('brand');
        var scrollTop = $(document).scrollTop();

        History.pushState({scrollTop:scrollTop}, null, "");
        History.pushState({p:'brand',brand:brand}, null, "");
    });

    // 이용자약관 클릭 이벤트
    $('.btn_agreement').on('click', function(){
        var scrollTop = $(document).scrollTop();

        History.pushState({scrollTop:scrollTop}, null, "");
        History.pushState({p:'agreement'}, null, "");
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
    })
});


function logging(category, action_detail, brand, model, area, link) {
    debugger;
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

    alert("open model");
    open_modal();

    $('head title').html("Mysupercar::" + cars_data[brand].title);
    alert("change title");

    ga('set', 'page', '/'+brand);
    ga('send', 'pageview');
    alert("GA");
}

function open_agreement_modal(){
    $('.msc_modal_tit').html('이용자약관');

    $('.msc_container').hide();
    $('.agreement_container').show();
    open_modal();
}

function open_modal(){
    alert("open model");
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
            pauseOnHover: true,
            restartDelay: 2500
        }
    });
}

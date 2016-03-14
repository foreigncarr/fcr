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

var cars_data = {};

var page_data = {
    top: 0
};

function bland_data_callback(data) {
    console.log('bland data loaded');
    cars_data = {};
    var entry = data.feed.entry;
    for (var i in entry){
        try {
            var code = entry[i].gsx$brandcode.$t;
            var title = entry[i].gsx$title.$t;
            var logo = entry[i].gsx$logo.$t;
            cars_data[code] = {title: title, models: [], logo: logo};
        }
        catch(e){}
    }
    var url = "https://spreadsheets.google.com/feeds/list/1tb0Fy74CxayHuSBUCd9OO5_hpvvXKuTCe8nOgNDi87M/od6/public/values?alt=json-in-script&callback=car_data_callback"
    loadScript(url);
}

function car_data_callback(data) {
    console.log('car model data loaded');
    var entry = data.feed.entry;
    for (var i in entry){
        try{
            var brand_code = entry[i].gsx$brandcode.$t;
            var model_code = entry[i].gsx$modelcode.$t;
            var model_name = entry[i].gsx$modelname.$t;
            var image = entry[i].gsx$image.$t;
            var mileage = entry[i].gsx$mileage.$t;
            var fuel = entry[i].gsx$fuel.$t;

            if (cars_data[brand_code] != null) {
                cars_data[brand_code].models.push ({
                    code: model_code,
                    name: model_name,
                    image: image,
                    mileage : mileage,
                    fuel: fuel
                });
            }
        }
        catch(e){}
    }
    init_brand_icons();
}

function init_brand_icons() {

    // 브랜드 아이콘 템플릿 렌더링
    var $el_brand_container = $('.brand_icons');
    var brand_icons_template = Handlebars.compile($("#brand_icons_template").html());
    for(var brand in cars_data){
        var $li = $(brand_icons_template({'brand':brand}));
        $li.data(cars_data[brand]);
        $el_brand_container.append($li);
    }
    // 브랜드 아이콘 클릭 이벤트
    $(".brand_icons a[data-brand]").on('click', function(){
        var brand = $(this).data('brand');
        var scrollTop = $(document).scrollTop();

        History.pushState({scrollTop:scrollTop}, null, "");
        History.pushState({p:'brand',brand:brand}, null, "");
    });
}

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

    var url = "https://spreadsheets.google.com/feeds/list/1jUtKI4UhHgBv2NrX0TQFFGBuqw7LpY2Li2VCo6EE5tA/od6/public/values?alt=json-in-script&callback=bland_data_callback"
    loadScript(url);


    /* move to handler
    // 브랜드 아이콘 템플릿 렌더링
    var $el_brand_container = $('.brand_icons');
    var brand_icons_template = Handlebars.compile($("#brand_icons_template").html());
    for(var brand in cars_data){
        var $li = $(brand_icons_template({'brand':brand}));
        $li.data(cars_data[brand]);
        $el_brand_container.append($li);
    }
    */

})(window);

$(function(){
    $("a[href='#']").click(function(e){
        e.preventDefault();
    });

    // intro 랜덤 배경
    //var intro_bg_no = Math.floor(Math.random()*10%2+1);
    //$('.intro_area').addClass('bg' + intro_bg_no);

    // 스와이프
    $('.slides').slidesjs({
        navigation:{active:false},
        width: 568,
        height: 314,
        play: {
            auto: true,
            interval: 1500,
            swap: true,
            pauseOnHover: true,
            restartDelay: 2500
        }
    });


    /* move to handler
    // 브랜드 아이콘 클릭 이벤트
    $(".brand_icons a[data-brand]").on('click', function(){
        var brand = $(this).data('brand');
        var scrollTop = $(document).scrollTop();

        History.pushState({scrollTop:scrollTop}, null, "");
        History.pushState({p:'brand',brand:brand}, null, "");
    });
    */

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

function open_cars_modal(brand){
    $('.msc_modal_tit').html(cars_data[brand].title);

    var cars_item_template = Handlebars.compile($("#cars_item_template").html());
    var html = cars_item_template(cars_data[brand]);

    $('.msc_container').hide();
    $('.cars_container').show().html(html);
    open_modal();
}

function open_agreement_modal(){
    $('.msc_modal_tit').html('이용자약관');

    $('.msc_container').hide();
    $('.agreement_container').show();
    open_modal();
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
}

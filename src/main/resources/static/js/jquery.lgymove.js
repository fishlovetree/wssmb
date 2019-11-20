/**
 * Created by lgy on 2017/10/21.
 * 图片验证码
 */
(function ($) {
    $.fn.imgcode = function (options) {

        //初始化参数
        var defaults = {
            callback:""  //回调函数
        };
        var opts = $.extend(defaults, options);
        return this.each(function () {
            var $this = $(this);//获取当前对象
            $this.html("");
            
            var html = '<div class="code-k-div">' +
                '<div class="code_bg"></div>' +
                '<div class="code-con">' +
                '<div class="code-img">' +
                '<div class="code-img-con">' +
                '<div class="code-mask"><img id="subimg"></div>' +
                '<div class="imgpanel"><img src="'+basePath+'/images/img.jpg" width="400" height="172"></div></div></div>' +
                '<div class="code-refresh"><img src="'+basePath+'/images/refresh.png" width="32" height="32" onclick="refreshimg()"></div>' +
                '<div class="code-btn"><div class="code-btn-img code-btn-m"></div><span style="top: 5px; position: relative;">按住滑块，拖动完成上方拼图</span></div>' +
                '</div>';
            $this.html(html);

            $(".imgpanel,.testing").jigsaw({});//加载背景图
        	
        	$(".code-mask").css({"top": 3+$.fn.jigsaw.sub.i*43 + "px","left": 3 + "px"});
        	
            //定义拖动参数
            var $divMove = $(this).find(".code-btn-img"); //拖动按钮
            var $divWrap = $(this).find(".code-btn");//鼠标可拖拽区域
            var mX = 0, mY = 0;//定义鼠标X轴Y轴
            var dX = 0, dY = 0;//定义滑动区域左、上位置
            var isDown = false;//mousedown标记
            if(document.attachEvent) {//ie的事件监听，拖拽div时禁止选中内容，firefox与chrome已在css中设置过-moz-user-select: none; -webkit-user-select: none;
                $divMove[0].attachEvent('onselectstart', function() {
                    return false;
                });
            }

            //按钮拖动事件
            $divMove.on({
                mousedown: function (e) {
                    var event = e || window.event;
                    mX = event.pageX;
                    dX = $divWrap.offset().left;
                    dY = $divWrap.offset().top;
                    isDown = true;//鼠标拖拽启
                    //$(this).addClass("active");
                    //修改按钮阴影
                    $divMove.css({"box-shadow":"0 0 8px #666"});
                }
            });
            //鼠标点击松手事件
            $divMove.mouseup(function (e) {
            	var left=$(".code-mask").position().left;

                isDown = false;//鼠标拖拽启
                //$divMove.removeClass("active");
                //还原按钮阴影
                $divMove.css({"box-shadow":"0 0 3px #ccc"});
                checkcode(left);
            });
            //滑动事件
            $divWrap.mousemove(function (event) {
                var event = event || window.event;
                var x = event.pageX;//鼠标滑动时的X轴
                if (isDown) {
                    if(x>(dX+30) && x<dX+$(this).width()-20){
                        $divMove.css({"left": (x - dX - 20) + "px"});//div动态位置赋值
                        $this.find(".code-mask").css({"left": (x - dX-30) + "px"});
                    }
                }
            });
            //验证数据
            function checkcode(left){
                
                if(Math.abs(109+$.fn.jigsaw.sub.j*100-left)<2){
                	if(plan_link==0)
                		$("#showDetermine").show();
                	else
                		$("#showLinkage").show();
                }
                /*else{
                	$("#showDetermine").hide();
                }*/
            }
            
        })
    }
    
    $.fn.jigsaw = function(options)
	{
		var settings = $.extend( {}, $.fn.jigsaw.defaults, options );
		$.fn.jigsaw.defaults = settings;
		//image value in defaults
		$.fn.jigsaw.defaults.image = this.children("img").attr("src");
		this.append('<div class="jigsaw_panel_"></div>');
		$.fn.jigsaw.defaults.width = this.children("img").attr("width");
		$.fn.jigsaw.defaults.height = this.children("img").attr("height");
		
		obj = this.children(".jigsaw_panel_");
		obj.css("width",parseInt($.fn.jigsaw.defaults.width) + parseInt($.fn.jigsaw.defaults.x*$.fn.jigsaw.defaults.margin*2) +"px").css("border","3px double #fb9d48").css("font-size","0");
		w = Math.floor($.fn.jigsaw.defaults.width/$.fn.jigsaw.defaults.x);
		h = Math.floor($.fn.jigsaw.defaults.height/$.fn.jigsaw.defaults.y);
		
		$.fn.jigsaw.sub.i=Math.floor(Math.random()*4);
		$.fn.jigsaw.sub.j=Math.floor(Math.random()*4);
		
		for(i=0;i<$.fn.jigsaw.defaults.x;i++)
		{
			for(j=0;j<$.fn.jigsaw.defaults.y;j++)
			{
				pos = "block" +i +j;
				obj.append("<div pos='" +pos +"'></div>");
				
				if(i==$.fn.jigsaw.sub.i && j==$.fn.jigsaw.sub.j){
					obj.children("div[pos='" +pos +"']").css("background-position","-" +(j*w) +"px -" +(i*h) +"px").css("width",w +"px").css("height",h+"px").css("display","inline-block").css("margin",$.fn.jigsaw.defaults.margin);
					
					$("#subimg").css("background-position","-" +(j*w) +"px -" +(i*h) +"px").css("width",w +"px").css("height",h+"px").css("background-image","url("+$.fn.jigsaw.defaults.image+")");
				}else
					obj.children("div[pos='" +pos +"']").css("background-position","-" +(j*w) +"px -" +(i*h) +"px").css("width",w +"px").css("height",h+"px").css("background-image","url("+$.fn.jigsaw.defaults.image+")").css("display","inline-block").css("margin",$.fn.jigsaw.defaults.margin);
			}
			//obj.append("<div class='clearfix'></div>");
		}
		this.children("img").hide();
		obj.fadeIn();
		//animate(this);
	}
	
	$.fn.jigsaw.sub = {
		i : 0,
		j : 0
	}
	
	$.fn.jigsaw.defaults = {
		width: 100,
		height: 200,
		x : 4,
		y : 4,
		margin : 0,
		error : 9,
		image: ""
	}
})(jQuery);

//刷新
function refreshimg(){
	if(plan_link==0){
		$("#imgscode").imgcode();
		$("#showDetermine").hide();
	}
	else{
		$("#imgscodeLink").imgcode();
		$("#showLinkage").hide();
	}
}
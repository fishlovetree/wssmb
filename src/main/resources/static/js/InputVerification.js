
// 非空字符串验证。 easyui 原装required 不能验证空格------NotEmpty 
// 限制长度 -区间------Len[min,max]
// 限制长度-至少 ------MinLen[min]
// 验证数字------Num
// 验证数字和"-"(组织机构代码验证，本系统中组织机构代码由全数字组成。)------NumBar
// 验证整数或小数------IntOrFloat 
// 正整数或负整数------Integer 
// 验证字母------Let 
// 验证大写字母------LetBig 
// 验证小写字母------LetSmall 
// 不能有特殊字符只能由数字、大小写字母组成------SpecialCharacter 
// 验证是否包含空格和非法字符------Unnormal
// 验证中文------Chinese 
// 验证身份证号------Card  目前校验和验证屏蔽中，正式上传需要开放
// 验证电话号码------Phone 
// 验证手机号码------MobilePhone 
// 既验证手机号，又验证座机号------telNum
// 验证邮箱------Email 
// 验证传真------Faxno 
// 验证邮政编码------Zip 
// 验证IP地址------IP 
// 验证msn------Msn 
// 验证日期格式yyyy-MM-dd或yyyy-M-d------Date 
// 验证货币------Currency 
// 验证QQ,从10000开始------QQ 
// 验证年龄------Age 
// 验证用户名------Username
// 验证密码------Pwd
// 验证姓名，可以是中文或英文------Name 
// 验证两次密码是否一致------PwdSame[id]  (元素id)

$(function() {
	$.extend( $.fn.validatebox.defaults.rules, {
		
		// 非空字符串验证。 easyui 原装required 不能验证空格  
		NotEmpty : { 
			validator : function(value) {
				return $.trim(value).length > 0;
			},
			message : '请输入有效值，不能全由空格组成！'
		},

		// 限制长度 -区间
		Len : {
			validator : function(value, param) {
				var len = $.trim(value).length;
				return len >= param[0] && len <= param[1];
			},
			message : "输入内容长度必须介于{0}和{1}之间！"
		},
		
		// 限制长度-至少 
		MinLen : {
			validator : function(value, param) {
				return value.length >= param[0];
			},
			message : '请输入至少{0}个字符！'
		},

		// 验证数字
		Num : {
			validator : function(value) {
				return /^[0-9]+$/i.test(value);
			},
			message : '请输入数字！'
		},

		// 验证数字和"-"(组织机构代码验证，本系统中组织机构代码由全数字组成。)
		NumBar : {
			validator : function(value) {
				return /^[0-9\-]+$/i.test(value);
			},
			message : '请输入数字或"-"！'
		},
		
		// 验证整数或小数
		IntOrFloat : {
			validator : function(value) {
				return /^\d+(\.\d+)?$/i.test(value);
			},
			message : '请输入数字，并确保格式正确！'
		},
		
		// 验证正整数或负整数
		Integer : {
			validator : function(value) {
				return /^([+]?[0-9])|([-]?[0-9])+\d*$/i
						.test(value);
			},
			message : '请输入整数！'
		},

		// 验证字母
		Let : {
			validator : function(value) {
				return /^[A-Za-z]+$/i.test(value);
			},
			message : '请输入字母！'
		},

		// 验证大写字母
		LetBig : {
			validator : function(value) {
				return /^[A-Z]+$/i.test(value);
			},
			message : '请输入大写字母！'
		},

		// 验证小写字母
		LetSmall : {
			validator : function(value) {
				return /^[a-z]+$/i.test(value);
			},
			message : '请输入大写字母！'
		},

		//不能有特殊字符只能由数字、大小写字母组成
		SpecialCharacter : {
			validator : function(value) {
				return /[A-Za-z0-9]+$/i.test(value);
			},
			message : '只能由数字、大小写字母组成！'
		},
		
		// 验证是否包含空格和非法字符
		Unnormal : {
			validator : function(value) {
				return /.+/i.test(value);
			},
			message : '输入值不能为空和包含其他非法字符！'
		},

		//汉字
		/*China : {
			validator : function(value) {
				return /^[\u4e00-\u9fa5]{0,}$/i.test(value);
			},
			message : '请输入中文字符！'
		},*/
		
		// 验证中文
		Chinese : {
			validator : function(value) {
				return /^[\Α-\￥]+$/i.test(value);
			},
			message : '请输入中文！'
		},

		// 验证身份证号
		Card : {
			validator : function(value) {
				var flag= isCardID(value);             
				return flag==true?true:false; 
			},
			message : '请输入正确身份证号码！'
		},

		// 验证座机号
		Phone : {
			validator : function(value) {
				return /^(\(\d{3,4}\)|\d{3,4}-|\s)?\d{7,14}$/.test(value);
			},
			message : '电话号码格式不正确,请使用下面格式:0000-88888888！'
		},
		
		// 验证手机号码
		MobilePhone : {
			validator : function(value) {
				return  /^1[34578]\d{9}$/.test(value);
			},
			message : '手机号码格式不正确！'
		},
		
		//既验证手机号，又验证座机号
		telNum:{ 
	    	validator: function(value, param){ 
	        	return /(^((0[0-9]{2,3}\-)|(0[0-9]{2,3}))?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^((\d3)|(\d{3}\-))?(1[34578]\d{9})$)/.test(value);
	    	},    
	    	message: '请输入正确的座机号码或手机号码。' 
	    } , 

		// 验证邮箱
		Email : {
			validator : function(value) {
				return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/i
						.test(value);
			},
			message : '请输入正确邮箱！'
		},
		
		// 验证传真
		Faxno : {
			validator : function(value) {
				return /^((\d{2,3})|(\d{3}\-))?(0\d{2,3}|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i
						.test(value);
			},
			message : '传真号码不正确！'
		},
		
		// 验证邮政编码
		Zip : {
			validator : function(value) {
				return /^[1-9]\d{5}$/i.test(value);
			},
			message : '邮政编码格式不正确！'
		},
		
		// 验证IP地址
		IP : {
			validator : function(value) {
				return /d+.d+.d+.d+/i.test(value);
			},
			message : 'IP地址格式不正确！'
		},
		
		// 验证msn
		Msn : {
			validator : function(value) {
				return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/
						.test(value);
			},
			message : '请输入有效的msn账号(例：abc@hotnail(msn/live).com)！'
		},

		// 验证日期格式yyyy-MM-dd或yyyy-M-d
		Date : {
			validator : function(value) {
				return /^(?:(?!0000)[0-9]{4}([-]?)(?:(?:0?[1-9]|1[0-2])\1(?:0?[1-9]|1[0-9]|2[0-8])|(?:0?[13-9]|1[0-2])\1(?:29|30)|(?:0?[13578]|1[02])\1(?:31))|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)([-]?)0?2\2(?:29))$/i
						.test(value);
			},
			message : '请输入正确日期：yyyy-mm-dd或yyyy-M-d！'
		},

		// 验证货币
		Currency : {
			validator : function(value) {
				return /^\d+(\.\d+)?$/i.test(value);
			},
			message : '货币格式不正确！'
		},
		
		// 验证QQ,从10000开始
		QQ : {
			validator : function(value) {
				return /^[1-9]\d{4,9}$/i.test(value);
			},
			message : 'QQ号码格式不正确！'
		},
		
		// 验证年龄
		Age : {
			validator : function(value) {
				return /^(?:[1-9][0-9]?|1[01][0-9]|120)$/i
						.test(value);
			},
			message : '年龄必须是0到120之间的整数！'
		},
		
		// 验证用户名
		Username : {
			validator : function(value) {
				return /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/i
						.test(value);
			},
			message : '用户名不合法（字母开头，允许6-16字节，允许字母数字下划线）！'
		},
		
		// 验证密码， 密码验证的正则表达式:由数字和字母组成，并且要同时含有数字和字母，且长度要在6-16位之间。
		Pwd : {
			validator : function(value) {
				return /^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z][a-zA-Z0-9_]{6,16}$/i
						.test(value);
			},
			message : '密码不合法（字母开头，由数字和字母组成，并且要同时含有数字和字母）！'
		},
		
		// 验证姓名，可以是中文或英文
		Name : {
			validator : function(value) {
				return /^[\Α-\￥]+$/i.test(value)
						| /^\w+[\w\s]+\w+$/i.test(value);
			},
			message : '请输入姓名！'
		},
		
		// 验证两次密码是否一致
		PwdSame : {
			validator : function(value, param) {
				if ($("#" + param[0]).val() != ""
						&& value != "") {
					return $("#" + param[0]).val() == value;
				} else {
					return true;
				}
			},
			message : '两次输入的密码不一致！'
		}
		
	});
});

function isCardID(code) { 
    var city={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江 ",31:"上海",32:"江苏",33:"浙江",34:"安徽",
    		35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北 ",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",
    		53:"云南",54:"西藏 ",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外 "};
    var tip = "";
    var pass= true;

    if(!code || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(code)){
        tip = "身份证号格式错误";
        pass = false;
    }

   else if(!city[code.substr(0,2)]){
        tip = "地址编码错误";
        pass = false;
    }
    else{
        //18位身份证需要验证最后一位校验位
        /*if(code.length == 18){
            code = code.split('');
            //∑(ai×Wi)(mod 11)
            //加权因子
            var factor = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ];
            //校验位
            var parity = [ 1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2 ];
            var sum = 0;
            var ai = 0;
            var wi = 0;
            for (var i = 0; i < 17; i++)
            {
                ai = code[i];
                wi = factor[i];
                sum += ai * wi;
            }
            var last = parity[sum % 11];
            if(parity[sum % 11] != code[17]){
                tip = "校验位错误";
                pass =false;
            }
        }*/
    }
    //if(!pass) return tip;
    return pass;
}
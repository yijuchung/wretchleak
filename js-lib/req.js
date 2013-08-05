var http_request = false;
var timer = 0;
// 建立 xmlhttprequest 物件 並確認可執行性
function makeRequest() {

        http_request = false;

        if (window.XMLHttpRequest) { // Mozilla, Safari,...
            http_request = new XMLHttpRequest();
            if (http_request.overrideMimeType) {
                http_request.overrideMimeType('text/xml');
            }
        } else if (window.ActiveXObject) { // IE
			var XmlHttpVersions = new Array('MSXML2.XMLHTTP.6.0','MSXML2.XMLHTTP.5.0','MSXML2.XMLHTTP.4.0','MSXML2.XMLHTTP.3.0','MSXML2.XMLHTTP','Microsoft.XMLHTTP');
			// try every prog id until one works
			for (var i=0; i<XmlHttpVersions.length && !http_request; i++){
				try{
				// try to create XMLHttpRequest object
					http_request = new ActiveXObject(XmlHttpVersions[i]);
				}
				catch (e) {} // ignore potential error
				}
        }

        if (!http_request) {
            return false;
        }else{
			return true;
		}

    }

// 執行 httprequest 並把數據傳出
function process(url, param, method){
	if(http_request){
		http_request.onreadystatechange = checkstatus;
		if(method == "GET"){
			http_request.open(method, url + param, true);
			http_request.send(null);
		}else if(method == "POST"){
			http_request.open(method, url, true);
			http_request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			http_request.setRequestHeader("Content-length", param.length);
			http_request.setRequestHeader("Connection", "close");
			http_request.send(param);
		}
	}
}

// 處理整個 ajax 呼叫過程
function call_ajax(url, param, method, id){
	if(id != ""){
		ajax_id = id;

		d = document.getElementById("loading");
		m = document.getElementById("load_msg");
		i = document.getElementById("load_img");

		if(d != null && m != null && i != null){			
			i.src = "images/loadg.gif";
			if(request_type == 0){
				m.innerHTML = " 好友描述獲取中...";
				d.style.display = "block";	

			}else if(request_type == 1){
				m.innerHTML = " 好友描述分析中...";
			}else if(request_type == 3){
				m.innerHTML = " 正在獲取認證碼...";
				d.style.display = "block";	
			}else if(request_type == 4){
				m.innerHTML = " 驗證中...";
				d.style.display = "block";	
			}


			if(makeRequest()){

			//	m.innerHTML = target_msg[target_type] + request_msg[request_type];
				process(url, param, method);

			//	alert(url +"," + param + "," + method);

			}else{
			//	i.src = "../pic/error.gif";
				e.innerHTML = " 無法發出請求...";
				setTimeout(d.style.display="none", 5);
			}
		}else{
			

		}

	}
}

function checkstatus() {
	d = document.getElementById("loading");
	m = document.getElementById("load_msg");
	i = document.getElementById("load_img");


	 if (http_request.readyState == 4){

			a = document.getElementById(ajax_id);
			//a_time = document.getElementById(ajax_id + "_t");
			
		if (http_request.status == 200) {			
		//	alert(http_request.responseText);

			if(d != null && m != null && i != null){
				if(request_type == 0){
					progress = 50;		
					 tmpx = parseResult(http_request.responseText);
				//	 update_content("res", tmpx);
					if(backana != "" && open_friend && have_friend){
					//	alert(backana);
						check(backana, init_id);
					}else{
						progress = 100;
					}
			//		m.innerHTML = target_msg[target_type] + result_msg[request_type];

				}else if(request_type == 1){	
						clearInterval(time3);
						progress = 100;
					//	parseResult2(http_request.responseText);
						tmpx2 = parseResult2(http_request.responseText)						
						update_content("res2", tmpx2);
				}else if(request_type == 3){	
				//	alert(http_request.responseText);
						tmpx3 = parseResult3(http_request.responseText);
						if(tmpx3 == 1){
							update_content("msg_content", "確認您是<strong>帳號擁有者</strong>: 請把 <strong>認證碼</strong> 放到您的無名小站 <strong><a href=\"http://www.wretch.cc/user/"+ user_id + "\" target=\"_blank\">名片</a></strong> 中任一公開欄位, 並點選 <strong>驗證</strong>. ");
							update_content("user_id_show", user_id);
							setTimeout("show_div('code_detail')", 550);
							hide_div_x("id_detail");
						}else{
							update_content("msg_content", err_msg[4]);

						}
						progress = 100;
						setTimeout("show_div('msg_info')", 550);
				}else if(request_type == 4){
					//alert(http_request.responseText);
						tmpx4 = parseResult4(http_request.responseText);
						if(tmpx4 == 1){
							update_content("msg_content", user_id + ": 恭喜您!! 您已經通過驗證, 請點選 <strong>\"進入\"</strong> 使用本服務!! ");
							setTimeout("show_div('gogo_detail')", 550);
							hide_div_x("code_detail");

							var gl = document.getElementById("golink");
							if(gl){
								gl.href="show.php?user="+user_id +"&t=" + code_id;
							}

						}else{
							update_content("msg_content", user_id + ": 驗證失敗...第一次驗證請參考 <a href=\"http://mmnet.iis.sinica.edu.tw/proj/wretchinfo/tutorial.php\" target=\"_blank\">教學文件</a> 喔~!! 請選擇 <strong><a href=\"javascript:backCode()\">重新驗證</a></strong> 或 <strong><a href=\"javascript:backId()\">輸入帳號</a></strong> ");

						}
						progress = 100;
						setTimeout("show_div('msg_info')", 550);
				}else if(request_type == 5){
					//alert(http_request.responseText);
					var tmpx = "" + http_request.responseText;
					//alert(tmpx);
					var resx = 0;
					var lines = tmpx.split("\n");
					var i = 0;
					while(i < lines.length){
						//alert(lines[i]);
						if(lines[i] == "--OKOK--"){
							resx = 1;
						}else if(lines[i] == "--SQLERR--"){
							resx = 2;
						}else if(lines[i] == "--ERR--"){
							resx = 3;
						}		
						i++;
					}					
					//alert(http_request.responseText);
					if(resx == 1){
						update_content("survey_msg", "<strong>問卷已經成功送出，非常感謝您的協助!!!</strong>");
						hide_div_x("survey_detail");
					}else if(resx == 2){
						update_content("survey_msg", "@@ 資料庫錯誤....請 <strong><a href=\"javascript:toggle_show_div('survey_detail')\">稍侯再試</a></strong>~~~感謝!!");
						show_div("survey_com");
						hide_div_x("survey_tran");
						
					}else if(resx == 3){
						update_content("survey_msg", "不明的錯誤....");
						show_div("survey_com");
						hide_div_x("survey_tran");
					}
				}else if(request_type == 6){
				//	alert(http_request.responseText);
					var tmpx = "" + http_request.responseText;
					//alert(tmpx);
					var resx = 0;
					var donex = 0;
					var lines = tmpx.split("\n");
					var i = 0;
					while(i < lines.length){
						//alert(lines[i]);
						if(lines[i] == "--OKOK--"){
							resx = 1;
						}		
						if(lines[i] == "--DONE--"){
						
							donex = 1;
						}		
						
						i++;
					}					
					//alert(http_request.responseText);
					if(resx == 1){
						show_div("survey");
					}else if(donex == 1){
						update_content("survey_msg", "<strong>您已經完成問卷了，非常感謝您!!!</strong>");
						show_div("survey");					
					}					
				}


				clearTimeout(timer);

				if(request_type == 1){
			//		timer = setTimeout("hide_div(d)", 500);

				}


			}
	

		} else {
			/*
			if(d != null && m != null && i != null){

				m.innerHTML = " 伺服器錯誤, 請稍後再試.";
				i.src = "../pic/error.gif";
				d.style.display="block";
			}
			*/
		}

	}
}




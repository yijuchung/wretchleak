// Variables
var backana = "";
var final_name = "";
var user_id = "";
var code_id = "";
var nickname = "";
var gender = 0;
var num_tag_frn = 0;
var msgx = "";

// Arrays
var frn_id = Array();
var frn_des = Array();
var name_2 = Array();
var tf_name_2 = Array();
var name_3 = Array();
var tf_name_3 = Array();
var nick = Array();
var tf_nick = Array();
var tag = Array();
var tf_tag = Array();
var tag2 = Array();
var tf_tag2 = Array();
var btn_name = Array();


// Status
var open_profile = true;
var open_friend = true;
var have_friend = true;
var have_profile = true;
var toggle_select = false;
var toggle_mode_detail = true;


// Loading 
var timer_started = 0;
var time2 = 0;
var time3 = 0;
var progress = 0;
var p_speed = 25;
var maxx = 559;
var old_key = "";
var old_id = "";
var old_style = "";

// Conponent Des
var info_name = Array();
info_name[0]="bir";
info_name[1]="blo";
info_name[2]="hei";
info_name[3]="wei";
info_name[4]="edu";
info_name[5]="occ";
info_name[6]="hob";
info_name[7]="fav";
info_name[8]="dis";
info_name[9]="ema";
info_name[10]="msn";
info_name[11]="yah";
info_name[12]="qqq";
info_name[13]="aim";
info_name[14]="goo";
info_name[15]="sky";
info_name[16]="int";
info_name[17]="vis";

var name_res_name = Array();
name_res_name[0] = "rname";
name_res_name[1] = "name3";
name_res_name[2] = "name2";
name_res_name[3] = "nick";
name_res_name[4] = "tag";
name_res_name[5] = "tag2";

// Messages
err_msg = Array();
err_msg[0] = "使用者名片關閉中";
err_msg[1] = "使用者沒有公開任何個人資訊";
err_msg[2] = "使用者好友關閉中";
err_msg[3] = "使用者沒有加我好友";
err_msg[4] = "伺服器錯誤或操作錯誤, 無法取得認證碼...";


// preload images;
pic1= new Image(36, 39); 
pic1.src="images/loadg.gif"; 

pic2= new Image(624,43); 
pic2.src="images/loadx.gif"; 

pic3= new Image(5,25); 
pic3.src="images/bar_left.gif"; 

pic4= new Image(5,25); 
pic4.src="images/bar_middle.gif"; 

pic5= new Image(5,25); 
pic5.src="images/bar_right.gif"; 


// UI Functions ------------------------------------------------------------------------

function backId(){
	show_div("id_detail");
	hide_div_x("code_detail");
	update_content("msg_content","請輸入您的無名帳號~~第一次來的好友請先看<a href=\"tutorial.php\">教學頁</a>喔~!!");
}



function backCode(){
	show_div("code_detail");
	update_content("msg_content", "確認您是<strong>帳號擁有者</strong>: 請把<strong>認證碼</strong>放到您的無名小站 <strong><a href=\"http://www.wretch.cc/user/"+ user_id + "\" target=\"_blank\">名片</a></strong> 中任一 <strong>公開欄位</strong> , 並點選 <strong>驗證</strong>. ");
}

function update_content(id, con){
	e = document.getElementById(id );
	if(e != null){
		e.innerHTML = con;
	}
}

function update_content_form(id, con){
	e = document.getElementById(id );
	if(e != null){
		e.value = con;
	}
}



function update_progress(){
	e = document.getElementById('load_bar_middle');
	if(e){
		tmp = e.style.width;
		tmp = tmp.replace(/px/i, ""); 
		tmp = parseInt(tmp);			
		tmp2 = progress / 100 * maxx;
		if(tmp < tmp2){
			if(progress < 100){
				tmp += Math.round(p_speed * ((tmp2 - tmp) / tmp2 )) + 1;
				e.style.width = tmp + "px";
			}else{
				e.style.width = maxx + "px";
			}
		}else{
			if(tmp >= maxx){
				timer = setTimeout("hide_div(d)", 500);
				if(timer_started == 1){
					timer_started = 0;
					clearInterval(time2);
				}
			}
		}
	}
}

function change_back(obj){
//	alert(obj.className);
	if(obj.className == 't_frn2'){
		obj.className = 't_frn';		
	}

	if(obj.className == 't_frn2x'){
		obj.className = 't_frnx';		
	}


	hide_div_x("frn_pop");
}

function change_back2(obj){
//	alert(obj.className);
	if(obj.className == 't_frn2'){
		obj.className = 't_frn3';
	}

	if(obj.className == 't_frn33'){
		obj.className = 't_frn3';
	}
}

function change_go(obj, index){
//	alert(obj.className);


	if(obj.className != 't_frn3' && toggle_mode_detail == false ){
		update_content("pop_middle", frn_des[index]);
		ex = document.getElementById('frn_pop');
		if(ex){
			ex.style.left = (findPosX(obj) + 35) + "px";
			if(typeof(ie) != "undefined"  && ie == "yes"){
				ex.style.top = (findPosY(obj) - 28) + "px";
			}else{
				ex.style.top = (findPosY(obj) - 22) + "px";
			}
		}
		show_div("frn_pop");
	}
	if(obj.className == 't_frn'){
		obj.className = 't_frn2';
	}else if(obj.className == 't_frnx'){
		obj.className = 't_frn2x';
	}else if(obj.className == 't_frn3'){
		obj.className = 't_frn33';
	}
}

// Reset Functions ------------------------------------------------------------------------


function reset_progress(){
	e = document.getElementById('load_bar_middle');
	if(e){
		e.style.width = "0px";
	}
}

function reset_vars(){
	backana = "";
	final_name = "";
	msgx = "";
	frn_id = Array();
	frn_des = Array();
	name_2 = Array();
	tf_name_2 = Array();
	name_3 = Array();
	tf_name_3 = Array();
	nickname = Array();
	tf_nickname = Array();
	tag = Array();
	tf_tag = Array();
	tag2 = Array();
	tf_tag2 = Array();
	num_tag_frn = 0;
	user_id = "";
	nickname = "";
	gender = 0;
	open_profile = true;
	open_friend = true;
	have_friend = true;
	have_profile = true;
//	toggle_select = false;
}

function reset_ui(){
	hide_div_x("info");
	hide_div_x("info_content_detail");
	
	x = 0;
	while(x < info_name.length){
		hide_div_x("tr_" + info_name[x]);
		clear_div(info_name[x]);
		x++;
	}

	hide_div_x("name_result");
	hide_div_x("name_result_detail");

	x = 0;
	while(x < name_res_name.length){
		hide_div_x("tr_" + name_res_name[x]);
		clear_div(name_res_name[x]);
		x++;
	}

	hide_div_x("friend_list");
	hide_div_x("friend_list_detail");
	clear_div("frnx");
	clear_div("total_frn");
	hide_div_x("select_frn");
	hide_div_x("select_frn_per");
	hide_div_x("select_frn_num");
	hide_div_x("select_frn_ony");
	hide_div_x("msg_info");

}

// Action Functions ------------------------------------------------------------------------


function getPage(){
	e = document.getElementById("ifi");
	if(e){
		alert(e.contentWindow.document.getElementById("container"));
	}
}

function increase_progress(){
	if(progress < 80){
		progress += 2;
	}
}

function increase_progress2(){
	if(progress < 95){
		progress += 3;
	}
}

function check_survey(){
	var id = get_value("user_id");	
	request_type = 6;
	param = "uid=" + encodeURIComponent(trim(id));
	call_ajax("check_survey.php", param , "POST", id);		
}

function complete_survey(){
	var res_sc = Array();
	var res_mc = Array();
	var res_mc2 = Array();
	
	var res_ft = Array();
	
	var res_ptt_id = "";
	var res_email = "";
	
	var err_sc = "";
	var err_mc = "";	
	var err_msg = "";
	

	
	i = 0;
	// get value -- SC
	while(i < 8){
		sel_yes =  get_value("sc" + parseInt(i+1) + "_1");
		sel_no =  get_value("sc" + parseInt(i+1) + "_2");		
		if(sel_yes == true || sel_no == true){
			if(sel_yes == true){
				res_sc[i] = 1;
			}else{
				res_sc[i] = 0;
			}
		}else{
			err_sc += parseInt(i+1) + ", ";
		}		
		i++;
	}
	
	if(err_sc != ""){
		err_sc = err_sc.substr(0, err_sc.length - 2);
		err_msg = "請完成選擇題第 " + err_sc + " 題。";
	}
	
	// get value -- MC
	// if question 6 is true
	var got_checked = 0;
	i = 0;
	// get value -- SC
	while(i < 9){
		sel_check =  get_value("mc1_" + parseInt(i+1) );
		if(sel_check){
			res_mc[i]  = 1;
			got_checked++;
		}else{
			res_mc[i] = 0;			
		}
		i++;
	}
	
	i = 0;	
	while(i < 9){
		sel_check =  get_value("mc2_" + parseInt(i+1) );
		if(sel_check){
			res_mc2[i]  = 1;
		}else{
			res_mc2[i] = 0;			
		}
		i++;
	}	
	
	sel_ft = get_value("ft1");
	sel_ft2 = get_value("ft2");
	
	if(	res_sc[5] == 1){	
		if(got_checked == 0 && trim(sel_ft) == ""){
			err_msg += "\n請勾選或填寫第 6 題下面的資訊，至少勾選或填寫一項。";			
		}	
	}	
	
	res_ptt_id = get_value("ptt_id");
	res_email = get_value("email");
	
	/*if(trim(res_ptt_id) == "" && trim(res_email) == ""){
		err_msg += "\n為了確保您能順利獲得 p 幣以及抽獎獎品，\"ppt ID\" 或 \"email address\"請至少填寫一項。";				
	}*/
	
	if(trim(res_email) == ""){
		err_msg += "\n為了確保您能順利獲得抽獎獎品，請填寫您的電子郵件地址。";				
	}
	
	if(err_msg != ""){
		//err_msg += "\nP.S. 若要收到 p幣必須填寫 \"ptt ID\"。";			
	
		alert(err_msg);
	}else{
		var id = get_value("user_id");
		hide_div_x("survey_com");
		show_div("survey_tran");
		
		request_type = 5;
		param = "uid=" + encodeURIComponent(trim(id)) + "&sc=" + encodeURIComponent(res_sc.join(",")) + "&mc=" + encodeURIComponent(res_mc.join(",")) +  "&ft=" + encodeURIComponent(sel_ft) + "&ptt=" + encodeURIComponent(res_ptt_id) + "&email=" + encodeURIComponent(res_email) + "&mc2=" + encodeURIComponent(res_mc2.join(",")) +  "&ft2=" + encodeURIComponent(sel_ft2);
		call_ajax("survey_done.php", param , "POST", id);		
		// No error, here we go
	//	alert("ID:" + id + "\nSC:" + res_sc.join(",") + "\nMC:" + res_mc.join(",") + "\nFT:" + sel_ft + "\nPTT:" + res_ptt_id + "\nEMAIL:" + res_email )
	}
	
}

function query(id){

	if(progress == 100 || progress == 0){
		reset_vars();
		reset_ui();
		reset_progress();

		e = document.getElementById(id);
		if(e != null && e.value != ""){
			progress = 0;
			if(timer_started == 0){
				timer_started = 1;
				time2 = setInterval(update_progress, 50);
			}
			progress = 20;
			time3 = setInterval(increase_progress, 3000);

			param = "id=" + encodeURIComponent(trim(e.value));
			request_type = 0;	
			init_id = id;	
			user_id = e.value;
			update_content("id_name", "<a href=\"http://www.wretch.cc/album/" + user_id + "\" target=\"_blank\">" + user_id  + "</a>" );		
			update_content("res", "");
			update_content("res2", "");
			
	//		getPage();
			call_ajax("get_user.php", param , "POST", id);
		}else{
			update_content("msg_content", "請輸入無名帳號~~");
			show_div("msg_info");
		}
	}else{
		reset_progress();
	}
}

function query_code(){
	e = document.getElementById("user_id");
	v = document.getElementById("code_field");
	b = document.getElementById("boat");

	if(e != null && e.value != "" && v != null && v.value != "" && b != null && b.value != ""){
		pcode_id = trim(v.value);
		puser_id = trim(e.value);
		pboat = trim(b.value);

		param = "tank=" + encodeURIComponent(pcode_id) + "&aeroplane=" + encodeURIComponent(puser_id) + "&boat=" + encodeURIComponent(pboat);
//		alert(param);
		reset_progress();
		request_type = 4;	
		progress = 0;
		if(timer_started == 0){
			timer_started = 1;
			time2 = setInterval(update_progress, 50);
		}

		progress = 20;
		time3 = setInterval(increase_progress, 1500);
		call_ajax("check_code.php", param , "POST");
		hide_div_x("code_detail");
		hide_div_x("msg_info");


	}
}

function allright(){
		e = document.getElementById("user_id");
		if(e != null && e.value != ""){
			user_id = trim(e.value);
			param = "aeroplane=" + encodeURIComponent(user_id);
			reset_progress();
			request_type = 3;	
			progress = 0;
			if(timer_started == 0){
				timer_started = 1;
				time2 = setInterval(update_progress, 50);
			}
			progress = 40;
			time3 = setInterval(increase_progress, 500);
			call_ajax("get_code.php", param , "POST");
			hide_div_x("msg_info");

		}else{
			update_content("msg_content", "@@...請輸入無名帳號喔~!!");
			show_div("msg_info");
		}
		return(false);
}

function check(msg, id){
	clearInterval(time3);
	progress = 80;
	time3 = setInterval(increase_progress2, 3000);
	e = document.getElementById(id);
	if(e != null){
		param = "id=" + encodeURIComponent(trim(e.value));
		param += "&msg=" + encodeURIComponent(msg);
		request_type = 1;		
		ajax_id_related = "";	
		call_ajax("get_check.php", param , "POST", id);
		draw_frns();

	}
}

function draw_frns(){
	if(open_friend && have_friend){

		conx = "";
	//	alert(frn_id.length);

		j = 0;
		no_des = 0;
		num_tag_frn = 0;
		if(toggle_mode_detail == true){
			while(j < frn_id.length){
				if(frn_des[j] != ""){
					num_tag_frn++;
					conx +=	"<div style=\"display:block\" id=\"frn_"+ j +"\" class=\"t_frn\" onmouseover=\"change_go(this, "+ j +")\" onmouseout=\"change_back(this)\" ><a href=\"http://www.wretch.cc/album/"+ frn_id[j] +"\" target=\"_blank\" ><div id=\"frn_id"+ j +"\" class=\"frn_id_x\">" + frn_id[j] + "</div><div id=\"frn_des_"+ j +"\" class=\"frn_des_x\">" + frn_des[j] + "</div></a></div>";
				}else{
					no_des = 1;
				}
				j++;
			}
		}else{
			while(j < frn_id.length){
				if(frn_des[j] != ""){
					num_tag_frn++;
					conx +=	"<div style=\"display:block\" id=\"frn_"+ j +"\" class=\"t_frnx\" onmouseover=\"change_go(this, "+ j +")\" onmouseout=\"change_back(this)\" ><a href=\"http://www.wretch.cc/album/"+ frn_id[j] +"\" target=\"_blank\" >" + frn_id[j] +"</a></div>";
				}else{
					no_des = 1;
				}
				j++;
			}

		}			
			if(no_des == 1){
				j = 0;
				conx += "<div id=\"frn_no_des\" style=\"width:500px;color:#999999;padding-bottom:5px;padding-left:5px;padding-top:10px;float:left;\">未使用好友描述的朋友 (" + (frn_id.length - num_tag_frn) +")</div>";
				while(j < frn_id.length){
					if(frn_des[j] == ""){
						conx +=	"<div style=\"display:block\" id=\"frn_"+ j +"\" class=\"t_frn3\" onmouseover=\"change_go(this)\" onmouseout=\"change_back2(this)\" ><a href=\"http://www.wretch.cc/album/"+ frn_id[j] +"\" target=\"_blank\" >" + frn_id[j] + "</a></div>";
					}
					j++;
				}
			}

		update_content("frnx", conx);	
		update_content("total_frn", "&nbsp;(" + num_tag_frn + ")");	
		show_div("friend_list");
		show_div('friend_list_detail');
	}

}

// Style Functions ------------------------------------------------------------------------


function set_gender(p_type){
	img = document.getElementById("info_img");
	bar = document.getElementById("info");
	oid = document.getElementById("id_name");
	onk = document.getElementById("nick_name");
	ocn = document.getElementById("info_content");
	colp = document.getElementById("collaps1");

	if(img && bar){
		if(p_type == 1){
			bar.style.backgroundImage = "url('images/malex.gif')";
			img.src = "images/malehead.gif";
			oid.className = "id_male";
			onk.style.color = "#2c86ba";
			ocn.style.color = "#95b7cb";
			colp.className = "collaps11";

		}else if(p_type == 2){
			bar.style.backgroundImage = "url('images/femalex.gif')";
			img.src = "images/femalehead.gif";
			oid.className = "id_female";
			onk.style.color = "#d3616b";
			ocn.style.color = "#dda4a4";
			colp.className = "collaps12";

		}else{
			bar.style.backgroundImage = "url('images/nomalex.gif')";
			img.src = "images/nohead.gif";
			oid.className = "id_nomale";
			onk.style.color = "#555555";
			ocn.style.color = "#AAAAAA";
			colp.className = "collaps10";

		}
	}
}

function prepare_show(key, id){
 time_frn = setTimeout("show_related_frn('" + key + "', '" + id + "')", 350);
}

function cancel_show(){
	clearTimeout(time_frn);
}

function toggle_ind(id){
	e = document.getElementById(id);
	if(e != null){
		if(e.innerHTML == "-"){
			e.innerHTML = "+";
		}else{
			e.innerHTML = "-";
		}
	}
}

function toggle_collaps(id){
	if(id == 1){
		toggle_show_div("info_content_detail");
		toggle_ind("collaps1");
	}else if (id == 2){
		toggle_show_div("name_result_detail");
		toggle_ind("collaps2");
	}else if (id == 3){
		toggle_show_div("friend_list_detail");
		toggle_ind("collaps3");

	}
}

function toggle_mode_frn(){
	if(toggle_mode_detail == true){
		toggle_mode_detail = false;
		update_content("show_frn_mode", "<a href=\"javascript:toggle_mode_frn()\" title=\"現在設定：精簡模式\">精簡</a>");
		draw_frns();
	}else{
		toggle_mode_detail = true;
		update_content("show_frn_mode", "<a href=\"javascript:toggle_mode_frn()\" title=\"現在設定：詳細模式\">詳細</a>");
		draw_frns();
	}

	if(old_key != ""){
		show_related_frn(old_key, old_id);
	}
	
	if(toggle_select){
		j = 0;
		while(j < frn_id.length){
			e = document.getElementById("frn_"+ j);
			if(e != null ){
				if(e.className == 't_frn4' || e.className == 't_frn4x'){
					e.style.display = 'block';
				}else{
					e.style.display = 'none';
				}
			}
			j++;
		}
		hide_div_x("frn_no_des");
	}

}

function toggle_select_frn(){
	if(toggle_select == false){
		j = 0;
		while(j < frn_id.length){
			e = document.getElementById("frn_"+ j);
			if(e != null ){
				if(e.className == 't_frn4' || e.className == 't_frn4x'){
					e.style.display = 'block';
				}else{
					e.style.display = 'none';
				}
			}
			j++;
		}
		update_content("select_frn_ony", "<a href=\"javascript:toggle_select_frn()\" title=\"現在設定：顯示相關好友\">相關</a>");
		hide_div_x("frn_no_des");
		toggle_select = true;
	}else{
		j = 0;
		while(j < frn_id.length){
			e = document.getElementById("frn_"+ j);
			if(e != null ){
				e.style.display = 'block';
			}
			j++;
		}
		update_content("select_frn_ony", "<a href=\"javascript:toggle_select_frn()\" title=\"現在設定：顯示全部好友\">全部</a>");
		show_div("frn_no_des");
		toggle_select = false;
	}
}

function select_btn(bkey, id){
	if(old_style != ""){
		ep = document.getElementById(old_id);
		if(ep != null){
		//	alert(old_style.substr(old_style.length-1, old_style.length-1));
			if(old_style.substr(old_style.length-1, old_style.length-1) == "2"){
				ep.className = old_style.substr(0, old_style.length-1);
			}else{
				ep.className = old_style;
			}
		}

	}
	ep = document.getElementById(id);
	if(ep != null){
		old_style = ep.className;
		if(old_style.search("t_tag2") != -1){
			ep.className = 't_tagx5';
		}else if(old_style.search("t_tag") != -1){
			ep.className = 't_tagx4';
		}else if(old_style.search("t_nick") != -1){
			ep.className = 't_tagx3';
		}else if(old_style.search("t_name3") != -1){
			ep.className = 't_tagx2';
		}else if(old_style.search("t_name2") != -1){
			ep.className = 't_tagx2';
		}else if(old_style.search("t_rname") != -1){
			ep.className = 't_tagx';
		}

	}
}

function show_related_frn(key, id){
	if(open_friend && have_friend){
//		if(old_key != key){
		select_btn(key, id);
				old_key = key;
				old_id = id;

			j = 0;
			select_count = 0;
			conx = "";
		//	alert(frn_id.length);
			while(j < frn_id.length){
				e = document.getElementById("frn_"+ j);
				if(e != null ){
					if(frn_des[j].indexOf(key) != -1){
							if(toggle_mode_detail){
								ex = document.getElementById("frn_des_"+ j);
								if(ex != null){
									ex.className = 'frn_des_x2';
								}
								e.className = 't_frn4';
							}else{
								e.className = 't_frn4x';
							}
							e.style.display = 'block';
							select_count++;
					}else{
						if(e.className != "t_frn3"){
							if(toggle_mode_detail){
								e.className = 't_frn';
								ex = document.getElementById("frn_des_"+ j);
								if(ex != null){
									ex.className = 'frn_des_x';
								}
							}else{
								e.className = 't_frnx';
							}

							if(toggle_select){
								e.style.display = 'none';
							}
						}
					}
				}
				j++;
			}
			
			tmp3 = select_count / num_tag_frn * 100;
			update_content("select_frn_num", select_count + " 人");
			update_content("select_frn_per", tmp3.toFixed(1) + "%");
			update_content("select_frn", key);
			show_div("select_frn");
			show_div("select_frn_per");
			show_div("select_frn_num");
			show_div("select_frn_ony");
			show_div("show_frn_mode");

//		}
	}
}



// Parse Functions ------------------------------------------------------------------------

function addMsg(con){
	if(msgx == ""){
		msgx += con;
	}else{
		msgx += ", " + con;
	}
}


function parseResult(msg){
//	alert(msg);
	var res = "";
	backana  = "";
	var lines = msg.split("\n");
	var i = 0;
	var mode = 0;
	var token = Array();
	set_gender(0);
//	res += lines.length + "<br/>";
	while(i < lines.length){
		if(lines[i] == "--USR_DIE--"){
			open_profile  = false;
			addMsg(err_msg[0]);
//			res += "使用者名片關閉中<br/>";
		}else if(lines[i] == "--USR_CLOSED--"){
			have_profile = false;
			addMsg(err_msg[1]);
//			res += "使用者沒有公開任何個人資訊<br/>";
		}else if(lines[i] == "--FRN_DIE--"){
			open_friend = false;
			addMsg(err_msg[2]);
//			res += "使用者好友關閉中<br/>";
		}else if(lines[i] == "--FRN_CLOSED--"){
			have_friend = false;
			addMsg(err_msg[3]);
//			res += "使用者沒有連入朋友<br/>";
		}
		if(lines[i] == "--USR_END--"){
			mode = 1;
		}
		if(lines[i] != undefined && lines[i] != ""){
			token = lines[i].split("[||]");
			if(token.length > 1){
				if(mode == 0){
					
					res += token[0] + " "  + token[1] + "<br/>";

					if(token[0] == "Nickname:"){
						nickname = token[1];
						update_content("nick_name", nickname);	
					}else if(token[0] == "Gender:"){
						if(token[1] == "Male"){
							gender = 1;
						}else if(token[1] == "Female"){
							gender = 2;
						}else{
							gender = 0;
						}
						set_gender(gender);
					}else if(token[0] == "Birthday:"){
						update_content("bir", token[1]);
						show_div("tr_bir");
					}else if(token[0] == "Blood type:"){
						update_content("blo", token[1]);
						show_div("tr_blo");
					}else if(token[0] == "Height:"){
						update_content("hei", token[1]);
						show_div("tr_hei");
					}else if(token[0] == "Weight:"){
						update_content("wei", token[1]);
						show_div("tr_wei");
					}else if(token[0] == "Education:"){
						update_content("edu", token[1]);
						show_div("tr_edu");
					}else if(token[0] == "Occupation:"){
						update_content("occ", token[1]);
						show_div("tr_occ");
					}else if(token[0] == "Hobby:"){
						update_content("hob", token[1]);
						show_div("tr_hob");
					}else if(token[0] == "Favorite:"){
						update_content("fav", token[1]);
						show_div("tr_fav");
					}else if(token[0] == "Dislike:"){
						update_content("dis", token[1]);
						show_div("tr_dis");
					}else if(token[0] == "E-Mail:"){
						update_content("ema", token[1]);
						show_div("tr_ema");
					}else if(token[0] == "MSN:"){
						update_content("msn", token[1]);
						show_div("tr_msn");
					}else if(token[0] == "Yahoo Messenger:"){
						update_content("yah", token[1]);
						show_div("tr_yah");
					}else if(token[0] == "QQ:"){
						update_content("qqq", token[1]);
						show_div("tr_qqq");
					}else if(token[0] == "AIM:"){
						update_content("aim", token[1]);
						show_div("tr_aim");
					}else if(token[0] == "Google Talk:"){
						update_content("goo", token[1]);
						show_div("tr_goo");
					}else if(token[0] == "Skype:"){
						update_content("sky", token[1]);
						show_div("tr_sky");
					}else if(token[0] == "Introduction:"){
						update_content("int", token[1]);
						show_div("tr_int");
					}else if(token[0] == "Total Visitors:"){
						if(token[1] > 0){
							update_content("vis", token[1]);
							show_div("tr_vis");
						}
					}
				}else if (mode == 1){
					if(token.length > 1){
						
					//	token[1] = token[1].replace(/\\u/g, '%u');
						tmp = unescape(token[1]);
					//	res += token[0] + ": "  + tmp  + "<br/>";
						frn_id.push(token[0]);
						frn_des.push(tmp);
						backana +=  token[0]+ "[\|\|]"+tmp+"\n";				
					}
				}
			}
		}
		i++;
	}
//	alert(backana);
	if(open_profile && have_profile){
		show_div('info');
		show_div('info_content_detail');
	}
	
	if(msgx != ""){
		update_content("msg_content", msgx + ".");
		show_div("msg_info");
	}



	return(res);
}


function pclass_change(obj, p_class){
//	alert(obj.className);
	if(obj.className.search('t_tagx') == -1){
		obj.className = p_class;
	}

}

function gen_div(p_class, p_key, p_id){
//	alert(escape(p_key));
  return "<div id=\"btn_" + p_id + "\" class=\"" + p_class + "\" onmouseover=\"prepare_show('"+p_key+"' , this.id);pclass_change(this, '"+ p_class+ "2')\" onmouseout=\"cancel_show();pclass_change(this, '"+ p_class+ "')\" ><a href=\"http://tw.info.search.yahoo.com/search/wretch?ei=UTF-8&fr=cb-wretch&fr2=sfp&searchtype=photo&p="+ encodeURIComponent(p_key) + "\" target=\"_blank\" >" + p_key + "</a></div>";
}

function parseResult2(msg){
//	alert(msg);
	var res = "";
	var lines = msg.split("\n");
	var i = 0;	
	var mode = 0;
	var token = Array();
	var first_token = "";
	while(i < lines.length){
		res += lines[i] + "<br/>";
		if(lines[i] == "--COMPLETE--"){
			mode = 1;
		}

		if(mode == 1 && lines[i] != ""){
			token = lines[i].split("=");
			if(token.length > 1){
				if(token[0] == "REAL_FIN"){
					btn_name.push(token[1]);
					first_token = token[1];
					conx = 	gen_div("t_rname", token[1],btn_name.length-1);
					update_content("rname", conx);
					show_div("tr_rname");
				}else if(token[0] == "REAL2"){
					token2 = token[1].split(":");
					if(token2.length == 2){
						name_2 = token2[0].split("|");
						tf_name_2 = token2[1].split("|");
						j = 0;
						conx = "";

						while(j < name_2.length){
							btn_name.push(name_2[j]);
							if(tf_name_2[j] <= 1){
								conx += gen_div("t_name21", name_2[j], btn_name.length-1);
							}else if(tf_name_2[j] <= 10){
								conx += gen_div("t_name210", name_2[j], btn_name.length-1);
							}else{
								conx += gen_div("t_name250", name_2[j], btn_name.length-1);
							}
							j++;
						}
						update_content("name2", conx);	
						show_div("tr_name2");

					}
				}else if(token[0] == "REAL3"){
					token2 = token[1].split(":");
					if(token2.length == 2){
						name_3 = token2[0].split("|");
						tf_name_3 = token2[1].split("|");
						j = 0;
						conx = "";

						while(j < name_3.length){
							btn_name.push(name_3[j]);
							if(tf_name_3[j] <= 1){
								conx += gen_div("t_name21", name_3[j], btn_name.length-1);
							}else if(tf_name_3[j] <= 10){
								conx += gen_div("t_name210", name_3[j], btn_name.length-1);
							}else{
								conx += gen_div("t_name250", name_3[j], btn_name.length-1);
							}
							j++;
						}
						update_content("name3", conx);	
						show_div("tr_name3");
					}
				}else if(token[0] == "NICK"){
					token2 = token[1].split(":");
					if(token2.length == 2){
						nick = token2[0].split("|");
						tf_nick = token2[1].split("|");
						j = 0;
						conx = "";

						while(j < nick.length){
							btn_name.push(nick[j]);
							if(tf_nick[j] <= 1){
								conx += gen_div("t_nick1", nick[j], btn_name.length-1);
							}else if(tf_nick[j] <= 10){
								conx += gen_div("t_nick10", nick[j], btn_name.length-1);
							}else{
								conx += gen_div("t_nick50", nick[j], btn_name.length-1);
							}
							j++;
						}
						update_content("nick", conx);	
						show_div("tr_nick");
					}
				}else if(token[0] == "TAG"){
					token2 = token[1].split(":");
					if(token2.length == 2){
						tag = token2[0].split("|");
						tf_tag = token2[1].split("|");
						j = 0;
						conx = "";

						while(j < tag.length){
							btn_name.push(tag[j]);
							if(tf_tag[j] <= 1){
								conx += gen_div("t_tag1", tag[j], btn_name.length-1);
							}else if(tf_tag[j] <= 10){
								conx += gen_div("t_tag10", tag[j], btn_name.length-1);
							}else{
								conx += gen_div("t_tag50", tag[j], btn_name.length-1);
							}
							j++;
						}
				
						update_content("tag", conx);	
						show_div("tr_tag");
					}
				}else if(token[0] == "TAG2"){
					token2 = token[1].split(":");
					if(token2.length == 2){
						tag2 = token2[0].split("|");
						tf_tag2 = token2[1].split("|");
						j = 0;
						conx = "";

						while(j < tag2.length){
							btn_name.push(tag2[j]);
							if(tf_tag2[j] <= 1){
								conx += gen_div("t_tag21", tag2[j], btn_name.length-1);
							}else if(tf_tag2[j] <= 10){
								conx += gen_div("t_tag210", tag2[j], btn_name.length-1);
							}else{
								conx += gen_div("t_tag250", tag2[j], btn_name.length-1);
							}
							j++;
						}
						update_content("tag2", conx);	
						show_div("tr_tag2");
					}
				}
			}
		}
		i++;
	}
	show_div('name_result');	
	show_div('name_result_detail');	
	if(btn_name.length > 0){
		show_related_frn(btn_name[0], "btn_0");
	}
//	if(frn_id.length >= 20){
		check_survey();
//	}
	return(res);
}


function parseResult3(msg){
	var res = "";
	var lines = msg.split("\n");
	var i = 0;	
	var mode = 0;
	var token = Array();
	while(i < lines.length){
		token = lines[i].split("|");
		if(token.length > 1){
			if(token[0] == "VC" && token[1] != ""){
				code_id = token[1];
				update_content_form("code_field", token[1]);
//				alert(token[1]);
				mode = 1;
				break;
			}
		}
		i++;
	}

	if(mode == 1){
		return(1);
	}

	return(0);
}

function parseResult4(msg){
	var res = "";
	var lines = msg.split("\n");
	var i = 0;	
	var mode = 0;
	var token = Array();
	while(i < lines.length){
		token = lines[i].split("|");
		if(token.length > 1){
			if(token[0] == "RES" && token[1] == "PASSED"){
				mode = 1;
				break;
			}
		}
		i++;
	}

	if(mode == 1){
		return(1);
	}

	return(0);
}

// Misc Functions ------------------------------------------------------------------------


function get_value(id){
	e = document.getElementById(id);
	if(e != null){
		if(e.type == "text" || e.type == "hidden"){
			return(e.value);
		}else{
			return(e.checked);
		}
	}
}


function swap_img(id, src){
	e = document.getElementById(id);
	if(e != null){
		e.src = src;
	}
}

function hide_div(o){
	o.style.display = "none";
}

function toggle_show_div(id){
	e = document.getElementById(id );
	if(e != null){
		if(e.style.display == "none"){
			e.style.display = "block";
		}else if (e.style.display == "block"){
			e.style.display = "none";
		}	
	}
}


function hide_div_x(id){
	e = document.getElementById(id );
	if(e != null){
		e.style.display = "none";
	}
}

// 顯示 div 
function show_div(id){
	e = document.getElementById(id );
	if(e != null){
		e.style.display = "block";
	}
}

function clear_div(id){
	e = document.getElementById(id );
	if(e != null){
		e.innerHTML = "";
	}
}

function hide_clear_div(id){
	e = document.getElementById(id );
	if(e != null){
		e.innerHTML = "";
		e.style.display = "none";
	}
}

function hide_survy(){
	hide_div_x("survey");
	hide_div_x("survey_detail");
}

function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
}

function ltrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
}

function rtrim(str, chars) {
    chars = chars || "\\s";
    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
}


function findPosX(obj)
  {
    var curleft = 0;
    if(obj.offsetParent)
        while(1) 
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
    return curleft;
  }

  function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }


app.Env("CYGWIN") = "nodosfilewarning";

Config.tty.execute_command = "/bin/bash --login -i";
Config.tty.title = "ck";
Config.tty.savelines = 1000;
Config.tty.input_encoding   = Encoding.UTF8;
Config.tty.display_encoding = Encoding.SJIS | Encoding.EUCJP | Encoding.UTF8;
Config.tty.scroll_key = 1;
Config.tty.scroll_output = 0;
Config.tty.bs_as_del  = 0;
Config.tty.use_bell   = 0;
Config.tty.cjk_width  = 1;

if (app.Env('COMPUTERNAME') == 'AOYAMA-PC2') {
	Config.window.font_name = "ＭＳ ゴシック";
	Config.window.font_size = 10;
	Config.window.position_x = 500;
	Config.window.position_y = 0;
	Config.window.cols = 158;
	Config.window.rows = 65;
}
else {
	if (false) {
		Config.window.font_name = "ＭＳ ゴシック";
		Config.window.font_size = 10;
		Config.window.position_x = 230;
		Config.window.position_y = 0;
		Config.window.cols = 160;
		Config.window.rows = 50;
	}
	else {
		Config.window.font_name = "ＭＳ ゴシック";
		Config.window.font_size = 12;
		Config.window.position_x = 234;
		Config.window.position_y = 0;
		Config.window.cols = 139;
		Config.window.rows = 44;
	}
}

Config.window.scrollbar_show  = 0;
Config.window.scrollbar_right = 1;
Config.window.blink_cursor    = 0;
Config.window.zorder          = WinZOrder.Normal;
Config.window.transparent     = 0xFF;
Config.window.linespace       = 0;
Config.window.border_left     = 1;
Config.window.border_top      = 1;
Config.window.border_right    = 1;
Config.window.border_bottom   = 1;


Config.window.background_file     = "";
Config.window.background_repeat_x = Place.NoRepeat;
Config.window.background_repeat_y = Place.NoRepeat;
Config.window.background_align_x  = Align.Center;
Config.window.background_align_y  = Align.Center;

Config.window.color_alpha   = 0xCC;
Config.window.mouse_left         = MouseCmd.Select;
Config.window.mouse_middle       = MouseCmd.Paste;
Config.window.mouse_right        = MouseCmd.Menu;

Config.accelkey.new_shell        = Keys.ShiftL | Keys.CtrlL | Keys.C;
Config.accelkey.new_window       = Keys.ShiftL | Keys.CtrlL | Keys.M;
Config.accelkey.open_window      = Keys.ShiftL | Keys.CtrlL | Keys.O;
Config.accelkey.close_window     = Keys.ShiftL | Keys.CtrlL | Keys.W;
Config.accelkey.next_shell       = Keys.ShiftL | Keys.CtrlL | Keys.N;
Config.accelkey.prev_shell       = Keys.ShiftL | Keys.CtrlL | Keys.P;
Config.accelkey.paste            = Keys.ShiftL | Keys.Insert;
Config.accelkey.popup_menu       = Keys.ShiftL | Keys.F10;
Config.accelkey.popup_sys_menu   = Keys.AltR   | Keys.Space;
Config.accelkey.scroll_page_up   = Keys.ShiftL | Keys.PageUp;
Config.accelkey.scroll_page_down = Keys.ShiftL | Keys.PageDown;
Config.accelkey.scroll_line_up   = Keys.None;
Config.accelkey.scroll_line_down = Keys.None;
Config.accelkey.scroll_top       = Keys.ShiftL | Keys.Home;
Config.accelkey.scroll_bottom    = Keys.ShiftL | Keys.End;


Config.window.color_foreground = 0x000000;
Config.window.color_background = 0xfff4f4ff;
Config.window.color_selection  = 0x660000ff;
Config.window.color_cursor     = 0x000000;
Config.window.color_imecursor  = 0xff00ff;

// 通常は
// 0/8  黒
// 1/9  赤
// 2/10 緑
// 3/11 黄色
// 4/12 青
// 5/13 紫
// 6/14 シアン
// 7/15 白（グレー）
// ただし、自分の場合は背景が明るい色なので、黒と白を反転させる

//# 背景色
Config.window.color_color0 = 0xf4f4ff;
//# pink
Config.window.color_color1 = 0xff0066;
//# comment green
Config.window.color_color2 = 0x007f00;
//# preprocessor dark yellow
Config.window.color_color3 = 0x7f7f00;
//# blue
Config.window.color_color4 = 0x0000ff;
//# Precondition darkmagenta
Config.window.color_color5 = 0xff00ff;
//# brown
Config.window.color_color6 = 0x006666;
//# cyan
Config.window.color_color7 =  0x000000;
//#Config.window.color_color8: #003366
Config.window.color_color11 = 0xfecb01;
//#Config.window.color_color10: #6666ff
Config.window.color_color11 = 0xfc8b0e;
Config.window.color_color12 = 0x0000ff;
Config.window.color_color13 = 0xbd319f;
Config.window.color_color14 = 0x00cdcd;
Config.window.color_color15 = 0x333333;

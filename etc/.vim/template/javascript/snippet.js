/**
 * strftimeの簡易版
 */
function strftimeLite(format, date) {
  date = date || new Date();
  var result = format;
  result = result.replace(/%Y/g, date.getFullYear());
  result = result.replace(/%m/g, ("0" + (date.getMonth() + 1)).slice(-2));
  result = result.replace(/%d/g, ("0" + date.getDate()).slice(-2));
  result = result.replace(/%H/g, ("0" + date.getHours()).slice(-2));
  result = result.replace(/%M/g, ("0" + date.getMinutes()).slice(-2));
  result = result.replace(/%S/g, ("0" + date.getSeconds()).slice(-2));
  result = result.replace(/%a/g, [ "日", "月", "火", "水", "木", "金", "土" ][date.getDay()]);
  return result;
}

/**
 * 日時をパースする。対応形式は
 * YYYY-MM-DD HH:MM:SS
 * YYYY-MM-DDTHH:MM:SS
 * YYYY/MM/DD HH:MM:SS
 * など。
 */
function parseDateTime(str) {
  var m;
  if (m = str.match(/(\d{4})\D(\d{1,2})\D(\d{1,2})\D(\d{1,2})\D(\d{1,2})\D(\d{1,2})/)) {
    return new Date(m[1], m[2] - 1, m[3], m[4], m[5], m[6]);
  } else {
    return null;
  }
}

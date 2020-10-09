class MatchInput {
  ///大陆手机号码11位数，匹配格式：前三位固定格式+后8位任意数
  /// 此方法中前三位格式有：
  /// 13+任意数 * 15+除4的任意数 * 18+除1和4的任意数 * 17+除9的任意数 * 147
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }

  ///正则表达式验证密码
  ///包含数字,字母,长度6-12
  static bool rexCheckPassword(String input) {
    // 6-20 位，字母、数字、字符
    return RegExp("^(?:(?=.*[a-z])(?=.*[0-9])).{6,12}\$").hasMatch(input);
  }

  ///用户输入是否包含表情
  static bool isEmoj(String input) {
    return RegExp(
            "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")
        .hasMatch(input);
  }
}

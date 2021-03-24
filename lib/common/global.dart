import 'package:flutter/material.dart';

class GlobalColors {
  static const materialColorPrimary = Colors.green;
  static const colorIndexTextField = Color(0XFFFAFEE8);
  static const colorMainContentAppBar = Color(0xFFE3B3A2);
  static const materialColorMainContent = Colors.blue;
  static const colorAnswerTitle = Color(0xFF5DADF7);
  static const colorWhite = Color(0xFFFFFFFF);
  static const colorGrey = Color(0xFF999999);
  static const colorAddAnswerBtn = Color(0xFFF7BA81);
  static const materialColorWhite = Colors.white;
}

class GlobalNumbers {
  static const int maxInt = 2147483647;
}

class GlobalStrings {
  static const appName = '仲吉在线心理诊所';
  static const indexHint = '在这里输入想咨询的问题，再点击“咨询”按钮就可以进行咨询。问题内容将仅用于查找匹配结果，不会上传云端保存。';
  static const askButtonText = '咨询';
  static const nullQuestionToast = '请先输入内容再进行咨询～';
  static const titleAskResult = '查询结果';
  static const titleMainContent = '问题内容';
  static const titleSettings = '设置';
  static const titleBecomePro = '专家号申请';
  static const questionTitleDefault = '这里是问题的标题哦，还没有加载出来的话请稍等~';
  static const questionSubTitleDefault = '这里是问题的内容~';
  static const answerTitle = '问题解答';
  static const expandAnswer = '展开内容';
  static const shrinkAnswer = '收起内容';
  static const drawerSettings = '设置';
  static const drawerBecomePro = '专家号申请';
  static const drawerProLogin = '专家号登录';
  static const drawerProLogout = '专家号登出';
  // 设置面板
  static const versionName = '版本号';
  static const defaultVersionName = '0.0.0';
  static const deviceId = '设备ID';
  static const defaultDeviceId = '设备ID正在读取中';
  static const unsupportedDeviceId = '此类型的设备暂时不受支持';
  static const backgroundMusic = '背景音乐';
  static const bgmUnsupported = '此类型的设备暂不支持播放背景音乐';
  // 问题添加面板
  static const appBarAddNew = '添加问题';
  static const nickNameLabel = '昵称';
  static const titleLabel = '标题';
  static const questionLabel = '问题内容';
  static const questionSubmit = '匿名提问';
  static const validationSuffix = '不能为空哦～';
  // 专家号申请面板
  static const realNameLabel = '真实姓名';
  static const idNumberLabel = '身份证号';
  static const idNumberHelper = '只能使用中国大陆的身份证号码';
  static const phoneNumberLabel = '手机号码';
  static const phoneNumberHelper = '只能使用中国大陆的手机号码';
  static const emailLabel = '电子邮箱';
  static const emailHelper = '审核结果将通过邮件发送';
  static const goRichTextEdit = '下一步：填写详细信息';
  static const realNameInvalid = '请填写真实汉字姓名';
  static const idNumberInvalid = '请填写真实身份证号';
  static const phoneNumberInvalid = '请填写真实手机号码';
  static const emailAddressInvalid = '请填写真实邮箱地址';
  // 专家号登录面板
  static const proLoginEmailLabel = '邮箱地址';
  static const proLoginPwdLabel = '密码';
  static const loginBtnText = '登录';
  static const loginEmptyAlert = '密码不能为空';
  // 富文本编辑面板
  static const appBarRichText = '申请详情';
  static const richTextHint = '请尽量详细填写个人从业资格、从业经历等专业相关信息';
  static const richTextSubmit = '提交';
  // 专家号申请确认对话框
  static const newProTitleSuccess = '申请提交成功';
  static const newProContentSuccess = '我们将在7个工作日内发送申请结果到您的邮箱';
  static const buttonGoHome = '回到主页';
  static const newProTitleFailure = '申请提交失败';
  static const newProContentFailure = '请确认网络状况正常后再试一次';
  // 专家号登出对话框
  static const confirmLogoutTitle = '确认登出';
  static String confirmLogoutContent(String realName) {
    return '确认登出姓名为「$realName」的专家账号？';
  }
  static const confirm = '确认';
  static const cancel = '取消';
  // 回答添加面板
  static const addAnswer = '添加回答';
  static const addAnswerHint = '请在此处输入回答内容，完成后按右上角「提交」按钮';
  static const addAnswerFail = '添加回答失败';
}

class GlobalStates {
  static bool isBgmOn = false;
  static String realNameLoggedIn;
}

class GlobalRegex {
  static RegExp realName = RegExp(
    r'^[\u4E00-\u9FA5]{2,10}(·[\u4E00-\u9FA5]{2,10}){0,2}$'
  );
  static RegExp idNumber = RegExp(
    r'^(\d{15}|\d18|^\d{17}(\d|X|x))$'
  );
  static RegExp phoneNumber = RegExp(
    r'^[1]([3-9])[0-9]{9}$'
  );
  static RegExp emailAddress = RegExp(
    r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$'
  );
}
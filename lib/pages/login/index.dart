import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:qypj/utils/index.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/components/input/yy_input.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
    this.type,
  }) : super(key: key);
  final int type;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userPhone;
  String userPhonePrefix;
  int retrieveStatus = 0; //0 输入找回账号  1开始找回
  String retrieveName; //要找回的账号
  @override
  void initState() {
    super.initState();
    if (widget.type == 1) {
      getUserInfo(context);
    }
  }

  setToken(String value) async {
    Box box = AppGlobal.appBox;
    box.put('qypj_token', value);
  }

  final username = TextEditingController();
  final userPassword = TextEditingController();

  void _alertShow() {
    YyShowDialog.showdPNGDiaog(
      context,
      prohibitClose: false,
      title: CommonUtils.txt('ts'),
      btnText: CommonUtils.txt('fzzhqbc'),
      callBack: () {
        CommonUtils.startLoadGIF();
        getUserInfo(context).then((res) {
          PageStatus.closeLoading();
          Clipboard.setData(ClipboardData(
              text:
                  '回家地址：${res.share.affUrlCopy.url} 帐号：${username.text} 密码：${userPassword.text}'));
          CommonUtils.showText(CommonUtils.txt('zccgdl'));
          context.pop();
          EventBus().emit('need-update-login-state', 'login');
        });
      },
      content: (setDialogState) {
        return DefaultTextStyle(
          style: GQStyle.gray203_13,
          child: Column(
            children: [
              Text(
                CommonUtils.txt('fzzhqbctx'),
                style: GQStyle.white255_13,
                maxLines: 100,
              ),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Text(
                CommonUtils.txt('fzzhqbcqw'),
                style: GQStyle.red13,
                maxLines: 100,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _login() {
    return LoginBox(
      title: '',
      onReg: () {
        //关闭键盘
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }

        if (username.text.isEmpty || username.text.length < 6) {
          CommonUtils.showText(CommonUtils.txt('srzh'));
          return;
        }
        if (userPassword.text.isEmpty) {
          CommonUtils.showText(CommonUtils.txt('srmm'));
          return;
        }
        PageStatus.showLoading(text: CommonUtils.txt('zzzc'));
        loginByReg(
          username: username.text,
          password: userPassword.text,
        ).then((res) {
          if (res.status != 0) {
            AppGlobal.apiToken = res.data;
            setToken(res.data);
            _alertShow();
          } else {
            CommonUtils.showText(res.msg);
          }
        }).whenComplete(() {
          PageStatus.closeLoading();
        });
      },
      onLogin: () {
        //关闭键盘
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }

        if (username.text.isEmpty || username.text.length < 6) {
          CommonUtils.showText(CommonUtils.txt('srzh'));
          return;
        }
        if (userPassword.text.isEmpty) {
          CommonUtils.showText(CommonUtils.txt('srmm'));
          return;
        }
        PageStatus.showLoading(text: CommonUtils.txt('zzdl'));
        loginByAccount(password: userPassword.text, username: username.text)
            .then((res) {
          if (res.status != 0) {
            CommonUtils.showText(CommonUtils.txt('cgdl'));
            AppGlobal.apiToken = res.data;
            setToken(res.data);
            getUserInfo(context).then((res) {
              context.pop();
              EventBus().emit('need-update-login-state', 'login');
            });
          } else {
            CommonUtils.showText(res.msg);
          }
        }).whenComplete(() {
          PageStatus.closeLoading();
        });
      },
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Color(0xff2f2f42),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(5)))),
          child: YyInput(
            controller: username,
            hintText: CommonUtils.txt('qsrzh'),
            type: TextInputType.text,
            textStyle: GQStyle.white255_14,
            bottomLine: false,
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(33),
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Color(0xff2f2f42),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(5)))),
          child: YyInput(
            hintText: CommonUtils.txt('qsrmm'),
            controller: userPassword,
            type: TextInputType.text,
            isPassword: true,
            textStyle: GQStyle.white255_14,
            bottomLine: false,
          ),
        ),
      ],
    );
  }

  // Widget _register() {
  //   final username = TextEditingController();
  //   final code = TextEditingController();
  //   final password = TextEditingController();
  //   final cpassword = TextEditingController();
  //   final phone = TextEditingController();
  //   final phoneCode = TextEditingController();
  //   Function startTime;
  //   String phonePrefix = '86';
  //   clearInput() {
  //     username.clear();
  //     code.clear();
  //     password.clear();
  //     cpassword.clear();
  //     phone.clear();
  //     phoneCode.clear();
  //   }

  //   return LoginBox(
  //     title: '快速注册',
  //     btnText: '立即注册',
  //     footer: Container(
  //       margin: EdgeInsets.only(top: ScreenUtil().setWidth(12)),
  //       width: double.infinity,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               loginType = loginType == 0 ? 1 : 0;
  //               setState(() {});
  //             },
  //             child: Text(
  //               loginType == 0 ? '账号密码注册>' : '手机验证码注册>',
  //               style: TextStyle(
  //                   color: Color(0xff666666), fontSize: ScreenUtil().setSp(13)),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               currentIndex = 0;
  //               setState(() {});
  //             },
  //             child: Text(
  //               '去登录>',
  //               style: TextStyle(
  //                   color: Color(0xff666666), fontSize: ScreenUtil().setSp(13)),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       if (loginType == 0) {
  //         if (phoneCode.text.isEmpty) {
  //           CommonUtils.showText('请输入手机验证码～');
  //           return;
  //         }
  //         if (phone.text.isEmpty) {
  //           CommonUtils.showText('请输入手机号码～');
  //           return;
  //         }
  //         PageStatus.showLoading();
  //         registerByPhone(
  //                 code: phoneCode.text,
  //                 phone: phone.text,
  //                 phonePrefix: phonePrefix,
  //                 invitedAff: code.text)
  //             .then((res) {
  //           if (res.status != 0) {
  //             currentIndex = 0;
  //             setState(() {});
  //             CommonUtils.showText('注册成功,快去登录吧～');
  //             clearInput();
  //           } else {
  //             CommonUtils.showText(res.msg);
  //           }
  //         }).whenComplete(() {
  //           PageStatus.closeLoading();
  //         });
  //       } else {
  //         if (username.text.isEmpty) {
  //           CommonUtils.showText('请输入用户名～');
  //           return;
  //         }
  //         if (password.text.isEmpty) {
  //           CommonUtils.showText('请输入密码～');
  //           return;
  //         }
  //         if (password.text.length < 6) {
  //           CommonUtils.showText('请输入6位数及以上的密码～');
  //           return;
  //         }
  //         if (password.text != cpassword.text) {
  //           CommonUtils.showText('两次输入的密码不一致,请重新输入～');
  //           password.clear();
  //           cpassword.clear();
  //           return;
  //         }
  //         PageStatus.showLoading();
  //         registerByPassword(
  //                 username: username.text,
  //                 password: password.text,
  //                 confirmPwd: cpassword.text,
  //                 invitedAff: code.text)
  //             .then((res) {
  //           if (res.status != 0) {
  //             currentIndex = 0;
  //             setState(() {});
  //             CommonUtils.showText('注册成功,快去登录吧～');
  //             clearInput();
  //           } else {
  //             CommonUtils.showText(res.msg);
  //           }
  //         }).whenComplete(() {
  //           PageStatus.closeLoading();
  //         });
  //       }
  //     },
  //     children: loginType == 0
  //         ? [
  //             YyInput(
  //                 controller: phone,
  //                 type: TextInputType.phone,
  //                 hintText: '输入手机号',
  //                 onChangeCountryCode: (CountryCode countryCode) {
  //                   phonePrefix = countryCode.toString().replaceAll('+', '');
  //                 }),
  //             YyInput(
  //               isGetCode: true,
  //               controller: phoneCode,
  //               type: TextInputType.text,
  //               initTime: (Function e) {
  //                 startTime = e;
  //               },
  //               onSendCode: () {
  //                 sendPhone(
  //                         phone: phone.text, phonePrefix: phonePrefix, type: 5)
  //                     .then((res) {
  //                   if (res.status == 1) {
  //                     if (startTime != null) {
  //                       startTime();
  //                       CommonUtils.showText('发送成功～');
  //                     }
  //                   } else {
  //                     CommonUtils.showText(res.msg);
  //                   }
  //                 });
  //               },
  //               hintText: '输入短信验证码',
  //             ),
  //             YyInput(
  //               controller: code,
  //               type: TextInputType.text,
  //               hintText: '输入邀请码（选填）',
  //             ),
  //           ]
  //         : [
  //             YyInput(
  //               controller: username,
  //               type: TextInputType.text,
  //               hintText: '请输入包含字母的用户名',
  //             ),
  //             YyInput(
  //               isPassword: true,
  //               controller: password,
  //               type: TextInputType.text,
  //               hintText: '请输入密码',
  //             ),
  //             YyInput(
  //               isPassword: true,
  //               controller: cpassword,
  //               type: TextInputType.text,
  //               hintText: '请再次输入密码',
  //             ),
  //             YyInput(
  //               controller: code,
  //               type: TextInputType.text,
  //               hintText: '输入邀请码（选填）',
  //             ),
  //           ],
  //   );
  // }

  // Widget _changePasswor() {
  //   final password = TextEditingController();
  //   final newpassword = TextEditingController();
  //   final cnewpassword = TextEditingController();
  //   var member = Provider.of<HomeConfig>(context, listen: false).member;
  //   return LoginBox(
  //     title: '修改密码',
  //     btnText: '修改并登录',
  //     onTap: () {
  //       if (password.text.isEmpty) {
  //         CommonUtils.showText('请输入原密码');
  //         return;
  //       }
  //       if (newpassword.text.isEmpty) {
  //         CommonUtils.showText('请输入新密码');
  //         return;
  //       }
  //       if (cnewpassword.text.isEmpty) {
  //         CommonUtils.showText('请再次输入新密码');
  //         return;
  //       }
  //       CommonUtils.debugPrint(newpassword.text);
  //       CommonUtils.debugPrint(cnewpassword.text);
  //       if (newpassword.text != cnewpassword.text) {
  //         CommonUtils.showText('两次输入的密码不一致,请重新输入');
  //         newpassword.clear();
  //         cnewpassword.clear();
  //         return;
  //       }
  //       if (newpassword.text.length < 6) {
  //         CommonUtils.showText('请输入至少6位的新密码');
  //         return;
  //       }
  //       PageStatus.showLoading();
  //       updatePassword(
  //               password: password.text,
  //               newPassword: newpassword.text,
  //               newPasswordConfirm: cnewpassword.text)
  //           .then((res) {
  //         if (res.status != 0) {
  //           CommonUtils.showText('密码修改成功');
  //           context.pop();
  //         } else {
  //           CommonUtils.showText(res.msg);
  //         }
  //       }).whenComplete(() {
  //         PageStatus.closeLoading();
  //       });
  //     },
  //     children: [
  //       member?.username == null
  //           ? SizedBox()
  //           : YyInput(
  //               isPassword: true,
  //               controller: password,
  //               type: TextInputType.text,
  //               hintText: '请输入原密码',
  //             ),
  //       YyInput(
  //         isPassword: true,
  //         controller: newpassword,
  //         type: TextInputType.text,
  //         hintText: '请输入新密码',
  //       ),
  //       YyInput(
  //         isPassword: true,
  //         controller: cnewpassword,
  //         type: TextInputType.text,
  //         hintText: '请再次确认新密码',
  //       )
  //     ],
  //   );
  // }

  // Widget _recoverAccount() {
  //   final acount = TextEditingController();
  //   final phone = TextEditingController();
  //   final phoneCode = TextEditingController();
  //   final password = TextEditingController();
  //   final cpassword = TextEditingController();

  //   Function startTime;
  //   String code = '86';
  //   clearinput() {
  //     acount.clear();
  //     phone.clear();
  //     phoneCode.clear();
  //     password.clear();
  //     cpassword.clear();
  //   }

  //   return LoginBox(
  //     title: '忘记密码',
  //     onTap: () {
  //       if (retrieveStatus == 0) {
  //         if (acount.text.isEmpty) {
  //           CommonUtils.showText('请输入要找回的用户名～');
  //           return;
  //         }
  //         PageStatus.showLoading();
  //         validateUsername(username: acount.text).then((res) {
  //           if (res.status == 0) {
  //             retrieveName = acount.text;
  //             retrieveStatus = 1;
  //             setState(() {});
  //           }
  //           if (res.status == 1) {
  //             CommonUtils.showText('该账号不存在～');
  //           }
  //         }).whenComplete(() {
  //           PageStatus.closeLoading();
  //         });
  //       } else {
  //         if (phone.text.isEmpty) {
  //           CommonUtils.showText('请输入手机号');
  //           return;
  //         }
  //         if (phoneCode.text.isEmpty) {
  //           CommonUtils.showText('请输入短信验证码');
  //           return;
  //         }
  //         if (password.text.isEmpty) {
  //           CommonUtils.showText('请输入新密码');
  //           return;
  //         }
  //         if (cpassword.text.isEmpty) {
  //           CommonUtils.showText('请输入再次输入新密码');
  //           return;
  //         }
  //         if (password.text.length < 6) {
  //           CommonUtils.showText('请至少输入6位数新密码');
  //           return;
  //         }
  //         if (password.text != cpassword.text) {
  //           CommonUtils.showText('两次输入的密码不一致,请重新密码');
  //           password.clear();
  //           cpassword.clear();
  //           return;
  //         }
  //         PageStatus.showLoading();
  //         forgetPassword(
  //                 code: phoneCode.text,
  //                 username: retrieveName,
  //                 phone: phone.text,
  //                 phonePrefix: code,
  //                 password: password.text,
  //                 passwordConfirm: cpassword.text)
  //             .then((res) {
  //           if (res.status != 0) {
  //             currentIndex = 0;
  //             setState(() {});
  //             CommonUtils.showText('密码已成功找回～');
  //             clearinput();
  //           } else {
  //             CommonUtils.showText(res.msg);
  //           }
  //         }).whenComplete(() {
  //           PageStatus.closeLoading();
  //         });
  //       }
  //     },
  //     children: retrieveStatus == 0
  //         ? [
  //             YyInput(
  //                 controller: acount,
  //                 type: TextInputType.text,
  //                 hintText: '请输入要找回的账号')
  //           ]
  //         : [
  //             YyInput(
  //               controller: phone,
  //               hintText: '请输入手机号',
  //               type: TextInputType.phone,
  //               onChangeCountryCode: (CountryCode countryCode) {
  //                 code = countryCode.toString().replaceAll('+', '');
  //               },
  //             ),
  //             YyInput(
  //               controller: phoneCode,
  //               hintText: '请输入短信验证码',
  //               isGetCode: true,
  //               initTime: (Function e) {
  //                 startTime = e;
  //               },
  //               onSendCode: () {
  //                 sendPhone(phone: phone.text, phonePrefix: code, type: 1)
  //                     .then((res) {
  //                   if (res.status == 1) {
  //                     if (startTime != null) {
  //                       startTime();
  //                       CommonUtils.showText('发送成功～');
  //                     }
  //                   } else {
  //                     CommonUtils.showText(res.msg);
  //                   }
  //                 });
  //               },
  //             ),
  //             YyInput(
  //                 hintText: '请输入新密码(至少6位)',
  //                 controller: password,
  //                 type: TextInputType.text,
  //                 isPassword: true),
  //             YyInput(
  //                 hintText: '请再次输入新密码(至少6位)',
  //                 controller: cpassword,
  //                 type: TextInputType.text,
  //                 isPassword: true)
  //           ],
  //   );
  // }

  // Widget _setPassword() {
  //   final password = TextEditingController();
  //   final newpassword = TextEditingController();
  //   return LoginBox(
  //     title: '设置密码',
  //     btnText: CommonUtils.txt('qd'),
  //     onTap: () {
  //       if (password.text.isEmpty) {
  //         CommonUtils.showText('请输入密码');
  //         return;
  //       }
  //       if (newpassword.text.isEmpty) {
  //         CommonUtils.showText('请输入确认密码');
  //         return;
  //       }
  //       if (newpassword.text != password.text) {
  //         CommonUtils.showText('两次输入的密码不一致,请重新输入');
  //         newpassword.clear();
  //         password.clear();
  //         return;
  //       }
  //       if (password.text.length < 6) {
  //         CommonUtils.showText('请输入至少6位的新密码');
  //         return;
  //       }
  //       PageStatus.showLoading();
  //       setPassword(
  //         password: password.text,
  //         passwordConfirm: newpassword.text,
  //       ).then((res) {
  //         if (res.status != 0) {
  //           CommonUtils.showText('密码设置成功');
  //           Provider.of<HomeConfig>(context, listen: false).setIsSetpassword(0);
  //           context.pop();
  //         } else {
  //           CommonUtils.showText(res.msg);
  //         }
  //       }).whenComplete(() {
  //         PageStatus.closeLoading();
  //       });
  //     },
  //     children: [
  //       YyInput(
  //         isPassword: true,
  //         controller: password,
  //         type: TextInputType.text,
  //         hintText: '请输入密码',
  //       ),
  //       YyInput(
  //         isPassword: true,
  //         controller: newpassword,
  //         type: TextInputType.text,
  //         hintText: '请再次输入密码',
  //       ),
  //     ],
  //   );
  // }

  // Widget _changeBind() {
  //   Function startTime;
  //   Function newstartTime;
  //   final phone = TextEditingController();
  //   final phoneCode = TextEditingController();
  //   final newphone = TextEditingController();
  //   final newphoneCode = TextEditingController();
  //   String code = '86';
  //   String newcode = '86';
  //   return LoginBox(
  //     title: '更换绑定',
  //     btnText: CommonUtils.txt('qd'),
  //     onTap: () {
  //       if (phone.text.isEmpty) {
  //         CommonUtils.showText('请输入原手机号～');
  //         return;
  //       }
  //       if (phoneCode.text.isEmpty) {
  //         CommonUtils.showText('请输入原手机短信验证码～');
  //         return;
  //       }
  //       if (newphone.text.isEmpty) {
  //         CommonUtils.showText('请输入新手机号～');
  //         return;
  //       }
  //       if (newphoneCode.text.isEmpty) {
  //         CommonUtils.showText('请输入新手机短信验证码～');
  //         return;
  //       }
  //       PageStatus.showLoading();
  //       changePhone(
  //               oldPhone: phone.text,
  //               oldPhonePrefix: code,
  //               oldCode: phoneCode.text,
  //               phone: newphone.text,
  //               phonePrefix: newcode,
  //               code: newphoneCode.text)
  //           .then((res) {
  //         if (res.status != 0) {
  //           CommonUtils.showText('手机绑定切换成功～');
  //           getHomeConfig(context).then((res) {
  //             context.pop();
  //           });
  //         } else {
  //           CommonUtils.showText(res.msg);
  //         }
  //       }).whenComplete(() {
  //         PageStatus.closeLoading();
  //       });
  //     },
  //     children: [
  //       Container(
  //         margin: EdgeInsets.only(top: ScreenUtil().setWidth(28)),
  //         child: Text(
  //           '手机号码: ${Provider.of<HomeConfig>(context, listen: true).member?.phone}',
  //           style: DefaultStyle.black13,
  //         ),
  //       ),
  //       YyInput(
  //         controller: phone,
  //         hintText: '请输入原手机号',
  //         type: TextInputType.phone,
  //         onChangeCountryCode: (CountryCode countryCode) {
  //           code = countryCode.toString().replaceAll('+', '');
  //         },
  //       ),
  //       YyInput(
  //         controller: phoneCode,
  //         hintText: '请输入原手机短信验证码',
  //         isGetCode: true,
  //         initTime: (Function e) {
  //           startTime = e;
  //         },
  //         onSendCode: () {
  //           sendPhone(phone: phone.text, phonePrefix: code, type: 4)
  //               .then((res) {
  //             if (res.status == 1) {
  //               if (startTime != null) {
  //                 startTime();
  //                 CommonUtils.showText('发送成功～');
  //               }
  //             } else {
  //               CommonUtils.showText(res.msg);
  //             }
  //           });
  //         },
  //       ),
  //       YyInput(
  //         controller: newphone,
  //         hintText: '请输入新手机号',
  //         type: TextInputType.phone,
  //         onChangeCountryCode: (CountryCode countryCode) {
  //           newcode = countryCode.toString().replaceAll('+', '');
  //         },
  //       ),
  //       YyInput(
  //         controller: newphoneCode,
  //         hintText: '请输入新手机短信验证码',
  //         isGetCode: true,
  //         initTime: (Function e) {
  //           newstartTime = e;
  //         },
  //         onSendCode: () {
  //           sendPhone(phone: newphone.text, phonePrefix: newcode, type: 4)
  //               .then((res) {
  //             if (res.status == 1) {
  //               if (newstartTime != null) {
  //                 newstartTime();
  //                 CommonUtils.showText('发送成功～');
  //               }
  //             } else {
  //               CommonUtils.showText(res.msg);
  //             }
  //           });
  //         },
  //       )
  //     ],
  //   );
  // }

  // Widget _bindPhone() {
  //   Function startTime;
  //   final phone = TextEditingController();
  //   final phoneCode = TextEditingController();
  //   String code = '86';
  //   return LoginBox(
  //     title: '绑定手机',
  //     btnText: CommonUtils.txt('qd'),
  //     onTap: () {
  //       if (phone.text.isEmpty) {
  //         CommonUtils.showText('请输入需要绑定的手机号');
  //         return;
  //       }
  //       if (phoneCode.text.isEmpty) {
  //         CommonUtils.showText('请输入短信验证码');
  //         return;
  //       }
  //       PageStatus.showLoading();
  //       bindPhone(code: phoneCode.text, phonePrefix: code, phone: phone.text)
  //           .then((res) {
  //         if (res.status != 0) {
  //           CommonUtils.showText('手机绑定成功～');
  //           context.pop();
  //         } else {
  //           CommonUtils.showText(res.msg);
  //         }
  //       }).whenComplete(() {
  //         PageStatus.closeLoading();
  //       });
  //     },
  //     children: [
  //       YyInput(
  //         controller: phone,
  //         hintText: '请输入绑定手机号',
  //         type: TextInputType.phone,
  //         onChangeCountryCode: (CountryCode countryCode) {
  //           code = countryCode.toString().replaceAll('+', '');
  //         },
  //       ),
  //       YyInput(
  //         controller: phoneCode,
  //         hintText: '请输入短信验证码',
  //         isGetCode: true,
  //         initTime: (Function e) {
  //           startTime = e;
  //         },
  //         onSendCode: () {
  //           sendPhone(phone: phone.text, phonePrefix: code, type: 2)
  //               .then((res) {
  //             if (res.status == 1) {
  //               if (startTime != null) {
  //                 startTime();
  //                 CommonUtils.showText('发送成功～');
  //               }
  //             } else {
  //               CommonUtils.showText(res.msg);
  //             }
  //           });
  //         },
  //       )
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: GQStyle.bgColor,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenWidth / 375 * 667,
                  child: LImage(
                    "wd_dlbg_n",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(30) + GQStyle.navbarHegiht),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _login(),
                      Padding(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ScreenUtil().setWidth(26.5)),
                            Text(CommonUtils.txt('ts'),
                                style: GQStyle.white255_15,
                                textAlign: TextAlign.left),
                            SizedBox(height: ScreenUtil().setWidth(20)),
                            Text(
                              "1.${CommonUtils.txt('zhty')}\n2.${CommonUtils.txt('zhte')}\n3.${CommonUtils.txt('zhts')}",
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: ScreenUtil().setSp(12)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: GQStyle.pagePadding,
                    ),
                    child: Container(
                      height: ScreenUtil().setWidth(44),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: LImage(
                              "nav_back_n",
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setWidth(20),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}

class LoginBox extends StatefulWidget {
  LoginBox({
    Key key,
    this.children,
    this.title,
    this.regText,
    this.onLogin,
    this.onReg,
  }) : super(key: key);
  List<Widget> children;
  String title;
  String regText;
  Function onLogin;
  Function onReg;
  @override
  _LoginBoxState createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
            child: Center(
              child: Text(
                widget.title,
                style: GQStyle.white24,
              ),
            )),
        Container(
            // margin: EdgeInsets.only(top: ScreenUtil().setWidth(47)),
            width: ScreenUtil().setWidth(325),
            // padding: EdgeInsets.symmetric(
            //     horizontal: ScreenUtil().setWidth(22.5),
            //     vertical: ScreenUtil().setWidth(20.5)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                color: Colors.transparent,
                boxShadow: [
                  // BoxShadow(
                  //     color: Colors.red,
                  //     offset: Offset(0, ScreenUtil().setWidth(1)),
                  //     blurRadius: ScreenUtil().setWidth(5))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  CommonUtils.txt("yhldcm"),
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(20)),
                LImage(
                  'flj_logo_icon',
                  width: ScreenUtil().setWidth(63),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(38),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.children,
                ),
                SizedBox(height: ScreenUtil().setWidth(55)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: widget.onReg,
                      child: Container(
                        width: ScreenUtil().setWidth(140),
                        height: ScreenUtil().setWidth(40),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(5)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: GQStyle
                                            .btnGradient_ff00edfd_ffbbe954),
                                  )),
                            ),
                            Center(
                              child: Text(
                                CommonUtils.txt('zc'),
                                style: GQStyle.white9255_15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onLogin,
                      child: Container(
                        width: ScreenUtil().setWidth(140),
                        height: ScreenUtil().setWidth(40),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(5)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: GQStyle
                                            .btnGradient_ff00edfd_ffbbe954),
                                  )),
                            ),
                            Center(
                              child: Text(
                                CommonUtils.txt('dl'),
                                style: GQStyle.white9255_15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ))
      ]),
    );
  }
}

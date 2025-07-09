import 'package:gardener/pages/account/base_info/login_birthday_page.dart';
import 'package:gardener/pages/account/base_info/login_community_page.dart';
import 'package:gardener/pages/account/base_info/login_marriage_page.dart';
import 'package:gardener/pages/account/base_info/login_nick_name_page.dart';
import 'package:gardener/pages/account/base_info/login_sex_page.dart';
import 'package:gardener/pages/account/login_msg_input_page.dart';
import 'package:gardener/pages/account/login_msg_page.dart';
import 'package:gardener/pages/account/login_page.dart';
import 'package:gardener/pages/activity/activity_info.dart';
import 'package:gardener/pages/discover/activity_square_page.dart';
import 'package:gardener/pages/discover/community_service_page.dart';
import 'package:gardener/pages/discover/group_square_page.dart';
import 'package:gardener/pages/information/information_search_page.dart';
import 'package:gardener/pages/information/user_create/information_create_page.dart';
import 'package:gardener/pages/information/user_create/information_editor_page.dart';
import 'package:gardener/pages/information/user_create/information_persion_page.dart';
import 'package:gardener/pages/information/user_create/information_topic_page.dart';
import 'package:gardener/pages/information/video_image/media_slide_page.dart';
import 'package:gardener/pages/information/community/select_community_city_page.dart';
import 'package:gardener/pages/information/community/select_community_page.dart';
import 'package:gardener/pages/message/char_info/chat_info_page.dart';
import 'package:gardener/pages/message/char_info/char_report_page.dart';
import 'package:gardener/pages/message/char_info/group_launch_page.dart';
import 'package:gardener/pages/message/contants_page/activity/activity_info_settings_page.dart';
import 'package:gardener/pages/message/contants_page/activity/constract_activity_page.dart';
import 'package:gardener/pages/mine/activity/mine_activity_page.dart';
import 'package:gardener/pages/information/video_image/components/video/tiktok/pages/user_detail_page.dart';
import 'package:gardener/pages/mine/task/task-page.dart';
import 'package:gardener/pages/mine/user-page.dart';
import 'package:gardener/provider/global_model.dart';
import 'package:provider/provider.dart';

import '../pages/information/picture_article_page.dart';
import '../pages/message/chat/chat_page.dart';
import '../pages/message/chat/transmit_message_page.dart';
import '/pages/home_page.dart';

class RoutePath {
  static String homePage = '/';
  // 主页面
  static String mainPage = '/main_page';
  // 我的
  static String userPage = '/user_page';
  // 创建输出内容
  static String informationCreatePage = '/information_create_page';

  // 信息编辑
  static String informationEditorPage = '/InformationEditorPage';
  // @相关人
  static String informationPersionPage = '/InformationPersionPage';
  // #主题
  static String informationTopicPage = '/InformationTopicPage';

  // 手机号一键登录
  static String loginPage = '/login_page';
  // 手机验证码登录
  static String loginMsgPage = '/LoginMsgPage';
  // 手机验证码输入页面
  static String loginMsgInputPage = '/LoginMsgInputPage';
  // 添加昵称
  static String loginNickNamePage = '/LoginNickNamePage';
  // 性别
  static String loginSexPage = '/LoginSexPage';
  // 年龄
  static String loginBirthdayPage = '/LoginBirthdayPage';
  // 婚姻
  static String loginMarriagePage = '/LoginMarriagePage';
  // 社区
  static String loginCommunityPage = '/LoginCommunityPage';

  static String pictureArticlePage = '/picture_article_page';

  static String mediaSlidePage = '/video_article_page';
  // 信息搜索
  static String informationSearchPage = '/information_search_page';
  // 聊天窗口
  static String chatPage = '/chatPage';
  // 聊天窗口信息设置
  static String chatInfoPage = '/ChatInfoPage';
  // 聊天举报
  static String chatReportPage = '/ChatReportPage';
  // 聊天加人群聊
  static String groupLaunchPage = '/GroupLaunchPage';
  // 转发页面
  static String transmitMessagePage = '/TransmitMessagePage';
  // 通讯录活动页面
  static String constractActivityPage = '/ConstractActivityPage';
  // 活动设置页面
  static String activityInfoSettingsPage = '/ActivityInfoSettingsPage';
  // 任务页面
  static String taskPage = '/TaskPage';
  // 我的活动
  static String mineActivityPage = '/MineActivityPage';
  // 用户信息
  static String userDetailPage = '/UserDetailPage';
  // 群广场
  static String groupSquarePage = '/GroupSquarePage';
  // 活动详情
  static String activityInfoPage = '/ActivityInfoPage';
  // 活动广场
  static String activitySquarePage = '/ActivitySquarePage';
  // 选择社区
  static String selectCommunityPage = '/SelectCommunityPage';
  // 选择社区的城市
  static String selectCommunityCityPage = '/SelectCommunityCityPage';
  // 社区服务
  static String communityServicePage = '/CommunityServicePage';


}

getRoutes(context){
  final model = Provider.of<GlobalModel>(context);

  return {
    //注册首页路由
    RoutePath.homePage: (context) => model.getCommunity().isEmpty ? const LoginCommunityPage() : const HomePage(title: '家园'),
    RoutePath.mainPage: (context) => const HomePage(title: '家园'),
    RoutePath.userPage: (context) => UserPage(),
    RoutePath.informationCreatePage: (context) => const InformationCreatePage(),
    RoutePath.informationEditorPage: (context) => const InformationEditorPage(),
    RoutePath.informationPersionPage: (context) => const InformationPersionPage(),
    RoutePath.informationTopicPage: (context) => const InformationTopicPage(),
    RoutePath.loginPage: (context) => const LoginPage(),
    RoutePath.loginMsgPage: (context) => const LoginMsgPage(),
    RoutePath.loginMsgInputPage: (context) => const LoginMsgInputPage(),
    RoutePath.pictureArticlePage: (context) => const PictureArticlePage(),
    RoutePath.mediaSlidePage: (context) => MediaSlidePage(),
    RoutePath.informationSearchPage: (context) => const InformationSearchPage(),
    RoutePath.chatPage: (context) => ChatPage(),
    RoutePath.chatInfoPage: (context) => const ChatInfoPage(),
    RoutePath.chatReportPage: (context) => const ChatReportPage(),
    RoutePath.groupLaunchPage: (context) => const GroupLaunchPage(),
    RoutePath.transmitMessagePage: (context) => TransmitMessagePage(),
    RoutePath.constractActivityPage: (context) => const ConstractActivityPage(),
    RoutePath.activityInfoSettingsPage: (context) => const ActivityInfoSettingsPage(),
    RoutePath.taskPage: (context) => TaskPage(),
    RoutePath.mineActivityPage: (context) => const MineActivityPage(),
    RoutePath.userDetailPage: (context) => UserDetailPage(),
    RoutePath.groupSquarePage: (context) => GroupSquarePage(),
    RoutePath.activityInfoPage: (context) => ActivityInfoPage(),
    RoutePath.activitySquarePage: (context) => ActivitySquarePage(),
    RoutePath.selectCommunityPage: (context) => SelectCommunityPage(),
    RoutePath.selectCommunityCityPage: (context) => SelectCommunityCityPage(),
    RoutePath.loginNickNamePage: (context) => LoginNickNamePage(),
    RoutePath.loginSexPage: (context) => LoginSexPage(),
    RoutePath.loginBirthdayPage: (context) => LoginBirthdayPage(),
    RoutePath.loginMarriagePage: (context) => LoginMarriagePage(),
    RoutePath.loginCommunityPage: (context) => LoginCommunityPage(),
    RoutePath.communityServicePage: (context) => CommunityServicePage(),
  };
}